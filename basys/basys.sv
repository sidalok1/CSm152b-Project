`include "macros.vh"

module basys (
	input 			clk,
	input			btnC, btnL, btnU, btnR, btnD,
	output	[6:0]	seg,
	output	[3:0]	an
);
	`include "params1.vh"
	reg [`DATA_SIZE-1:0] inputs [0:number_of_inputs-1][0:in_channels-1][0:in_size-1][0:in_size-1];

	reg [number_of_inputs-1:0] input_index;
	wire [`DATA_SIZE-1:0] current_input [0:in_channels-1][0:in_size-1][0:in_size-1];
	genvar gi, gj, gk;
	generate
		for (gi = 0; gi < in_channels; gi = gi + 1) begin
		for (gj = 0; gj < in_size; gj = gj + 1) begin
		for (gk = 0; gk < in_size; gk = gk + 1) begin
			assign current_input[gi][gj][gk] = inputs[input_index][gi][gj][gk];
		end end end
	endgenerate
	
	wire [`DATA_SIZE-1:0] conv1_out [0:out_channels-1][0:out_size-1][0:out_size-1];
    
	conv2d #(
		in_channels,
		out_channels,
		kern_size,
		kern_size,
		stride,
		stride,
		padding,
		padding,
		in_size,
		in_size,
		`DATA_SIZE
	) conv1 ( .in(current_input), .out(conv1_out) );

	

	integer i, j, k;

	wire [7:0] conv_to_display;

	assign conv_to_display = conv1_out[i][j][k];

	wire d_clk;

	clock #(1, 60) clkdiv (1'b0, clk, d_clk);

	display sevseg (d_clk, conv_to_display, 1'b1, an, seg);

	wire next_in, prev_in, next_out, prev_out, reset;

	debounce 
		bC (clk, btnC, reset),
		bL (clk, btnL, prev_in),
		bU (clk, btnU, prev_out),
		bR (clk, btnR, next_in),
		bD (clk, btnD, next_out);

	initial begin
		$readmemh("in.mem", inputs);
		$readmemh("kern.mem", conv1.kernels);
		i = 0;
		j = 0;
		k = 0;
		input_index = 0;
	end

	always @* begin
		if (reset) begin
			input_index = 0;
		end 
		else begin
			if (next_in && (input_index < number_of_inputs - 1))
				input_index = input_index + 1;
			else if (prev_in && (input_index > 0))
				input_index = input_index - 1;
			
			if (next_out) begin
				if (k < out_size - 1)
					k = k + 1;
				else if (j < out_size - 1) begin
					k = 0;
					j = j + 1;
				end
				else if (i < out_channels - 1) begin
					k = 0;
					j = 0;
					i = i + 1;
				end
			end
			else if (prev_out) begin
				if (k > 0)
					k = k - 1;
				else if (j > 0) begin
					k = out_size - 1;
					j = j - 1;
				end
				else if (i > 0) begin
					k = out_size - 1;
					j = out_size - 1;
					i = i - 1;
				end
			end
		end
	end

endmodule