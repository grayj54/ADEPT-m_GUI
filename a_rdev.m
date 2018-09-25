function [dev kerr]=a_rdev(p,dev,fout)
global REF CONST VERBOSE

ip(1).aliases={'T' 'T_K' 'T_C'};
ip(1).type='number';
ip(1).n=[1 1;1 1];
ip(1).range=[-inf inf];
ip(1).values={};
ip(1).default=[300];

ip(2).aliases={'type'};
ip(2).type='string';
ip(2).n=[1 1;1 1];
ip(2).range=[];
ip(2).values={'Solar_Cell' 'solar_cell' 'Diode' 'diode' 'Generic' 'generic'};
ip(2).default={'Solar_Cell'};

ip(3).aliases={'n_pass'}; % # passes for light
ip(3).type='number';
ip(3).n=[1 1;1 1];
ip(3).range=[1 1000];
ip(3).values=[];
ip(3).default=[1];

[ip kerr]=a_diktat(p,ip,fout);

dev.T=double(ip(1).set);
if strcmp(ip(1).name,'T_C')
    dev.T=dev.T-CONST.abs_zero;
end
if dev.T <= 0
    kerr=kerr+1;
    if VERBOSE; fprintf('a_rdev.m: T must be > 0\n'); end
end
REF.t=dev.T;

type=char(ip(2).set{1});
if strcmp(type,'solar_cell') ||strcmp(type,'Solar_Cell')
    dev.type='Solar Cell';
elseif strcmp(type,'diode') ||strcmp(type,'Diode')
    dev.type='Diode';
elseif strcmp(type,'generic') ||strcmp(type,'Generic')
    dev.type='Generic';
end

dev.Optical.npass=double(ip(3).set);