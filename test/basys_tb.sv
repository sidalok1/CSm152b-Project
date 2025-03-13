`timescale 1ns/1ps
`include "macros.vh"
module basys_tb ();
	reg clk, bC, bL, bU, bR, bD;
	wire integer _;
	always #0.5 clk = ~clk;
	basys UUT (clk, bC, bL, bU, bR, bD, _, _);
	initial begin
		$dumpfile(".signals");
		$dumpvars(0, basys_tb);
		{clk, bC, bL, bU, bR, bD} = 0;
		#10 $finish();
	end
endmodule