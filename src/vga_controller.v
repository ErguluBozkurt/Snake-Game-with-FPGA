`timescale 1ns / 1ps

module vga_controller(
    input clk,          // 25MHz clock
    input rst,
    output reg hsync,
    output reg vsync,
    output video_on,
    output [9:0] pixel_x,
    output [9:0] pixel_y
);

    // VGA 640x480@60Hz timing constants
    parameter HD = 640; // Horizontal display area
    parameter HF = 16;   // Horizontal front porch
    parameter HB = 48;   // Horizontal back porch
    parameter HR = 96;   // Horizontal retrace
    parameter VD = 480;  // Vertical display area
    parameter VF = 10;   // Vertical front porch
    parameter VB = 33;   // Vertical back porch
    parameter VR = 2;    // Vertical retrace

    reg [9:0] h_counter;
    reg [9:0] v_counter;

    // Horizontal and vertical counters
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            h_counter <= 0;
            v_counter <= 0;
        end else begin
            if (h_counter < HD + HF + HB + HR - 1) begin
                h_counter <= h_counter + 1;
            end else begin
                h_counter <= 0;
                if (v_counter < VD + VF + VB + VR - 1) begin
                    v_counter <= v_counter + 1;
                end else begin
                    v_counter <= 0;
                end
            end
        end
    end

    // Generate sync signals
    always @(*) begin
        hsync = ~((h_counter >= HD + HF) && (h_counter < HD + HF + HR));
        vsync = ~((v_counter >= VD + VF) && (v_counter < VD + VF + VR));
    end

    // Video on/off
    assign video_on = (h_counter < HD) && (v_counter < VD);

    // Output pixel coordinates
    assign pixel_x = h_counter;
    assign pixel_y = v_counter;

endmodule