classdef defaultdevObj
% Adept data type

    properties
        runno char
        eqrunno char
        nD
        input_file char
        OpCond struct
        const A_const
        diktats cell
        description char
        T double
        type char
        Optical struct
        bc struct
        reg struct
        semi struct
        mesh struct
        misc struct
        newton struct
        ref struct
        norm struct
        node struct
        ele struct
        nt struct
        data struct
    end
    
    methods
        function dev=defaultdevObj()
        % function dev=Adept(source)
        %
        % Define the semiconductor device to be simulated and simulate at
        % thermal equilibrium @ temperature=REF.T
        %
        % source = diktat file name
        %



                 dev.nD=[];
                 dev.input_file='';
                 dev.OpCond=struct;
                 dev.const=A_const;
                 dev.diktats=cell(0);
                 dev.description='';
                 dev.T= 300;
                 dev.type= 1;
                 dev.Optical=struct;
                 dev.bc=struct;
                 dev.reg=struct;
                 dev.semi=struct;
                 dev.mesh=struct;
                 dev.misc=struct;
                 dev.newton=struct;
                 dev.ref=struct;
                 dev.norm=struct;
                 dev.node=struct;
                 dev.ele=struct;
                 dev.nt=struct;
                 dev.data=struct;
                 dev.runno='';
                 dev.eqrunno='';
             
        end
    end

    
end