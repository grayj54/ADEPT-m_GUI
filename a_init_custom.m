function ip=a_init_custom

ip(1).aliases={'t_A' 't_nm' 't_um' 't_cm'}; % this should be the same for all layer types
ip(1).units={'A' 'nm' 'um' 'cm'};
ip(1).full_name='Layer thickness';
ip(1).type='number';
ip(1).n=[1 1;1 1];
ip(1).range=[eps inf];
ip(1).values=[];
ip(1).default=[-999];

ip(2).aliases={'model' 'semi'}; % a_rlayer looks for this to determine which model to use.
% 'model' is the preferred alias.
% 'custom' is the only supported value at this time.  
ip(2).units='';
ip(2).full_name='';
ip(2).type='string';
ip(2).n=[1 1;1 1];
ip(2).range=[];
ip(2).values={'custom' 'custom(T)'};
ip(2).default={'custom'};

%----------------------------------------------------

ip(3).aliases={'chi'}; % electron affinity (eV)
ip(3).units='eV';
ip(3).full_name='Electron affinity';
ip(3).type='number';
ip(3).n=[1 1;1 2];
ip(3).range=[-inf inf];
ip(3).values=[];
ip(3).default=[4];

ip(4).aliases={'Eg' 'eg'}; % bandgap (eV)
ip(4).units='eV';
ip(4).full_name='Semiconductor bandgap';
ip(4).type='number';
ip(4).n=[1 1;1 2];
ip(4).range=[0 inf];
ip(4).values=[];
ip(4).default=[1];

ip(5).aliases={'ks'}; % dielectic constant
ip(5).units=' ';
ip(5).full_name='Dielectric constant';
ip(5).type='number';
ip(5).n=[1 1;1 2];
ip(5).range=[1 inf];
ip(5).values=[];
ip(5).default=[10];

ip(6).aliases={'Nc'}; % Conduction band effective density of states (#/cm^3)
ip(6).units='#/cm^3';
ip(6).full_name='Conduction band effective density-of-states';
ip(6).type='number';
ip(6).n=[1 1;1 2];
ip(6).range=[realmin inf];
ip(6).values=[];
ip(6).default=[1e19];

ip(7).aliases={'Nv'}; % Valence band effective density of states (#/cm^3)
ip(7).units='#/cm^3';
ip(7).full_name='Valence band effective density-of-states';
ip(7).type='number';
ip(7).n=[1 1;1 2];
ip(7).range=[realmin inf];
ip(7).values=[];
ip(7).default=[1e19];

ip(8).aliases={'Nc.tot'}; % Conduction band "actual" density of states (#/cm^3)
ip(8).units='#/cm^3';
ip(8).full_name='Conduction band ''actual'' density-of-states';
ip(8).type='number';
ip(8).n=[1 1;1 2];
ip(8).range=[realmin inf];
ip(8).values=[];
ip(8).default=[inf];

ip(9).aliases={'Nv.tot'}; % Valence band "actual" density of states (#/cm^3)
ip(9).units='#/cm^3';
ip(9).full_name='Valence band ''actual'' density-of-states';
ip(9).type='number';
ip(9).n=[1 1;1 2];
ip(9).range=[realmin inf];
ip(9).values=[];
ip(9).default=[inf];

ip(10).aliases={'vth.n'}; % electron thermal velocity (cm/s)
ip(10).units='cm/s';
ip(10).full_name='Thermal velocity for electrons';
ip(10).type='number';
ip(10).n=[1 1;1 2];
ip(10).range=[0 inf];
ip(10).values=[];
ip(10).default=[0];

ip(11).aliases={'vth.p'}; % hole thermal velocity (cm/s)
ip(11).units='cm/s';
ip(11).full_name='Thermal velocity for holes';
ip(11).type='number';
ip(11).n=[1 1;1 2];
ip(11).range=[0 inf];
ip(11).values=[];
ip(11).default=[0];

ip(12).aliases={'Nd+' 'ndp' 'Ndp' 'N.ndp'}; % fixed fully ionized dopant (#/cm^3)
ip(12).units='#/cm^3';
ip(12).full_name='Donor doping density (fully ionized)';
ip(12).type='number';
ip(12).n=[1 inf;1 2];
ip(12).range=[0 inf];
ip(12).values=[];
ip(12).default=[0];
% ip(12).indexed=1;

ip(13).aliases={'Na-' 'nam' 'Nam' 'N.nam'}; % fixed fully ionized dopant (#/cm^3)
ip(13).units='#/cm^3';
ip(13).full_name='Acceptor doping density (fully ionized)';
ip(13).type='number';
ip(13).n=[1 inf;1 2];
ip(13).range=[0 inf];
ip(13).values={'file'}; % file input
ip(13).default=[0];
% ip(13).indexed=1;

ip(14).aliases={'un'}; % electron mobility (cm^2/V-s)
ip(14).units='cm^2/V-s';
ip(14).full_name='Electron mobility';
ip(14).type='number';
ip(14).n=[1 1;1 2];
ip(14).range=[realmin inf];
ip(14).values={'*'};
ip(14).default=[100];

ip(15).aliases={'up'}; % hole mobility (cm^2/V-s)
ip(15).units='cm^2/V-s';
ip(15).full_name='Hole mobility';
ip(15).type='number';
ip(15).n=[1 1;1 2];
ip(15).range=[realmin inf];
ip(15).values={'*'};
ip(15).default=[100];

ip(16).aliases={'Et.shr' 'et.shr'}; % deep-level trap with negligible trapped charge. et=Et-Ei
ip(6).units='eV';
ip(16).full_name='Trap energy for SHR recombination (wrt E_i)';
ip(16).type='number';
ip(16).n=[1 inf;1 2];
ip(16).range=[-inf inf];
ip(16).values=[];
ip(16).default=[0];

ip(17).aliases={'taun.shr'}; % electron lifetime
ip(17).units='s';
ip(17).full_name='Electron lifetime for SHR recombination';
ip(17).type='number';
ip(17).n=[1 inf;1 2];
ip(17).range=[1e-50 inf];
ip(17).values={'*'};
ip(17).default=[1e100];

ip(18).aliases={'taup.shr'}; % hole lifetime
ip(18).units='s';
ip(18).full_name='Hole lifetime for SHR recombination';
ip(18).type='number';
ip(18).n=[1 inf;1 2];
ip(18).range=[1e-50 inf];
ip(18).values={'*'};
ip(18).default=[1e100];

ip(19).aliases={'B.rad' 'B'}; % radiative recombination coeff.
ip(19).units='cm^3/s';
ip(19).full_name='Radiative recombination coefficient';
ip(19).type='number';
ip(19).n=[1 1;1 2];
ip(19).range=[0 inf];
ip(19).values={'*'};
ip(19).default=[0];

ip(20).aliases={'Cn.auger' 'Cn'}; % Auger recombination coeff for electrons
ip(20).units='cm^6/s';
ip(20).full_name='Auger recombination coefficient for electrons';
ip(20).type='number';
ip(20).n=[1 1;1 2];
ip(20).range=[0 inf];
ip(20).values={'*'};
ip(20).default=[0];

ip(21).aliases={'Cp.auger' 'Cp'}; % Auger recombination coeff for holes
ip(21).units='cm^6/s';
ip(21).full_name='Auger recombination coefficient for electrons';
ip(21).type='number';
ip(21).n=[1 1;1 2];
ip(21).range=[0 inf];
ip(21).values={'*'};
ip(21).default=[0];

ip(22).aliases={'alpha_model' 'alpha_model.opt'}; % for creation of e-h pairs
ip(22).units='';
ip(22).full_name='Light absorption model of creation od e-h pairs';
ip(22).type='string';
ip(22).n=[1 1;1 1];
ip(22).range=[];
ip(22).values={'none' 'simple' 'equation' 'file'};
ip(22).default={'none'};

ip(23).aliases={'N.d'}; % donor trap density
ip(23).units='#/cm^3';
ip(23).full_name='Donor dopant density';
ip(23).type='number';
ip(23).n=[1 inf;1 2];
ip(23).range=[0 inf];
ip(23).values={'*'};
ip(23).default=0;
% ip(23).indexed=1;

ip(24).aliases={'Et.d' 'et.d'}; % Et.d=Ec-Et
ip(24).units='eV';
ip(24).full_name='Donor activation energy (wrt E_C)';
ip(24).type='number';
ip(24).n=[1 inf;1 2];
ip(24).range=[-inf inf];
ip(24).values=[];
ip(24).default=-1;

ip(25).aliases={'g.d'}; % degeneracy factor
ip(25).units=' ';
ip(25).full_name='Donor degeneracy factor';
ip(25).type='number';
ip(25).n=[1 inf;1 1];
ip(25).range=[1 inf];
ip(25).values=[];
ip(25).default=2; % standard value

ip(26).aliases={'cp.d'}; % capture cross-esction for holes (cm^2)
ip(26).units='cm^2';
ip(26).full_name='Donor capture cross-section for holes';
ip(26).type='number';
ip(26).n=[1 inf;1 2];
ip(26).range=[realmin inf];
ip(26).values=[];
ip(26).default=1e-30;

ip(27).aliases={'cn.d'}; % capture cross-esction for electrons (cm^2)
ip(27).units='cm^2';
ip(27).full_name='Donor capture cross-section for electrons';
ip(27).type='number';
ip(27).n=[1 inf;1 2];
ip(27).range=[realmin inf];
ip(27).values=[];
ip(27).default=1e-30;

ip(28).aliases={'N.a'}; % acceptor trap density
ip(28).units='#/cm^3';
ip(28).full_name='Acceptor dopant density';
ip(28).type='number';
ip(28).n=[1 inf;1 2];
ip(28).range=[0 inf];
ip(28).values={'*'};
ip(28).default=0;
% ip(28).indexed=1;

ip(29).aliases={'Et.a'}; % Et.slt=Et-Ev
ip(29).units='eV';
ip(29).full_name='Acceptor activation energy (wrt E_V)';
ip(29).type='number';
ip(29).n=[1 inf;1 2];
ip(29).range=[-inf inf];
ip(29).values=[];
ip(29).default=-1;

ip(30).aliases={'g.a'}; % degeneracy factor
ip(30).units=' ';
ip(30).full_name='Acceptor degeneracy factor';
ip(30).type='number';
ip(30).n=[1 inf;1 1];
ip(30).range=[1 inf];
ip(30).values=[];
ip(30).default=4; % standard value

ip(31).aliases={'cp.a'}; % capture cross-esction for holes (cm^2)
ip(31).units='cm^2';
ip(31).full_name='Acceptor capture cross-section for holes';
ip(31).type='number';
ip(31).n=[1 inf;1 2];
ip(31).range=[realmin inf];
ip(31).values=[];
ip(31).default=1e-30;

ip(32).aliases={'cn.a'}; % capture cross-esction for electrons (cm^2)
ip(32).units='cm^2';
ip(32).full_name='Acceptor capture cross-section for electrons';
ip(32).type='number';
ip(32).n=[1 inf;1 2];
ip(32).range=[realmin inf];
ip(32).values=[];
ip(32).default=1e-30;

ip(33).aliases={'N.slt'}; % SLT trap density
ip(33).units='#/cm^3';
ip(33).full_name='Recombination center (trap) denisty';
ip(33).type='number';
ip(33).n=[1 inf;1 2];
ip(33).range=[0 inf];
ip(33).values=[];
ip(33).default=[0];

ip(34).aliases={'type.slt'}; % donor-like or acceptor-like
ip(34).units='';
ip(34).full_name='Recombination center (trap) charge type';
ip(34).type='string';
ip(34).n=[1 inf;1 1];
ip(34).range=[];
ip(34).values={'donor' 'acceptor' 'off'};
ip(34).default={'off'};

ip(35).aliases={'Et.slt' 'et.slt'}; % Et.slt=Et-Ei
ip(35).units='eV';
ip(35).full_name='Recombination center (trap) activation energy (wrt E_i)';
ip(35).type='number';
ip(35).n=[1 inf;1 2];
ip(35).range=[-inf inf];
ip(35).values=[];
ip(35).default=[0];

ip(36).aliases={'g.slt'}; % degeneracy factor
ip(36).units=' ';
ip(36).full_name='Recombination center (trap) degeneracy factor';
ip(36).type='number';
ip(36).n=[1 inf;1 1];
ip(36).range=[1 inf];
ip(36).values=[];
ip(36).default=1;

ip(37).aliases={'cp.slt'}; % capture cross-section for holes (cm^2)
ip(37).units='cm^2';
ip(37).full_name='Recombination center (trap) capture cross-section for holes';
ip(37).type='number';
ip(37).n=[1 inf;1 2];
ip(37).range=[realmin inf];
ip(37).values=[];
ip(37).default=[realmin];

ip(38).aliases={'cn.slt'}; % capture cross-section for electrons (cm^2)
ip(38).units='cn.slt';
ip(38).full_name='Recombination center (trap) capture cross-section for electrons';
ip(38).type='number';
ip(38).n=[1 inf;1 2];
ip(38).range=[realmin inf];
ip(38).values=[];
ip(38).default=[realmin];

ip(39).aliases={'taup.slt'}; % hole lifetime to compute cp=1/(taup*vth*Nt)
ip(39).units='s';
ip(39).full_name='Recombination center (trap) lifetime for holes';
ip(39).type='number';
ip(39).n=[1 inf;1 2];
ip(39).range=[-1 inf];
ip(39).values={'*'};
ip(39).default=[-1];

ip(40).aliases={'taun.slt'}; % electron lifetime to compute cn=1/(taun*vth*Nt)
ip(40).units='s';
ip(40).full_name='Recombination center (trap) lifetime for electrons';
ip(40).type='number';
ip(40).n=[1 inf;1 2];
ip(40).range=[-1 inf];
ip(40).values={'*'};
ip(40).default=[-1];

ip(41).aliases={'N.mv3'}; % 3-level multivalent trap density
ip(41).units='';
ip(41).full_name='';
ip(41).type='number';
ip(41).n=[1 inf;1 2];
ip(41).range=[0 inf];
ip(41).values=[];
ip(41).default=[0];

ip(42).aliases={'Etp.mv3'}; % Etp.mv3=Et-Ev
ip(42).units='';
ip(42).full_name='';
ip(42).type='number';
ip(42).n=[1 inf;1 2];
ip(42).range=[-inf inf];
ip(42).values=[];
ip(42).default=[0];

ip(43).aliases={'Etm.mv3'}; % Etm.mv3=Et-Ev
ip(43).units='';
ip(43).full_name='';
ip(43).type='number';
ip(43).n=[1 inf;1 2];
ip(43).range=[-inf inf];
ip(43).values=[];
ip(43).default=[0];

ip(44).aliases={'cpp.mv3'}; % capture cross-section for holes (cm^2)
ip(44).units='';
ip(44).full_name='';
ip(44).type='number';
ip(44).n=[1 inf;1 2];
ip(44).range=[0 inf];
ip(44).values=[];
ip(44).default=[1e-14];

ip(45).aliases={'cnp.mv3'}; % capture cross-section for electrons (cm^2)
ip(45).units='';
ip(45).full_name='';
ip(45).type='number';
ip(45).n=[1 inf;1 2];
ip(45).range=[0 inf];
ip(45).values=[];
ip(45).default=[1e-14];

ip(46).aliases={'cpm.mv3'}; % capture cross-section for holes (cm^2)
ip(46).units='';
ip(46).full_name='';
ip(46).type='number';
ip(46).n=[1 inf;1 2];
ip(46).range=[0 inf];
ip(46).values=[];
ip(46).default=[1e-14];

ip(47).aliases={'cnm.mv3'}; % capture cross-section for electrons (cm^2)
ip(47).units='';
ip(47).full_name='';
ip(47).type='number';
ip(47).n=[1 inf;1 2];
ip(47).range=[0 inf];
ip(47).values=[];
ip(47).default=[1e-14];

ip(48).aliases={'Eg.opt'}; % optical bandgap
ip(48).units='eV';
ip(48).full_name='Optical bandgap';
ip(48).type='number';
ip(48).n=[1 inf;1 2];
ip(48).range=[-1 inf];
ip(48).values=[];
ip(48).default=[-1]; % defaults to electrical bandgap

ip(49).aliases={'A1.opt'}; % coeff for absorption formula
ip(49).units=' ';
ip(49).full_name='A1.opt';
ip(49).type='number';
ip(49).n=[1 inf;1 2];
ip(49).range=[0 inf];
ip(49).values=[];
ip(49).default=[0]; 

ip(50).aliases={'A2.opt'}; % absorption power law for numerator
ip(50).units=' ';
ip(50).full_name='A2.opt';
ip(50).type='number';
ip(50).n=[1 inf;1 1];
ip(50).range=[0 inf];
ip(50).values=[];
ip(50).default=[0]; 

ip(51).aliases={'A3.opt'}; % absorption power law for denomenator
ip(51).units=' ';
ip(51).full_name='A3.opt';
ip(51).type='number';
ip(51).n=[1 inf;1 1];
ip(51).range=[0 inf];
ip(51).values=[];
ip(51).default=[0];

ip(52).aliases={'alpha_fc.opt'}; % free carrier absorption
ip(52).units='';
ip(52).full_name='Free carrier absortion switch';
ip(52).type='string';
ip(52).n=[1 1;1 1];
ip(52).range=[];
ip(52).values={'on' 'off'};
ip(52).default={'off'};

ip(53).aliases={'FCn.opt'}; % free carrier abs coeff for electrons (cm^-1*cm^3/um^Bn)
ip(53).units='cm^2/um^Bn';
ip(53).full_name='Free carrier abs coeff for electrons';
ip(53).type='number';
ip(53).n=[1 1;1 2];
ip(53).range=[0 inf];
ip(53).values=[];
ip(53).default=[0];

ip(54).aliases={'FCp.opt'}; % free carrier abs coeff for holes (cm^-1*cm^3/um^Bp)
ip(54).units='cm^2/um^Bp';
ip(54).full_name='Free carrier abs coeff for holes';
ip(54).type='number';
ip(54).n=[1 1;1 2];
ip(54).range=[0 inf];
ip(54).values=[];
ip(54).default=[0];

ip(55).aliases={'Bn.opt'}; % free carrier power law for electrons (wl^Bn)
ip(55).units=' ';
ip(55).full_name='Bn';
ip(55).type='number';
ip(55).n=[1 1;1 1];
ip(55).range=[-inf inf];
ip(55).values=[];
ip(55).default=[2];

ip(56).aliases={'Bp.opt'}; % free carrier power law for holes (wl^Bn)
ip(56).units=' ';
ip(56).full_name='Bp';
ip(56).type='number';
ip(56).n=[1 1;1 1];
ip(56).range=[-inf inf];
ip(56).values=[];
ip(56).default=[2];

ip(57).aliases={'vth'}; % thermal velocity (cm/s)
ip(57).units='cm/s';
ip(57).full_name='Thermal velocity (electrons and holes)';
ip(57).type='number';
ip(57).n=[1 1;1 2];
ip(57).range=[0 inf];
ip(57).values=[];
ip(57).default=[0];

ip(58).aliases={'btail'}; % band tails
ip(58).units='';
ip(58).full_name='';
ip(58).type='string';
ip(58).n=[1 1;1 1];
ip(58).range=[];
ip(58).values={'on' 'off'};
ip(58).default={'off'};

ip(59).aliases={'ktv.bt'}; % charicteristic energy of valence band tail (donor-like)
ip(59).units='';
ip(59).full_name='';
ip(59).type='number';
ip(59).n=[1 1;1 2];
ip(59).range=[realmin inf];
ip(59).values=[];
ip(59).default=[.026];

ip(60).aliases={'ktc.bt'}; % charicteristic energy of conduction band tail (acceptor-like)
ip(60).units='';
ip(60).full_name='';
ip(60).type='number';
ip(60).n=[1 1;1 2];
ip(60).range=[realmin inf];
ip(60).values=[];
ip(60).default=[.026];

ip(61).aliases={'dEv.bt'}; % delE above Ev at which exp. band tail starts (density is assumed constant between Ev and Ev.bt)
ip(61).units='';
ip(61).full_name='';
ip(61).type='number';
ip(61).n=[1 1;1 2];
ip(61).range=[0 inf]; % must be >= 0
ip(61).values=[];
ip(61).default=[0]; %defaults to Ev -- NOT CHANGEABLE

ip(62).aliases={'dEc.bt'}; % delE below Ec at which exp. band tail starts (density is assumed constant between Ec.bt and Ec)
ip(62).units='';
ip(62).full_name='';
ip(62).type='number';
ip(62).n=[1 1;1 2];
ip(62).range=[0 inf]; % must be >= 0
ip(62).values=[];
ip(62).default=[0]; % defaults to Ec -- NOT CHANGEABLE

ip(63).aliases={'Gv0.bt'}; % density of states at Ev.bt for valence band tail (#/cm3/eV)
ip(63).units='';
ip(63).full_name='';
ip(63).type='number';
ip(63).n=[1 1;1 2];
ip(63).range=[-1 inf];
ip(63).values=[];
ip(63).default=[-1]; % defaults to 2*pi*Nv/(kT*pi)^3/2*sqrt(kT)

ip(64).aliases={'Gc0.bt'}; % density of states at Ec.bt for conduction band tail (#/cm3/eV)
ip(64).units='';
ip(64).full_name='';
ip(64).type='number';
ip(64).n=[1 1;1 2];
ip(64).range=[-1 inf];
ip(64).values=[];
ip(64).default=[-1]; % defaults to 2*pi*Nc/(kT*pi)^3/2*sqrt(kT))

ip(65).aliases={'cpv.bt'}; % capture cross-section for holes (cm^2)
ip(65).units='';
ip(65).full_name='';
ip(65).type='number';
ip(65).n=[1 inf;1 2];
ip(65).range=[realmin inf];
ip(65).values={};
ip(65).default=[1e-14];

ip(66).aliases={'cnv.bt'}; % capture cross-section for electrons (cm^2)
ip(66).units='';
ip(66).full_name='';
ip(66).type='number';
ip(66).n=[1 inf;1 2];
ip(66).range=[realmin inf];
ip(66).values={};
ip(66).default=[1e-14];

ip(67).aliases={'cpc.bt'}; % capture cross-section for holes (cm^2)
ip(67).units='';
ip(67).full_name='';
ip(67).type='number';
ip(67).n=[1 inf;1 2];
ip(67).range=[realmin inf];
ip(67).values={};
ip(67).default=[1e-14];

ip(68).aliases={'cnc.bt'}; % capture cross-section for electrons (cm^2)
ip(68).units='';
ip(68).full_name='';
ip(68).type='number';
ip(68).n=[1 inf;1 2];
ip(68).range=[realmin inf];
ip(68).values={};
ip(68).default=[1e-14];

ip(69).aliases={'nlaguerre.bt'}; % # of points for Gauss-Laguerre quadrature 
ip(69).units='';
ip(69).full_name='';
ip(69).type='number';
ip(69).n=[1 1;1 1];
ip(69).range=[2 100]; 
ip(69).values={};
ip(69).default=[15];

ip(70).aliases={'maxEstep.bt'}; % max intergtion step size between (Ev & Ev.bt) and (Ec.bt & Ec)
ip(70).units='';
ip(70).full_name='';
ip(70).type='number';
ip(70).n=[1 1;1 1];
ip(70).range=[-1 inf];
ip(70).values={};
ip(70).default=[-1]; % defaults to kT (not implemented)

ip(71).aliases={'gv.bt'}; % degeneracy factor
ip(71).units='';
ip(71).full_name='';
ip(71).type='number';
ip(71).n=[1 inf;1 1];
ip(71).range=[1 inf];
ip(71).values=[];
ip(71).default=[2]; % standard value for donors

ip(72).aliases={'gc.bt'}; % degeneracy factor
ip(72).units='';
ip(72).full_name='';
ip(72).type='number';
ip(72).n=[1 inf;1 1];
ip(72).range=[1 inf];
ip(72).values=[];
ip(72).default=[4]; % standard value for acceptors

ip(73).aliases={'g.shr'}; % shr degeneracy factor
ip(73).units='';
ip(73).full_name='';
ip(73).type='number';
ip(73).n=[1 inf;1 1];
ip(73).range=[-inf inf];
ip(73).values=[];
ip(73).default=[1]; % + for acceptor-like, - for donor-like et'=et+sign(g)*log(abs(g))

ip(74).aliases={'sigma.shr'}; % standard deviation of distribution
ip(74).units='';
ip(74).full_name='';
ip(74).type='number';
ip(74).n=[1 inf;1 1];
ip(74).range=[0 inf];
ip(74).values=[];
ip(74).default=[0]; % defaults to discrete trap

ip(75).aliases={'nint.shr'}; % # points for integration method
ip(75).units='';
ip(75).full_name='';
ip(75).type='number';
ip(75).n=[1 inf;1 1];
ip(75).range=[-1 inf];
ip(75).values=[];
ip(75).default=[-1]; % not used if sigma=0, must be set if not a discrete trap

ip(76).aliases={'int_method.shr' 'imeth.shr'};
ip(76).units='';
ip(76).full_name='';
ip(76).type='string';
ip(76).n=[1 inf;1 1];
ip(76).range=[];
ip(76).values={'Gauss-Hermite' 'Midpoint' 'none'};
ip(76).default={'none'}; 

ip(77).aliases={'distribution.shr' 'distrib.shr'};
ip(77).units='';
ip(77).full_name='';
ip(77).type='string';
ip(77).n=[1 inf;1 1];
ip(77).range=[];
ip(77).values={'discrete' 'Gaussian' 'uniform'};
ip(77).default={'discrete'};

ip(78).aliases={'half_range.shr' 'hrange.shr'};
ip(78).units='';
ip(78).full_name='';
ip(78).type='number';
ip(78).n=[1 inf;1 2];
ip(78).range=[eps inf];
ip(78).values=[];
ip(78).default=[100*eps];

ip(79).aliases={'nsigma.shr'}; % +/- sigma range for Midpoint integration of Gaussian
ip(79).units='';
ip(79).full_name='';
ip(79).type='number';
ip(79).n=[1 inf;1 1];
ip(79).range=[eps inf];
ip(79).values=[];
ip(79).default=[5];

ip(80).aliases={'sigma.slt'}; % standard deviation of distribution
ip(80).units='';
ip(80).full_name='';
ip(80).type='number';
ip(80).n=[1 inf;1 1];
ip(80).range=[0 inf];
ip(80).values=[];
ip(80).default=[0]; % defaults to discrete trap

ip(81).aliases={'nint.slt'}; % # points for integration method
ip(81).units='';
ip(81).full_name='';
ip(81).type='number';
ip(81).n=[1 inf;1 1];
ip(81).range=[-1 inf];
ip(81).values=[];
ip(81).default=[-1]; % not used if sigma=0, must be set is not a discrete trap

ip(82).aliases={'int_method.slt' 'imeth.slt'};
ip(82).units='';
ip(82).full_name='';
ip(82).type='string';
ip(82).n=[1 inf;1 1];
ip(82).range=[];
ip(82).values={'Gauss-Hermite' 'Midpoint' 'none'};
ip(82).default={'none'}; 

ip(83).aliases={'distribution.slt' 'distrib.slt'};
ip(83).units='';
ip(83).full_name='';
ip(83).type='string';
ip(83).n=[1 inf;1 1];
ip(83).range=[];
ip(83).values={'discrete' 'Gaussian' 'uniform'};
ip(83).default={'discrete'};

ip(84).aliases={'half_range.slt' 'hrange.slt'};
ip(84).units='';
ip(84).full_name='';
ip(84).type='number';
ip(84).n=[1 inf;1 2];
ip(84).range=[eps inf];
ip(84).values=[];
ip(84).default=[100*eps];

ip(85).aliases={'nsigma.slt'}; % +/- sigma range for Midpoint integration of Gaussian
ip(85).units='';
ip(85).full_name='';
ip(85).type='number';
ip(85).n=[1 inf;1 1];
ip(85).range=[eps inf];
ip(85).values=[];
ip(85).default=[5];

ip(86).aliases={'sigma.mv3'}; % standard deviation of distribution
ip(86).units='';
ip(86).full_name='';
ip(86).type='number';
ip(86).n=[1 inf;1 1];
ip(86).range=[0 inf];
ip(86).values=[];
ip(86).default=[0]; % defaults to discrete trap

ip(87).aliases={'nint.mv3'}; % # points for integration method
ip(87).units='';
ip(87).full_name='';
ip(87).type='number';
ip(87).n=[1 inf;1 1];
ip(87).range=[-1 inf];
ip(87).values=[];
ip(87).default=[-1]; % not used if sigma=0, must be set if not a discrete trap

ip(88).aliases={'int_method.mv3' 'imeth.mv3'};
ip(88).units='';
ip(88).full_name='';
ip(88).type='string';
ip(88).n=[1 inf;1 1];
ip(88).range=[];
ip(88).values={'Gauss-Hermite' 'Midpoint' 'none'};
ip(88).default={'none'}; 

ip(89).aliases={'distribution.mv3' 'distrib.mv3'};
ip(89).units='';
ip(89).full_name='';
ip(89).type='string';
ip(89).n=[1 inf;1 1];
ip(89).range=[];
ip(89).values={'discrete' 'Gaussian' 'uniform'};
ip(89).default={'discrete'};

ip(90).aliases={'half_range.mv3' 'hrange.mv3'};
ip(90).units='';
ip(90).full_name='';
ip(90).type='number';
ip(90).n=[1 inf;1 2];
ip(90).range=[eps inf];
ip(90).values=[];
ip(90).default=[100*eps];

ip(91).aliases={'nsigma.mv3'}; % +/- sigma range for Midpoint integration of Gaussian
ip(91).units='';
ip(91).full_name='';
ip(91).type='number';
ip(91).n=[1 inf;1 1];
ip(91).range=[eps inf];
ip(91).values=[];
ip(91).default=[5];

ip(92).aliases={'prof.ndp'}; % doping profile
ip(92).units='';
ip(92).full_name='Type of doping profile';
ip(92).type='string';
ip(92).n=[1 inf;1 1];
ip(92).range=[];
ip(92).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
ip(92).default={'linear'};

ip(93).aliases={'xo.ndp'};
ip(93).units='cm';
ip(93).full_name='Starting point of dopant profile';
ip(93).type='number';
ip(93).n=[1 inf;1 1];
ip(93).range=[-inf inf];
ip(93).values=[];
ip(93).default=[0];

ip(94).aliases={'dir.ndp'};
ip(94).units='';
ip(94).full_name='Direction of dopant profile';
ip(94).type='string';
ip(94).n=[1 inf;1 1];
ip(94).range=[];
ip(94).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
ip(94).default={'t-b'};

ip(95).aliases={'Dt.ndp'};
ip(95).units='cm^2';
ip(95).full_name='Dt';
ip(95).type='number';
ip(95).n=[1 inf;1 1];
ip(95).range=[eps inf];
ip(95).values=[];
ip(95).default=[inf]; % defaults to constant doping

ip(96).aliases={'L.ndp'};
ip(96).units='cm';
ip(96).full_name='L';
ip(96).type='number';
ip(96).n=[1 inf;1 1];
ip(96).range=[eps inf];
ip(96).values=[];
ip(96).default=[inf]; % defaults to constant doping

ip(97).aliases={'sigma.ndp'};
ip(97).units='cm^2';
ip(97).full_name='sigma';
ip(97).type='number';
ip(97).n=[1 inf;1 1];
ip(97).range=[eps inf];
ip(97).values=[];
ip(97).default=[inf]; % defaults to constant doping

ip(98).aliases={'prof.nam'}; % doping profile
ip(98).units='Type of doping profile';
ip(98).full_name='';
ip(98).type='string';
ip(98).n=[1 inf;1 1];
ip(98).range=[];
ip(98).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
ip(98).default={'linear'};

ip(99).aliases={'xo.nam'};
ip(99).units='Starting point of dopant profile';
ip(99).full_name='';
ip(99).type='number';
ip(99).n=[1 inf;1 1];
ip(99).range=[-inf inf];
ip(99).values=[];
ip(99).default=[0];

ip(100).aliases={'dir.nam'};
ip(100).units='Direction of dopant profile';
ip(100).full_name='';
ip(100).type='string';
ip(100).n=[1 inf;1 1];
ip(100).range=[];
ip(100).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
ip(100).default={'t-b'};

ip(101).aliases={'Dt.nam'};
ip(101).units='cm^2';
ip(101).full_name='Dt';
ip(101).type='number';
ip(101).n=[1 inf;1 1];
ip(101).range=[eps inf];
ip(101).values=[];
ip(101).default=[inf]; % defaults to constant doping

ip(102).aliases={'L.nam'};
ip(102).units='cm';
ip(102).full_name='L';
ip(102).type='number';
ip(102).n=[1 inf;1 1];
ip(102).range=[eps inf];
ip(102).values=[];
ip(102).default=[inf]; % defaults to constant doping

ip(103).aliases={'sigma.nam'};
ip(103).units='cm^2';
ip(103).full_name='sigma';
ip(103).type='number';
ip(103).n=[1 inf;1 1];
ip(103).range=[eps inf];
ip(103).values=[];
ip(103).default=[inf]; % defaults to constant doping

ip(104).aliases={'prof.d'}; % doping profile
ip(104).units='';
ip(104).full_name='Type of doping profile';
ip(104).type='string';
ip(104).n=[1 inf;1 1];
ip(104).range=[];
ip(104).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
ip(104).default={'linear'};

ip(105).aliases={'xo.d'};
ip(105).units='cm';
ip(105).full_name='Starting point of dopant profile';
ip(105).type='number';
ip(105).n=[1 inf;1 1];
ip(105).range=[-inf inf];
ip(105).values=[];
ip(105).default=[0];

ip(106).aliases={'dir.d'};
ip(106).units='';
ip(106).full_name='Direction of dopant profile';
ip(106).type='string';
ip(106).n=[1 inf;1 1];
ip(106).range=[];
ip(106).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
ip(106).default={'t-b'};

ip(107).aliases={'Dt.d'};
ip(107).units='cm^2';
ip(107).full_name='Dt';
ip(107).type='number';
ip(107).n=[1 inf;1 1];
ip(107).range=[eps inf];
ip(107).values=[];
ip(107).default=[inf]; % defaults to constant doping

ip(108).aliases={'L.d'};
ip(108).units='cm';
ip(108).full_name='L';
ip(108).type='number';
ip(108).n=[1 inf;1 1];
ip(108).range=[eps inf];
ip(108).values=[];
ip(108).default=[inf]; % defaults to constant doping

ip(109).aliases={'sigma.d'};
ip(109).units='cm^2';
ip(109).full_name='sigma';
ip(109).type='number';
ip(109).n=[1 inf;1 1];
ip(109).range=[eps inf];
ip(109).values=[];
ip(109).default=[inf]; % defaults to constant doping

ip(110).aliases={'prof.a'}; % doping profile
ip(110).units='';
ip(110).full_name='Type of doping profile';
ip(110).type='string';
ip(110).n=[1 inf;1 1];
ip(110).range=[];
ip(110).values={'linear' 'erfc' 'gaussian' 'exp' 'file'};
ip(110).default={'linear'};

ip(111).aliases={'xo.a'};
ip(111).units='cm';
ip(111).full_name='Starting point of dopant profile';
ip(111).type='number';
ip(111).n=[1 inf;1 1];
ip(111).range=[-inf inf];
ip(111).values=[];
ip(111).default=[0];

ip(112).aliases={'dir.a'};
ip(112).units='';
ip(112).full_name='Direction of dopant profile';
ip(112).type='string';
ip(112).n=[1 inf;1 1];
ip(112).range=[];
ip(112).values={'t-b' 'b-t' 'top-bottom' 'bottom-top'};
ip(112).default={'t-b'};

ip(113).aliases={'Dt.a'};
ip(113).units='cm^2';
ip(113).full_name='Dt';
ip(113).type='number';
ip(113).n=[1 inf;1 1];
ip(113).range=[eps inf];
ip(113).values=[];
ip(113).default=[inf]; % defaults to constant doping

ip(114).aliases={'L.a'};
ip(114).units='cm';
ip(114).full_name='L';
ip(114).type='number';
ip(114).n=[1 inf;1 1];
ip(114).range=[eps inf];
ip(114).values=[];
ip(114).default=[inf]; % defaults to constant doping

ip(115).aliases={'sigma.a'};
ip(115).units='cm^2';
ip(115).full_name='sigma';
ip(115).type='number';
ip(115).n=[1 inf;1 1];
ip(115).range=[eps inf];
ip(115).values=[];
ip(115).default=[inf]; % defaults to constant doping

ip(116).aliases={'alpha_file' 'alpha_file.opt'};
ip(116).units='';
ip(116).full_name='File name for abs. coeff. vs. wl';
ip(116).type='string';
ip(116).n=[1 1;1 1];
ip(116).range=[];
ip(116).values={'*'};
ip(116).default={''};

ip(117).aliases={'model.un'}; % electron mobility model
ip(117).units='';
ip(117).full_name='Mobility model for electrons';
ip(117).type='string';
ip(117).n=[1 1;1 1];
ip(117).range=[];
ip(117).values={'linear' 'C-T'};
ip(117).default={'linear'};

ip(118).aliases={'max.un'};
ip(118).units='cm^2/V-s';
ip(118).full_name='un(max) for C-T model';
ip(118).type='number';
ip(118).n=[1 1;1 2];
ip(118).range=[eps inf];
ip(118).values=[];
ip(118).default=100;

ip(119).aliases={'min.un'};
ip(119).units='cm^2/V-s';
ip(119).full_name='un(min) for C-T model';
ip(119).type='number';
ip(119).n=[1 1;1 2];
ip(119).range=[eps inf];
ip(119).values=[];
ip(119).default=100;

ip(120).aliases={'Nref.un'};
ip(120).units='cm^-3';
ip(120).full_name='Reference dopant concentration for C-T model';
ip(120).type='number';
ip(120).n=[1 1;1 2];
ip(120).range=[eps inf];
ip(120).values=[];
ip(120).default=inf;

ip(121).aliases={'beta.un'};
ip(121).units=' ';
ip(121).full_name='Exponent for C-T model';
ip(121).type='number';
ip(121).n=[1 1;1 1];
ip(121).range=[eps inf];
ip(121).values=[];
ip(121).default=1;

ip(122).aliases={'model.up'}; % hole mobility model
ip(122).units='';
ip(122).full_name='Mobility model for holes';
ip(122).type='string';
ip(122).n=[1 1;1 1];
ip(122).range=[];
ip(122).values={'linear' 'C-T'};
ip(122).default={'linear'};

ip(123).aliases={'max.up'};
ip(123).units='cm^2/V-s';
ip(123).full_name='up(max) for C-T model';
ip(123).type='number';
ip(123).n=[1 1;1 2];
ip(123).range=[eps inf];
ip(123).values=[];
ip(123).default=100;

ip(124).aliases={'min.up'};
ip(124).units='cm^2/V-s';
ip(124).full_name='up(max) for C-T model';
ip(124).type='number';
ip(124).n=[1 1;1 2];
ip(124).range=[eps inf];
ip(124).values=[];
ip(124).default=100;

ip(125).aliases={'Nref.up'};
ip(125).units='cm^-3';
ip(125).full_name='Reference dopant concentration for C-T model';
ip(125).type='number';
ip(125).n=[1 1;1 2];
ip(125).range=[eps inf];
ip(125).values=[];
ip(125).default=inf;

ip(126).aliases={'beta.up'};
ip(126).units='';
ip(126).full_name='Exponent for C-T model';
ip(126).type='number';
ip(126).n=[1 1;1 1];
ip(126).range=[eps inf];
ip(126).values=[];
ip(126).default=1;

ip(127).aliases={'Ncutp.shr'};
ip(127).units='';
ip(127).full_name='';
ip(127).type='number';
ip(127).n=[1 inf;1 1];
ip(127).range=[eps inf];
ip(127).values=[];
ip(127).default=inf;

ip(128).aliases={'Ncutn.shr'};
ip(128).units='';
ip(128).full_name='';
ip(128).type='number';
ip(128).n=[1 inf;1 1];
ip(128).range=[eps inf];
ip(128).values=[];
ip(128).default=inf;