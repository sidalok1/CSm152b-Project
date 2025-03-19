`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2025 03:40:32 PM
// Design Name: 
// Module Name: maxpool
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


module maxpool1( in, out );

    input wire signed [7:0] in [0:15][0:25][0:25];
    output wire signed [7:0] out [0:15][0:12][0:12];
    
    genvar i, j, k;
    
    generate
        for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 13; j = j + 1) begin
        for (k = 0; k < 13; k = k + 1) begin
            max_of_four maximum (out[i][j][k], in[i][(j*2)][(k*2)], in[i][(j*2)+1][(k*2)], in[i][(j*2)][(k*2)+1], in[i][(j*2)+1][(k*2)+1]);
        end end end
    endgenerate
endmodule


