module basys (
	input 			clk,
	input			btnC, btnL, btnU, btnR, btnD,
	output	[6:0]	seg,
	output	[3:0]	an
);
    wire s;
	wire [7:0] display;
    wire sec;
	wire d_clk;
	
	seq1 UUT (clk, s, display[0]); assign display[7:1] = 0;

	clock #(1, 60*4) clkdiv (1'b0, clk, d_clk);

	display sevseg (d_clk, display, 1'b1, an, seg);

	debounce #(8) bC (d_clk, btnC, s);

endmodule