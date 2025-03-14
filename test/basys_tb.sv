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
		#40 bD = 1; #40 bD = 0;
		for (i = 0; i < 2; i++) begin
		#40 bU = 1; #40 bU = 0;
		end
		for (i = 0; i < 5; i++) begin
		#40 bR = 1; #40 bR = 0;
		end
		for (i = 0; i < 5; i++) begin
		#40 bL = 1; #40 bL = 0;
		end
		for (i = 0; i < 10; i++) begin
		#40 bD = 1; #40 bD = 0;
		end
		for (i = 0; i < 10; i++) begin
		#40 bU = 1; #40 bU = 0;
		end

		

		#40 $finish();
	end
endmodule