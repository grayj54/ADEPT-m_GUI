classdef Adept
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
        function dev=Adept(arg)
        % function dev=Adept(source)
        %
        % Define the semiconductor device to be simulated and simulate at
        % thermal equilibrium @ temperature=REF.T
        %
        % source = diktat file name
        %

        global CONST A_FID VERBOSE
             if nargin == 0
                 dev.nD=[];
                 dev.input_file='';
                 dev.OpCond=struct;
                 dev.const=A_const;
                 dev.diktats=cell(0);
                 dev.description='';
                 dev.T=[];
                 dev.type='';
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
             elseif nargin > 1
                error('Cannot construct Adept object')
            elseif isa(arg,'Adept')
                dev=arg;
            else
                error('Cannot construct Adept object')
            end
        end
        
        function disp(dev)
            if strcmp(dev.OpCond.mode,'gui_input')
                fprintf('  GUI input ADEPT object\n\n');
            elseif strcmp(dev.OpCond.mode,'equilibrium')
                fprintf('  ADEPT Object: %s\n',dev.runno);
                fprintf('   device type: %s\n',dev.type);
                fprintf('          mode: %s\n',dev.OpCond.mode);
                fprintf('\n');
            elseif strcmp(dev.runno,'')
                fprintf('  Empty ADEPT object\n\n');
            else
                fprintf('  ADEPT Object: %s\n',dev.runno);
                fprintf('   Equilibrium: %s\n',dev.eqrunno);
                fprintf('   device type: %s\n',dev.type);
                fprintf('          mode: %s\n',dev.OpCond.mode);
                fprintf('             V: %.3g Volts\n',dev.OpCond.Va);
                fprintf('             J: %.3g A/cm^2\n',dev.OpCond.Jt);
                fprintf('  Illumination: %s\n',dev.OpCond.Generation.type);
                fprintf('\n');
            end
        end
        
    end
    
end