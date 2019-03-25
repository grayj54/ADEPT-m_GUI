function ip=a_init_bc

ip(1).aliases={'Sp' 'sp'};
ip(1).units='cm/s';
ip(1).full_name='Surface recombination velocity for holes';
ip(1).type='number';
ip(1).n=[1 1;1 1];
ip(1).range=[0 inf];
ip(1).values={};
ip(1).default=[inf];

ip(2).aliases={'Sn' 'sn'};
ip(2).units='cm/s';
ip(2).full_name='Surface recombination velocity for electrons';
ip(2).type='number';
ip(2).n=[1 1;1 1];
ip(2).range=[0 inf];
ip(2).values=[];
ip(2).default=[inf];

ip(3).aliases={'contact'};
ip(3).units='';
ip(3).full_name='Contact type';
ip(3).type='string';
ip(3).n=[1 1;1 1];
ip(3).range=[];
ip(3).values={'ideal' 'ohmic' 'blocking' 'Schottky'};
ip(3).default={'ideal'};

ip(4).aliases={'R_c' 'R_grid'}; % contact/grid resistance
ip(4).units='ohm-cm^2';
ip(4).full_name='Contact resistance';
ip(4).type='number';
ip(4).n=[1 1;1 1];
ip(4).range=[0 inf];
ip(4).values=[];
ip(4).default=[0];

ip(5).aliases={'shadow'};
ip(5).units=' ';
ip(5).full_name='Surface shadowing';
ip(5).type='number';
ip(5).n=[1 1;1 1];
ip(5).range=[0 1];
ip(5).values=[];
ip(5).default=[0];

ip(6).aliases={'R_ext'}; % external relectance if R_ext.wl='constant'
ip(6).units=' ';
ip(6).full_name='External reflectance';
ip(6).type='number';
ip(6).n=[1 1;1 1];
ip(6).range=[0 1];
ip(6).values=[];
ip(6).default=[0];

ip(7).aliases={'R_int'}; % internal reflectance
ip(7).units=' ';
ip(7).full_name='Internal reflectance';
ip(7).type='number';
ip(7).n=[1 1;1 1];
ip(7).range=[0 1];
ip(7).values=[];
ip(7).default=[0];

ip(8).aliases={'R_ext.wl'}; % R vs wl file
ip(8).units='';
ip(8).full_name='File name for R(wl)';
ip(8).type='string';
ip(8).n=[1 1;1 1];
ip(8).range=[];
ip(8).values=[];
ip(8).default={'constant'}; % no file, use R_ext

ip(9).aliases={'phi_M' 'MWF' 'mwf'}; % metal work function if contact='Schottky'
ip(9).units='eV';
ip(9).full_name='Metal contact work function';
ip(9).type='number';
ip(9).n=[1 1;1 1];
ip(9).range=[-inf inf];
ip(9).values=[];
ip(9).default=[0];
