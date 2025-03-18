`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 02:22:05 AM
// Design Name: 
// Module Name: clkdiv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clkdiv #( parameter cycles = 2) (
    input       rst,
    input       sysclk,
    output reg  clk
);
    reg [$clog2(cycles)-1:0]  counter;

    initial begin
        counter = 0;
        clk = 0;
    end

    always @( posedge sysclk ) begin
        if (rst) begin
            counter <= 0;
            clk <= 0;
        end
        else if ( counter == (cycles / 2) ) begin
            clk <= ~clk;
            counter <= 0;
        end
        else counter <= counter + 1;
    end

endmodule
