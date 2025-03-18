`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 04:18:28 PM
// Design Name: 
// Module Name: seq1
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
`define WAIT_IDLE 0
`define WAIT_READ 1
`define WAIT_CONV 2

module seq1(clk, start, finished, conv1_to);
    input clk;
    input start;
    output reg finished;
    
    reg start_input;
    wire input_finished;
    wire signed [7:0] in_to_conv1 [0:27][0:27];
    in_mat input_matrix(clk, start_input, input_finished, in_to_conv1);
    
    reg start_conv1;
    wire conv1_finished;
    output wire signed [7:0] conv1_to [0:15][0:25][0:25];
    conv1 conv_1 (clk, start_conv1, in_to_conv1, conv1_finished, conv1_to);
     
    reg [1:0] state;
    
    initial begin
        state = `WAIT_IDLE;
        finished = 1;
        start_input = 0;
        start_conv1 = 0;
    end
    
    always @( clk ) begin
        case (state)
            `WAIT_IDLE: begin
                if (start) begin
                    finished <= 0;
                    start_input <= 1;
                    state <= `WAIT_READ;
                end
            end
            `WAIT_READ: begin
                if (start_input) begin
                    start_input <= 0;
                end
                else if (input_finished) begin
                    state <= `WAIT_CONV;
                    start_conv1 <= 1;
                end
            end
            `WAIT_CONV: begin
                if (start_conv1) begin
                    start_conv1 <= 0;
                end
                else if (conv1_finished) begin
                    state <= `WAIT_IDLE;
                    finished <= 1;
                end
            end
        endcase
    end
endmodule
