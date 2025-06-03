`timescale 1ns / 1ps

module clock_divider #(
    parameter DIV = 2
)(
    input clk_in,
    input rst,
    output reg clk_out
);

    reg [31:0] counter = 0;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIV/2 - 1)) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule