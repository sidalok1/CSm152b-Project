`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 02:15:05 AM
// Design Name: 
// Module Name: conv1
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

`include "macros.vh"

module conv1(clk, start, mat, finished, out);

    input clk;
    input start;
    input signed [7:0] mat [0:27][0:27];
    output wire finished;
    output reg signed [7:0] out [0:15][0:25][0:25];
    
    
    reg [3:0] chan;
    wire [7:0] addr;
    wire [7:0] data;
    wire [7:0] data_b;
    
    assign addr = (chan * 9) + (i * 3) + j;
    
    reg [1:0] i, j;
    integer ci, cj;
    reg [1:0] state;
    
    assign finished = state == `IDLE;
    
    reg [7:0] kern [0:2][0:2];
    reg [7:0] bias;
    
    conv1_kern kernels_mem (
        .a(addr),      // input wire [7 : 0] a
        .spo(data)  // output wire [7 : 0] spo
    ); 
    conv1_bias bias_mem (
        .a(chan),      // input wire [7 : 0] a
        .spo(data_b)  // output wire [7 : 0] spo
    );
    
    initial begin
        state = `IDLE;
        chan = 0;
        i = 0;
        j = 0;
    end
    
    always @ ( clk ) begin
        case (state)
            `IDLE: begin
                if (start) begin
                    state <= `READ;
                    chan <= 0;
                    i <= 0;
                    j <= 0;
                end
            end
            `READ: begin
                if (i == 2 && j == 2) begin
                    i <= 0;
                    j <= 0;
                    ci <= 0;
                    cj <= 0;
                    state <= `CALC;
                end
                else if (j == 2) begin
                    j <= 0;
                    i <= i + 1;
                end
                else begin
                    j <= j + 1;
                end
                kern[i][j] <= data;
                bias <= data_b;
            end
            `CALC: begin
                if (chan == 15) begin
                    state <= `IDLE;
                    chan <= 0;
                    i <= 0;
                    j <= 0;
                    ci <= 0;
                    cj <= 0;
                end
                else begin
                    chan <= chan + 1;
                    state <= `READ;
                    i <= 0;
                    j <= 0;
                end
                for (ci = 0; ci < 26; ci = ci + 1) begin
                for (cj = 0; cj < 26; cj = cj + 1) begin
                    out[chan][ci][cj] <= bias[chan] +
                        (mat[ci+0][cj+0] * kern[0][0]) + (mat[ci+0][cj+1] * kern[0][1]) + (mat[ci+0][cj+2] * kern[0][2]) +
                        (mat[ci+1][cj+0] * kern[1][0]) + (mat[ci+1][cj+1] * kern[1][1]) + (mat[ci+1][cj+2] * kern[1][2]) +
                        (mat[ci+2][cj+0] * kern[2][0]) + (mat[ci+2][cj+1] * kern[2][1]) + (mat[ci+2][cj+2] * kern[2][2]) ;
                end end
            end
        endcase
    end
    

endmodule
