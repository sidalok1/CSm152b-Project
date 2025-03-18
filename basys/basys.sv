`include "macros.vh"
module basys (
	input 			clk,
	input			btnC, btnL, btnU, btnR, btnD,
	output	[6:0]	seg,
	output	[3:0]	an
);
	`include "params1.vh"
	//reg [`DATA_SIZE-1:0] inputs [0:number_of_inputs-1][0:(in_channels * (in_size ** 2))-1];
	reg signed [`DATA_SIZE-1:0] inputs [0:(in_channels * (in_size ** 2))-1];

	wire signed [`DATA_SIZE-1:0] current_input [0:in_channels-1][0:in_size-1][0:in_size-1];
	genvar ii, jj, kk;
	generate
		for (gi = 0; gi < in_channels; gi = gi + 1) begin
		for (gj = 0; gj < in_size; gj = gj + 1) begin
		for (gk = 0; gk < in_size; gk = gk + 1) begin
			assign current_input[gi][gj][gk] = inputs[input_index][gi][gj][gk];
		end end end
	endgenerate
	
	wire signed [`DATA_SIZE-1:0] conv1_out [0:out_channels_1-1][0:out_size_1-1][0:out_size_1-1];
	
	wire signed [`DATA_SIZE-1:0] conv1_ReLU_out [0:out_channels_1-1][0:out_size_1-1][0:out_size_1-1];
	
	wire signed [`DATA_SIZE-1:0] conv1_maxpool_out [0:out_channels_1-1][0:maxpool_size_1-1][0:maxpool_size_1-1];
    
	conv2d #(
		in_channels,
		out_channels_1,
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

	ReLU #(out_channels_1, out_size_1, out_size_1, `DATA_SIZE) conv1_relu (conv1_out, conv1_ReLU_out);
	
	maxpool #(.in_channels(out_channels_1), .rows(out_size_1), .cols(out_size_1), .data_size(`DATA_SIZE)) conv1_maxpool (conv1_ReLU_out, conv1_maxpool_out);

    wire signed [`DATA_SIZE-1:0] conv2_out [0:out_channels_2-1][0:out_size_2-1][0:out_size_2-1];
	
	wire signed [`DATA_SIZE-1:0] conv2_ReLU_out [0:out_channels_2-1][0:out_size_2-1][0:out_size_2-1];
	
	wire signed [`DATA_SIZE-1:0] conv2_maxpool_out [0:out_channels_2-1][0:maxpool_size_2-1][0:maxpool_size_2-1];

    conv2d #(
		out_channels_1,
		out_channels_2,
		kern_size,
		kern_size,
		stride,
		stride,
		padding,
		padding,
		maxpool_size_1,
		maxpool_size_1,
		`DATA_SIZE
	) conv2 ( .in(conv1_maxpool_out), .out(conv2_out) );

	ReLU #(out_channels_2, out_size_2, out_size_2, `DATA_SIZE) conv2_relu (conv2_out, conv2_ReLU_out);
	
	maxpool #(.in_channels(out_channels_2), .rows(out_size_2), .cols(out_size_2), .data_size(`DATA_SIZE)) conv2_maxpool (conv2_ReLU_out, conv2_maxpool_out);
    
    wire signed [`DATA_SIZE-1:0] fc_in [0:(out_channels_2 * (maxpool_size_2)**2)-1];
    
    genvar n, m, c;
    generate
        for (c = 0; c < out_channels_2; c = c + 1) begin
            for (n = 0; n < maxpool_size_2; n = n + 1) begin
            for (m = 0; m < maxpool_size_2; m = m + 1) begin
                assign fc_in[(c * (maxpool_size_2 ** 2)) + (n * maxpool_size_2) + m] = conv2_maxpool_out[c][n][m];
            end end
        end
    endgenerate
    
    wire signed [`DATA_SIZE-1:0] fc_out [0:9];
    
    fullyconnected #((out_channels_2 * (maxpool_size_2**2)), 10, `DATA_SIZE) fc (fc_in, fc_out); 
    
    wire [`DATA_SIZE-1:0] soft_max_out;
    
    soft_onehot #(10, `DATA_SIZE) encoder (fc_out, soft_max_out);

	integer i, j, k;

	wire signed [7:0] conv_to_display;

	assign conv_to_display = soft_max_out;

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
		$readmemh("in42_0-0.mem", inputs);
		$readmemh("conv1_bias.mem", conv1.biases);
		$readmemh("conv2_bias.mem", conv2.biases);
		$readmemh("fc_bias.mem", fc.biases);
		$readmemh("fc_weights.mem", fc.weight_mem);
		`include "readmems.vh"
		_reset = 0;
		_next_out = 0;
		_prev_out = 0;
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
		
		    _reset <= reset;
		    _next_out <= next_out;
		    _prev_out <= prev_out;
		
			if (nxt) begin
			
			     if (k == maxpool_size_2 - 1) begin
			         if (j == maxpool_size_2 - 1) begin
			             if (i == out_channels_2 - 1) begin
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
			                 j <= maxpool_size_2 - 1;
			                 k <= maxpool_size_2 - 1;
			             end
			         end else begin
			             j <= j - 1;
			             k <= maxpool_size_2 - 1;
			         end
			     end else begin
			         k <= k - 1;
			     end
			     
			end
		end
	end

endmodule