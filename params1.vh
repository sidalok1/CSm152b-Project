`ifndef DEF_PARAMS
`define DEF_PARAMS

    parameter in_size = 5;
    
        
    parameter in_channels = 1;
    parameter out_channels = 1;
    
    parameter kern_size = 3;
    
    parameter padding = 0;
    parameter stride = 1;
    
    parameter out_size = (in_size - kern_size + padding + stride) / stride;
    
    
    parameter number_of_inputs = 4;

`else

    defparam in_size = 5;
    
        
    defparam in_channels = 1;
    defparam out_channels = 1;
    
    defparam input_bus_size = (in_size ** 2) * `DATA_SIZE * in_channels;
    
    defparam kern_size = 3;
    
    defparam padding = 0;
    defparam stride = 1;
    
    defparam out_size = (in_size - kern_size + padding + stride) / stride;
    defparam output_bus_elemets = (out_size ** 2) * out_channels;
    defparam output_bus_size = output_bus_elemets * `DATA_SIZE;
    
    
    defparam number_of_inputs = 4;

`endif