function [dev,kerr]=a_pcustom(inputs,dev,nlayer)
global CONST VERBOSE A_FID

kerr=0;

for i=1:length(inputs.layer(nlayer).ip)
    if strcmp(inputs.layer(nlayer).ip(i).type,'number')
        for j=1:length(inputs.layer(nlayer).ip(i).set)
            if inputs.layer(nlayer).ip(i).set(j,:) == inputs.layer(nlayer).ip(i).default
                inputs.layer(nlayer).ip(i).default_used(j)=1;
            else
                inputs.layer(nlayer).ip(i).default_used(j)=0;
            end
        end
    end
end

dev.reg(nlayer).describe=inputs.layer(nlayer).describe;

% check if piece-wise constant
if size(inputs.layer(nlayer).ip(3).set,2) == 1; inputs.layer(nlayer).ip(3).set(:,2)=inputs.layer(nlayer).ip(3).set(:,1); end; % chi
if size(inputs.layer(nlayer).ip(4).set,2) == 1; inputs.layer(nlayer).ip(4).set(:,2)=inputs.layer(nlayer).ip(4).set(:,1); end; % eg
if size(inputs.layer(nlayer).ip(5).set,2) == 1; inputs.layer(nlayer).ip(5).set(:,2)=inputs.layer(nlayer).ip(5).set(:,1); end; % ks
if size(inputs.layer(nlayer).ip(6).set,2) == 1; inputs.layer(nlayer).ip(6).set(:,2)=inputs.layer(nlayer).ip(6).set(:,1); end; % Nc
if size(inputs.layer(nlayer).ip(7).set,2) == 1; inputs.layer(nlayer).ip(7).set(:,2)=inputs.layer(nlayer).ip(7).set(:,1); end; % Nv
if size(inputs.layer(nlayer).ip(8).set,2) == 1; inputs.layer(nlayer).ip(8).set(:,2)=inputs.layer(nlayer).ip(8).set(:,1); end; % Nc.tot
if size(inputs.layer(nlayer).ip(9).set,2) == 1; inputs.layer(nlayer).ip(9).set(:,2)=inputs.layer(nlayer).ip(9).set(:,1); end; % Nv.tot
if size(inputs.layer(nlayer).ip(10).set,2) == 1; inputs.layer(nlayer).ip(10).set(:,2)=inputs.layer(nlayer).ip(10).set(:,1); end; % vth.n
if size(inputs.layer(nlayer).ip(11).set,2) == 1; inputs.layer(nlayer).ip(11).set(:,2)=inputs.layer(nlayer).ip(11).set(:,1); end; % vth.p
if size(inputs.layer(nlayer).ip(12).set,2) == 1; inputs.layer(nlayer).ip(12).set(:,2)=inputs.layer(nlayer).ip(12).set(:,1); end; % Nd+
if size(inputs.layer(nlayer).ip(13).set,2) == 1; inputs.layer(nlayer).ip(13).set(:,2)=inputs.layer(nlayer).ip(13).set(:,1); end; % Na-
if size(inputs.layer(nlayer).ip(14).set,2) == 1; inputs.layer(nlayer).ip(14).set(:,2)=inputs.layer(nlayer).ip(14).set(:,1); end; % un
if size(inputs.layer(nlayer).ip(15).set,2) == 1; inputs.layer(nlayer).ip(15).set(:,2)=inputs.layer(nlayer).ip(15).set(:,1); end; % up
if size(inputs.layer(nlayer).ip(16).set,2) == 1; inputs.layer(nlayer).ip(16).set(:,2)=inputs.layer(nlayer).ip(16).set(:,1); end; % et.shr
if size(inputs.layer(nlayer).ip(17).set,2) == 1; inputs.layer(nlayer).ip(17).set(:,2)=inputs.layer(nlayer).ip(17).set(:,1); end; % taun.shr
if size(inputs.layer(nlayer).ip(18).set,2) == 1; inputs.layer(nlayer).ip(18).set(:,2)=inputs.layer(nlayer).ip(18).set(:,1); end; % taup.shr
if size(inputs.layer(nlayer).ip(19).set,2) == 1; inputs.layer(nlayer).ip(19).set(:,2)=inputs.layer(nlayer).ip(19).set(:,1); end; % B.rad
if size(inputs.layer(nlayer).ip(20).set,2) == 1; inputs.layer(nlayer).ip(20).set(:,2)=inputs.layer(nlayer).ip(20).set(:,1); end; % Cn.auger
if size(inputs.layer(nlayer).ip(21).set,2) == 1; inputs.layer(nlayer).ip(21).set(:,2)=inputs.layer(nlayer).ip(21).set(:,1); end; % Cp.auger
if size(inputs.layer(nlayer).ip(23).set,2) == 1; inputs.layer(nlayer).ip(23).set(:,2)=inputs.layer(nlayer).ip(23).set(:,1); end; % N.d
if size(inputs.layer(nlayer).ip(24).set,2) == 1; inputs.layer(nlayer).ip(24).set(:,2)=inputs.layer(nlayer).ip(24).set(:,1); end; % et.d
if size(inputs.layer(nlayer).ip(26).set,2) == 1; inputs.layer(nlayer).ip(26).set(:,2)=inputs.layer(nlayer).ip(26).set(:,1); end; % cp.d
if size(inputs.layer(nlayer).ip(27).set,2) == 1; inputs.layer(nlayer).ip(27).set(:,2)=inputs.layer(nlayer).ip(27).set(:,1); end; % cn.d
if size(inputs.layer(nlayer).ip(28).set,2) == 1; inputs.layer(nlayer).ip(28).set(:,2)=inputs.layer(nlayer).ip(28).set(:,1); end; % N.a
if size(inputs.layer(nlayer).ip(29).set,2) == 1; inputs.layer(nlayer).ip(29).set(:,2)=inputs.layer(nlayer).ip(29).set(:,1); end; % et.a
if size(inputs.layer(nlayer).ip(31).set,2) == 1; inputs.layer(nlayer).ip(31).set(:,2)=inputs.layer(nlayer).ip(31).set(:,1); end; % cp.a
if size(inputs.layer(nlayer).ip(32).set,2) == 1; inputs.layer(nlayer).ip(32).set(:,2)=inputs.layer(nlayer).ip(32).set(:,1); end; % cn.a
if size(inputs.layer(nlayer).ip(33).set,2) == 1; inputs.layer(nlayer).ip(33).set(:,2)=inputs.layer(nlayer).ip(33).set(:,1); end; % N.slt
if size(inputs.layer(nlayer).ip(35).set,2) == 1; inputs.layer(nlayer).ip(35).set(:,2)=inputs.layer(nlayer).ip(35).set(:,1); end; % et.slt
if size(inputs.layer(nlayer).ip(37).set,2) == 1; inputs.layer(nlayer).ip(37).set(:,2)=inputs.layer(nlayer).ip(37).set(:,1); end; % cp.slt
if size(inputs.layer(nlayer).ip(38).set,2) == 1; inputs.layer(nlayer).ip(38).set(:,2)=inputs.layer(nlayer).ip(38).set(:,1); end; % cn.slt
if size(inputs.layer(nlayer).ip(39).set,2) == 1; inputs.layer(nlayer).ip(39).set(:,2)=inputs.layer(nlayer).ip(39).set(:,1); end; % taup.slt
if size(inputs.layer(nlayer).ip(40).set,2) == 1; inputs.layer(nlayer).ip(40).set(:,2)=inputs.layer(nlayer).ip(40).set(:,1); end; % taun.slt
if size(inputs.layer(nlayer).ip(41).set,2) == 1; inputs.layer(nlayer).ip(41).set(:,2)=inputs.layer(nlayer).ip(41).set(:,1); end; % N.mv3
if size(inputs.layer(nlayer).ip(42).set,2) == 1; inputs.layer(nlayer).ip(42).set(:,2)=inputs.layer(nlayer).ip(42).set(:,1); end; % etp.mv3
if size(inputs.layer(nlayer).ip(43).set,2) == 1; inputs.layer(nlayer).ip(43).set(:,2)=inputs.layer(nlayer).ip(43).set(:,1); end; % etm.mv3
if size(inputs.layer(nlayer).ip(44).set,2) == 1; inputs.layer(nlayer).ip(44).set(:,2)=inputs.layer(nlayer).ip(44).set(:,1); end; % cpp.mv3
if size(inputs.layer(nlayer).ip(45).set,2) == 1; inputs.layer(nlayer).ip(45).set(:,2)=inputs.layer(nlayer).ip(45).set(:,1); end; % cnp.mv3
if size(inputs.layer(nlayer).ip(46).set,2) == 1; inputs.layer(nlayer).ip(46).set(:,2)=inputs.layer(nlayer).ip(46).set(:,1); end; % cpm.mv3
if size(inputs.layer(nlayer).ip(47).set,2) == 1; inputs.layer(nlayer).ip(47).set(:,2)=inputs.layer(nlayer).ip(47).set(:,1); end; % cnm.mv3
if size(inputs.layer(nlayer).ip(48).set,2) == 1; inputs.layer(nlayer).ip(48).set(:,2)=inputs.layer(nlayer).ip(48).set(:,1); end; % eg.opt
if size(inputs.layer(nlayer).ip(49).set,2) == 1; inputs.layer(nlayer).ip(49).set(:,2)=inputs.layer(nlayer).ip(49).set(:,1); end; % A1.opt
if size(inputs.layer(nlayer).ip(53).set,2) == 1; inputs.layer(nlayer).ip(53).set(:,2)=inputs.layer(nlayer).ip(53).set(:,1); end; % FCn.opt
if size(inputs.layer(nlayer).ip(54).set,2) == 1; inputs.layer(nlayer).ip(54).set(:,2)=inputs.layer(nlayer).ip(54).set(:,1); end; % FCp.opt
if size(inputs.layer(nlayer).ip(55).set,2) == 1; inputs.layer(nlayer).ip(55).set(:,2)=inputs.layer(nlayer).ip(55).set(:,1); end; % Bn.opt
if size(inputs.layer(nlayer).ip(56).set,2) == 1; inputs.layer(nlayer).ip(56).set(:,2)=inputs.layer(nlayer).ip(56).set(:,1); end; % Bp.opt
if size(inputs.layer(nlayer).ip(57).set,2) == 1; inputs.layer(nlayer).ip(57).set(:,2)=inputs.layer(nlayer).ip(57).set(:,1); end; % vth
if size(inputs.layer(nlayer).ip(59).set,2) == 1; inputs.layer(nlayer).ip(59).set(:,2)=inputs.layer(nlayer).ip(59).set(:,1); end; % ktv.bt
if size(inputs.layer(nlayer).ip(60).set,2) == 1; inputs.layer(nlayer).ip(60).set(:,2)=inputs.layer(nlayer).ip(60).set(:,1); end; % ktc.bt
if size(inputs.layer(nlayer).ip(61).set,2) == 1; inputs.layer(nlayer).ip(61).set(:,2)=inputs.layer(nlayer).ip(61).set(:,1); end; % Ev.bt
if size(inputs.layer(nlayer).ip(62).set,2) == 1; inputs.layer(nlayer).ip(62).set(:,2)=inputs.layer(nlayer).ip(62).set(:,1); end; % Ec.bt
if size(inputs.layer(nlayer).ip(63).set,2) == 1; inputs.layer(nlayer).ip(63).set(:,2)=inputs.layer(nlayer).ip(63).set(:,1); end; % Nv.bt
if size(inputs.layer(nlayer).ip(64).set,2) == 1; inputs.layer(nlayer).ip(64).set(:,2)=inputs.layer(nlayer).ip(64).set(:,1); end; % Nc.bt
if size(inputs.layer(nlayer).ip(65).set,2) == 1; inputs.layer(nlayer).ip(65).set(:,2)=inputs.layer(nlayer).ip(65).set(:,1); end; % cpv.bt
if size(inputs.layer(nlayer).ip(66).set,2) == 1; inputs.layer(nlayer).ip(66).set(:,2)=inputs.layer(nlayer).ip(66).set(:,1); end; % cnv.bt
if size(inputs.layer(nlayer).ip(67).set,2) == 1; inputs.layer(nlayer).ip(67).set(:,2)=inputs.layer(nlayer).ip(67).set(:,1); end; % cpc.bt
if size(inputs.layer(nlayer).ip(68).set,2) == 1; inputs.layer(nlayer).ip(68).set(:,2)=inputs.layer(nlayer).ip(68).set(:,1); end; % cnc.bt
if size(inputs.layer(nlayer).ip(78).set,2) == 1; inputs.layer(nlayer).ip(78).set(:,2)=inputs.layer(nlayer).ip(78).set(:,1); end; % hrange.shr
if size(inputs.layer(nlayer).ip(84).set,2) == 1; inputs.layer(nlayer).ip(84).set(:,2)=inputs.layer(nlayer).ip(84).set(:,1); end; % hrange.slt
if size(inputs.layer(nlayer).ip(90).set,2) == 1; inputs.layer(nlayer).ip(90).set(:,2)=inputs.layer(nlayer).ip(90).set(:,1); end; % hrange.mv3
if size(inputs.layer(nlayer).ip(118).set,2) == 1; inputs.layer(nlayer).ip(118).set(:,2)=inputs.layer(nlayer).ip(118).set(:,1); end; % max.un
if size(inputs.layer(nlayer).ip(119).set,2) == 1; inputs.layer(nlayer).ip(119).set(:,2)=inputs.layer(nlayer).ip(119).set(:,1); end; % min.un
if size(inputs.layer(nlayer).ip(120).set,2) == 1; inputs.layer(nlayer).ip(120).set(:,2)=inputs.layer(nlayer).ip(120).set(:,1); end; % Nref.un
if size(inputs.layer(nlayer).ip(123).set,2) == 1; inputs.layer(nlayer).ip(123).set(:,2)=inputs.layer(nlayer).ip(123).set(:,1); end; % max.up
if size(inputs.layer(nlayer).ip(124).set,2) == 1; inputs.layer(nlayer).ip(124).set(:,2)=inputs.layer(nlayer).ip(124).set(:,1); end; % min.up
if size(inputs.layer(nlayer).ip(125).set,2) == 1; inputs.layer(nlayer).ip(125).set(:,2)=inputs.layer(nlayer).ip(125).set(:,1); end; % Nref.up

if inputs.layer(nlayer).ip(1).set(1) < 0
    ierr=ierr+1;
    if VERBOSE; fprintf(A_FID,'Layer thickness not set\n'); end
else
    % convert layer thickness to cm
    if strcmp(inputs.layer(nlayer).ip(1).name,'t_A')
        tt=1e-8*inputs.layer(nlayer).ip(1).set(1);
    elseif strcmp(inputs.layer(nlayer).ip(1).name,'t_nm')
        tt=1e-7*inputs.layer(nlayer).ip(1).set(1);
    elseif strcmp(inputs.layer(nlayer).ip(1).name,'t_um')
        tt=1e-4*inputs.layer(nlayer).ip(1).set(1);
    else
         tt=inputs.layer(nlayer).ip(1).set(1);
    end
end
if nlayer == 1
    dev.reg(nlayer).min=0.0;
    dev.reg(nlayer).max=tt;
else
    dev.reg(nlayer).min=dev.reg(nlayer-1).max;
    dev.reg(nlayer).max=dev.reg(nlayer-1).max+tt;
end
dev.reg(nlayer).thick=tt;

dev.reg(nlayer).mat='semiconductor';
% try
%     matno=length(dev.semi)+1;
% catch
%     matno=1;
% end
if isempty(fieldnames(dev.semi))
    matno=1;
else
    matno=length(dev.semi)+1;
end
dev.reg(nlayer).matno=matno;
dev.semi(matno).reg_no=nlayer;
dev.semi(matno).model=inputs.layer(nlayer).ip(2).set;

%--------------------------------------------------------------------------
% band structure
dev.semi(matno).chi=inputs.layer(nlayer).ip(3).set;
% need this for Schottky barriers
if matno == 1
    dev.bc.top.chi=dev.semi(matno).chi(1,1);
else
    dev.bc.bottom.chi=dev.semi(matno).chi(1,2);
end
dev.semi(matno).eg=inputs.layer(nlayer).ip(4).set;
rEg=dev.semi(matno).eg; % for local use
dev.semi(matno).ks=inputs.layer(nlayer).ip(5).set;
dev.semi(matno).nc=inputs.layer(nlayer).ip(6).set;
rNc=dev.semi(matno).nc; % for local use
% need this for Schottky barriers
if matno == 1
    dev.bc.top.Nc=dev.semi(matno).nc;
else
    dev.bc.bottom.Nc=dev.semi(matno).nc;
end
dev.semi(matno).nv=inputs.layer(nlayer).ip(7).set;
rNv=dev.semi(matno).nv; % for local use
dev.semi(matno).nct=inputs.layer(nlayer).ip(8).set;
dev.semi(matno).nvt=inputs.layer(nlayer).ip(9).set;

%--------------------------------------------------------------------------
% mobility
dev.semi(matno).un_model=inputs.layer(nlayer).ip(117).set;
dev.semi(matno).un=inputs.layer(nlayer).ip(14).set;
dev.semi(matno).un_max=inputs.layer(nlayer).ip(118).set;      
dev.semi(matno).un_min=inputs.layer(nlayer).ip(119).set;
dev.semi(matno).un_nref=inputs.layer(nlayer).ip(120).set;
dev.semi(matno).un_beta=inputs.layer(nlayer).ip(121).set;
dev.semi(matno).up_model=inputs.layer(nlayer).ip(122).set;
dev.semi(matno).up=inputs.layer(nlayer).ip(15).set;
dev.semi(matno).up_max=inputs.layer(nlayer).ip(123).set;      
dev.semi(matno).up_min=inputs.layer(nlayer).ip(124).set;
dev.semi(matno).up_nref=inputs.layer(nlayer).ip(125).set;
dev.semi(matno).up_beta=inputs.layer(nlayer).ip(126).set;

%--------------------------------------------------------------------------
% band-to-band recombination
dev.semi(matno).B=inputs.layer(nlayer).ip(19).set;
dev.semi(matno).Cn=inputs.layer(nlayer).ip(20).set;
dev.semi(matno).Cp=inputs.layer(nlayer).ip(21).set;

%--------------------------------------------------------------------------
% vth
if inputs.layer(nlayer).ip(57).set(1) == 0 % possibly different vthp and vthn
    if inputs.layer(nlayer).ip(10).set(1) == 0
        dev.semi(matno).vthn=[1e7 1e7];
    else
        dev.semi(matno).vthn=inputs.layer(nlayer).ip(10).set;
    end
    if inputs.layer(nlayer).ip(11).set(1) == 0
        dev.semi(matno).vthp=[1e7 1e7];
    else
        dev.semi(matno).vthp=inputs.layer(nlayer).ip(11).set;
    end
elseif inputs.layer(nlayer).ip(57).set(1) > 0 && (inputs.layer(nlayer).ip(10).set(1) > 0 || inputs.layer(nlayer).ip(11).set(1))
    error('rcustom.m: cannot set vth.p/vth.n if vth is set')
else % vthp=vthn
    dev.semi(matno).vthn=inputs.layer(nlayer).ip(57).set;
    dev.semi(matno).vthp=inputs.layer(nlayer).ip(57).set;
end

%--------------------------------------------------------------------------
% fully ionized dopants
% donors
nndp=size(inputs.layer(nlayer).ip(12).set,1);
dev.semi(matno).numndp=nndp;
for kk=1:nndp
    dev.semi(matno).prof_ndp{kk}=inputs.layer(nlayer).ip(92).set{kk};
    % common to all profiles
    dev.semi(matno).ndp(kk,:)=inputs.layer(nlayer).ip(12).set(kk,:);
    % common to erfc,gaussian, exp
    if strcmp((inputs.layer(nlayer).ip(92).set{kk}),'erfc') || strcmp((inputs.layer(nlayer).ip(92).set{kk}),'gaussian') || strcmp((inputs.layer(nlayer).ip(92).set{kk}),'exp')
        try dev.semi(matno).xo_ndp(kk)=inputs.layer(nlayer).ip(93).set(kk); catch dev.semi(matno).xo_ndp(kk)=inputs.layer(nlayer).ip(93).default; end
        try
            if strcmp(inputs.layer(nlayer).ip(94).set(kk),'t-b') || strcmp(inputs.layer(nlayer).ip(94).set(kk),'top-bottom')
                dev.semi(matno).dir_ndp(kk)=1;
            else
                dev.semi(matno).dir_ndp(kk)=-1;
            end
        catch
            dev.semi(matno).dir_ndp(kk)=1;
        end
    end
    switch inputs.layer(nlayer).ip(92).set{kk}
        case 'linear'
             % no extra parameters to set
        case 'erfc'
            try dev.semi(matno).Dt_ndp(kk)=inputs.layer(nlayer).ip(95).set(kk); catch dev.semi(matno).Dt_ndp(kk)=inputs.layer(nlayer).ip(95).default; end
        case 'gaussian'
            try dev.semi(matno).sigma_ndp(kk)=inputs.layer(nlayer).ip(97).set(kk); catch dev.semi(matno).sigma_ndp(kk)=inputs.layer(nlayer).ip(97).default; end
        case 'exp'
            try dev.semi(matno).L_ndp(kk)=inputs.layer(nlayer).ip(96).set(kk); catch dev.semi(matno).L_ndp(kk)=inputs.layer(nlayer).ip(96).default; end
        otherwise
            kerr=kerr+1;
            if VERBOSE; fprintf('a_rcustom.m: profile not supported for .ndp\n'); end
    end
end

% acceptors
nnam=size(inputs.layer(nlayer).ip(13).set,1);
dev.semi(matno).numnam=nnam;
for kk=1:nnam
    dev.semi(matno).prof_nam{kk}=inputs.layer(nlayer).ip(98).set{kk};
    % common to all profiles
    dev.semi(matno).nam(kk,:)=inputs.layer(nlayer).ip(13).set(kk,:);
    % common to erfc,gaussian, exp
    if strcmp((inputs.layer(nlayer).ip(98).set{kk}),'erfc') || strcmp((inputs.layer(nlayer).ip(98).set{kk}),'gaussian') || strcmp((inputs.layer(nlayer).ip(98).set{kk}),'exp')
        try dev.semi(matno).xo_nam(kk)=inputs.layer(nlayer).ip(99).set(kk); catch dev.semi(matno).xo_nam(kk)=inputs.layer(nlayer).ip(99).default; end
        try
            if strcmp(inputs.layer(nlayer).ip(100).set(kk),'t-b') || strcmp(inputs.layer(nlayer).ip(100).set(kk),'top-bottom')
                dev.semi(matno).dir_nam(kk)=1;
            else
                dev.semi(matno).dir_nam(kk)=-1;
            end
        catch
            dev.semi(matno).dir_nam(kk)=1;
        end
    end
    switch inputs.layer(nlayer).ip(98).set{kk}
        case 'linear'
            % no extra parameters to set
        case 'erfc'
            try dev.semi(matno).Dt_nam(kk)=inputs.layer(nlayer).ip(101).set(kk); catch dev.semi(matno).Dt_nam(kk)=inputs.layer(nlayer).ip(101).default; end
        case 'gaussian'
            try dev.semi(matno).sigma_nam(kk)=inputs.layer(nlayer).ip(103).set(kk); catch dev.semi(matno).sigma_nam(kk)=inputs.layer(nlayer).ip(103).default; end
        case 'exp'
            try dev.semi(matno).L_nam(kk)=inputs.layer(nlayer).ip(102).set(kk); catch dev.semi(matno).L_nam(kk)=inputs.layer(nlayer).ip(102).default; end
        otherwise
            kerr=kerr+1;
            if VERBOSE; fprintf('a_rcustom.m: profile not supported for .nam\n'); end
    end
end

%--------------------------------------------------------------------------
% dopants
% donors
nnd=size(inputs.layer(nlayer).ip(23).set,1);
dev.semi(matno).numd=nnd;
for kk=1:nnd
    dev.semi(matno).prof_d{kk}=inputs.layer(nlayer).ip(104).set{kk};
    % common to all profiles
    dev.semi(matno).Nd(kk,:)=inputs.layer(nlayer).ip(23).set(kk,:);
    try dev.semi(matno).Etd(kk,:)=inputs.layer(nlayer).ip(24).set(kk,:); catch dev.semi(matno).Etd(kk,1:2)=inputs.layer(nlayer).ip(24).default; end
    try dev.semi(matno).gd(kk,1)=inputs.layer(nlayer).ip(25).set(kk); catch dev.semi(matno).gd(kk,1)=inputs.layer(nlayer).ip(25).default; end
    try dev.semi(matno).cpd(kk,:)=inputs.layer(nlayer).ip(26).set(kk,:); catch dev.semi(matno).cpd(kk,1:2)=inputs.layer(nlayer).ip(26).default; end
    try dev.semi(matno).cnd(kk,:)=inputs.layer(nlayer).ip(27).set(kk,:); catch dev.semi(matno).cnd(kk,1:2)=inputs.layer(nlayer).ip(27).default; end
    % common to erfc,gaussian, exp
    if strcmp((inputs.layer(nlayer).ip(104).set{kk}),'erfc') || strcmp((inputs.layer(nlayer).ip(104).set{kk}),'gaussian') || strcmp((inputs.layer(nlayer).ip(104).set{kk}),'exp')
        try dev.semi(matno).xo_d(kk)=inputs.layer(nlayer).ip(105).set(kk); catch dev.semi(matno).xo_d(kk)=inputs.layer(nlayer).ip(105).default; end
        try
            if strcmp(inputs.layer(nlayer).ip(106).set(kk),'t-b') || strcmp(inputs.layer(nlayer).ip(106).set(kk),'top-bottom')
                dev.semi(matno).dir_d(kk)=1;
            else
                dev.semi(matno).dir_d(kk)=-1;
            end
        catch
            dev.semi(matno).dir_d(kk)=1;
        end
    end
    switch inputs.layer(nlayer).ip(104).set{kk}
        case 'linear'
            % no extra parameters to set
        case 'erfc'
            try dev.semi(matno).Dt_d(kk)=inputs.layer(nlayer).ip(107).set(kk); catch dev.semi(matno).Dt_d(kk)=inputs.layer(nlayer).ip(107).default; end      
        case 'gaussian'
            try dev.semi(matno).sigma_d(kk)=inputs.layer(nlayer).ip(109).set(kk); catch dev.semi(matno).sigma_d(kk)=inputs.layer(nlayer).ip(109).default; end
        case 'exp'
            try dev.semi(matno).L_d(kk)=inputs.layer(nlayer).ip(108).set(kk); catch dev.semi(matno).L_d(kk)=inputs.layer(nlayer).ip(108).default; end
        otherwise
            kerr=kerr+1;
            if VERBOSE; fprintf('a_rcustom.m: profile not supported for .d\n'); end
    end
end

% acceptors
nna=size(inputs.layer(nlayer).ip(28).set,1);
dev.semi(matno).numa=nna;
for kk=1:nna
    dev.semi(matno).prof_a{kk}=inputs.layer(nlayer).ip(110).set{kk};
    % common to all profiles
    dev.semi(matno).Na(kk,:)=inputs.layer(nlayer).ip(28).set(kk,:);
    try dev.semi(matno).Eta(kk,:)=inputs.layer(nlayer).ip(29).set(kk,:); catch dev.semi(matno).Eta(kk,1:2)=inputs.layer(nlayer).ip(24).default; end
    try dev.semi(matno).ga(kk,1)=inputs.layer(nlayer).ip(30).set(kk); catch dev.semi(matno).ga(kk,1)=inputs.layer(nlayer).ip(25).default; end
    try dev.semi(matno).cpa(kk,:)=inputs.layer(nlayer).ip(31).set(kk,:); catch dev.semi(matno).cpa(kk,1:2)=inputs.layer(nlayer).ip(26).default; end
    try dev.semi(matno).cna(kk,:)=inputs.layer(nlayer).ip(32).set(kk,:); catch dev.semi(matno).cna(kk,1:2)=inputs.layer(nlayer).ip(27).default; end
    % common to erfc, gaussian, exp
    if strcmp((inputs.layer(nlayer).ip(110).set{kk}),'erfc') || strcmp((inputs.layer(nlayer).ip(110).set{kk}),'gaussian') || strcmp((inputs.layer(nlayer).ip(110).set{kk}),'exp')
        try dev.semi(matno).xo_a(kk)=inputs.layer(nlayer).ip(111).set(kk); catch dev.semi(matno).xo_a(kk)=inputs.layer(nlayer).ip(111).default; end
        try
            if strcmp(inputs.layer(nlayer).ip(112).set(kk),'t-b') || strcmp(inputs.layer(nlayer).ip(112).set(kk),'top-bottom')
                dev.semi(matno).dir_a(kk)=1;
            else
                dev.semi(matno).dir_a(kk)=-1;
            end
        catch
            dev.semi(matno).dir_a(kk)=1;
        end
    end
    switch inputs.layer(nlayer).ip(110).set{kk}
        case 'linear'
            % no extra parameters to set
        case 'erfc'
            try dev.semi(matno).Dt_a(kk)=inputs.layer(nlayer).ip(113).set(kk); catch dev.semi(matno).Dt_a(kk)=inputs.layer(nlayer).ip(113).default; end
        case 'gaussian'
            try dev.semi(matno).sigma_a(kk)=inputs.layer(nlayer).ip(115).set(kk); catch dev.semi(matno).sigma_a(kk)=inputs.layer(nlayer).ip(115).default; end
        case 'exp'
            try dev.semi(matno).L_a(kk)=inputs.layer(nlayer).ip(114).set(kk); catch dev.semi(matno).L_a(kk)=inputs.layer(nlayer).ip(114).default; end
        otherwise
            kerr=kerr+1;
            if VERBOSE; fprintf('a_rcustom.m: profile not supported for .a\n'); end
    end
end

%--------------------------------------------------------------------------
% shr recombination
nshr=size(inputs.layer(nlayer).ip(16).set,1);

for kk=1:nshr % check for valid inputs
   switch char(inputs.layer(nlayer).ip(77).set(kk)) % distribution.shr
       case 'discrete'
           if inputs.layer(nlayer).ip(75).set(kk) ~= -1
               error('a_rcustom.m: nint.shr must = -1 (not used)')
           else
               inputs.layer(nlayer).ip(75).set(kk)=1; % set to one for calculations
           end
           if inputs.layer(nlayer).ip(74).set(kk) ~= 0
               error('a_rcustom.m: sigma.shr must = 0 for discrete trap')
           end
           if strcmp(inputs.layer(nlayer).ip(76).set(kk),'none') == 0
               error('a_rcustom.m: int_method.shr must = ''none'' for discrete trap')
           end
       case 'Gaussian'
           if inputs.layer(nlayer).ip(74).set(kk) == 0
               error('a_rcustom.m: sigma.shr must > 0 for Gaussian trap distribution')
           end
           if inputs.layer(nlayer).ip(76).default_used
               inputs.layer(nlayer).ip(76).set(kk)={'Gauss-Hermite'};
               if inputs.layer(nlayer).ip(75).default_used
                   inputs.layer(nlayer).ip(75).set(kk)=15; % default value
               end
           else
               if strcmp(inputs.layer(nlayer).ip(76).set(kk),'Gauss-Hermite')
                   if inputs.layer(nlayer).ip(75).default_used
                       inputs.layer(nlayer).ip(75).set(kk)=15; % default value
                   end
               elseif strcmp(inputs.layer(nlayer).ip(76).set(kk),'Midpoint')
                   if inputs.layer(nlayer).ip(75).default_used
                       inputs.layer(nlayer).ip(75).set(kk)=20; % default value
                   end
               end
           end
           if strcmp(inputs.layer(nlayer).ip(76).set(kk),'none') % int_method.shr
              error('a_rcustom.m: int_method.shr must = ''Gauss-Hermite'' or ''Midpoint'' for Gaussian distribution')
           end
           if inputs.layer(nlayer).ip(75).set(kk) < 2 && strcmp(inputs.layer(nlayer).ip(76).set(kk),'Gauss-Hermite')
               error('a_rcustom.m: nint.shr must be >= 2 for ''Gauss-Hermite'' integration')
           end
           if inputs.layer(nlayer).ip(75).set(kk) < 1 && strcmp(inputs.layer(nlayer).ip(76).set(kk),'Midpoint')
               error('a_rcustom.m: nint.shr must be >= 1 for ''Midpoint'' integration')
           end
       case 'uniform'
           if inputs.layer(nlayer).ip(74).set(kk) ~= 0
               error('a_rcustom.m: sigma.shr not used for uniform trap distribution')
           end
           if inputs.layer(nlayer).ip(76).default_used
               inputs.layer(nlayer).ip(76).set(kk)={'Midpoint'};
               if inputs.layer(nlayer).ip(75).default_used
                   inputs.layer(nlayer).ip(75).set(kk)=20; % default value
               end
           end
           if strcmp(inputs.layer(nlayer).ip(76).set(kk),'none') || strcmp(inputs.layer(nlayer).ip(76).set(kk),'Gauss-Hermite')
              error('a_rcustom.m: int_method.shr must = ''Midpoint'' for uniform trap distribution')
           end
           if inputs.layer(nlayer).ip(75).set(kk) < 1
               error('a_rcustom.m: nint.shr must be >= 1')
           end
           if inputs.layer(nlayer).ip(78).set(kk,1) < eps || inputs.layer(nlayer).ip(78).set(kk,2) < eps
               error('a_rcustom.m: half_range.shr must be >= eps')
           end
   end
end
 
numshr=0; % multiple shr centers
for l1=1:size(inputs.layer(nlayer).ip(16).set,1) 
   if strcmp(inputs.layer(nlayer).ip(77).set(l1),'Gaussian') && strcmp(inputs.layer(nlayer).ip(76).set(l1),'Gauss-Hermite')
       [hxi,hwi]=Gauss_Hermite(inputs.layer(nlayer).ip(75).set(l1));
   elseif strcmp(inputs.layer(nlayer).ip(77).set(l1),'Gaussian') && strcmp(inputs.layer(nlayer).ip(76).set(l1),'Midpoint')
       Ebot=inputs.layer(nlayer).ip(16).set(l1,:)-inputs.layer(nlayer).ip(79).set(l1)*inputs.layer(nlayer).ip(74).set(l1,:);
       Etop=inputs.layer(nlayer).ip(16).set(l1,:)+inputs.layer(nlayer).ip(79).set(l1)*inputs.layer(nlayer).ip(74).set(l1,:);
       rne=inputs.layer(nlayer).ip(75).set(l1);
       delE=(Etop-Ebot)/rne;
       ret(1,:)=Ebot(1):delE(1):Etop(1);
       ret(2,:)=Ebot(2):delE(2):Etop(2);
       mei(:,1:rne)=0.5*(ret(:,1:rne)+ret(:,2:rne+1));
   elseif strcmp(inputs.layer(nlayer).ip(77).set(l1),'uniform') && strcmp(inputs.layer(nlayer).ip(76).set(l1),'Midpoint')
       Ebot=inputs.layer(nlayer).ip(16).set(l1,:)-inputs.layer(nlayer).ip(78).set(l1,:);
       Etop=inputs.layer(nlayer).ip(16).set(l1,:)+inputs.layer(nlayer).ip(78).set(l1,:);
       rne=inputs.layer(nlayer).ip(75).set(l1);
       delE=(Etop-Ebot)/rne;
       ret(1,:)=Ebot(1):delE(1):Etop(1);
       ret(2,:)=Ebot(2):delE(2):Etop(2);
       mei(:,1:rne)=0.5*(ret(:,1:rne)+ret(:,2:rne+1));
   elseif strcmp(inputs.layer(nlayer).ip(77).set(l1),'discrete')
       % nothing to do
   else
       error('a_rcustom.m: this should not happen')
   end
   
   for l2=1:inputs.layer(nlayer).ip(75).set(l1)
     numshr=numshr+1;
     dev.semi(matno).shr_species(numshr)=l1;
     if strcmp(inputs.layer(nlayer).ip(77).set(l1),'discrete')
         dev.semi(matno).shrdist(numshr)={'discrete'};
         dev.semi(matno).et(numshr,:)=inputs.layer(nlayer).ip(16).set(l1,:)+sign(inputs.layer(nlayer).ip(73).set(l1)).*log(abs(inputs.layer(nlayer).ip(73).set(l1))');
         dev.semi(matno).taup(numshr,:)=inputs.layer(nlayer).ip(17).set(l1,:);
         dev.semi(matno).taun(numshr,:)=inputs.layer(nlayer).ip(18).set(l1,:);
     elseif strcmp(inputs.layer(nlayer).ip(77).set(l1),'Gaussian')
         dev.semi(matno).shrdist{numshr}='Gaussian';
         if strcmp(inputs.layer(nlayer).ip(76).set(l1),'Gauss-Hermite')
             zzi=2*hwi(l2)*exp(-hxi(l2)^2)/sqrt(2*pi);
             Ett=inputs.layer(nlayer).ip(16).set(l1,:)+sign(inputs.layer(nlayer).ip(73).set(l1)).*log(abs(inputs.layer(nlayer).ip(73).set(l1))');
             dev.semi(matno).et(numshr,:)=Ett+sqrt(2)*inputs.layer(nlayer).ip(74).set(l1)*hxi(l2);
             dev.semi(matno).taup(numshr,:)=inputs.layer(nlayer).ip(17).set(l1,:)/zzi;
             dev.semi(matno).taun(numshr,:)=inputs.layer(nlayer).ip(18).set(l1,:)/zzi;
         elseif strcmp(inputs.layer(nlayer).ip(76).set(kk),'Midpoint')
             zxi=delE.*exp(-(mei(:,l2)').^2/2/inputs.layer(nlayer).ip(74).set(l1)^2)./sqrt(2*pi)/inputs.layer(nlayer).ip(74).set(l1);
             dev.semi(matno).et(numshr,:)=mei(:,l2)+sign(inputs.layer(nlayer).ip(73).set(l1)).*log(abs(inputs.layer(nlayer).ip(73).set(l1))');
             dev.semi(matno).taup(numshr,:)=inputs.layer(nlayer).ip(17).set(l1,:)./zxi;
             dev.semi(matno).taun(numshr,:)=inputs.layer(nlayer).ip(18).set(l1,:)./zxi;                
         else
             error('a_rcustom.m: integration method not implemented')
         end
     elseif strcmp(inputs.layer(nlayer).ip(77).set(l1),'uniform') % Midpoint integration
         dev.semi(matno).shrdist{numshr}='uniform';
         dev.semi(matno).et(numshr,:)=mei(:,l2)+sign(inputs.layer(nlayer).ip(73).set(l1)).*log(abs(inputs.layer(nlayer).ip(73).set(l1))');
         dev.semi(matno).taup(numshr,:)=inputs.layer(nlayer).ip(17).set(l1,:).*(Etop-Ebot)./delE;
         dev.semi(matno).taun(numshr,:)=inputs.layer(nlayer).ip(18).set(l1,:).*(Etop-Ebot)./delE;
     else
         error('a_rcustom.m: distribution type not implemented')
     end
   end
end
dev.semi(matno).numshr=numshr;

%----------------------------------------------------------------------
% amphoteric (mv3)

nmv3=size(inputs.layer(nlayer).ip(33).set,1);
for kk=1:nmv3 % check for valid inputs
   switch char(inputs.layer(nlayer).ip(89).set(kk)) % distribution.mv3
       case 'discrete'
           if inputs.layer(nlayer).ip(87).set(kk) ~= -1
               error('a_rcustom.m: nint.mv3 must = -1 (not used)')
           else
               inputs.layer(nlayer).ip(87).set(kk)=1; % set to one for calculations
           end
           if inputs.layer(nlayer).ip(86).set(kk) ~= 0
               error('a_rcustom.m: sigma.mv3 must = 0 for discrete trap')
           end
           if strcmp(inputs.layer(nlayer).ip(88).set(kk),'none') == 0
               error('a_rcustom.m: int_method.mv3 must = ''none'' for discrete trap')
           end
       case 'Gaussian'
           if inputs.layer(nlayer).ip(86).set(kk) == 0
               error('a_rcustom.m: sigma.mv3 must > 0 for Gaussian trap distribution')
           end
           if inputs.layer(nlayer).ip(88).default_used
               inputs.layer(nlayer).ip(88).set(kk)={'Gauss-Hermite'};
               if inputs.layer(nlayer).ip(87).default_used
                   inputs.layer(nlayer).ip(87).set(kk)=15; % default value
               end
           else
               if strcmp(inputs.layer(nlayer).ip(88).set(kk),'Gauss-Hermite')
                   if inputs.layer(nlayer).ip(87).default_used
                       inputs.layer(nlayer).ip(87).set(kk)=15; % default value
                   end
               elseif strcmp(inputs.layer(nlayer).ip(88).set(kk),'Midpoint')
                   if inputs.layer(nlayer).ip(87).default_used
                       inputs.layer(nlayer).ip(87).set(kk)=20; % default value
                   end
               end
           end
           if strcmp(inputs.layer(nlayer).ip(88).set(kk),'none') % int_method.slt
              error('a_rcustom.m: int_method.mv3 must = ''Gauss-Hermite'' or ''Midpoint'' for Gaussian distribution')
           end
           if inputs.layer(nlayer).ip(87).set(kk) < 2 && strcmp(inputs.layer(nlayer).ip(88).set(kk),'Gauss-Hermite')
               error('a_rcustom.m: nint.mv3 must be >= 2 for ''Gauss-Hermite'' integration')
           end
           if inputs.layer(nlayer).ip(87).set(kk) < 1 && strcmp(inputs.layer(nlayer).ip(88).set(kk),'Midpoint')
               error('a_rcustom.m: nint.mv3 must be >= 1 for ''Midpoint'' integration')
           end
       case 'uniform'
           if inputs.layer(nlayer).ip(86).set(kk) ~= 0
               error('a_rcustom.m: sigma.mv3 not used for uniform trap distribution')
           end
           if inputs.layer(nlayer).ip(88).default_used
               inputs.layer(nlayer).ip(88).set(kk)={'Midpoint'};
               if inputs.layer(nlayer).ip(87).default_used
                   inputs.layer(nlayer).ip(87).set(kk)=20; % default value
               end
           end
           if strcmp(inputs.layer(nlayer).ip(88).set(kk),'none') || strcmp(inputs.layer(nlayer).ip(88).set(kk),'Gauss-Hermite')
              error('a_rcustom.m: int_method.mv3 must = ''Midpoint'' for uniform trap distribution')
           end
           if inputs.layer(nlayer).ip(87).set(kk) < 1
               error('a_rcustom.m: nint.mv3 must be >= 1')
           end
           if inputs.layer(nlayer).ip(90).set(kk,1) < eps || inputs.layer(nlayer).ip(90).set(kk,2) < eps
               error('a_rcustom.m: half_range.mv3 must be >= eps')
           end
   end
end
 
nummv3=0; % multiple mv3 centers
for l1=1:size(inputs.layer(nlayer).ip(41).set,1) 
   if strcmp(inputs.layer(nlayer).ip(89).set(l1),'Gaussian') && strcmp(inputs.layer(nlayer).ip(88).set(l1),'Gauss-Hermite')
       [hxi,hwi]=Gauss_Hermite(inputs.layer(nlayer).ip(81).set(l1));
   elseif strcmp(inputs.layer(nlayer).ip(89).set(l1),'Gaussian') && strcmp(inputs.layer(nlayer).ip(88).set(l1),'Midpoint')
       Ebotp=inputs.layer(nlayer).ip(42).set(l1,:)-inputs.layer(nlayer).ip(91).set(l1)*inputs.layer(nlayer).ip(86).set(l1,:);
       Etopp=inputs.layer(nlayer).ip(42).set(l1,:)+inputs.layer(nlayer).ip(91).set(l1)*inputs.layer(nlayer).ip(86).set(l1,:);
       Ebotm=inputs.layer(nlayer).ip(43).set(l1,:)-inputs.layer(nlayer).ip(91).set(l1)*inputs.layer(nlayer).ip(86).set(l1,:);
       Etopm=inputs.layer(nlayer).ip(43).set(l1,:)+inputs.layer(nlayer).ip(91).set(l1)*inputs.layer(nlayer).ip(86).set(l1,:);
       rne=inputs.layer(nlayer).ip(87).set(l1);
       delEp=(Etopp-Ebotp)/rne;
       delEn=(Etopn-Ebotn)/rne;
       retp(1,:)=Ebotp(1):delEp(1):Etopp(1);
       retp(2,:)=Ebotp(2):delEp(2):Etopp(2);
       retn(1,:)=Ebotn(1):delEn(1):Etopn(1);
       retp(2,:)=Ebotn(2):delEn(2):Etopn(2);
       meinputs.layer(nlayer).ip(:,1:rne)=0.5*(retp(:,1:rne)+retp(:,2:rne+1));
       mein(:,1:rne)=0.5*(retn(:,1:rne)+retn(:,2:rne+1));
   elseif strcmp(inputs.layer(nlayer).ip(89).set(l1),'uniform') && strcmp(inputs.layer(nlayer).ip(88).set(l1),'Midpoint')
       Ebotp=inputs.layer(nlayer).ip(42).set(l1,:)-inputs.layer(nlayer).ip(90).set(l1,:);
       Etopp=inputs.layer(nlayer).ip(42).set(l1,:)+inputs.layer(nlayer).ip(90).set(l1,:);
       Ebotn=inputs.layer(nlayer).ip(43).set(l1,:)-inputs.layer(nlayer).ip(90).set(l1,:);
       Etopn=inputs.layer(nlayer).ip(43).set(l1,:)+inputs.layer(nlayer).ip(90).set(l1,:);
       rne=inputs.layer(nlayer).ip(87).set(l1);
       delEp=(Etopp-Ebotp)/rne;
       delEn=(Etopn-Ebotn)/rne;
       retp(1,:)=Ebotp(1):delEp(1):Etopp(1);
       retp(2,:)=Ebotp(2):delEp(2):Etopp(2);
       retn(1,:)=Ebotn(1):delEn(1):Etopn(1);
       retp(2,:)=Ebotn(2):delEn(2):Etopn(2);
       meinputs.layer(nlayer).ip(:,1:rne)=0.5*(retp(:,1:rne)+retp(:,2:rne+1));
       mein(:,1:rne)=0.5*(retn(:,1:rne)+retn(:,2:rne+1));
   elseif strcmp(inputs.layer(nlayer).ip(89).set(l1),'discrete')
       % nothing to do
   else
       error('a_rcustom.m: this should not happen')
   end
   for l2=1:inputs.layer(nlayer).ip(87).set(l1)
     nummv3=nummv3+1;
     dev.semi(matno).slt_species(nummv3)=l1;
     if strcmp(inputs.layer(nlayer).ip(89).set(l1),'discrete')
         dev.semi(matno).sltdist(nummv3)={'discrete'};
         dev.semi(matno).Nmv3(nummv3,:)=inputs.layer(nlayer).ip(41).set(l1,:);
         dev.semi(matno).Etp3(nummv3,:)=inputs.layer(nlayer).ip(42).set(l1,:);
         dev.semi(matno).Etm3(nummv3,:)=inputs.layer(nlayer).ip(43).set(l1,:);
         dev.semi(matno).cpp3(nummv3,:)=inputs.layer(nlayer).ip(44).set(l1,:);
         dev.semi(matno).cnp3(nummv3,:)=inputs.layer(nlayer).ip(45).set(l1,:);
         dev.semi(matno).cpm3(nummv3,:)=inputs.layer(nlayer).ip(46).set(l1,:);
         dev.semi(matno).cnm3(nummv3,:)=inputs.layer(nlayer).ip(47).set(l1,:);
     elseif strcmp(inputs.layer(nlayer).ip(89).set(l1),'Gaussian')
         dev.semi(matno).sltdist{nummv3}='Gaussian';
         if strcmp(inputs.layer(nlayer).ip(88).set(l1),'Gauss-Hermite')
             zzi=2*hwi(l2)*exp(-hxi(l2)^2)/sqrt(2*pi);
             dev.semi(matno).Nmv3(nummv3,:)=inputs.layer(nlayer).ip(41).set(l1,:).*zzi;
             dev.semi(matno).Etp3(nummv3,:)=inputs.layer(nlayer).ip(42).set(l1,:)+sqrt(2)*inputs.layer(nlayer).ip(86).set(l1)*hxi(l2);
             dev.semi(matno).Etm3(nummv3,:)=inputs.layer(nlayer).ip(43).set(l1,:)+sqrt(2)*inputs.layer(nlayer).ip(86).set(l1)*hxi(l2);
             dev.semi(matno).cpp3(nummv3,:)=inputs.layer(nlayer).ip(44).set(l1,:);
             dev.semi(matno).cnp3(nummv3,:)=inputs.layer(nlayer).ip(45).set(l1,:);
             dev.semi(matno).cpm3(nummv3,:)=inputs.layer(nlayer).ip(46).set(l1,:);
             dev.semi(matno).cnm3(nummv3,:)=inputs.layer(nlayer).ip(47).set(l1,:);
         elseif strcmp(inputs.layer(nlayer).ip(88).set(kk),'Midpoint')
             zxi=delE.*exp(-(mei(:,l2)').^2/2/inputs.layer(nlayer).ip(80).set(l1)^2)./sqrt(2*pi)/inputs.layer(nlayer).ip(74).set(l1);
             dev.semi(matno).Nmv3(nummv3,:)=inputs.layer(nlayer).ip(41).set(l1,:).*zxi;
             dev.semi(matno).Etp3(nummv3,:)=meinputs.layer(nlayer).ip(:,l2);
             dev.semi(matno).Etm3(nummv3,:)=mein(:,l2);
             dev.semi(matno).cpp3(nummv3,:)=inputs.layer(nlayer).ip(44).set(l1,:);
             dev.semi(matno).cnp3(nummv3,:)=inputs.layer(nlayer).ip(45).set(l1,:);
             dev.semi(matno).cpm3(nummv3,:)=inputs.layer(nlayer).ip(46).set(l1,:);
             dev.semi(matno).cnm3(nummv3,:)=inputs.layer(nlayer).ip(47).set(l1,:);               
         else
             error('a_rcustom.m: integration method not implemented')
         end
     elseif strcmp(inputs.layer(nlayer).ip(89).set(l1),'uniform') % Midpoint integration
         dev.semi(matno).sltdist{nummv3}='uniform';
         dev.semi(matno).Nmv3(nummv3,:)=inputs.layer(nlayer).ip(41).set(l1,:).*delEp./(Etopp-Ebotp);
         dev.semi(matno).Etp3(nummv3,:)=meinputs.layer(nlayer).ip(:,l2);
         dev.semi(matno).Etm3(nummv3,:)=mein(:,l2);
         dev.semi(matno).cpp3(nummv3,:)=inputs.layer(nlayer).ip(44).set(l1,:);
         dev.semi(matno).cnp3(nummv3,:)=inputs.layer(nlayer).ip(45).set(l1,:);
         dev.semi(matno).cpm3(nummv3,:)=inputs.layer(nlayer).ip(46).set(l1,:);
         dev.semi(matno).cnm3(nummv3,:)=inputs.layer(nlayer).ip(47).set(l1,:);
     else
         error('a_rcustom.m: distribution type not implemented')
     end
   end
end
dev.semi(matno).nummv3=nummv3;

%--------------------------------------------------------------------------
% slt recombination

%set cp.slt and cn.slt
if inputs.layer(nlayer).ip(37).default_used == 1
    inputs.layer(nlayer).ip(37).set=[1e-14 1e-14];
    inputs.layer(nlayer).ip(37).default=[1e-14 1e-14];
end
if inputs.layer(nlayer).ip(38).default_used == 1
    inputs.layer(nlayer).ip(38).set=[1e-14 1e-14];
    inputs.layer(nlayer).ip(38).default=[1e-14 1e-14];
end

if inputs.layer(nlayer).ip(39).default_used == 0 && inputs.layer(nlayer).ip(37).default_used == 1
    inputs.layer(nlayer).ip(37).set=1./inputs.layer(nlayer).ip(39).set./dev.semi(matno).vthp./inputs.layer(nlayer).ip(33).set; %cp
elseif inputs.layer(nlayer).ip(39).default_used == 0 && inputs.layer(nlayer).ip(37).default_used == 0
    error('a_rcustom.m: cannot set both taup.slt and cp.slt')
end
if inputs.layer(nlayer).ip(40).default_used == 0 && inputs.layer(nlayer).ip(38).default_used == 1
    inputs.layer(nlayer).ip(38).set=1./inputs.layer(nlayer).ip(40).set./dev.semi(matno).vthn./inputs.layer(nlayer).ip(33).set; %cn
elseif inputs.layer(nlayer).ip(40).default_used == 0 && inputs.layer(nlayer).ip(38).default_used == 0
    error('a_rcustom.m: cannot set both taup.slt and cp.slt')
end

nslt=size(inputs.layer(nlayer).ip(33).set,1);
for kk=1:nslt % check for valid inputs
   if inputs.layer(nlayer).ip(33).set(kk,1) > 0 || inputs.layer(nlayer).ip(33).set(kk,1) > 0
       if strcmp(inputs.layer(nlayer).ip(34).set(kk),'off')
           error('a_rcustom.m: slt trap type must be set to donor or acceptor')
       end
   end
   switch char(inputs.layer(nlayer).ip(83).set(kk)) % distribution.slt
       case 'discrete'
           if inputs.layer(nlayer).ip(81).set(kk) ~= -1
               error('a_rcustom.m: nint.slt must = -1 (not used)')
           else
               inputs.layer(nlayer).ip(81).set(kk)=1; % set to one for calculations
           end
           if inputs.layer(nlayer).ip(80).set(kk) ~= 0
               error('a_rcustom.m: sigma.slt must = 0 for discrete trap')
           end
           if strcmp(inputs.layer(nlayer).ip(82).set(kk),'none') == 0
               error('a_rcustom.m: int_method.slt must = ''none'' for discrete trap')
           end
       case 'Gaussian'
           if inputs.layer(nlayer).ip(80).set(kk) == 0
               error('a_rcustom.m: sigma.slt must > 0 for Gaussian trap distribution')
           end
           if inputs.layer(nlayer).ip(82).default_used
               inputs.layer(nlayer).ip(82).set(kk)={'Gauss-Hermite'};
               if inputs.layer(nlayer).ip(81).default_used
                   inputs.layer(nlayer).ip(81).set(kk)=15; % default value
               end
           else
               if strcmp(inputs.layer(nlayer).ip(82).set(kk),'Gauss-Hermite')
                   if inputs.layer(nlayer).ip(81).default_used
                       inputs.layer(nlayer).ip(81).set(kk)=15; % default value
                   end
               elseif strcmp(inputs.layer(nlayer).ip(82).set(kk),'Midpoint')
                   if inputs.layer(nlayer).ip(81).default_used
                       inputs.layer(nlayer).ip(81).set(kk)=20; % default value
                   end
               end
           end
           if strcmp(inputs.layer(nlayer).ip(82).set(kk),'none') % int_method.slt
              error('a_rcustom.m: int_method.slt must = ''Gauss-Hermite'' or ''Midpoint'' for Gaussian distribution')
           end
           if inputs.layer(nlayer).ip(81).set(kk) < 2 && strcmp(inputs.layer(nlayer).ip(82).set(kk),'Gauss-Hermite')
               error('a_rcustom.m: nint.slt must be >= 2 for ''Gauss-Hermite'' integration')
           end
           if inputs.layer(nlayer).ip(81).set(kk) < 1 && strcmp(inputs.layer(nlayer).ip(82).set(kk),'Midpoint')
               error('a_rcustom.m: nint.slt must be >= 1 for ''Midpoint'' integration')
           end
       case 'uniform'
           if inputs.layer(nlayer).ip(80).set(kk) ~= 0
               error('a_rcustom.m: sigma.slt not used for uniform trap distribution')
           end
           if inputs.layer(nlayer).ip(82).default_used
               inputs.layer(nlayer).ip(82).set(kk)={'Midpoint'};
               if inputs.layer(nlayer).ip(81).default_used
                   inputs.layer(nlayer).ip(81).set(kk)=20; % default value
               end
           end
           if strcmp(inputs.layer(nlayer).ip(82).set(kk),'none') || strcmp(inputs.layer(nlayer).ip(82).set(kk),'Gauss-Hermite')
              error('a_rcustom.m: int_method.slt must = ''Midpoint'' for uniform trap distribution')
           end
           if inputs.layer(nlayer).ip(81).set(kk) < 1
               error('a_rcustom.m: nint.slt must be >= 1')
           end
           if inputs.layer(nlayer).ip(84).set(kk,1) < eps || inputs.layer(nlayer).ip(84).set(kk,2) < eps
               error('a_rcustom.m: half_range.slt must be >= eps')
           end
   end
end
 
numslt=0; % multiple slt centers
for l1=1:size(inputs.layer(nlayer).ip(33).set,1) 
   if strcmp(inputs.layer(nlayer).ip(83).set(l1),'Gaussian') && strcmp(inputs.layer(nlayer).ip(82).set(l1),'Gauss-Hermite')
       [hxi,hwi]=Gauss_Hermite(inputs.layer(nlayer).ip(81).set(l1));
   elseif strcmp(inputs.layer(nlayer).ip(83).set(l1),'Gaussian') && strcmp(inputs.layer(nlayer).ip(82).set(l1),'Midpoint')
%            Ebot=-rEg/2-dev.const.kb*dev.T/2*log(rNv./rNc);
%            Etop=Ebot+rEg;
       Ebot=inputs.layer(nlayer).ip(35).set(l1,:)-inputs.layer(nlayer).ip(85).set(l1)*inputs.layer(nlayer).ip(80).set(l1,:);
       Etop=inputs.layer(nlayer).ip(35).set(l1,:)+inputs.layer(nlayer).ip(85).set(l1)*inputs.layer(nlayer).ip(80).set(l1,:);
       rne=inputs.layer(nlayer).ip(81).set(l1);
       delE=(Etop-Ebot)/rne;
       ret(1,:)=Ebot(1):delE(1):Etop(1);
       ret(2,:)=Ebot(2):delE(2):Etop(2);
       mei(:,1:rne)=0.5*(ret(:,1:rne)+ret(:,2:rne+1));
   elseif strcmp(inputs.layer(nlayer).ip(83).set(l1),'uniform') && strcmp(inputs.layer(nlayer).ip(82).set(l1),'Midpoint')
       Ebot=inputs.layer(nlayer).ip(35).set(l1,:)-inputs.layer(nlayer).ip(84).set(l1,:);
       Etop=inputs.layer(nlayer).ip(35).set(l1,:)+inputs.layer(nlayer).ip(84).set(l1,:);
       rne=inputs.layer(nlayer).ip(81).set(l1);
       delE=(Etop-Ebot)/rne;
       ret(1,:)=Ebot(1):delE(1):Etop(1);
       ret(2,:)=Ebot(2):delE(2):Etop(2);
       mei(:,1:rne)=0.5*(ret(:,1:rne)+ret(:,2:rne+1));
   elseif strcmp(inputs.layer(nlayer).ip(83).set(l1),'discrete')
       % nothing to do
   else
       error('a_rcustom.m: this should not happen')
   end
   for l2=1:inputs.layer(nlayer).ip(81).set(l1)
     numslt=numslt+1;
     dev.semi(matno).slt_species(numslt)=l1;
     if strcmp(inputs.layer(nlayer).ip(83).set(l1),'discrete')
         dev.semi(matno).sltdist(numslt)={'discrete'};
         dev.semi(matno).Nslt(numslt,:)=inputs.layer(nlayer).ip(33).set(l1,:);
         dev.semi(matno).slt_type{numslt}=inputs.layer(nlayer).ip(34).set{l1};
         dev.semi(matno).Etslt(numslt,:)=inputs.layer(nlayer).ip(35).set(l1,:);
         dev.semi(matno).gslt(numslt,:)=inputs.layer(nlayer).ip(36).set(l1);
         dev.semi(matno).cpslt(numslt,:)=inputs.layer(nlayer).ip(37).set(l1,:);
         dev.semi(matno).cnslt(numslt,:)=inputs.layer(nlayer).ip(38).set(l1,:);
     elseif strcmp(inputs.layer(nlayer).ip(83).set(l1),'Gaussian')
         dev.semi(matno).sltdist{numslt}='Gaussian';
         if strcmp(inputs.layer(nlayer).ip(82).set(l1),'Gauss-Hermite')
             zzi=2*hwi(l2)*exp(-hxi(l2)^2)/sqrt(2*pi);
             dev.semi(matno).Nslt(numslt,:)=inputs.layer(nlayer).ip(33).set(l1,:).*zzi;
             dev.semi(matno).slt_type{numslt}=inputs.layer(nlayer).ip(34).set{l1};
             dev.semi(matno).Etslt(numslt,:)=inputs.layer(nlayer).ip(35).set(l1,:)+sqrt(2)*inputs.layer(nlayer).ip(80).set(l1)*hxi(l2);
             dev.semi(matno).gslt(numslt,:)=inputs.layer(nlayer).ip(36).set(l1);
             dev.semi(matno).cpslt(numslt,:)=inputs.layer(nlayer).ip(37).set(l1,:);
             dev.semi(matno).cnslt(numslt,:)=inputs.layer(nlayer).ip(38).set(l1,:);
         elseif strcmp(inputs.layer(nlayer).ip(82).set(kk),'Midpoint')
             zxi=delE.*exp(-(mei(:,l2)').^2/2/inputs.layer(nlayer).ip(80).set(l1)^2)./sqrt(2*pi)/inputs.layer(nlayer).ip(74).set(l1);
             dev.semi(matno).Nslt(numslt,:)=inputs.layer(nlayer).ip(33).set(l1,:).*zxi;
             dev.semi(matno).slt_type{numslt}=inputs.layer(nlayer).ip(34).set{l1};
             dev.semi(matno).Etslt(numslt,:)=mei(:,l2);
             dev.semi(matno).gslt(numslt,:)=inputs.layer(nlayer).ip(36).set(l1);
             dev.semi(matno).cpslt(numslt,:)=inputs.layer(nlayer).ip(37).set(l1,:);
             dev.semi(matno).cnslt(numslt,:)=inputs.layer(nlayer).ip(38).set(l1,:);                
         else
             error('a_rcustom.m: integration method not implemented')
         end
     elseif strcmp(inputs.layer(nlayer).ip(83).set(l1),'uniform') % Midpoint integration
         dev.semi(matno).sltdist{numslt}='uniform';
         dev.semi(matno).Nslt(numslt,:)=inputs.layer(nlayer).ip(33).set(l1,:).*delE./(Etop-Ebot);
         dev.semi(matno).slt_type{numslt}=inputs.layer(nlayer).ip(34).set{l1};
         dev.semi(matno).Etslt(numslt,:)=mei(:,l2);
         dev.semi(matno).gslt(numslt,:)=inputs.layer(nlayer).ip(36).set(l1);
         dev.semi(matno).cpslt(numslt,:)=inputs.layer(nlayer).ip(37).set(l1,:);
         dev.semi(matno).cnslt(numslt,:)=inputs.layer(nlayer).ip(38).set(l1,:);
     else
         error('a_rcustom.m: distribution type not implemented')
     end
   end
end
dev.semi(matno).numslt=numslt;

%--------------------------------------------------------------------------
% band tails
dev.semi(matno).btail=char(inputs.layer(nlayer).ip(58).set{1});
dev.semi(matno).nbtquad=0;
if strcmp(dev.semi(matno).btail,'on')
    if inputs.layer(nlayer).ip(63).set(1,1) < 0 || inputs.layer(nlayer).ip(63).set(1,2) < 0
        dev.semi(matno).gvbt=2*pi*dev.semi(matno).nv/(CONST.kb*dev.T*pi)^1.5*sqrt(CONST.kb*dev.T);
    else
        dev.semi(matno).gvbt=inputs.layer(nlayer).ip(63).set;
    end
    if inputs.layer(nlayer).ip(64).set(1,1) < 0 || inputs.layer(nlayer).ip(64).set(1,2) < 0
        dev.semi(matno).gcbt=2*pi*dev.semi(matno).nc/(CONST.kb*dev.T*pi)^1.5*sqrt(CONST.kb*dev.T);
    else
        dev.semi(matno).gcbt=inputs.layer(nlayer).ip(64).set;
    end
    dev.semi(matno).ktvb=inputs.layer(nlayer).ip(59).set; % ktv.bt
    dev.semi(matno).ktcb=inputs.layer(nlayer).ip(60).set; % ktc.bt
    dev.semi(matno).dEvb=inputs.layer(nlayer).ip(61).set; % dEv.bt
    dev.semi(matno).dEcb=inputs.layer(nlayer).ip(62).set; % dEc.bt
    if dev.semi(matno).dEvb(1) > 0 ||...
       dev.semi(matno).dEvb(2) > 0 ||...
       dev.semi(matno).dEvb(1) > 0 ||...
       dev.semi(matno).dEvb(2) > 0
           error('dEv.bt, dEc.bt ~= 0 not implemented')
    end
    dev.semi(matno).cpvb=inputs.layer(nlayer).ip(65).set; % cpv.bt
    dev.semi(matno).cnvb=inputs.layer(nlayer).ip(66).set; % cnv.bt
    dev.semi(matno).cpcb=inputs.layer(nlayer).ip(67).set; % cpc.bt
    dev.semi(matno).cncb=inputs.layer(nlayer).ip(68).set; % cnc.bt
    dev.semi(matno).nbtquad=inputs.layer(nlayer).ip(69).set; % nlaguerre.bt
    dev.semi(matno).btstep=inputs.layer(nlayer).ip(70).set; % maxEstep.bt
    dev.semi(matno).gdb=inputs.layer(nlayer).ip(71).set; % gd.bt
    dev.semi(matno).gab=inputs.layer(nlayer).ip(72).set; % ga.bt
    nbtquad=dev.semi(matno).nbtquad;
    [lxi,lwi,~]=Gauss_Laguerre(nbtquad);
    % valence band tails [donor-like; effective density, effective trap energies wrt Ec, Eteff=Ec-Et] 
    dev.semi(matno).Nvbt_eff(1:nbtquad,1)=dev.semi(matno).ktvb(1).*dev.semi(matno).gvbt(1)*lwi';
    dev.semi(matno).Nvbt_eff(1:nbtquad,2)=dev.semi(matno).ktvb(2).*dev.semi(matno).gvbt(2)*lwi';
    dev.semi(matno).etvbt_eff(1:nbtquad,1)=dev.semi(matno).eg(1)-dev.semi(matno).ktvb(1)*lxi';
    dev.semi(matno).etvbt_eff(1:nbtquad,2)=dev.semi(matno).eg(2)-dev.semi(matno).ktvb(2)*lxi';
    % conduction band tails [acceptor-like; effective density, effective trap energies wrt Ev, Eteff=Et-Ev]
    dev.semi(matno).Ncbt_eff(1:nbtquad,1)=dev.semi(matno).ktcb(1).*dev.semi(matno).gcbt(1)*lwi';
    dev.semi(matno).Ncbt_eff(1:nbtquad,2)=dev.semi(matno).ktcb(2).*dev.semi(matno).gcbt(2)*lwi';
    dev.semi(matno).etcbt_eff(1:nbtquad,1)=dev.semi(matno).eg(1)-dev.semi(matno).ktcb(1)*lxi';
    dev.semi(matno).etcbt_eff(1:nbtquad,2)=dev.semi(matno).eg(2)-dev.semi(matno).ktcb(2)*lxi';
elseif inputs.layer(nlayer).ip(58).default_used == 0
    if VERBOSE; fprintf('CAUTION: btail explicitly turned off, so band tail parameters are not used.\n'); end
else
    if inputs.layer(nlayer).ip(59).default_used == 0 || inputs.layer(nlayer).ip(60).default_used == 0 || inputs.layer(nlayer).ip(61).default_used == 0 || ...
       inputs.layer(nlayer).ip(62).default_used == 0 || inputs.layer(nlayer).ip(63).default_used == 0 || inputs.layer(nlayer).ip(64).default_used == 0 || ...
       inputs.layer(nlayer).ip(65).default_used == 0 || inputs.layer(nlayer).ip(66).default_used == 0 || inputs.layer(nlayer).ip(67).default_used == 0 || ...
       inputs.layer(nlayer).ip(68).default_used == 0 || inputs.layer(nlayer).ip(69).default_used == 0 || inputs.layer(nlayer).ip(70).default_used == 0 || ...
       inputs.layer(nlayer).ip(71).default_used == 0 || inputs.layer(nlayer).ip(72).default_used == 0
       error('Band tail parameters set, but btail=''off''')
    end
end

%--------------------------------------------------------------------------
% absortion coeff info
dev.semi(matno).alpha_model=char(inputs.layer(nlayer).ip(22).set{1});
if strcmp(dev.semi(matno).alpha_model,'none') || strcmp(dev.semi(matno).alpha_model,'simple')
    if size(inputs.layer(nlayer).ip(48).set,1) == size(inputs.layer(nlayer).ip(49).set,1) &&...
        size(inputs.layer(nlayer).ip(48).set,1) == size(inputs.layer(nlayer).ip(50).set,1) &&...
        size(inputs.layer(nlayer).ip(48).set,1) == size(inputs.layer(nlayer).ip(51).set,1)
        dev.Optical.opt_abs_model(nlayer).A1=inputs.layer(nlayer).ip(49).set;
        dev.Optical.opt_abs_model(nlayer).A2=inputs.layer(nlayer).ip(50).set;
        dev.Optical.opt_abs_model(nlayer).A3=inputs.layer(nlayer).ip(51).set;
        dev.Optical.opt_abs_model(nlayer).numalf=size(inputs.layer(nlayer).ip(48).set,1);
    else
       error('--- size of Eg.opt, A1, A2, A3 must be the same\n')
    end    
    dev.Optical.opt_abs_model(nlayer).alpha_model=dev.semi(matno).alpha_model;
    dev.Optical.opt_abs_model(nlayer).Eg=inputs.layer(nlayer).ip(48).set;
    for kr=1:size(inputs.layer(nlayer).ip(48).set,1)
        for kc=1:size(inputs.layer(nlayer).ip(48).set,2)
            if dev.Optical.opt_abs_model(nlayer).Eg(kr,kc) < 0
                dev.Optical.opt_abs_model(nlayer).Eg=dev.semi(matno).eg;
            end
            if strcmp(dev.Optical.opt_abs_model(nlayer).alpha_model,'none') && dev.Optical.opt_abs_model(nlayer).A1(kr,kc) > 0
                error('--- if alpha_model is ''none'', A1 must be zero\n')
            end
        end
    end
elseif strcmp(dev.semi(matno).alpha_model,'file')
     dev.Optical.opt_abs_model(nlayer).alpha_model=dev.semi(matno).alpha_model;
     alpha_file=char(inputs.layer(nlayer).ip(116).set{1});
     dev.Optical.opt_abs_model(nlayer).alpha_data=a_ralpha(alpha_file);
else
    error('absorption model not implemented')
end

%--------------------------------------------------------------------------
% parasitic absorption info
dev.semi(matno).alpha_fc=char(inputs.layer(nlayer).ip(52).set{1});
dev.Optical.opt_abs_model(nlayer).alpha_fc=dev.semi(matno).alpha_fc;
dev.Optical.opt_abs_model(nlayer).fcn=inputs.layer(nlayer).ip(53).set;
dev.Optical.opt_abs_model(nlayer).fcp=inputs.layer(nlayer).ip(54).set;
dev.Optical.opt_abs_model(nlayer).bn=inputs.layer(nlayer).ip(55).set;
dev.Optical.opt_abs_model(nlayer).bp=inputs.layer(nlayer).ip(56).set;
if strcmp(dev.Optical.opt_abs_model(nlayer).alpha_fc,'off')
    if dev.Optical.opt_abs_model(nlayer).fcn(1,1) > 0 || dev.Optical.opt_abs_model(nlayer).fcp(1,1) > 0 ||...
       dev.Optical.opt_abs_model(nlayer).fcn(1,2) > 0 || dev.Optical.opt_abs_model(nlayer).fcp(1,2) > 0
        error('--- if alpha_model is ''off'', FCn and FCp must be zero\n')
    end
end

dev.reg(nlayer).rip=inputs.layer(nlayer).ip;