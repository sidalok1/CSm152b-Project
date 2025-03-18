module maxpool 
	#(parameter
		in_channels=1,
		kernel_rows=2,
		kernel_cols=2,
		stride_row=2,
		stride_col=2,
		pad_rows=0,
		pad_cols=0,
		rows=27,
		cols=27,
		data_size=8
	)
	(
		in,
		out
	);
    localparam out_channels = in_channels;
    
	input wire signed [data_size-1:0] in [0:in_channels-1][0:rows-1][0:cols-1];

	localparam output_rows = 
		(rows - kernel_rows + pad_rows + stride_row) / stride_row;
	localparam output_cols = 
		(cols - kernel_cols + pad_cols + stride_col) / stride_col;
	output reg signed [data_size-1:0] out [0:out_channels-1][0:output_rows-1][0:output_cols-1];

	genvar i, j, ci, co;
	generate
		
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

	integer idx, cidx, kidx,
			jdx, cjdx, kjdx,
			ind;

	reg signed [(data_size*2)-1:0] current;

	always @* begin
		for (cjdx = out_channels - 1; cjdx >= 0; cjdx = cjdx - 1) begin
			$display("Output: %d", cjdx);
		for (cidx = in_channels - 1; cidx >= 0;  cidx = cidx - 1) begin
			$display("Input: %d", cidx);
			for (jdx = output_rows - 1; jdx >= 0; jdx = jdx - 1) begin
				$display("\tRow: %d", jdx);
			for (idx = output_cols - 1; idx >= 0; idx = idx - 1) begin
				$display("\tCol: %d", idx);
				ind = (((cjdx * (output_rows * output_cols)) + (jdx * (output_rows)) + idx)	* data_size) + data_size - 1;
				current = 0;
				for (kjdx = kernel_rows - 1; kjdx >= 0; kjdx = kjdx - 1) begin
				for (kidx = kernel_cols - 1; kidx >= 0; kidx = kidx - 1) begin
						$display("\t%d > %d?", padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx], current);
                        if (padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx] > current) begin
                            current = padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx];
                        end
				end end
				out[cjdx][jdx][idx] = current;
				$display("\t\t Value: %d", current);
			end	end
		end end
	end

endmodule