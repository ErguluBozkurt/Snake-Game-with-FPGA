`timescale 1ns / 1ps

module random_generator(
    input clk,
    input rst,
    output reg [15:0] random_num
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            random_num <= 16'hABCD; // Seed value
        end else begin
            random_num <= {random_num[14:0], random_num[15] ^ random_num[13] ^ random_num[12] ^ random_num[10]};
        end
    end

endmodule