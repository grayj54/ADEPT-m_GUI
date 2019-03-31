classdef defaultDevObj < handle
% Adept data type

    properties
        nD char
        input_file char
        type char
        title char
        device struct
        mesh struct
        misc struct
        top struct
        layers struct
        bottom struct
    end
    
    methods
        function dev=defaultDevObj()
            dev.nD = '1d';
            dev.input_file = '';
            dev.type = 'gui_input';
            dev.title = '';
            dev.device(1).ip = a_init_dev;
            dev.mesh(1).ip = a_init_mesh;
            dev.misc(1).ip = a_init_misc;
            dev.top(1).ip = a_init_bc;
            dev.layers(1).describe = '';
            dev.layers(1).ip = a_init_custom;
            dev.bottom(1).ip = a_init_bc;            
        end
    end 
end