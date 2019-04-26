function ip=a_init_mesh

ip(1).aliases={'method' 'meth'};
ip(1).units='';
ip(1).full_name='Mesh generation method';
ip(1).type='string';
ip(1).n=[1 1;1 1];
ip(1).range=[];
ip(1).values={'uniform' 'auto' 'Adebug'};
ip(1).default={'auto'};

ip(2).aliases={'nx' 'nodes' 'maxnodes' 'nmax'};
ip(2).units=' ';
ip(2).full_name='Maximum number of mesh points';
ip(2).type='number';
ip(2).n=[1 1;1 1];
ip(2).range=[1 inf];
ip(2).values=[];
ip(2).default=[100000];

ip(3).aliases={'h_min_cm' 'h_min_A' 'h_min_nm' 'h_min_um'};
ip(3).units={'cm' 'A' 'nm' 'um'};
ip(3).full_name='Smallest allowed mesh spacing';
ip(3).type='number';
ip(3).n=[1 1;1 1];
ip(3).range=[eps inf];
ip(3).values=[];
ip(3).default=[1e-8]; % cm

ip(4).aliases={'h_max_cm' 'h_max_A' 'h_max_nm' 'h_max_um'};
ip(4).units={'cm' 'A' 'nm' 'um'};
ip(4).full_name='Largest allowed mesh spacing';
ip(4).type='number';
ip(4).n=[1 1;1 1];
ip(4).range=[-1 inf]; % must be >= h_min_...
ip(4).values=[];
ip(4).default=[-1]; % defaults to device thickness/1000

ip(5).aliases={'h_ratio'};
ip(5).units=' ';
ip(5).full_name='Maximum spacing ratio between adjacent mesh spaces';
ip(5).type='number';
ip(5).n=[1 1;1 1];
ip(5).range=[2 inf];
ip(5).values=[];
ip(5).default=[2]; 

ip(6).aliases={'D_ratio'};
ip(6).units='';
ip(6).full_name='Maximum D-field ratio between adjacent mesh spaces';
ip(6).type='number';
ip(6).n=[1 1;1 1];
ip(6).range=[1.01 inf];
ip(6).values=[];
ip(6).default=[2];

ip(7).aliases={'sharp'};
ip(7).units='';
ip(7).full_name='Sharp transistions between layers';
ip(7).type='string';
ip(7).n=[1 1;1 1];
ip(7).range=[];
ip(7).values={'on' 'off'};
ip(7).default={'on'};

ip(8).aliases={'D_thr'};
ip(8).units='C/cm^2';
ip(8).full_name='D-field theshold';
ip(8).type='number';
ip(8).n=[1 1;1 1];
ip(8).range=[eps inf];
ip(8).values=[];
ip(8).default=[1];