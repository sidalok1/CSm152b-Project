module max_of_four ( out, in1, in2, in3, in4 );
    input wire signed [7:0] in1, in2, in3, in4;
    output wire signed [7:0] out;
    
    wire signed [7:0] max12, max3;
    
    assign max12 = (in1 > in2)   ? in1   : in2;
    assign max3  = (max12 > in3) ? max12 : in3;
    assign out   = (max3 > in4)  ? max3  : in4;
                            
endmodule