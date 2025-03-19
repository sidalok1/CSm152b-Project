`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2025 05:13:43 PM
// Design Name: 
// Module Name: relu2
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


module relu2( in, out );

    input wire signed [7:0] in [0:31][0:10][0:10];
    output wire signed [7:0] out [0:31][0:10][0:10];

    genvar i, j, k;

    generate
    for (i = 0; i < 32; i = i + 1) begin
    for (j = 0; j < 11; j = j + 1) begin
    for (k = 0; k < 11; k = k + 1) begin
        assign out[i][j][k] = (in[i][j][k] < 0) ? 0 : in[i][j][k];
    end end end
    endgenerate

endmodule