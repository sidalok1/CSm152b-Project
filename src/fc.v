module fully_connected_layer
	#(parameter
		in_features=1,
        out_features=1,
		data_size=8
	)
	(
		in,
		out
	);

    input [
        (rows * cols * in_channels * data_size) - 1
        :
        0
    ] in;

    output [
        (out_features * data_size) - 1
        :
        0
    ] out;

    reg signed [data_size-1:0] weights [0:in_features-1][0:out_features-1];
    reg signed [data_size-1:0] biases [0:out_features-1];

    wire signed [data_size-1:0] in_flat [0:in_features-1];

    genvar i, j;
    generate
        for (i = 0; i < in_features; i = i + 1) begin : in_flat_gen
            assign in_flat[i] = in[i * data_size +: data_size];
        end
    endgenerate

    initial begin
        if (bias == 0) begin
            for (j = 0; j < out_features; j = j + 1) begin : out_gen
                biases[j] = 0;
            end
        end
	end

    always @(*) begin
        for (j = 0; j < out_features; j = j + 1) begin : out_gen
            out[j * data_size +: data_size] = biases[j];
            for (i = 0; i < in_features; i = i + 1) begin : in_gen
                out[j * data_size +: data_size] = out[j * data_size +: data_size] + in_flat[i] * weights[i][j];
            end
        end
    end

    
endmodule