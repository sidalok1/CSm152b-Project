`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 03:10:20 AM
// Design Name: 
// Module Name: relu
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


module relu1( in, out );

    input wire signed [7:0] in [0:15][0:25][0:25];
    output wire signed [7:0] out [0:15][0:25][0:25];

    genvar i, j, k;

    generate
    for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 26; j = j + 1) begin
    for (k = 0; k < 26; k = k + 1) begin
        assign out[i][j][k] = (in[i][j][k] < 0) ? 0 : in[i][j][k];
    end end end
    endgenerate

endmodule
