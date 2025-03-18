module soft_onehot #(parameter values=3, data_size=8) (in, out);
    input wire signed [data_size-1:0] in [0:$clog2(values)];
    output reg [data_size-1:0] out;
    reg [data_size-1:0] i;
    reg signed [data_size-1:0] max = 0;
    always @* begin
        max = 0;
        out = 0;
        for (i = 0; i < values; i = i + 1) begin
            if (in[i] > max) begin
                max = in[i];
                out = i;
            end
        end
    end
endmodule
