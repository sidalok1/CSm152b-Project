`include "macros.vh"

module conv2(clk, start, mat, finished, out);

    input clk;
    input start;
    input signed [7:0] mat [0:15][0:12][0:12];
    output wire finished;
    output reg signed [7:0] out [0:31][0:10][0:10];
    
    
    reg [3:0] chan_in;
    reg [4:0] chan_out;
    wire [12:0] addr;
    wire [7:0] data;
    wire [7:0] data_b;
    
    reg [1:0] i, j;
    assign addr = (chan_in * (9*32)) + (chan_out * 9) + (i * 3) + j;
    
    integer ci, cj, ck;
    reg [1:0] state;
    
    assign finished = state == `IDLE;
    
    reg [7:0] kern [0:2][0:2];
    reg [7:0] bias;
    
    conv2_kern kernels_mem (
        .a(addr),      // input wire [7 : 0] a
        .spo(data)  // output wire [7 : 0] spo
    ); 
    conv2_bias bias_mem (
        .a(chan_out),      // input wire [7 : 0] a
        .spo(data_b)  // output wire [7 : 0] spo
    );
    
    initial begin
        state = `IDLE;
        chan_in = 0;
        chan_out <= 0;
        i = 0;
        j = 0;
    end
    
    always @ ( clk ) begin
        case (state)
            `IDLE: begin
                if (start) begin
                    state <= `READ;
                    chan_in <= 0;
                    chan_out <= 0;
                    i <= 0;
                    j <= 0;
                end
            end
            `READ: begin
                if (i == 2 && j == 2) begin
                    i <= 0;
                    j <= 0;
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
                if (chan_in == 15 && chan_out == 31) begin
                    state <= `IDLE;
                    chan_in <= 0;
                    chan_out <= 0;
                end
                else if (chan_in == 15) begin
                    chan_out <= chan_out + 1;
                    chan_in <= 0;
                    state <= `READ;
                end
                else begin
                    chan_in <= chan_in + 1;
                    state <= `READ;
                end
                i <= 0;
                j <= 0;
                for (ci = 0; ci < 26; ci = ci + 1) begin
                for (cj = 0; cj < 26; cj = cj + 1) begin
                    out[chan_out][ci][cj] <= bias +
                        (mat[chan_in][ci+0][cj+0] * kern[0][0]) + (mat[chan_in][ci+0][cj+1] * kern[0][1]) + (mat[chan_in][ci+0][cj+2] * kern[0][2]) +
                        (mat[chan_in][ci+1][cj+0] * kern[1][0]) + (mat[chan_in][ci+1][cj+1] * kern[1][1]) + (mat[chan_in][ci+1][cj+2] * kern[1][2]) +
                        (mat[chan_in][ci+2][cj+0] * kern[2][0]) + (mat[chan_in][ci+2][cj+1] * kern[2][1]) + (mat[chan_in][ci+2][cj+2] * kern[2][2]) ;
                end end
            end
        endcase
    end
    

endmodule