module #(
    parameter           num_clks=0,     //Default: generate only one 1hz clock out
    parameter integer   frequencies     [num_clks-1:0]
) clock (
    input                       rst,
    input                       sysclock,
    output reg [num_clks-1:0]   clocks
);
    localparam                  basys_cc = 50_000_000;
    
    wire integer                dividers [num_clks-1:0];
    reg [$clog2(basys_cc)-1:0]  counter;
    
    genvar i, divider_range, n;
    generate
        n = 0;
        
        for (i = 0; i < num_clks; i = i + 1)
            assign dividers[i] = basys_clk_cycles / frequencies[i];
        

    endgenerate

endmodule