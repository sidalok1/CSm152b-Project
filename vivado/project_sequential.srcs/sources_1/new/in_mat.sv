`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 12:15:02 AM
// Design Name: 
// Module Name: in_mat
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

module in_mat(clk, start, finished, dout);
    input clk;
    input start;
    output wire finished;
    output reg signed [7:0] dout [0:27][0:27];

    reg state;
    
    assign finished = state == `IDLE;
    
    integer i, j;
    
    wire [9:0] addr;
    assign addr = (i * 28) + j;
    wire signed [7:0] data;
    
    initial begin
        state = `IDLE;
        i = 0;
        j = 0;
    end
    
    inputs_mem in_mem (
        .a(addr),      // input wire [9 : 0] a
        .spo(data)  // output wire [7 : 0] spo
    );
    
    always @( clk ) begin
        case (state)
            `IDLE: begin
                if (start) begin
                    state <= `READ;
                end
            end
            `READ: begin
                if (i == 27 && j == 27) begin
                    i <= 0;
                    j <= 0;
                    state <= `IDLE;
                end 
                else if (j == 27) begin
                    j <= 0;
                    i <= i + 1;    
                end
                else begin
                    j <= j + 1;
                end
                dout[i][j] <= data;
            end
        endcase
    end
    
endmodule

/*

module in_mat(clk, addr_i, addr_j, dout);
    input clk;
    input [5:0] addr_i;
    input [5:0] addr_j;
    output reg [7:0] dout [0:2][0:2];
    
    wire [9:0] addr;
    
    assign addr = (addr_i * 28) + addr_j;
    
    blk_mem_gen_0 i0_j0_to_i0j1 (
        .clka(clk), 
        .addra(addr), 
        .douta(dout[0][0]), 
        .clkb(clk),    
        .addrb(addr+1),  
        .doutb(dout[0][1])  
    );
    blk_mem_gen_0 i0_j2_to_i1j0 (
        .clka(clk), 
        .addra(addr+2), 
        .douta(dout[0][2]), 
        .clkb(clk),    
        .addrb(addr+28),  
        .doutb(dout[1][0])  
    );
    blk_mem_gen_0 i1_j1_to_i1j2 (
        .clka(clk), 
        .addra(addr+29), 
        .douta(dout[1][1]), 
        .clkb(clk),    
        .addrb(addr+30),  
        .doutb(dout[1][2])  
    );
    blk_mem_gen_0 i2_j0_to_i2j1 (
        .clka(clk), 
        .addra(addr+56), 
        .douta(dout[2][0]), 
        .clkb(clk),    
        .addrb(addr+57),  
        .doutb(dout[2][1])  
    );
    blk_mem_gen_1 i2j2 (
        .clka(clk),
        .addra(addr+58),
        .douta(dout[2][2])
    );
    
endmodule

*/
