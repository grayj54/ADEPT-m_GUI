function ip=a_init_misc

ip(1).aliases={'ref_chi'};
ip(1).units='eV';
ip(1).full_name='Electron affinity';
ip(1).type='number';
ip(1).n=[1 1;1 1];
ip(1).range=[-inf inf];
ip(1).values=[];
ip(1).default=[4];

ip(2).aliases={'ref_Nc'};
ip(2).units='cm^-3';
ip(2).full_name='Reference conduction band effective density-of-states';
ip(2).type='number';
ip(2).n=[1 1;1 1];
ip(2).range=[1 inf];
ip(2).values={};
ip(2).default=1e19;
%ip(2).default=sqrt(1e20*exp(1.12/REF.t/CONST.kb));

ip(3).aliases={'ref_Nv'};
ip(3).units='cm^-3';
ip(3).full_name='Reference valence band effective density-of-states';
ip(3).type='number';
ip(3).n=[1 1;1 1];
ip(3).range=[1 inf];
ip(3).values={};
ip(3).default=1e19;
%ip(3).default=sqrt(1e20*exp(1.12/REF.t/CONST.kb));

ip(4).aliases={'ref_Eg'};
ip(4).units='eV';
ip(4).full_name='Reference bandgap';
ip(4).type='number';
ip(4).n=[1 1;1 1];
ip(4).range=[eps inf];
ip(4).values=[];
ip(4).default=[1];

ip(5).aliases={'ref_ks'};
ip(5).units=' ';
ip(5).full_name='Reference dielectric constant';
ip(5).type='number';
ip(5).n=[1 1;1 1];
ip(5).range=[1 inf];
ip(5).values=[];
ip(5).default=[10];

ip(6).aliases={'Fermi-Dirac' 'F-D'};
ip(6).units='';
ip(6).full_name='Fermi-Dirac statistics flag';
ip(6).type='string';
ip(6).n=[1 1;1 1];
ip(6).range=[];
ip(6).values={'on' 'off' 'on_val'};
ip(6).default={'off'};

ip(7).aliases={'itmaxq'};
ip(7).units='iterations';
ip(7).full_name='Maximum # of iterations for equilibrium solver';
ip(7).type='number';
ip(7).n=[1 1;1 1];
ip(7).range=[1 inf];
ip(7).values={};
ip(7).default=[100];

ip(8).aliases={'deltaq'};
ip(8).units='kT';
ip(8).full_name='Maximum error for equilibrium solver';
ip(8).type='number';
ip(8).n=[1 1;1 1];
ip(8).range=[eps 1];
ip(8).values=[];
ip(8).default=[1e-6];

ip(9).aliases={'itmax'};ip(7).units=' ';
ip(9).units='iterations';
ip(9).full_name='Maximum # of iterations for nonequilibrium solver';
ip(9).type='number';
ip(9).n=[1 1;1 1];
ip(9).range=[1 inf];
ip(9).values={};
ip(9).default=[100];

ip(10).aliases={'delta'};
ip(10).units='kT';
ip(10).full_name='Maximum error for nonequilibrium solver';
ip(10).type='number';
ip(10).n=[1 1;1 1];
ip(10).range=[eps 1];
ip(10).values=[];
ip(10).default=[1e-6];

ip(11).aliases={'show_sig'};
ip(11).units='';
ip(11).full_name='Show estimated number of significant digits in error';
ip(11).type='string';
ip(11).n=[1 1;1 1];
ip(11).range=[];
ip(11).values={'on' 'off'};
ip(11).default={'off'};

ip(12).aliases={'delta_setup'};
ip(12).units='kT';
ip(12).full_name='Maximum error during setup';
ip(12).type='number';
ip(12).n=[1 1;1 1];
ip(12).range=[eps 1];
ip(12).values=[];
ip(12).default=[1e-4];

ip(13).aliases={'delta_scaleG'};
ip(13).units=' ';
ip(13).full_name='Scaling factor for generation rate';
ip(13).type='number';
ip(13).n=[1 1;1 1];
ip(13).range=[eps 1];
ip(13).values=[];
ip(13).default=[1e-3];

ip(14).aliases={'min_N'};
ip(14).units=' ';
ip(14).full_name='Smallest doping concentration (prevents division by zero)';
ip(14).type='number';
ip(14).n=[1 1;1 1];
ip(14).range=[eps 1];
ip(14).values=[];
ip(14).default=1;

ip(15).aliases={'n_diverge' 'ndiv'};
ip(15).units=' ';
ip(15).full_name='Number of consecutive times correction term can increase before solution is assumed to diverge';
ip(15).type='number';
ip(15).n=[1 1;1 1];
ip(15).range=[2 inf];
ip(15).values=[];
ip(15).default=5;