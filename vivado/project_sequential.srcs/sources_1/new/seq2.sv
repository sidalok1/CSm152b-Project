`define CONV2 1

module seq2(clk, in, start, finished, seq2_out);
    input clk;
    input start;
    output wire finished;
    
    reg start_conv2;
    wire conv2_finished;
    input wire signed [7:0] in [0:15][0:12][0:12];
    wire signed [7:0] conv2_to_relu [0:31][0:10][0:10];
    wire signed [7:0] relu_to_maxpool [0:31][0:10][0:10];
    output wire signed [7:0] seq2_out [0:31][0:4][0:4];
    
    conv2 conv_2 (clk, start_conv2, in, conv2_finished, conv2_to_relu);
    relu2 relu (conv2_to_relu, relu_to_maxpool);
    maxpool2 maxpool (relu_to_maxpool, seq2_out);
    
    reg state;
    assign finished = state == `IDLE;
    
    initial begin
        state = `IDLE;
        start_conv2 = 0;
    end
    
    always @( clk ) begin
        case (state)
            `IDLE: begin
                if (start) begin
                    start_conv2 <= 1;
                    state <= `CONV2;
                end
            end
            `CONV2: begin
                if (start_conv2) begin
                    start_conv2 <= 0;
                end
                else if (conv2_finished) begin
                    state <= `IDLE;
                end
            end
        endcase
    end
endmodule