`timescale 1ns/1ps
`include "macros.vh"
module basys_tb ();
	reg clk, bC, bL, bU, bR, bD;
	integer i;
	wire _;
	always #0.5 clk = ~clk;
	basys UUT (clk, bC, bL, bU, bR, bD, _, _);
	initial begin
		$dumpfile(".signals");
		$dumpvars(0, basys_tb);
		{clk, bC, bL, bU, bR, bD} = 0;
		#400 bD = 1; #400 bD = 0;
		for (i = 0; i < 2; i++) begin
		#4000 bU = 1; #4000 bU = 0;
		end
		for (i = 0; i < 5; i++) begin
		#400 bR = 1; #400 bR = 0;
		end
		for (i = 0; i < 5; i++) begin
		#400 bL = 1; #400 bL = 0;
		end
		for (i = 0; i < 10; i++) begin
		#400 bD = 1; #400 bD = 0;
		end
		for (i = 0; i < 10; i++) begin
		#400 bU = 1; #400 bU = 0;
		end

	end
endmodule