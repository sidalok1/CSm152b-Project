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
		bias=1,
		rows=27,
		cols=27,
		data_size=8
	)
	(
		in,
		out
	);

	//$display("Instantiating %d input channels of uint%d matrices size %dx%d"
	//	,in_channels, data_size, cols, rows);
	input [
		(((rows * cols) * in_channels) * data_size) - 1
		:
		0
	] in;

	localparam output_rows = 
		(rows - kernel_rows + pad_rows + stride_row) / stride_row;
	localparam output_cols = 
		(cols - kernel_cols + pad_cols + stride_col) / stride_col;
	//$display("Instantiating %d output channels of size %dx%d"
	//	,out_channels, output_cols, output_rows);
	output reg signed [
		(((output_rows * output_cols) * out_channels) * data_size) - 1
		:
		0
	] out;

	genvar i, j, ci, co;
	generate
		
		
		//$display("Instantiating %d kernels for every %d input channels of size %dx%d"
		//	,out_channels, in_channels, kernel_cols, kernel_rows);
		reg signed [data_size-1:0] kernels [0:in_channels-1][0:out_channels-1][0:kernel_rows-1][0:kernel_cols-1];

		if (bias == 0) 
			begin
				//$display("Bias not asserted, setting bias to zero");
				wire [data_size-1:0] biases [0:in_channels-1][0:out_channels-1];
				for (i = 0; i < in_channels; i = i + 1)
					for (j = 0; j < out_channels; j = j + 1)
						assign biases[i][j] = 0;
			end
		else
			begin
				//$display("Instantiating bias registers");
				reg [data_size-1:0] biases [0:in_channels-1][0:out_channels-1];
			end

		wire signed [data_size-1:0] padded_inputs [0:in_channels-1][0:(rows + (2 * pad_rows))-1][0:(cols + (2 * pad_cols))-1];

		//Assign input matrices from inputs
		//$display("Padding input matrices");
		for (ci = in_channels - 1; ci >= 0; ci = ci - 1) begin
			for (j = (rows + (2 * pad_rows)) - 1; j >= 0; j = j - 1) begin
			for (i = (cols + (2 * pad_cols)) - 1; i >= 0; i = i - 1) begin
				if (i < pad_cols || i > (cols + pad_cols) || j < pad_rows || j > (rows + pad_rows))
					assign padded_inputs[ci][j][i] = 0;
				else
					assign padded_inputs[ci][j][i] = in[((ci * rows * cols) + (j * rows) + i) * data_size +: data_size-1];
			end end
		end
	endgenerate

	generate
		for (ci = 0; ci < in_channels;  ci = ci + 1) begin:kern_input_channels
		for (co = 0; co < out_channels; co = co + 1) begin:kern_output_channels
		for (i = 0; i < kernel_rows; i = i + 1) begin:kern_row
		for (j = 0; j < kernel_cols; j = j + 1) begin:kern_col
				wire [data_size-1:0] kern;
				assign kern = kernels[ci][co] [i][j];
		end end end end

		for (ci = 0; ci < in_channels;  ci = ci + 1) begin:in_input_channels
		for (i = 0; i < rows; i = i + 1) begin:in_row
		for (j = 0; j < cols; j = j + 1) begin:in_col
				wire [data_size-1:0] inp;
				assign inp = padded_inputs[ci][i][j];
		end end end
	endgenerate

	integer idx, cidx, kidx,
			jdx, cjdx, kjdx, 
			ind;

	reg signed [(data_size*2)-1:0] current;

	initial $readmemh("./mem/kern.mem", kernels);

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
				current = bias[cidx][cjdx];
				for (kjdx = kernel_rows - 1; kjdx >= 0; kjdx = kjdx - 1) begin
				for (kidx = kernel_cols - 1; kidx >= 0; kidx = kidx - 1) begin
						$display("\t%d * %d", padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx], kernels[cidx][cjdx][(kernel_rows-1)-kjdx][(kernel_cols-1)-kidx]);
						current += 
							padded_inputs[cidx][(jdx * stride_row) + kjdx][(idx * stride_col) + kidx] 
								* 
							kernels[cidx][cjdx] [(kernel_rows-1)-kjdx][(kernel_cols-1)-kidx];
				end end
				out[ind -: data_size-1] = current[data_size-1:0];
				$display("\t\t Value: %d", current);
			end	end
		end end
	end

endmodule