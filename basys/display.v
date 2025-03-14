module display(
    input               disp_clk, 
    input signed[7:0]   din,
    input               en, 
    output  reg [3:0]   anodes,
    output      [6:0]   segment
    );
    
    reg                 sign;
    reg         [15:0]  num;
    reg         [1:0]   cnt;
    reg         [3:0]   currentNum;
    
    DecimalDecoder decode(currentNum, segment);
    
    initial begin
        cnt = 2'b00;
        num = 16'b0;
        sign = 0;
    end

    always @ (posedge disp_clk) begin 
        cnt <= cnt + 1;

        if (en) begin 
            if (din >= 0) begin
                num <= din;
                sign <= 0;
            end
            else begin
                num <= ~din + 1;
                sign <= 1;
            end
        end

        case (cnt)
            2'b00: begin
                anodes <= 4'b1110;
                currentNum <= (((num % 1000) % 100) % 10);
            end
            2'b01: begin
                anodes <= 4'b1101;
                currentNum <= ((num % 1000) % 100) / 10;
            end
            2'b10: begin
                anodes <= 4'b1011;
                currentNum <= (num % 1000) / 100;
            end
            2'b11: begin
                anodes <= 4'b0111;
                if (sign)
                    currentNum <= 4'hf;
                else
                    currentNum <= 4'he;
            end
        endcase
    end
    
endmodule

module DecimalDecoder(bin, cathodes);
    input       [3:0]   bin;
    
    output  reg [6:0]   cathodes;
    
    always @* begin
        case(bin)
            4'd1:       cathodes = 7'b1111001;
            4'd2:       cathodes = 7'b0100100;
            4'd3:       cathodes = 7'b0110000;
            4'd4:       cathodes = 7'b0011001;
            4'd5:       cathodes = 7'b0010010;
            4'd6:       cathodes = 7'b0000010;
            4'd7:       cathodes = 7'b1111000;
            4'd8:       cathodes = 7'b0000000;
            4'd9:       cathodes = 7'b0011000;
            4'he:       cathodes = 7'b1111111;
            4'hf:       cathodes = 7'b0111111;
            default:    cathodes = 7'b1000000;
        endcase
    end
endmodule 