module conv2d 
	#(parameter
		in_channels=1,
		out_channels=1,
		kernel_rows=1,
		kernel_cols=1,
		stride_row=1,
		stride_col=1,
		pad_rows=0,
		pad_cols=0,
		rows=28,
		cols=28,
		data_size=8
	) (in, out);

	input wire [`DATA_SIZE-1:0] in [0:in_channels-1][0:rows-1][0:cols-1];

	localparam output_rows = 
		(rows - kernel_rows + pad_rows + stride_row) / stride_row;
	localparam output_cols = 
		(cols - kernel_cols + pad_cols + stride_col) / stride_col;
	output reg [data_size-1:0] out [0:out_channels-1][0:output_rows-1][0:output_cols-1];

	genvar i, j, ci, co, ki, kj;
	generate
		
		reg signed [data_size-1:0] kernels [0:in_channels-1][0:out_channels-1][0:kernel_rows-1][0:kernel_cols-1];

		reg [data_size-1:0] biases [0:in_channels-1][0:out_channels-1];

		wire signed [data_size-1:0] padded_inputs [0:in_channels-1][0:(rows + (2 * pad_rows))-1][0:(cols + (2 * pad_cols))-1];

		for (ci = in_channels - 1; ci >= 0; ci = ci - 1) begin
			for (j = (rows + (2 * pad_rows)) - 1; j >= 0; j = j - 1) begin
			for (i = (cols + (2 * pad_cols)) - 1; i >= 0; i = i - 1) begin
				if (i < pad_cols || i > (cols + pad_cols) || j < pad_rows || j > (rows + pad_rows))
					assign padded_inputs[ci][j][i] = 0;
				else
					assign padded_inputs[ci][j][i] = in[ci][j][i];
			end end
		end
	endgenerate

	generate
		for (co = 0; co < out_channels; co = co + 1) begin:out_output_channels
		for (i = 0; i < output_rows; i = i + 1) begin:out_row
		for (j = 0; j < output_cols; j = j + 1) begin:out_col
				wire [data_size-1:0] outp;
				assign outp = out[co] [i][j];
		end end end

		for (ci = 0; ci < in_channels;  ci = ci + 1) begin:in_input_channels
		for (i = 0; i < rows; i = i + 1) begin:in_row
		for (j = 0; j < cols; j = j + 1) begin:in_col
				wire [data_size-1:0] inp;
				assign inp = in[ci][i][j];
		end end end
	endgenerate

	integer idx, cidx, kidx,
			jdx, cjdx, kjdx;

	reg signed [(data_size*2)-1:0] current;

	initial begin
		for (idx = 0; idx < in_channels; idx = idx + 1) begin
		for (jdx = 0; jdx < out_channels; jdx = jdx + 1) begin
			biases[idx][jdx] = 0;
		end end
	end

	always @* begin
		for (cjdx = out_channels - 1; cjdx >= 0; cjdx = cjdx - 1) begin
			$display("Output: %d", cjdx);
		for (cidx = in_channels - 1; cidx >= 0;  cidx = cidx - 1) begin
			$display("Input: %d", cidx);
			for (jdx = output_rows - 1; jdx >= 0; jdx = jdx - 1) begin
				$display("\tRow: %d", jdx);
			for (idx = output_cols - 1; idx >= 0; idx = idx - 1) begin
				$display("\tCol: %d", idx);
				current = biases[cidx][cjdx];
				for (kjdx = kernel_rows - 1; kjdx >= 0; kjdx = kjdx - 1) begin
				for (kidx = kernel_cols - 1; kidx >= 0; kidx = kidx - 1) begin
						$display("\t%d * %d", padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx], kernels[cidx][cjdx][kjdx][kidx]);
						current = current + 
							padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx] 
								* 
							kernels[cidx][cjdx] [kjdx][kidx];
				end end
				out[cjdx][jdx][idx] = current;
				$display("\t\t Value: %d", current);
			end	end
		end end
	end

endmodule

/*
always @* begin
		for (cjdx = 0; cjdx < out_channels; cjdx = cjdx + 1) begin
			$display("Output channel: %d", cjdx);
		for (cidx = 0; cidx < in_channels;  cidx = cidx + 1) begin
			$display("Input channel: %d", cidx);
			for (jdx = 0; jdx < output_rows; jdx = jdx + 1) begin
				$display("\tRow: %d", jdx);
			for (idx = 0; idx < output_cols; idx = idx + 1) begin
				$display("\tCol: %d", idx);
				current = biases[cidx][cjdx];
				for (kjdx = 0; kjdx < kernel_rows; kjdx = kjdx + 1) begin
				for (kidx = 0; kidx < kernel_cols; kidx = kidx + 1) begin
						$display("\t%d * %d", padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx], kernels[cidx][cjdx][(kernel_rows-1)-kjdx][(kernel_cols-1)-kidx]);
						current = current + 
							padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx] 
								* 
							kernels[cidx][cjdx] [(kernel_rows-1)-kjdx][(kernel_cols-1)-kidx];
				end end
				out[cjdx][jdx][idx] = current;
				$display("\t\t Value: %d", current);
			end	end
		end end
	end
*/