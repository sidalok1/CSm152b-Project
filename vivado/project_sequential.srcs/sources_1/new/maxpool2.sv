
module maxpool2( in, out );

    input wire signed [7:0] in [0:31][0:10][0:10];
    output wire signed [7:0] out [0:31][0:4][0:4];
    
    genvar i, j, k;
    
    generate
        for (i = 0; i < 32; i = i + 1) begin
        for (j = 0; j < 5; j = j + 1) begin
        for (k = 0; k < 5; k = k + 1) begin
            max_of_four maximum (out[i][j][k], in[i][(j*2)][(k*2)], in[i][(j*2)+1][(k*2)], in[i][(j*2)][(k*2)+1], in[i][(j*2)+1][(k*2)+1]);
        end end end
    endgenerate
endmodule

