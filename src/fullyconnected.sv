module fullyconnected #(parameter in=1, out=1, data_size=8) (inputs, outputs);
    input wire signed [data_size-1:0] inputs [0:in-1];
    output reg signed [data_size-1:0] outputs [0:out-1];
    reg signed [data_size-1:0] weight_mem [0:(in*out)-1];
    wire signed [data_size-1:0] weights [0:out-1][0:in-1];
    reg signed [data_size-1:0] biases [0:out-1];
    genvar igen, jgen;
    generate
        for (jgen = 0; jgen < out; jgen = jgen + 1) begin
        for (igen = 0; igen < in;  igen = igen + 1) begin
            assign weights[jgen][igen] = weight_mem[(jgen * in) + igen];
        end end
    endgenerate
    integer i, j;
    reg [(data_size*2)-1:0] current = 0;
    always @* begin
        for (j = 0; j < out; j = j + 1) begin
            current = biases[j];
            for (i = 0; i < in; i = i + 1) begin
                current = current + (inputs[i] * weights[j][i]);
            end 
        end
    end
endmodule
