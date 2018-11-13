function dev=A_build(source)
% function dev=A_build(source)
%
% Define the semiconductor device to be simulated and simulate at
% thermal equilibrium @ temperature=REF.T
%
% source = diktat file name
%

global CONST A_FID VERBOSE

if nargin == 0
    error('A_build.m: no diktat file specified');
end

a_init;

if verLessThan('matlab','R2016a')
    dev.nD=0;
else
    dev=Adept; % create Adept object
end

nc=length(source);

% set global physical constants

% set up device structure
if isa(source,'Adept')
    dev=a_gui_1d(dev,source);
    % add test to make sure object came from GUI
elseif ischar(source)
    if strcmp(source(nc-2:nc),'.1d') 
        if VERBOSE disp('A_build: Parse and interpret diktat file'); end
        [dev ierr]=a_input0_1d(dev,source); 
%         % for creation of GUI test file
%         dev.OpCond.mode='gui_input';
%         dev.input_file='from GUI';
%         dev.diktats=[];
%         gui_example=dev;
%         A_save(gui_example);
%         return;
        if ierr > 0
            error('Errors in diktat file')
        end
    elseif strcmp(source(nc-3:nc),'.GUI')
        gui=A_load(source)
        dev=a_gui_1d(dev,gui);
    else
        error('Not a legal diktat file name')
    end
else
    error('Not a legal diktat file name or Adept object')
end

if VERBOSE disp('A_build: Setup device structure and finite box mesh'); end
    dev=a_setup(dev);

% get final equilibrium solution
if VERBOSE; disp('A_build: Get final equilibrium solution with a_doeq'); end
[dev error_code]=a_doeq(dev);
if error_code == 0
    error('A_build(1): simulation terminated');
end

% set carrier quasipotentials
% dev.node.zp=-dev.node.v;
% dev.node.zn=dev.node.v;

% save equilibrium values
dev.ele.plo=dev.ele.pl;
dev.ele.pro=dev.ele.pr;
dev.ele.nlo=dev.ele.nl;
dev.ele.nro=dev.ele.nr;
dev.node.zpo=dev.node.zp;
dev.node.zno=dev.node.zn;
dev.node.vo=dev.node.v;

% use non-equilibrium solver to get final equilibrium solution
if VERBOSE; disp('A_build: Get final equilibrium solution with a_doneq'); end
[dev,error_code]=a_doneq(dev);
if error_code == 0
    error('A_build(2): simulation terminated');
end
dev.OpCond.Gon=0;
 
% save equilibrium values
dev.node.zpo=dev.node.zp;
dev.ele.plo=dev.ele.pl;
dev.ele.pro=dev.ele.pr;
dev.node.zno=dev.node.zn;
dev.ele.nlo=dev.ele.nl;
dev.ele.nro=dev.ele.nr;
dev.node.vo=dev.node.v;
dev.ele.ntlo=dev.ele.ntl;
dev.ele.ntro=dev.ele.ntr;

% save data for extraction
dev.data=p_extract(dev);

dev.runno=a_srunno('EQ');
dev.eqrunno=dev.runno;