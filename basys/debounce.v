module debounce #(parameter cycles = 16) (clk, in, out);

	input clk, in;
	output out;

	reg signed [cycles-1:0] d;

	assign out = d == -1;

	initial d = 0;

	always @( posedge clk ) begin
		d[cycles-1:1] = d[cycles-2:0];
		d[0] = in;
	end

endmodule