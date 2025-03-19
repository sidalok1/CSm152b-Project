/*
Parameterized clock divider module for Basys 3 (or any 100 mhz PLD)

If no parameters are passed, then output register is a 1 hz clock.

Instantiates a single output clock at the frequency given by the
frequency param
*/

module clock #(
    parameter   num_clks=0,     //Default: generate only one 1hz clock out
    parameter   frequency=1     
) (
    input       rst,
    input       sysclk,
    output reg  clk
);
    localparam                  basys_cc = 100_000_000;
    localparam                  divider = basys_cc / (2 * frequency);
    reg [$clog2(divider)-1:0]  counter;

    initial begin
        counter = 0;
        clk = 0;
    end

    always @( posedge sysclk ) begin
        if (rst) begin
            counter <= 0;
            clk <= 0;
        end
        else if (counter == divider ) begin
            clk <= ~clk;
            counter <= 0;
        end
        else counter <= counter + 1;
    end

endmodule