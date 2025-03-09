/*
Parameterized clock divider module for Basys 3 (or any 100 mhz PLD)

If no parameters are passed, then output register is a 1 hz clock.

Otherwise, pass the number of clocks desired as num_clks parameter.
Also, pass an array of integers (parameter frequencies) the desired
frequency of each clock. For N desired clocks, this array should be
[N-1:0]. The clk output register will be [N:0], with clk[N] being a
1 hz clock always.

Note that passing (packed) arrays as parameters is supported only in
SystemVerilog
*/

module #(
    parameter           num_clks=0,     //Default: generate only one 1hz clock out
    parameter integer   frequencies     [num_clks-1:0] //Should be specified in megaherts
) clock (
    input                       rst,
    input                       sysclk,
    output reg [num_clks:0]     clk
);
    localparam                  basys_cc = 100_000_000;
    
    wire integer                dividers [num_clks:0];
    reg [$clog2(basys_cc)-1:0]  counter;
    
    integer i;
    generate
        for ( i = 0; i < num_clks; i = i + 1 )
            assign dividers[i] = basys_cc / (2 * frequencies[i]);
        assign dividers[num_clks] = basys_cc / 2;
    endgenerate

    initial begin
        counter = 0;
        clk = 0;
    end

    always @( posedge sysclk, posedge rst ) begin
        if (counter == dividers[num_clks] ) begin
            clk <= ~clk;
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
            for ( i = 0; i < num_clks < i = i + 1 )
                if ( (counter % dividers[i]) == 0 )
                    clk[i] <= ~clk[i];
        end
    end

endmodule