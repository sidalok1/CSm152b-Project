module ReLU #(parameter channels = 1, rows = 1, cols = 1, data_size = 8) (in, out);
    input wire signed [data_size-1:0] in [0:channels-1][0:rows-1][0:cols-1];
    output wire signed [data_size-1:0] out [0:channels-1][0:rows-1][0:cols-1];
    genvar i, j, k;
    generate
        for (i = 0; i < channels; i = i + 1) begin
        for (j = 0; j < rows; j = j + 1) begin
        for (k = 0; k < cols; k = k + 1) begin
            assign out[i][j][k] = (in[i][j][k] < 0) ? 0 : in[i][j][k];
        end end end
    endgenerate
endmodule