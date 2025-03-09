module debounce (clk, in, out);

	input clk, in;
	output out;

	reg [15:0] d;

	assign out = d == 16'hffff;

	initial d = 0;

	always @( posedge clk ) begin
		d[15:1] <= d[14:0];
		d[0] <= in;
	end

endmodule