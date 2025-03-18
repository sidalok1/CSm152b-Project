`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 04:41:57 PM
// Design Name: 
// Module Name: tb
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


module tb();

    reg s = 0;
    wire f;
    wire [7:0] outmat [0:15][0:25][0:25];
    reg clk = 0;
    
    always #0.5 clk = ~clk;
    
    seq1 UUT (clk, s, f, outmat);
    
    initial begin
        #5 s = 1;
        #5 s = 0;
        
    end

endmodule