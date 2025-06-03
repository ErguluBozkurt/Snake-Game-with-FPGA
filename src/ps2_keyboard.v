`timescale 1ns / 1ps

module ps2_keyboard(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    output reg [7:0] key_code,
    output reg key_valid
);

    reg [3:0] bit_count = 0;
    reg [10:0] shift_reg = 0;
    reg ps2_clk_prev;

    always @(posedge clk) begin
        if (rst) begin
            bit_count <= 0;
            shift_reg <= 0;
            key_code <= 0;
            key_valid <= 0;
            ps2_clk_prev <= 1;
        end else begin
            ps2_clk_prev <= ps2_clk;
            
            // Detect falling edge of PS/2 clock
            if (ps2_clk_prev && !ps2_clk) begin
                shift_reg <= {ps2_data, shift_reg[10:1]};
                bit_count <= bit_count + 1;
                
                if (bit_count == 10) begin
                    // Check parity and stop bit
                    if (!shift_reg[0] && shift_reg[10] && 
                        ^shift_reg[8:1] == shift_reg[9]) begin
                        key_code <= shift_reg[8:1];
                        key_valid <= 1;
                    end else begin
                        key_valid <= 0;
                    end
                    bit_count <= 0;
                end else begin
                    key_valid <= 0;
                end
            end else begin
                key_valid <= 0;
            end
        end
    end

endmodule