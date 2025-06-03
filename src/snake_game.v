`timescale 1ns / 1ps

module snake_game(
    input clk,                  // 100MHz clock
    input rst,                  // Reset button
    input ps2_clk,              // PS/2 clock
    input ps2_data,             // PS/2 data
    output [3:0] vga_red,       // VGA red
    output [3:0] vga_green,     // VGA green
    output [3:0] vga_blue,      // VGA blue
    output vga_hsync,           // VGA hsync
    output vga_vsync,           // VGA vsync
    output [6:0] seg,           // 7-segment display
    output [3:0] an             // 7-segment anodes
);

    // Clock divider for VGA (25MHz)
    wire clk_25mhz;
    clock_divider #(.DIV(4)) clk_div(
        .clk_in(clk),
        .clk_out(clk_25mhz),
        .rst(rst)
    );

    // VGA controller
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire video_on;
    
    vga_controller vga(
        .clk(clk_25mhz),
        .rst(rst),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    // Keyboard input
    wire [7:0] key_code;
    wire key_valid;
    
    ps2_keyboard keyboard(
        .clk(clk),
        .rst(rst),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .key_code(key_code),
        .key_valid(key_valid)
    );

    // Game parameters
    localparam GRID_SIZE = 16;  // 16x16 pixels per block
    localparam GRID_WIDTH = 40; // 40 blocks wide (640/16)
    localparam GRID_HEIGHT = 30; // 30 blocks tall (480/16)
    
    // Game state
    reg [5:0] snake_x [0:255];  // Snake X positions (max 256 segments)
    reg [5:0] snake_y [0:255];  // Snake Y positions
    reg [7:0] snake_length = 3; // Initial length
    reg [5:0] food_x;           // Food X position
    reg [5:0] food_y;           // Food Y position
    reg [1:0] direction = 2'b01; // 00:up, 01:right, 10:down, 11:left
    reg [15:0] score = 0;
    reg game_over = 0;
    
    // Random number generator for food
    wire [15:0] random_num;
    random_generator rng(
        .clk(clk),
        .rst(rst),
        .random_num(random_num)
    );

    // 7-segment display for score
    seven_seg score_display(
        .clk(clk),
        .number(score),
        .seg(seg),
        .an(an)
    );

    // Game clock (controls snake speed)
    reg [23:0] game_counter = 0;
    wire game_tick = (game_counter == 24'd5_000_000); // Adjust for speed
    
    always @(posedge clk) begin
        if (rst) begin
            game_counter <= 0;
        end else begin
            game_counter <= game_counter + 1;
            if (game_tick) game_counter <= 0;
        end
    end

    // Process keyboard input
    always @(posedge clk) begin
        if (rst) begin
            direction <= 2'b01; // Start moving right
        end else if (key_valid) begin
            case (key_code)
                8'h1D: if (direction != 2'b10) direction <= 2'b00; // W (up)
                8'h1C: if (direction != 2'b11) direction <= 2'b01; // A (left)
                8'h1B: if (direction != 2'b00) direction <= 2'b10; // S (down)
                8'h23: if (direction != 2'b01) direction <= 2'b11; // D (right)
            endcase
        end
    end

    // Initialize game
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            snake_x[i] = 0;
            snake_y[i] = 0;
        end
        snake_x[0] = 5;
        snake_y[0] = 15;
        snake_x[1] = 4;
        snake_y[1] = 15;
        snake_x[2] = 3;
        snake_y[2] = 15;
        
        food_x = 20;
        food_y = 15;
    end

    // Game logic
    always @(posedge clk) begin
        if (rst) begin
            // Reset game state
            snake_length <= 3;
            snake_x[0] <= 5;
            snake_y[0] <= 15;
            snake_x[1] <= 4;
            snake_y[1] <= 15;
            snake_x[2] <= 3;
            snake_y[2] <= 15;
            direction <= 2'b01;
            score <= 0;
            game_over <= 0;
            food_x <= random_num[5:0] % GRID_WIDTH;
            food_y <= random_num[13:8] % GRID_HEIGHT;
        end else if (!game_over && game_tick) begin
            // Move snake
            for (i = 255; i > 0; i = i - 1) begin
                snake_x[i] <= snake_x[i-1];
                snake_y[i] <= snake_y[i-1];
            end
            
            case (direction)
                2'b00: snake_y[0] <= snake_y[0] - 1; // Up
                2'b01: snake_x[0] <= snake_x[0] + 1;  // Right
                2'b10: snake_y[0] <= snake_y[0] + 1;  // Down
                2'b11: snake_x[0] <= snake_x[0] - 1;  // Left
            endcase
            
            // Check for collisions with walls
            if (snake_x[0] == 0 || snake_x[0] == GRID_WIDTH-1 || 
                snake_y[0] == 0 || snake_y[0] == GRID_HEIGHT-1) begin
                game_over <= 1;
            end
            
            // Check for collisions with self
            for (i = 1; i < snake_length; i = i + 1) begin
                if (snake_x[0] == snake_x[i] && snake_y[0] == snake_y[i]) begin
                    game_over <= 1;
                end
            end
            
            // Check for food collision
            if (snake_x[0] == food_x && snake_y[0] == food_y) begin
                snake_length <= snake_length + 1;
                score <= score + 1;
                food_x <= random_num[5:0] % GRID_WIDTH;
                food_y <= random_num[13:8] % GRID_HEIGHT;
            end
        end
    end

    // VGA output
    reg [11:0] rgb;
    always @(posedge clk) begin
        if (!video_on) begin
            rgb <= 12'h000; // Blanking
        end else begin
            // Convert pixel coordinates to grid coordinates
            wire [5:0] grid_x = pixel_x[9:4];
            wire [5:0] grid_y = pixel_y[9:4];
            
            // Draw border
            if (grid_x == 0 || grid_x == GRID_WIDTH-1 || 
                grid_y == 0 || grid_y == GRID_HEIGHT-1) begin
                rgb <= 12'hF00; // Red border
            end 
            // Draw food
            else if (grid_x == food_x && grid_y == food_y) begin
                rgb <= 12'h0F0; // Green food
            end
            // Draw snake
            else begin
                reg is_snake = 0;
                integer j;
                for (j = 0; j < snake_length; j = j + 1) begin
                    if (grid_x == snake_x[j] && grid_y == snake_y[j]) begin
                        is_snake = 1;
                    end
                end
                
                if (is_snake) begin
                    rgb <= 12'hFFF; // White snake
                end else begin
                    rgb <= 12'h000; // Black background
                end
            end
            
            // Game over overlay
            if (game_over) begin
                // Simple red overlay
                if (pixel_x > 200 && pixel_x < 440 && 
                    pixel_y > 200 && pixel_y < 280) begin
                    rgb <= 12'hF00;
                end
            end
        end
    end

    assign vga_red = rgb[11:8];
    assign vga_green = rgb[7:4];
    assign vga_blue = rgb[3:0];

endmodule