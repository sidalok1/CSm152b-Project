`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2025 04:39:26 PM
// Design Name: 
// Module Name: mnist
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

`define SEQ1 1
`define SEQ2 2
`define FULL 3

module mnist(clk, start, finished, out);
    input clk, start;
    output wire finished;
    output wire signed [7:0] out [0:31][0:4][0:4];
    reg [1:0] state = `IDLE;
    assign finished = state == `IDLE;
    
    reg start_seq1 = 0, start_seq2 = 0, start_fc = 0;
    wire seq1_finished, seq2_finished, fc_finished;
    wire signed [7:0] seq1_to_seq2 [0:15][0:12][0:12];
    
    
    seq1 sequential_1 (clk, start_seq1, seq1_finished, seq1_to_seq2);
    seq2 sequential_2 (clk, seq1_to_seq2, start_seq2, seq2_finished, out);
    
    always @ ( clk ) begin
        case (state)
            `IDLE: begin
                if (start) begin
                    start_seq1 <= 1;
                    state <= `SEQ1;
                end
            end
            `SEQ1: begin
                if (start_seq1) begin
                    start_seq1 <= 0;
                end
                else if (seq1_finished) begin
                    state <= `SEQ2;
                    start_seq2 <= 1;
                end
            end
            `SEQ2: begin
                if (start_seq2) begin
                    start_seq2 <= 0;
                end
                else if (seq2_finished) begin
                    state <= `IDLE;
                end
            end
            `FULL: begin
                if (start_fc) begin
                    start_fc <= 0;
                end
                else if (fc_finished) begin
                    state <= `IDLE;
                end
            end
        endcase
    end
endmodule
