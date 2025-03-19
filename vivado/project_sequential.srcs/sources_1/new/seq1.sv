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

`define CONV 2

module seq1(clk, start, finished, seq1_out);
    input clk;
    input start;
    output wire finished;
    
    reg start_input, start_conv1;
    wire input_finished, conv1_finished;
    wire signed [7:0] in_to_conv1 [0:27][0:27];
    wire signed [7:0] conv1_to_relu [0:15][0:25][0:25];
    wire signed [7:0] relu_to_maxpool [0:15][0:25][0:25];
    output wire signed [7:0] seq1_out [0:15][0:12][0:12];
    
    in_mat input_matrix(clk, start_input, input_finished, in_to_conv1);
    conv1 conv_1 (clk, start_conv1, in_to_conv1, conv1_finished, conv1_to_relu);
    relu1 relu (conv1_to_relu, relu_to_maxpool);
    maxpool1 maxpool (relu_to_maxpool, seq1_out);
    
    reg [1:0] state;
    assign finished = state == `IDLE;
    
    initial begin
        state = `IDLE;
        start_input = 0;
        start_conv1 = 0;
    end
    
    always @( clk ) begin
        case (state)
            `IDLE: begin
                if (start) begin
                    start_input <= 1;
                    state <= `READ;
                end
            end
            `READ: begin
                if (start_input) begin
                    start_input <= 0;
                end
                else if (input_finished) begin
                    state <= `CONV;
                    start_conv1 <= 1;
                end
            end
            `CONV: begin
                if (start_conv1) begin
                    start_conv1 <= 0;
                end
                else if (conv1_finished) begin
                    state <= `IDLE;
                end
            end
        endcase
    end
endmodule
