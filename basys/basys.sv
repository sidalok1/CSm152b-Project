`include "macros.vh"

module basys (
	input 			clk,
	input			btnC, btnL, btnU, btnR, btnD,
	output	[6:0]	seg,
	output	[3:0]	an
);
	`include "params1.vh"
	reg [input_bus_size-1:0] inputs [0:number_of_inputs-1];

	reg [number_of_inputs-1:0] input_index;
	wire [input_bus_size-1:0] current_input;
	assign current_input = inputs[input_index];
	
	wire [(out_size * out_size * `DATA_SIZE) - 1 : 0] conv_out;
    
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
	) UUT ( current_input, conv_out );

	

	reg [$clog2(output_bus_elemets)-1:0] output_select;
	wire [$clog2(output_bus_size)-1:0] output_index;

	assign output_index = ((output_index + 1) * `DATA_SIZE) - 1;

	wire [7:0] conv_to_display;

	assign conv_to_display = conv_out[output_index -: `DATA_SIZE - 1];

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