function ip=a_init_dev

ip(1).aliases={'T_K' 'T_C'};
ip(1).units={'K' 'C'};
ip(1).full_name='Operating Temperature';
ip(1).type='number';
ip(1).n=[1 1;1 1];
ip(1).range=[-inf inf];
ip(1).values={};
ip(1).default=[300];

ip(2).aliases={'type'};
ip(2).units='';
ip(2).full_name='Device Type';
ip(2).type='string';
ip(2).n=[1 1;1 1];
ip(2).range=[];
ip(2).values={'Solar_Cell' 'solar_cell' 'Diode' 'diode' 'Generic' 'generic'};
ip(2).default={'Solar_Cell'};

ip(3).aliases={'n_pass'}; % # passes for light
ip(3).units=' ';
ip(3).full_name='Number of light ray passes considered under illumination';
ip(3).type='number';
ip(3).n=[1 1;1 1];
ip(3).range=[1 1000];
ip(3).values=[];
ip(3).default=[1];
end