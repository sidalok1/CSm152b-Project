`include "macros.vh"

module basys (
	input 			clk,
	input			btnC, btnL, btnU, btnR, btnD,
	output	[6:0]	seg,
	output	[3:0]	an
);
	`include "params1.vh"
	//reg [`DATA_SIZE-1:0] inputs [0:number_of_inputs-1][0:(in_channels * (in_size ** 2))-1];
	reg [`DATA_SIZE-1:0] inputs [0:(in_channels * (in_size ** 2))-1];

	wire [`DATA_SIZE-1:0] current_input [0:in_channels-1][0:in_size-1][0:in_size-1];
	genvar ii, jj, kk;
	generate
	   for (ii = 0; ii < in_channels; ii = ii + 1) begin
	   for (jj = 0; jj < in_size; jj = jj + 1) begin
	   for (kk = 0; kk < in_size; kk = kk + 1) begin
	       assign current_input[ii][jj][kk] = inputs[(ii * in_size * in_size) + (jj * in_size) + kk];
	   end end end
	endgenerate 
	

	/*always @( posedge clk ) begin
	integer gi, gj, gk;
		 for (gi = 0; gi < in_channels; gi = gi + 1) begin
		for (gj = 0; gj < in_size; gj = gj + 1) begin
		for (gk = 0; gk < in_size; gk = gk + 1) begin
			current_input[gi][gj][gk] = inputs[input_index][gi][gj][gk];
		end end end 
		current_input = inputs[input_index +: (in_channels * (in_size ** 2)];
	end*/
	
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

	clock #(1, 60*4) clkdiv (1'b0, clk, d_clk);

	display sevseg (d_clk, conv_to_display, 1'b1, an, seg);

	wire next_in, prev_in, next_out, prev_out, reset;
    reg _reset, _next_out, _prev_out;
    wire rst, nxt, prv;
    assign rst = reset & ~_reset;
    assign nxt = next_out & ~_next_out;
    assign prv = prev_out & ~_prev_out;
	debounce #(8)
		bC (d_clk, btnC, reset),
		bL (d_clk, btnL, prev_in),
		bU (d_clk, btnU, prev_out),
		bR (d_clk, btnR, next_in),
		bD (d_clk, btnD, next_out);

	initial begin
		$readmemh("in.mem", inputs);
		$readmemh("kern.mem", conv1.kernels);
		_reset = 0;
		_next_out = 0;
		_prev_out = 0;
		i = 0;
		j = 0;
		k = 0;
	end

	always @( posedge clk ) begin
		if (rst) begin
            _reset <= 0;
            _next_out <= 0;
            _prev_out <= 0;
			k <= 0;
			j <= 0;
			i <= 0;
		end 
		else begin
		
		    _reset <= reset;
		    _next_out <= next_out;
		    _prev_out <= prev_out;
		
			if (nxt) begin
			
			     if (k == out_size - 1) begin
			         if (j == out_size - 1) begin
			             if (i == out_channels - 1) begin
			                 //do nothing
			             end else begin
			                 i <= i + 1;
			                 j <= 0;
			                 k <= 0;
			             end
			         end else begin
			             j <= j + 1;
			             k <= 0;
			         end
			     end else begin
			         k <= k + 1;
			     end
			
			end
			else if (prv) begin
			
				 if (k == 0) begin
			         if (j == 0) begin
			             if (i == 0) begin
			                 //do nothing
			             end else begin
			                 i <= i - 1;
			                 j <= out_size - 1;
			                 k <= out_size - 1;
			             end
			         end else begin
			             j <= j - 1;
			             k <= out_size - 1;
			         end
			     end else begin
			         k <= k - 1;
			     end
			     
			end
		end
	end

endmodule