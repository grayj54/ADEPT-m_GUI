classdef Silicon 
    properties
        ip = struct;
        ltitle = struct;
       %nlayer = struct;
        thick = struct;
    end
    methods
        function dev = Silicon()
            dev.ltitle = '';
            dev.thick = 0;
            
            dev.ip(1).aliases={'t_A' 't_nm' 't_um' 't_cm'}; % this should be the same for all layer types
            dev.ip(1).type='number';
            dev.ip(1).n=[1 1;1 1];
            dev.ip(1).range=[eps inf];
            dev.ip(1).values=[];
            dev.ip(1).default=[-999];

            dev.ip(2).aliases={'model' 'semi'}; % a_rlayer looks for this
            dev.ip(2).type='string';
            dev.ip(2).n=[1 1;1 1];
            dev.ip(2).range=[];
            dev.ip(2).values={'custom' 'custom(T)' 'Si' 'silicon'};
            dev.ip(2).default={'custom'};

            %----------------------------------------------------

            dev.ip(3).aliases={'chi'}; % electron affinity (eV)
            dev.ip(3).type='number';
            dev.ip(3).n=[1 1;1 2];
            dev.ip(3).range=[-inf inf];
            dev.ip(3).values=[];
            dev.ip(3).default=[4.2];

            dev.ip(4).aliases={'Eg' 'eg'}; % bandgap (eV)
            dev.ip(4).type='number';
            dev.ip(4).n=[1 1;1 2];
            dev.ip(4).range=[0 inf];
            dev.ip(4).values=[];
            dev.ip(4).default=[1.12];

            dev.ip(5).aliases={'ks'}; % dielectic constant
            dev.ip(5).type='number';
            dev.ip(5).n=[1 1;1 2];
            dev.ip(5).range=[1 inf];
            dev.ip(5).values=[];
            dev.ip(5).default=[11.7];

            dev.ip(6).aliases={'Nc'}; % Conduction band effective density of states (#/cm^3)
            dev.ip(6).type='number';
            dev.ip(6).n=[1 1;1 2];
            dev.ip(6).range=[realmin inf];
            dev.ip(6).values=[];
            dev.ip(6).default=[3.2e19];

            dev.ip(7).aliases={'Nv'}; % Valence band effective density of states (#/cm^3)
            dev.ip(7).type='number';
            dev.ip(7).n=[1 1;1 2];
            dev.ip(7).range=[realmin inf];
            dev.ip(7).values=[];
            dev.ip(7).default=[1.8e19];

            dev.ip(8).aliases={'Nc.tot'}; % Conduction band "actual" density of states (#/cm^3)
            dev.ip(8).type='number';
            dev.ip(8).n=[1 1;1 2];
            dev.ip(8).range=[realmin inf];
            dev.ip(8).values=[];
            dev.ip(8).default=[inf];

            dev.ip(9).aliases={'Nv.tot'}; % Valence band "actual" density of states (#/cm^3)
            dev.ip(9).type='number';
            dev.ip(9).n=[1 1;1 2];
            dev.ip(9).range=[realmin inf];
            dev.ip(9).values=[];
            dev.ip(9).default=[inf];

            dev.ip(10).aliases={'vth.n'}; % electron thermal velocity (cm/s)
            dev.ip(10).type='number';
            dev.ip(10).n=[1 1;1 2];
            dev.ip(10).range=[0 inf];
            dev.ip(10).values=[];
            dev.ip(10).default=[2.3e7];

            dev.ip(11).aliases={'vth.p'}; % hole thermal velocity (cm/s)
            dev.ip(11).type='number';
            dev.ip(11).n=[1 1;1 2];
            dev.ip(11).range=[0 inf];
            dev.ip(11).values=[];
            dev.ip(11).default=[1.65e7];

            dev.ip(12).aliases={'Nd+' 'ndp' 'Ndp' 'N.ndp'}; % fixed fully ionized dopant (#/cm^3)
            dev.ip(12).type='number';
            dev.ip(12).n=[1 inf;1 2];
            dev.ip(12).range=[0 inf];
            dev.ip(12).values=[];
            dev.ip(12).default=[1e16];
            dev.ip(12).indexed=1;

            dev.ip(13).aliases={'Na-' 'nam' 'Nam' 'N.nam'}; % fixed fully ionized dopant (#/cm^3)
            dev.ip(13).type='number';
            dev.ip(13).n=[1 inf;1 2];
            dev.ip(13).range=[0 inf];
            dev.ip(13).values={'file'}; % file input
            dev.ip(13).default=[2e19];
            dev.ip(13).indexed=1;

            dev.ip(14).aliases={'un'}; % electron mobility (cm^2/V-s)
            dev.ip(14).type='number';
            dev.ip(14).n=[1 1;1 2];
            dev.ip(14).range=[realmin inf];
            dev.ip(14).values={'*'};
            dev.ip(14).default=[100];

            dev.ip(15).aliases={'up'}; % hole mobility (cm^2/V-s)
            dev.ip(15).type='number';
            dev.ip(15).n=[1 1;1 2];
            dev.ip(15).range=[realmin inf];
            dev.ip(15).values={'*'};
            dev.ip(15).default=[100];

            dev.ip(16).aliases={'Et.shr' 'et.shr'}; % deep-level trap with negligible trapped charge. et=Et-Ei
            dev.ip(16).type='number';
            dev.ip(16).n=[1 inf;1 2];
            dev.ip(16).range=[-inf inf];
            dev.ip(16).values=[];
            dev.ip(16).default=[0];

            dev.ip(17).aliases={'taun.shr'}; % electron lifetime
            dev.ip(17).type='number';
            dev.ip(17).n=[1 inf;1 2];
            dev.ip(17).range=[1e-50 inf];
            dev.ip(17).values={'*'};
            dev.ip(17).default=[-1];

            dev.ip(18).aliases={'taup.shr'}; % hole lifetime
            dev.ip(18).type='number';
            dev.ip(18).n=[1 inf;1 2];
            dev.ip(18).range=[1e-50 inf];
            dev.ip(18).values={'*'};
            dev.ip(18).default=[1e100];

            dev.ip(19).aliases={'B.rad' 'B'}; % radiative recombination coeff.
            dev.ip(19).type='number';
            dev.ip(19).n=[1 1;1 2];
            dev.ip(19).range=[0 inf];
            dev.ip(19).values={'*'};
            dev.ip(19).default=[1.1e-14];

            dev.ip(20).aliases={'Cn.auger' 'Cn'}; % Auger recombination coeff for electrons
            dev.ip(20).type='number';
            dev.ip(20).n=[1 1;1 2];
            dev.ip(20).range=[0 inf];
            dev.ip(20).values={'*'};
            dev.ip(20).default=[1.1e-30];

            dev.ip(21).aliases={'Cp.auger' 'Cp'}; % Auger recombination coeff for holes
            dev.ip(21).type='number';
            dev.ip(21).n=[1 1;1 2];
            dev.ip(21).range=[0 inf];
            dev.ip(21).values={'*'};
            dev.ip(21).default=[3e-31];

            dev.ip(22).aliases={'alpha_model' 'alpha_model.opt'}; % for creation of e-h pairs
            dev.ip(22).type='string';
            dev.ip(22).n=[1 1;1 1];
            dev.ip(22).range=[];
            dev.ip(22).values={'none' 'simple' 'equation' 'file'};
            dev.ip(22).default={'file'};

            dev.ip(23).aliases={'N.d'}; % donor trap density
            dev.ip(23).type='number';
            dev.ip(23).n=[1 inf;1 2];
            dev.ip(23).range=[0 inf];
            dev.ip(23).values={'*'};
            dev.ip(23).default=0;
            dev.ip(23).indexed=1;

            dev.ip(24).aliases={'Et.d' 'et.d'}; % Et.d=Ec-Et
            dev.ip(24).type='number';
            dev.ip(24).n=[1 inf;1 2];
            dev.ip(24).range=[-inf inf];
            dev.ip(24).values=[];
            dev.ip(24).default=-1;

            dev.ip(25).aliases={'g.d'}; % degeneracy factor
            dev.ip(25).type='number';
            dev.ip(25).n=[1 inf;1 1];
            dev.ip(25).range=[1 inf];
            dev.ip(25).values=[];
            dev.ip(25).default=2; % standard value

            dev.ip(26).aliases={'cp.d'}; % capture cross-esction for holes (cm^2)
            dev.ip(26).type='number';
            dev.ip(26).n=[1 inf;1 2];
            dev.ip(26).range=[realmin inf];
            dev.ip(26).values=[];
            dev.ip(26).default=1e-30;

            dev.ip(27).aliases={'cn.d'}; % capture cross-esction for electrons (cm^2)
            dev.ip(27).type='number';
            dev.ip(27).n=[1 inf;1 2];
            dev.ip(27).range=[realmin inf];
            dev.ip(27).values=[];
            dev.ip(27).default=1e-30;

            dev.ip(28).aliases={'N.a'}; % acceptor trap density
            dev.ip(28).type='number';
            dev.ip(28).n=[1 inf;1 2];
            dev.ip(28).range=[0 inf];
            dev.ip(28).values={'*'};
            dev.ip(28).default=0;
            dev.ip(28).indexed=1;

            dev.ip(29).aliases={'Et.a'}; % Et.slt=Et-Ev
            dev.ip(29).type='number';
            dev.ip(29).n=[1 inf;1 2];
            dev.ip(29).range=[-inf inf];
            dev.ip(29).values=[];
            dev.ip(29).default=-1;

            dev.ip(30).aliases={'g.a'}; % degeneracy factor
            dev.ip(30).type='number';
            dev.ip(30).n=[1 inf;1 1];
            dev.ip(30).range=[1 inf];
            dev.ip(30).values=[];
            dev.ip(30).default=4; % standard value

            dev.ip(31).aliases={'cp.a'}; % capture cross-esction for holes (cm^2)
            dev.ip(31).type='number';
            dev.ip(31).n=[1 inf;1 2];
            dev.ip(31).range=[realmin inf];
            dev.ip(31).values=[];
            dev.ip(31).default=1e-30;

            dev.ip(32).aliases={'cn.a'}; % capture cross-esction for electrons (cm^2)
            dev.ip(32).type='number';
            dev.ip(32).n=[1 inf;1 2];
            dev.ip(32).range=[realmin inf];
            dev.ip(32).values=[];
            dev.ip(32).default=1e-30;

            dev.ip(33).aliases={'N.slt'}; % SLT trap density
            dev.ip(33).type='number';
            dev.ip(33).n=[1 inf;1 2];
            dev.ip(33).range=[0 inf];
            dev.ip(33).values=[];
            dev.ip(33).default=[0];

            dev.ip(34).aliases={'type.slt'}; % donor-like or acceptor-like
            dev.ip(34).type='string';
            dev.ip(34).n=[1 inf;1 1];
            dev.ip(34).range=[];
            dev.ip(34).values={'donor' 'acceptor' 'off'};
            dev.ip(34).default={'off'};

            dev.ip(35).aliases={'Et.slt' 'et.slt'}; % Et.slt=Et-Ei
            dev.ip(35).type='number';
            dev.ip(35).n=[1 inf;1 2];
            dev.ip(35).range=[-inf inf];
            dev.ip(35).values=[];
            dev.ip(35).default=[0];

            dev.ip(36).aliases={'g.slt'}; % degeneracy factor
            dev.ip(36).type='number';
            dev.ip(36).n=[1 inf;1 1];
            dev.ip(36).range=[1 inf];
            dev.ip(36).values=[];
            dev.ip(36).default=1;

            dev.ip(37).aliases={'cp.slt'}; % capture cross-section for holes (cm^2)
            dev.ip(37).type='number';
            dev.ip(37).n=[1 inf;1 2];
            dev.ip(37).range=[realmin inf];
            dev.ip(37).values=[];
            dev.ip(37).default=[realmin];

            dev.ip(38).aliases={'cn.slt'}; % capture cross-section for electrons (cm^2)
            dev.ip(38).type='number';
            dev.ip(38).n=[1 inf;1 2];
            dev.ip(38).range=[realmin inf];
            dev.ip(38).values=[];
            dev.ip(38).default=[realmin];

            dev.ip(39).aliases={'taup.slt'}; % hole lifetime to compute cp=1/(taup*vth*Nt)
            dev.ip(39).type='number';
            dev.ip(39).n=[1 inf;1 2];
            dev.ip(39).range=[-1 inf];
            dev.ip(39).values={'*'};
            dev.ip(39).default=[-1];

            dev.ip(40).aliases={'taun.slt'}; % electron lifetime to compute cn=1/(taun*vth*Nt)
            dev.ip(40).type='number';
            dev.ip(40).n=[1 inf;1 2];
            dev.ip(40).range=[-1 inf];
            dev.ip(40).values={'*'};
            dev.ip(40).default=[-1];

            dev.ip(41).aliases={'N.mv3'}; % 3-level multivalent trap density
            dev.ip(41).type='number';
            dev.ip(41).n=[1 inf;1 2];
            dev.ip(41).range=[0 inf];
            dev.ip(41).values=[];
            dev.ip(41).default=[0];

            dev.ip(42).aliases={'Etp.mv3'}; % Etp.mv3=Et-Ev
            dev.ip(42).type='number';
            dev.ip(42).n=[1 inf;1 2];
            dev.ip(42).range=[-inf inf];
            dev.ip(42).values=[];
            dev.ip(42).default=[0];

            dev.ip(43).aliases={'Etm.mv3'}; % Etm.mv3=Et-Ev
            dev.ip(43).type='number';
            dev.ip(43).n=[1 inf;1 2];
            dev.ip(43).range=[-inf inf];
            dev.ip(43).values=[];
            dev.ip(43).default=[0];

            dev.ip(44).aliases={'cpp.mv3'}; % capture cross-section for holes (cm^2)
            dev.ip(44).type='number';
            dev.ip(44).n=[1 inf;1 2];
            dev.ip(44).range=[0 inf];
            dev.ip(44).values=[];
            dev.ip(44).default=[1e-14];

            dev.ip(45).aliases={'cnp.mv3'}; % capture cross-section for electrons (cm^2)
            dev.ip(45).type='number';
            dev.ip(45).n=[1 inf;1 2];
            dev.ip(45).range=[0 inf];
            dev.ip(45).values=[];
            dev.ip(45).default=[1e-14];

            dev.ip(46).aliases={'cpm.mv3'}; % capture cross-section for holes (cm^2)
            dev.ip(46).type='number';
            dev.ip(46).n=[1 inf;1 2];
            dev.ip(46).range=[0 inf];
            dev.ip(46).values=[];
            dev.ip(46).default=[1e-14];

            dev.ip(47).aliases={'cnm.mv3'}; % capture cross-section for electrons (cm^2)
            dev.ip(47).type='number';
            dev.ip(47).n=[1 inf;1 2];
            dev.ip(47).range=[0 inf];
            dev.ip(47).values=[];
            dev.ip(47).default=[1e-14];

            dev.ip(48).aliases={'Eg.opt'}; % optical bandgap
            dev.ip(48).type='number';
            dev.ip(48).n=[1 inf;1 2];
            dev.ip(48).range=[-1 inf];
            dev.ip(48).values=[];
            dev.ip(48).default=[-1]; % defaults to electrical bandgap

            dev.ip(49).aliases={'A1.opt'}; % coeff for absorption formula
            dev.ip(49).type='number';
            dev.ip(49).n=[1 inf;1 2];
            dev.ip(49).range=[0 inf];
            dev.ip(49).values=[];
            dev.ip(49).default=[0]; 

            dev.ip(50).aliases={'A2.opt'}; % absorption power law for numerator
            dev.ip(50).type='number';
            dev.ip(50).n=[1 inf;1 1];
            dev.ip(50).range=[0 inf];
            dev.ip(50).values=[];
            dev.ip(50).default=[0]; 

            dev.ip(51).aliases={'A3.opt'}; % absorption power law for denomenator
            dev.ip(51).type='number';
            dev.ip(51).n=[1 inf;1 1];
            dev.ip(51).range=[0 inf];
            dev.ip(51).values=[];
            dev.ip(51).default=[0];

            dev.ip(52).aliases={'alpha_fc.opt'}; % free carrier absorption
            dev.ip(52).type='string';
            dev.ip(52).n=[1 1;1 1];
            dev.ip(52).range=[];
            dev.ip(52).values={'on' 'off'};
            dev.ip(52).default={'off'};

            dev.ip(53).aliases={'FCn.opt'}; % free carrier abs coeff for electrons (cm^-1*cm^3/um^B)
            dev.ip(53).type='number';
            dev.ip(53).n=[1 1;1 2];
            dev.ip(53).range=[0 inf];
            dev.ip(53).values=[];
            dev.ip(53).default=[0];

            dev.ip(54).aliases={'FCp.opt'}; % free carrier abs coeff for holes (cm^-1*cm^3/um^B)
            dev.ip(54).type='number';
            dev.ip(54).n=[1 1;1 2];
            dev.ip(54).range=[0 inf];
            dev.ip(54).values=[];
            dev.ip(54).default=[0];

            dev.ip(55).aliases={'Bn.opt'}; % free carrier power law for electrons (wl^Bn)
            dev.ip(55).type='number';
            dev.ip(55).n=[1 1;1 1];
            dev.ip(55).range=[-inf inf];
            dev.ip(55).values=[];
            dev.ip(55).default=[2];

            dev.ip(56).aliases={'Bp.opt'}; % free carrier power law for holes (wl^Bn)
            dev.ip(56).type='number';
            dev.ip(56).n=[1 1;1 1];
            dev.ip(56).range=[-inf inf];
            dev.ip(56).values=[];
            dev.ip(56).default=[2];

            dev.ip(57).aliases={'vth'}; % thermal velocity (cm/s)
            dev.ip(57).type='number';
            dev.ip(57).n=[1 1;1 2];
            dev.ip(57).range=[0 inf];
            dev.ip(57).values=[];
            dev.ip(57).default=[0];

            dev.ip(58).aliases={'btail'}; % band tails
            dev.ip(58).type='string';
            dev.ip(58).n=[1 1;1 1];
            dev.ip(58).range=[];
            dev.ip(58).values={'on' 'off'};
            dev.ip(58).default={'off'};

            dev.ip(59).aliases={'ktv.bt'}; % charicteristic energy of valence band tail (donor-like)
            dev.ip(59).type='number';
            dev.ip(59).n=[1 1;1 2];
            dev.ip(59).range=[realmin inf];
            dev.ip(59).values=[];
            dev.ip(59).default=[.026];

            dev.ip(60).aliases={'ktc.bt'}; % charicteristic energy of conduction band tail (acceptor-like)
            dev.ip(60).type='number';
            dev.ip(60).n=[1 1;1 2];
            dev.ip(60).range=[realmin inf];
            dev.ip(60).values=[];
            dev.ip(60).default=[.026];

            dev.ip(61).aliases={'dEv.bt'}; % delE above Ev at which exp. band tail starts (density is assumed constant between Ev and Ev.bt)
            dev.ip(61).type='number';
            dev.ip(61).n=[1 1;1 2];
            dev.ip(61).range=[0 inf]; % must be >= 0
            dev.ip(61).values=[];
            dev.ip(61).default=[0]; %defaults to Ev -- NOT CHANGEABLE

            dev.ip(62).aliases={'dEc.bt'}; % delE below Ec at which exp. band tail starts (density is assumed constant between Ec.bt and Ec)
            dev.ip(62).type='number';
            dev.ip(62).n=[1 1;1 2];
            dev.ip(62).range=[0 inf]; % must be >= 0
            dev.ip(62).values=[];
            dev.ip(62).default=[0]; % defaults to Ec -- NOT CHANGEABLE

            dev.ip(63).aliases={'Gv0.bt'}; % density of states at Ev.bt for valence band tail (#/cm3/eV)
            dev.ip(63).type='number';
            dev.ip(63).n=[1 1;1 2];
            dev.ip(63).range=[-1 inf];
            dev.ip(63).values=[];
            dev.ip(63).default=[-1]; % defaults to 2*pi*Nv/(kT*pi)^3/2*sqrt(kT)

            dev.ip(64).aliases={'Gc0.bt'}; % density of states at Ec.bt for conduction band tail (#/cm3/eV)
            dev.ip(64).type='number';
            dev.ip(64).n=[1 1;1 2];
            dev.ip(64).range=[-1 inf];
            dev.ip(64).values=[];
            dev.ip(64).default=[-1]; % defaults to 2*pi*Nc/(kT*pi)^3/2*sqrt(kT))

            dev.ip(65).aliases={'cpv.bt'}; % capture cross-section for holes (cm^2)
            dev.ip(65).type='number';
            dev.ip(65).n=[1 inf;1 2];
            dev.ip(65).range=[realmin inf];
            dev.ip(65).values={};
            dev.ip(65).default=[1e-14];

            dev.ip(66).aliases={'cnv.bt'}; % capture cross-section for electrons (cm^2)
            dev.ip(66).type='number';
            dev.ip(66).n=[1 inf;1 2];
            dev.ip(66).range=[realmin inf];
            dev.ip(66).values={};
            dev.ip(66).default=[1e-14];

            dev.ip(67).aliases={'cpc.bt'}; % capture cross-section for holes (cm^2)
            dev.ip(67).type='number';
            dev.ip(67).n=[1 inf;1 2];
            dev.ip(67).range=[realmin inf];
            dev.ip(67).values={};
            dev.ip(67).default=[1e-14];

            dev.ip(68).aliases={'cnc.bt'}; % capture cross-section for electrons (cm^2)
            dev.ip(68).type='number';
            dev.ip(68).n=[1 inf;1 2];
            dev.ip(68).range=[realmin inf];
            dev.ip(68).values={};
            dev.ip(68).default=[1e-14];

            dev.ip(69).aliases={'nlaguerre.bt'}; % # of points for Gauss-Laguerre quadrature 
            dev.ip(69).type='number';
            dev.ip(69).n=[1 1;1 1];
            dev.ip(69).range=[2 100]; 
            dev.ip(69).values={};
            dev.ip(69).default=[15];

            dev.ip(70).aliases={'maxEstep.bt'}; % max intergtion step size between (Ev & Ev.bt) and (Ec.bt & Ec)
            dev.ip(70).type='number';
            dev.ip(70).n=[1 1;1 1];
            dev.ip(70).range=[-1 inf];
            dev.ip(70).values={};
            dev.ip(70).default=[-1]; % defaults to kT (not implemented)

            dev.ip(71).aliases={'gv.bt'}; % degeneracy factor
            dev.ip(71).type='number';
            dev.ip(71).n=[1 inf;1 1];
            dev.ip(71).range=[1 inf];
            dev.ip(71).values=[];
            dev.ip(71).default=[2]; % standard value for donors

            dev.ip(72).aliases={'gc.bt'}; % degeneracy factor
            dev.ip(72).type='number';
            dev.ip(72).n=[1 inf;1 1];
            dev.ip(72).range=[1 inf];
            dev.ip(72).values=[];
            dev.ip(72).default=[4]; % standard value for acceptors

            dev.ip(73).aliases={'g.shr'}; % shr degeneracy factor
            dev.ip(73).type='number';
            dev.ip(73).n=[1 inf;1 1];
            dev.ip(73).range=[-inf inf];
            dev.ip(73).values=[];
            dev.ip(73).default=[1]; % + for acceptor-like, - for donor-like et'=et+sign(g)*log(abs(g))

            dev.ip(74).aliases={'sigma.shr'}; % standard deviation of distribution
            dev.ip(74).type='number';
            dev.ip(74).n=[1 inf;1 1];
            dev.ip(74).range=[0 inf];
            dev.ip(74).values=[];
            dev.ip(74).default=[0]; % defaults to discrete trap

            dev.ip(75).aliases={'nint.shr'}; % # points for integration method
            dev.ip(75).type='number';
            dev.ip(75).n=[1 inf;1 1];
            dev.ip(75).range=[-1 inf];
            dev.ip(75).values=[];
            dev.ip(75).default=[-1]; % not used if sigma=0, must be set is not a discrete trap

            dev.ip(76).aliases={'int_method.shr' 'imeth.shr'};
            dev.ip(76).type='string';
            dev.ip(76).n=[1 inf;1 1];
            dev.ip(76).range=[];
            dev.ip(76).values={'Gauss-Hermite' 'Midpoint' 'none'};
            dev.ip(76).default={'none'}; 

            dev.ip(77).aliases={'distribution.shr' 'distrib.shr'};
            dev.ip(77).type='string';
            dev.ip(77).n=[1 inf;1 1];
            dev.ip(77).range=[];
            dev.ip(77).values={'discrete' 'Gaussian' 'uniform'};
            dev.ip(77).default={'discrete'};

            dev.ip(78).aliases={'half_range.shr' 'hrange.shr'};
            dev.ip(78).type='number';
            dev.ip(78).n=[1 inf;1 2];
            dev.ip(78).range=[eps inf];
            dev.ip(78).values=[];
            dev.ip(78).default=[100*eps];

            dev.ip(79).aliases={'nsigma.shr'}; % +/- sigma range for Midpoint integration of Gaussian
            dev.ip(79).type='number';
            dev.ip(79).n=[1 inf;1 1];
            dev.ip(79).range=[eps inf];
            dev.ip(79).values=[];
            dev.ip(79).default=[5];

            dev.ip(80).aliases={'sigma.slt'}; % standard deviation of distribution
            dev.ip(80).type='number';
            dev.ip(80).n=[1 inf;1 1];
            dev.ip(80).range=[0 inf];
            dev.ip(80).values=[];
            dev.ip(80).default=[0]; % defaults to discrete trap

            dev.ip(81).aliases={'nint.slt'}; % # points for integration method
            dev.ip(81).type='number';
            dev.ip(81).n=[1 inf;1 1];
            dev.ip(81).range=[-1 inf];
            dev.ip(81).values=[];
            dev.ip(81).default=[-1]; % not used if sigma=0, must be set is not a discrete trap

            dev.ip(82).aliases={'int_method.slt' 'imeth.slt'};
            dev.ip(82).type='string';
            dev.ip(82).n=[1 inf;1 1];
            dev.ip(82).range=[];
            dev.ip(82).values={'Gauss-Hermite' 'Midpoint' 'none'};
            dev.ip(82).default={'none'}; 

            dev.ip(83).aliases={'distribution.slt' 'distrib.slt'};
            dev.ip(83).type='string';
            dev.ip(83).n=[1 inf;1 1];
            dev.ip(83).range=[];
            dev.ip(83).values={'discrete' 'Gaussian' 'uniform'};
            dev.ip(83).default={'discrete'};

            dev.ip(84).aliases={'half_range.slt' 'hrange.slt'};
            dev.ip(84).type='number';
            dev.ip(84).n=[1 inf;1 2];
            dev.ip(84).range=[eps inf];
            dev.ip(84).values=[];
            dev.ip(84).default=[100*eps];

            dev.ip(85).aliases={'nsigma.slt'}; % +/- sigma range for Midpoint integration of Gaussian
            dev.ip(85).type='number';
            dev.ip(85).n=[1 inf;1 1];
            dev.ip(85).range=[eps inf];
            dev.ip(85).values=[];
            dev.ip(85).default=[5];

            dev.ip(86).aliases={'sigma.mv3'}; % standard deviation of distribution
            dev.ip(86).type='number';
            dev.ip(86).n=[1 inf;1 1];
            dev.ip(86).range=[0 inf];
            dev.ip(86).values=[];
            dev.ip(86).default=[0]; % defaults to discrete trap

            dev.ip(87).aliases={'nint.mv3'}; % # points for integration method
            dev.ip(87).type='number';
            dev.ip(87).n=[1 inf;1 1];
            dev.ip(87).range=[-1 inf];
            dev.ip(87).values=[];
            dev.ip(87).default=[-1]; % not used if sigma=0, must be set if not a discrete trap

            dev.ip(88).aliases={'int_method.mv3' 'imeth.mv3'};
            dev.ip(88).type='string';
            dev.ip(88).n=[1 inf;1 1];
            dev.ip(88).range=[];
            dev.ip(88).values={'Gauss-Hermite' 'Midpoint' 'none'};
            dev.ip(88).default={'none'}; 

            dev.ip(89).aliases={'distribution.mv3' 'distrib.mv3'};
            dev.ip(89).type='string';
            dev.ip(89).n=[1 inf;1 1];
            dev.ip(89).range=[];
            dev.ip(89).values={'discrete' 'Gaussian' 'uniform'};
            dev.ip(89).default={'discrete'};

            dev.ip(90).aliases={'half_range.mv3' 'hrange.mv3'};
            dev.ip(90).type='number';
            dev.ip(90).n=[1 inf;1 2];
            dev.ip(90).range=[eps inf];
            dev.ip(90).values=[];
            dev.ip(90).default=[100*eps];

            dev.ip(91).aliases={'nsigma.mv3'}; % +/- sigma range for Midpoint integration of Gaussian
            dev.ip(91).type='number';
            dev.ip(91).n=[1 inf;1 1];
            dev.ip(91).range=[eps inf];
            dev.ip(91).values=[];
            dev.ip(91).default=[5];

            dev.ip(92).aliases={'prof.ndp'}; % doping profile
            dev.ip(92).type='string';
            dev.ip(92).n=[1 inf;1 1];
            dev.ip(92).range=[];
            dev.ip(92).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
            dev.ip(92).default={'linear'};

            dev.ip(93).aliases={'xo.ndp'};
            dev.ip(93).type='number';
            dev.ip(93).n=[1 inf;1 1];
            dev.ip(93).range=[-inf inf];
            dev.ip(93).values=[];
            dev.ip(93).default=[0];

            dev.ip(94).aliases={'dir.ndp'};
            dev.ip(94).type='string';
            dev.ip(94).n=[1 inf;1 1];
            dev.ip(94).range=[];
            dev.ip(94).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
            dev.ip(94).default={'t-b'};

            dev.ip(95).aliases={'Dt.ndp'};
            dev.ip(95).type='number';
            dev.ip(95).n=[1 inf;1 1];
            dev.ip(95).range=[eps inf];
            dev.ip(95).values=[];
            dev.ip(95).default=[inf]; % defaults to constant doping

            dev.ip(96).aliases={'L.ndp'};
            dev.ip(96).type='number';
            dev.ip(96).n=[1 inf;1 1];
            dev.ip(96).range=[eps inf];
            dev.ip(96).values=[];
            dev.ip(96).default=[inf]; % defaults to constant doping

            dev.ip(97).aliases={'sigma.ndp'};
            dev.ip(97).type='number';
            dev.ip(97).n=[1 inf;1 1];
            dev.ip(97).range=[eps inf];
            dev.ip(97).values=[];
            dev.ip(97).default=[inf]; % defaults to constant doping

            dev.ip(98).aliases={'prof.nam'}; % doping profile
            dev.ip(98).type='string';
            dev.ip(98).n=[1 inf;1 1];
            dev.ip(98).range=[];
            dev.ip(98).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
            dev.ip(98).default={'linear'};

            dev.ip(99).aliases={'xo.nam'};
            dev.ip(99).type='number';
            dev.ip(99).n=[1 inf;1 1];
            dev.ip(99).range=[-inf inf];
            dev.ip(99).values=[];
            dev.ip(99).default=[0];

            dev.ip(100).aliases={'dir.nam'};
            dev.ip(100).type='string';
            dev.ip(100).n=[1 inf;1 1];
            dev.ip(100).range=[];
            dev.ip(100).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
            dev.ip(100).default={'t-b'};

            dev.ip(101).aliases={'Dt.nam'};
            dev.ip(101).type='number';
            dev.ip(101).n=[1 inf;1 1];
            dev.ip(101).range=[eps inf];
            dev.ip(101).values=[];
            dev.ip(101).default=[2e-10]; % defaults to constant doping

            dev.ip(102).aliases={'L.nam'};
            dev.ip(102).type='number';
            dev.ip(102).n=[1 inf;1 1];
            dev.ip(102).range=[eps inf];
            dev.ip(102).values=[];
            dev.ip(102).default=[inf]; % defaults to constant doping

            dev.ip(103).aliases={'sigma.nam'};
            dev.ip(103).type='number';
            dev.ip(103).n=[1 inf;1 1];
            dev.ip(103).range=[eps inf];
            dev.ip(103).values=[];
            dev.ip(103).default=[inf]; % defaults to constant doping

            dev.ip(104).aliases={'prof.d'}; % doping profile
            dev.ip(104).type='string';
            dev.ip(104).n=[1 inf;1 1];
            dev.ip(104).range=[];
            dev.ip(104).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
            dev.ip(104).default={'linear'};

            dev.ip(105).aliases={'xo.d'};
            dev.ip(105).type='number';
            dev.ip(105).n=[1 inf;1 1];
            dev.ip(105).range=[-inf inf];
            dev.ip(105).values=[];
            dev.ip(105).default=[0];

            dev.ip(106).aliases={'dir.d'};
            dev.ip(106).type='string';
            dev.ip(106).n=[1 inf;1 1];
            dev.ip(106).range=[];
            dev.ip(106).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
            dev.ip(106).default={'t-b'};

            dev.ip(107).aliases={'Dt.d'};
            dev.ip(107).type='number';
            dev.ip(107).n=[1 inf;1 1];
            dev.ip(107).range=[eps inf];
            dev.ip(107).values=[];
            dev.ip(107).default=[inf]; % defaults to constant doping

            dev.ip(108).aliases={'L.d'};
            dev.ip(108).type='number';
            dev.ip(108).n=[1 inf;1 1];
            dev.ip(108).range=[eps inf];
            dev.ip(108).values=[];
            dev.ip(108).default=[inf]; % defaults to constant doping

            dev.ip(109).aliases={'sigma.d'};
            dev.ip(109).type='number';
            dev.ip(109).n=[1 inf;1 1];
            dev.ip(109).range=[eps inf];
            dev.ip(109).values=[];
            dev.ip(109).default=[inf]; % defaults to constant doping

            dev.ip(110).aliases={'prof.a'}; % doping profile
            dev.ip(110).type='string';
            dev.ip(110).n=[1 inf;1 1];
            dev.ip(110).range=[];
            dev.ip(110).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
            dev.ip(110).default={'linear'};

            dev.ip(111).aliases={'xo.a'};
            dev.ip(111).type='number';
            dev.ip(111).n=[1 inf;1 1];
            dev.ip(111).range=[-inf inf];
            dev.ip(111).values=[];
            dev.ip(111).default=[0];

            dev.ip(112).aliases={'dir.a'};
            dev.ip(112).type='string';
            dev.ip(112).n=[1 inf;1 1];
            dev.ip(112).range=[];
            dev.ip(112).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
            dev.ip(112).default={'t-b'};

            dev.ip(113).aliases={'Dt.a'};
            dev.ip(113).type='number';
            dev.ip(113).n=[1 inf;1 1];
            dev.ip(113).range=[eps inf];
            dev.ip(113).values=[];
            dev.ip(113).default=[inf]; % defaults to constant doping

            dev.ip(114).aliases={'L.a'};
            dev.ip(114).type='number';
            dev.ip(114).n=[1 inf;1 1];
            dev.ip(114).range=[eps inf];
            dev.ip(114).values=[];
            dev.ip(114).default=[inf]; % defaults to constant doping

            dev.ip(115).aliases={'sigma.a'};
            dev.ip(115).type='number';
            dev.ip(115).n=[1 inf;1 1];
            dev.ip(115).range=[eps inf];
            dev.ip(115).values=[];
            dev.ip(115).default=[inf]; % defaults to constant doping

            dev.ip(116).aliases={'alpha_file' 'alpha_file.opt'};
            dev.ip(116).type='string';
            dev.ip(116).n=[1 1;1 1];
            dev.ip(116).range=[];
            dev.ip(116).values={'*'};
            dev.ip(116).default={'si.a'};

            dev.ip(117).aliases={'model.un'}; % electron mobility model
            dev.ip(117).type='string';
            dev.ip(117).n=[1 1;1 1];
            dev.ip(117).range=[];
            dev.ip(117).values={'linear' 'C-T'};
            dev.ip(117).default={'linear'};

            dev.ip(118).aliases={'max.un'};
            dev.ip(118).type='number';
            dev.ip(118).n=[1 1;1 2];
            dev.ip(118).range=[eps inf];
            dev.ip(118).values=[];
            dev.ip(118).default=1340;

            dev.ip(119).aliases={'min.un'};
            dev.ip(119).type='number';
            dev.ip(119).n=[1 1;1 2];
            dev.ip(119).range=[eps inf];
            dev.ip(119).values=[];
            dev.ip(119).default=88;

            dev.ip(120).aliases={'Nref.un'};
            dev.ip(120).type='number';
            dev.ip(120).n=[1 1;1 2];
            dev.ip(120).range=[eps inf];
            dev.ip(120).values=[];
            dev.ip(120).default=1.26e17;

            dev.ip(121).aliases={'beta.un'};
            dev.ip(121).type='number';
            dev.ip(121).n=[1 1;1 1];
            dev.ip(121).range=[eps inf];
            dev.ip(121).values=[];
            dev.ip(121).default=0.88;

            dev.ip(122).aliases={'model.up'}; % hole mobility model
            dev.ip(122).type='string';
            dev.ip(122).n=[1 1;1 1];
            dev.ip(122).range=[];
            dev.ip(122).values={'linear' 'C-T'};
            dev.ip(122).default={'linear'};

            dev.ip(123).aliases={'max.up'};
            dev.ip(123).type='number';
            dev.ip(123).n=[1 1;1 2];
            dev.ip(123).range=[eps inf];
            dev.ip(123).values=[];
            dev.ip(123).default=461;

            dev.ip(124).aliases={'min.up'};
            dev.ip(124).type='number';
            dev.ip(124).n=[1 1;1 2];
            dev.ip(124).range=[eps inf];
            dev.ip(124).values=[];
            dev.ip(124).default=54.3;

            dev.ip(125).aliases={'Nref.up'};
            dev.ip(125).type='number';
            dev.ip(125).n=[1 1;1 2];
            dev.ip(125).range=[eps inf];
            dev.ip(125).values=[];
            dev.ip(125).default=2.35e17;

            dev.ip(126).aliases={'beta.up'};
            dev.ip(126).type='number';
            dev.ip(126).n=[1 1;1 1];
            dev.ip(126).range=[eps inf];
            dev.ip(126).values=[];
            dev.ip(126).default=0.88;

            dev.ip(127).aliases={'Ncutp.shr'};
            dev.ip(127).type='number';
            dev.ip(127).n=[1 inf;1 1];
            dev.ip(127).range=[eps inf];
            dev.ip(127).values=[];
            dev.ip(127).default=inf;

            dev.ip(128).aliases={'Ncutn.shr'};
            dev.ip(128).type='number';
            dev.ip(128).n=[1 inf;1 1];
            dev.ip(128).range=[eps inf];
            dev.ip(128).values=[];
            dev.ip(128).default=inf;
        end
        end
    end
    
