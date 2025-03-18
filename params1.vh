`ifndef DEF_PARAMS
`define DEF_PARAMS

    parameter number_of_inputs = 3;

    parameter in_size = 28;
        
    parameter in_channels = 1;
    parameter out_channels_1 = 16;
    
    parameter kern_size = 3;
    
    parameter padding = 0;
    parameter stride = 1;
    
    parameter out_size_1 = (in_size - kern_size + padding + stride) / stride;
    parameter maxpool_size_1 = out_size_1 / 2;
    
    
    
    parameter out_channels_2 = 32;
    
    parameter out_size_2 = (out_size_1 - kern_size + padding + stride) / stride;
    parameter maxpool_size_2 = out_size_2 / 2;

`else

    defparam number_of_inputs = 3;

    defparam in_size = 28;
        
    defparam in_channels = 1;
    defparam out_channels_1 = 16;
    
    defparam kern_size = 3;
    
    defparam padding = 0;
    defparam stride = 1;
    
    defparam out_size_1 = (in_size - kern_size + padding + stride) / stride;
    defparam maxpool_size_1 = out_size_1 / 2;
    
    
    
    defparam out_channels_2 = 32;
    
    defparam out_size_2 = (maxpool_size_1 - kern_size + padding + stride) / stride;
    defparam maxpool_size_2 = out_size_2 / 2;


`endif