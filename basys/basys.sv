module basys (
	input 			clk,
	input			btnC, btnL, btnU, btnR, btnD,
	output	[6:0]	seg,
	output	[3:0]	an
);
	parameter data_size = 8;
	parameter input_size = 5;
	parameter kernel_size = 3;
	parameter number_of_inputs = 4;
	parameter in_channels = 1;
	parameter out_channels = 1;
	parameter input_bus_size = input_size * input_size * data_size * in_channels;

	reg [input_bus_size-1:0] inputs [0:number_of_inputs-1];

	reg [number_of_inputs-1:0] input_index;
	wire [input_bus_size-1:0] current_input;
	assign current_input = inputs[input_index];

	conv2d #(
		in_channels,
		out_channels,
		kernel_size,
		kernel_size,
		1,
		1,
		0,
		0,
		input_size,
		input_size,
		data_size
	) UUT ( current_input );

	parameter output_rows = UUT.output_rows;
	parameter output_cols = UUT.output_cols;
	parameter output_bus_elemets = output_rows * output_cols * out_channels;
	parameter output_bus_size = output_bus_elemets * data_size;

	reg [$clog2(output_bus_elemets)-1:0] output_select;
	wire [$clog2(output_bus_size)-1:0] output_index;

	assign output_index = ((output_index + 1) * data_size) - 1;

	wire [7:0] conv_to_display;

	assign conv_to_display = UUT.out[output_index -: data_size - 1];

	wire d_clk, _;

	clock #(1, {60}) clkdiv (0, clk, {d_clk, _});

	display sevseg (d_clk, conv_to_display, 1, an, seg);

	wire next_in, prev_in, next_out, prev_out, reset;

	debounce 
		bC (clk, btnC, reset),
		bL (clk, btnL, prev_in),
		bU (clk, btnU, next_out),
		bR (clk, btnR, next_in),
		bD (clk, btnD, prev_out);

	initial begin
		$readmemh("./mem/in.mem", inputs);
		$readmemh("./mem/kern.mem", UUT.kernels);
		output_select = 0;
		input_index = 0;
	end

	always @* begin
		if (reset) begin
			output_select = 0;
			input_index = 0;
		end 
		else begin
			if (next_in && (input_index < number_of_inputs))
				input_index = input_index + 1;
			else if (prev_in && (input_index > 0))
				input_index = input_index - 1;
			
			if (next_out && (output_select < output_bus_elemets))
				output_select = output_select + 1;
			else if (prev_out && (output_select > 0))
				output_select = output_select - 1;
		end
	end

endmodule