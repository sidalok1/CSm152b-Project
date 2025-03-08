`timescale 1ns/1ps
module conv2d_tb ();

	parameter inpsize=5;
	parameter kersize=3;
	parameter datasize=8;

	reg [datasize-1:0] kern [1:kersize][1:kersize];

	reg [(inpsize*inpsize*datasize)-1:0] in;

	conv2d #( 1,1,kersize,kersize,1,1,0,0,0,inpsize,inpsize,datasize) UUT (.in(in));

	genvar i, j;

	generate
		for (i = 1; i <= kersize; i = i + 1) begin:row
		for (j = 1; j <= kersize; j = j + 1) begin:col
				wire [datasize-1:0] temp_kern;
				assign temp_kern = kern[i][j];
		end end
	endgenerate

	integer idx, jdx;

	initial begin
		$dumpfile(".signals");
		$dumpvars(0,conv2d_tb);

		

		$readmemh("./mem/kern.mem", kern);
		in = {
			8'd1,	8'd2,	8'd3,	8'd4,	8'd5,
			8'd6,	8'd7,	8'd8,	8'd9,	8'd10,
			8'd11, 	8'd12, 	8'd13, 	8'd14, 	8'd15,
			8'd16, 	8'd17, 	8'd18, 	8'd19, 	8'd20,
			8'd21, 	8'd22, 	8'd23, 	8'd24, 	8'd25
		};

		#100
		$finish();
	end

endmodule