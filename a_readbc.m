function [dev kerr]=a_readbc(p,dev,fout,torb)
global REF CONST
kerr=0;

ip(1).aliases={'Sp' 'sp'};
ip(1).type='number';
ip(1).n=[1 1;1 1];
ip(1).range=[0 inf];
ip(1).values={};
ip(1).default=[inf];

ip(2).aliases={'Sn' 'sn'};
ip(2).type='number';
ip(2).n=[1 1;1 1];
ip(2).range=[0 inf];
ip(2).values=[];
ip(2).default=[inf];

ip(3).aliases={'contact'};
ip(3).type='string';
ip(3).n=[1 1;1 1];
ip(3).range=[];
ip(3).values={'ideal' 'ohmic' 'blocking' 'Schottky'};
ip(3).default={'ideal'};

ip(4).aliases={'R_c' 'R_grid'}; % contact/grid resistance
ip(4).type='number';
ip(4).n=[1 1;1 1];
ip(4).range=[0 inf];
ip(4).values=[];
ip(4).default=[0];

ip(5).aliases={'shadow'};
ip(5).type='number';
ip(5).n=[1 1;1 1];
ip(5).range=[0 1];
ip(5).values=[];
ip(5).default=[0];

ip(6).aliases={'R_ext'}; % external relectance
ip(6).type='number';
ip(6).n=[1 1;1 1];
ip(6).range=[0 1];
ip(6).values=[];
ip(6).default=[0];

ip(7).aliases={'R_int'}; % internal reflectance
ip(7).type='number';
ip(7).n=[1 1;1 1];
ip(7).range=[0 1];
ip(7).values=[];
ip(7).default=[0];

ip(8).aliases={'R_ext.wl'}; % R vs wl file
ip(8).type='string';
ip(8).n=[1 1;1 1];
ip(8).range=[];
ip(8).values=[];
ip(8).default={'constant'};

ip(9).aliases={'phi_M' 'MWF' 'mwf'}; % metal work function
ip(9).type='number';
ip(9).n=[1 1;1 1];
ip(9).range=[-inf inf];
ip(9).values=[];
ip(9).default=[0];

[ip kerr]=a_diktat(p,ip,fout);

if strcmp(torb,'top')
    if strcmp(char(ip(3).set{1}),'ideal') || strcmp(char(ip(3).set{1}),'ohmic')
        dev.bc.top.eq_bc='neutral';
        dev.bc.top.neq_bc='ideal';
        if ip(1).set(1) < inf || ip(2).set(1) < inf
            disp('cannot set Sn or Sp for contact=ideal');
            kerr=kerr+1;
        end
        dev.bc.top.sp=inf;
        dev.bc.top.sn=inf;
    elseif strcmp(char(ip(3).set{1}),'blocking')
        dev.bc.top.eq_bc='neutral';
        dev.bc.top.neq_bc='non-ideal';
        dev.bc.top.sp=ip(1).set(1);
        dev.bc.top.sn=ip(2).set(1);
    elseif strcmp(char(ip(3).set{1}),'Schottky')
        dev.bc.top.eq_bc='Schottky';
        dev.bc.top.neq_bc='non-ideal';
        dev.bc.top.phim=ip(9).set(1);
        dev.bc.top.sp=ip(1).set(1);
        dev.bc.top.sn=ip(2).set(1);
    end
    dev.bc.top.rc=ip(4).set(1);
    dev.bc.top.shadow=ip(5).set(1);
    dev.bc.top.Rext=ip(6).set(1);
    dev.bc.top.Rint=ip(7).set(1);
    dev.bc.top.Rextfile=char(ip(8).set{1});
    
else % bottom    
    if strcmp(char(ip(3).set{1}),'ideal') || strcmp(char(ip(3).set{1}),'ohmic')
        dev.bc.bottom.eq_bc='neutral';
        dev.bc.bottom.neq_bc='ideal';
        if ip(1).set(1) < inf || ip(2).set(1) < inf
            disp('cannot set Sn or Sp for contact=ideal');
            kerr=kerr+1;
        end
        dev.bc.bottom.sp=inf;
        dev.bc.bottom.sn=inf;
    elseif strcmp(char(ip(3).set{1}),'blocking')
        dev.bc.bottom.eq_bc='neutral';
        dev.bc.bottom.neq_bc='non-ideal';
        dev.bc.bottom.sp=ip(1).set(1);
        dev.bc.bottom.sn=ip(2).set(1);
    elseif strcmp(char(ip(3).set{1}),'Schottky')
        dev.bc.bottom.eq_bc='Schottky';
        dev.bc.bottom.neq_bc='non-ideal';
        dev.bc.bottom.phim=ip(9).set(1);
        dev.bc.bottom.sp=ip(1).set(1);
        dev.bc.bottom.sn=ip(2).set(1);
    end
    dev.bc.bottom.rc=ip(4).set(1);
    dev.bc.bottom.shadow=ip(5).set(1);
    dev.bc.bottom.Rext=ip(6).set(1);
    dev.bc.bottom.Rint=ip(7).set(1);
    dev.bc.bottom.Rextfile=char(ip(8).set{1});
    
end