function [values,derivs]=a_custom_semi(in,simp,ref,norm,fdflag,flag)
%
%
% ref is a data structure with the reference values
%
% norm is a data structure with the normalization factors
%
% simp is a data structure containing the model inputs
%

prof.minN=simp.minN;

zz.rdt=in.rdt;
zz.rdtold=in.rdtold;
zz.omega=in.omega;
p=in.p;
n=in.n;
E=in.E;
a=in.xt;
b=in.xb;
x=in.x;

num=length(x);

% keep track of ionized impurities for mobility model(s)
Nion(1:num)=0;
% keep track of total impurities for bulk lifetime model
Nimp(1:num)=0;

% initialize nt_'s
values.nt_Nd(1:simp.numd,1:num)=0;
values.nt_Na(1:simp.numa,1:num)=0;
values.nt_Nslt(1:simp.numslt,1:num)=0;
values.nt_Nvbt(1:simp.nbtquad,1:num)=0;
values.nt_Ncbt(1:simp.nbtquad,1:num)=0;
values.nt_Nmvp3(1:simp.nummv3,1:num)=0;
values.nt_Nmv03(1:simp.nummv3,1:num)=0;
values.nt_Nmvm3(1:simp.nummv3,1:num)=0;

if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    po=in.po;
    no=in.no;
end

% initialize cumulative quantities
Qt(1:num)=0;
Rp(1:num)=0;
Rn(1:num)=0;
if strcmp(flag,'eq') || strcmp(flag,'neq')
    dQtdp(1:num)=0;
    dQtdn(1:num)=0;
    dRpdp(1:num)=0;
    dRpdn(1:num)=0;
    dRndn(1:num)=0;
    dRndp(1:num)=0;
end

% band parameters
[dvp,ddvpdp]=a_vbfd(p,a_linear(x,a,b,simp.nv(1),simp.nv(2))/norm.n,fdflag,flag);
values.vp(1:num)=(ref.chi-a_linear(x,a,b,simp.chi(1),simp.chi(2)))/norm.v...
          -(a_linear(x,a,b,simp.eg(1),simp.eg(2))-ref.eg)/norm.v...
          +log(a_linear(x,a,b,simp.nv(1),simp.nv(2))/ref.nv)+dvp;
[dvn,ddvndn]=a_vbfd(n,a_linear(x,a,b,simp.nc(1),simp.nc(2))/norm.n,fdflag,flag);
values.vn(1:num)=(a_linear(x,a,b,simp.chi(1),simp.chi(2))-ref.chi)/norm.v...
          +log(a_linear(x,a,b,simp.nc(1),simp.nc(2))/ref.nc)+dvn;
if strcmp(flag,'eq') || strcmp(flag,'neq') || strcmp(flag,'band')
    derivs.dvpdp(1:num)=ddvpdp;
    derivs.dvndn(1:num)=ddvndn;
end
if strcmp(flag,'band'); return; end

% band stuff for plots
if strcmp(flag,'plot')
    values.chi=a_linear(x,a,b,simp.chi(1),simp.chi(2));
    values.Eg=a_linear(x,a,b,simp.eg(1),simp.eg(2));
    values.Nc=a_linear(x,a,b,simp.nc(1),simp.nc(2));
    values.Nv=a_linear(x,a,b,simp.nv(1),simp.nv(2));
end

% fully ionized donors
if strcmp(flag,'plot')
    values.Ndp(1:num)=0;
end
for jk=1:simp.numndp
    prof.kind=simp.prof_ndp(jk);
    prof.Co=simp.ndp(jk,1);
    prof.xt=a;
    prof.xb=b;
    prof.yt=simp.ndp(jk,1);
    prof.yb=simp.ndp(jk,2);
    try prof.dir=simp.dir_ndp(jk); catch; end
    try prof.xo=simp.xo_ndp(jk); catch; end
    try prof.Dt=simp.Dt_ndp(jk); catch; end
    try prof.sigma=simp.sigma_ndp(jk); catch; end
    try prof.L=simp.L_ndp(jk); catch; end
    Ndp=a_profile(x,prof);
    Nion=Nion+Ndp;
    Nimp=Nimp+Ndp;
    Qt=Qt+Ndp/norm.n;
    if strcmp(flag,'plot')
        values.Ndp=values.Ndp+Ndp;
    end
end

% fully ionized acceptors
if strcmp(flag,'plot')
    values.Nam(1:num)=0;
end
for jk=1:simp.numnam
    prof.kind=simp.prof_nam(jk);
    prof.Co=simp.nam(jk,1);
    prof.xt=a;
    prof.xb=b;
    prof.yt=simp.nam(jk,1);
    prof.yb=simp.nam(jk,2);
    try prof.dir=simp.dir_nam(jk); catch; end
    try prof.xo=simp.xo_nam(jk); catch; end
    try prof.Dt=simp.Dt_nam(jk); catch; end
    try prof.sigma=simp.sigma_nam(jk); catch; end
    try prof.L=simp.L_nam(jk); catch; end
    Nam=a_profile(x,prof);
    Nion=Nion+Nam;
    Nimp=Nimp+Nam;
    Qt=Qt-Nam/norm.n;
    if strcmp(flag,'plot')
        values.Nam=values.Nam+a_profile(x,prof);
    end
end

% stuff needed for calculations
if simp.nct(1) == inf || simp.nct(2) == inf
    zz.nct=inf;
else
    zz.nct=a_linear(x,a,b,simp.nct(1),simp.nct(2))/norm.n;
end
if simp.nvt(1) == inf || simp.nvt(2) == inf
    zz.nvt=inf;
else
    zz.nvt=a_linear(x,a,b,simp.nvt(1),simp.nvt(2))/norm.n;
end
zz.p=p;
zz.n=n;
if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    zz.po=po;
    zz.no=no;
end

zz.nc=a_linear(x,a,b,simp.nc(1),simp.nc(2))/norm.n;
zz.nv=a_linear(x,a,b,simp.nv(1),simp.nv(2))/norm.n;
zz.eg=a_linear(x,a,b,simp.eg(1),simp.eg(2))/norm.v;

% donor traps
if strcmp(flag,'plot')
    values.Ntd(1:num)=0;
    values.Qd(1:num)=0;
    values.Rpd(1:num)=0;
    values.Rnd(1:num)=0;
    values.Ndd(1:num)=0;
end
for jk=1:simp.numd
  if simp.Nd(jk,1) > 0 || simp.Nd(jk,2) > 0
    prof.kind=simp.prof_d(jk);
    prof.Co=simp.Nd(jk,1);
    prof.xt=a;
    prof.xb=b;
    prof.yt=simp.Nd(jk,1);
    prof.yb=simp.Nd(jk,2);
    try prof.dir=simp.dir_d(jk); catch; end
    try prof.xo=simp.xo_d(jk); catch; end
    try prof.Dt=simp.Dt_d(jk); catch; end
    try prof.sigma=simp.sigma_d(jk); catch; end
    try prof.L=simp.L_d(jk); catch; end
    zz.Nt=a_profile(x,prof)/norm.n;
    Nimp=Nimp+zz.Nt*norm.n;
    zz.et=a_linear(x,a,b,simp.Etd(jk,1),simp.Etd(jk,2))/norm.v+log(simp.gd(jk)); % Etd=Ec-Etrap
    zz.cp=a_linear(x,a,b,simp.cpd(jk,1),simp.cpd(jk,2))/norm.cap_area;
    zz.cn=a_linear(x,a,b,simp.cnd(jk,1),simp.cnd(jk,2))/norm.cap_area;
    zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
    zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s;
    try zz.nt_last(1,:)=in.oldntNd(jk,:);
        try zz.nt_last(2,:)=in.oldoldntNd(jk,:); end
    catch zz.nt_last=0; end;
    if strcmp(flag,'eq') || strcmp(flag,'neq')
        [vals ders]=slt_d(flag,fdflag,zz);
        values.nt_Nd(jk,:)=vals.nt;
        Qt=Qt+vals.qt;
        dQtdp=dQtdp+ders.dqtdp;
        dQtdn=dQtdn+ders.dqtdn;
        if strcmp(flag,'neq')
            Rp=Rp+vals.Rp;
            dRpdp=dRpdp+ders.dRpdp;
            dRpdn=dRpdn+ders.dRpdn;
            Rn=Rn+vals.Rn;
            dRndn=dRndn+ders.dRndn;
            dRndp=dRndp+ders.dRndp;
        end
    elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
        vals=slt_d(flag,fdflag,zz);
        values.nt_Nd(jk,:)=vals.nt;
        Qt=Qt+vals.qt;
        if strcmp(flag,'vals') || strcmp(flag,'plot')
            Rp=Rp+vals.Rp;
            Rn=Rn+vals.Rn;
        end
          if strcmp(flag,'plot')
              values.Ntd=values.Ntd+vals.nt;
              values.Qd=values.Qd+vals.qt;
              values.Rpd=values.Rpd+vals.Rp;
              values.Rnd=values.Rnd+vals.Rn;
              values.Ndd=values.Ndd+zz.Nt;
          end
    end
  else
    values.nt_Nd(jk,1:num)=0;
  end
end
Nion=Nion+values.nt_Nd;

% acceptor traps
if strcmp(flag,'plot')
    values.Nta(1:num)=0;
    values.Qa(1:num)=0;
    values.Rpa(1:num)=0;
    values.Rna(1:num)=0;
    values.Naa(1:num)=0;
end
for jk=1:simp.numa
  if simp.Na(jk,1) > 0 || simp.Na(jk,2) > 0
    prof.kind=simp.prof_a(jk);
    prof.Co=simp.Na(jk,1);
    prof.xt=a;
    prof.xb=b;
    prof.yt=simp.Na(jk,1);
    prof.yb=simp.Na(jk,2);
    try prof.dir=simp.dir_a(jk); catch; end
    try prof.xo=simp.xo_a(jk); catch; end
    try prof.Dt=simp.Dt_a(jk); catch; end
    try prof.sigma=simp.sigma_a(jk); catch; end
    try prof.L=simp.L_a(jk); catch; end
    zz.Nt=a_profile(x,prof)/norm.n;
    Nimp=Nimp+zz.Nt*norm.n;
    zz.et=a_linear(x,a,b,simp.Eta(jk,1),simp.Eta(jk,2))/norm.v+log(simp.ga(jk)); % Eta=Etrap-Ev
    zz.cp=a_linear(x,a,b,simp.cpa(jk,1),simp.cpa(jk,2))/norm.cap_area;
    zz.cn=a_linear(x,a,b,simp.cna(jk,1),simp.cna(jk,2))/norm.cap_area;
    zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
    zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s; 
    try zz.nt_last(1,:)=in.oldntNa(jk,:);
        try zz.nt_last(2,:)=in.oldoldntNa(jk,:); end
    catch zz.nt_last=0; end;   
    if strcmp(flag,'eq') || strcmp(flag,'neq')
        [vals ders]=slt_a(flag,fdflag,zz);
        values.nt_Na(jk,:)=vals.nt;
        Qt=Qt+vals.qt;
        dQtdp=dQtdp+ders.dqtdp;
        dQtdn=dQtdn+ders.dqtdn;
        if strcmp(flag,'neq')
            Rp=Rp+vals.Rp;
            dRpdp=dRpdp+ders.dRpdp;
            dRpdn=dRpdn+ders.dRpdn;
            Rn=Rn+vals.Rn;
            dRndn=dRndn+ders.dRndn;
            dRndp=dRndp+ders.dRndp;
        end
    elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
        vals=slt_a(flag,fdflag,zz);
        values.nt_Na(jk,:)=vals.nt;
        Qt=Qt+vals.qt;
        if strcmp(flag,'vals') || strcmp(flag,'plot')
            Rp=Rp+vals.Rp;
            Rn=Rn+vals.Rn;
            if strcmp(flag,'plot')
                values.Nta=values.Nta+vals.nt;
                values.Qa=values.Qa+vals.qt;
                values.Rpa=values.Rpa+vals.Rp;
                values.Rna=values.Rna+vals.Rn;
                values.Naa=values.Naa+zz.Nt;
            end
        end
    end
  else
    values.nt_Na(jk,1:num)=0;
  end
end
Nion=Nion+values.nt_Na;

% deep-level recombination center with neglible net trapped charge
if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
  values.Rshr(1:num)=0;
  for jk=1:simp.numshr
      etshr=a_linear(x,a,b,simp.et(jk,1),simp.et(jk,2))/norm.v; % Etshr=Etrap-Ei
        % et=Etrap-Ei, change ref to Ev
      zz.et=0.5*(zz.eg+log(zz.nv./zz.nc))+etshr; % convert to Etrap-Ev
      zz.taup=a_linear(x,a,b,simp.taup(jk,1),simp.taup(jk,2))/norm.time;
      %zz.taup=zz.taup./(1+Nimp/simp.Ncutp(jk));
      zz.taun=a_linear(x,a,b,simp.taun(jk,1),simp.taun(jk,2))/norm.time;
      %zz.taun=zz.taun./(1+Nimp/simp.Ncutn(jk));
      if strcmp(flag,'neq')
          [vals ders]=shr_r(flag,fdflag,zz);
          Rp=Rp+vals.R;
          dRpdp=dRpdp+ders.dRdp;
          dRpdn=dRpdn+ders.dRdn;
          Rn=Rn+vals.R;
          dRndn=dRndn+ders.dRdn;
          dRndp=dRndp+ders.dRdp;
      elseif strcmp(flag,'vals') || strcmp(flag,'plot')
          vals=shr_r(flag,fdflag,zz);
          Rp=Rp+vals.R;
          Rn=Rn+vals.R;
          if strcmp(flag,'plot')
              values.Rshr=values.Rshr+vals.R;
          end
      end
  end
end

% deep level traps
if strcmp(flag,'plot')
    values.Qslt(1:num)=0;
    values.Rpslt(1:num)=0;
    values.Rnslt(1:num)=0;
end
for jk=1:simp.numslt
  if simp.Nslt(jk,1) > 0 || simp.Nslt(jk,2) > 0
    zz.Nt=a_linear(x,a,b,simp.Nslt(jk,1),simp.Nslt(jk,2))/norm.n;
    try zz.nt_last(1,:)=in.oldntNslt(jk,:);
        try zz.nt_last(2,:)=in.oldoldntNslt(jk,:); end
    catch zz.nt_last=0; end;
    if strcmp(simp.slt_type(jk),'donor')
        etslt=a_linear(x,a,b,simp.Etslt(jk,1),simp.Etslt(jk,2))/norm.v; % Etslt=Etrap-Ei
        zz.et=0.5*(zz.eg-log(zz.nv/zz.nc))-etslt+log(simp.gslt(jk)); % convert to Ec-Etrap
        zz.cp=a_linear(x,a,b,simp.cpslt(jk,1),simp.cpslt(jk,2))/norm.cap_area;
        zz.cn=a_linear(x,a,b,simp.cnslt(jk,1),simp.cnslt(jk,2))/norm.cap_area;
        zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
        zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s;    
        if strcmp(flag,'eq') || strcmp(flag,'neq')
            [vals ders]=slt_d(flag,fdflag,zz);
            values.nt_Nslt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            dQtdp=dQtdp+ders.dqtdp;
            dQtdn=dQtdn+ders.dqtdn;
            if strcmp(flag,'neq')
                Rp=Rp+vals.Rp;
                dRpdp=dRpdp+ders.dRpdp;
                dRpdn=dRpdn+ders.dRpdn;
                Rn=Rn+vals.Rn;
                dRndn=dRndn+ders.dRndn;
                dRndp=dRndp+ders.dRndp;
            end
        elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
            vals=slt_d(flag,fdflag,zz);
            values.nt_Nslt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            if strcmp(flag,'vals') || strcmp(flag,'plot')
                Rp=Rp+vals.Rp;
                Rn=Rn+vals.Rn;
                if strcmp(flag,'plot')
                    values.Qslt=values.Qslt+vals.qt;
                    values.Rpslt=values.Rpslt+vals.Rp;
                    values.Rnslt=values.Rnslt+vals.Rn;
                end
            end
        end
    else % acceptor
        etslt=a_linear(x,a,b,simp.Etslt(jk,1),simp.Etslt(jk,2))/norm.v; % Etslt=Etrap-Ei
        zz.et=0.5*(zz.eg+log(zz.nv/zz.nc))+etslt+log(simp.gslt(jk)); % convert to Etrap-Ev
        zz.cp=a_linear(x,a,b,simp.cpslt(jk,1),simp.cpslt(jk,2))/norm.cap_area;
        zz.cn=a_linear(x,a,b,simp.cnslt(jk,1),simp.cnslt(jk,2))/norm.cap_area;
        zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
        zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s;
        if strcmp(flag,'eq') || strcmp(flag,'neq')
            [vals ders]=slt_a(flag,fdflag,zz);
            values.nt_Nslt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            dQtdp=dQtdp+ders.dqtdp;
            dQtdn=dQtdn+ders.dqtdn;
            if strcmp(flag,'neq')
                Rp=Rp+vals.Rp;
                dRpdp=dRpdp+ders.dRpdp;
                dRpdn=dRpdn+ders.dRpdn;
                Rn=Rn+vals.Rn;
                dRndn=dRndn+ders.dRndn;
                dRndp=dRndp+ders.dRndp;
            end
        elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
            vals=slt_a(flag,fdflag,zz);
            values.nt_Nslt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            if strcmp(flag,'vals') || strcmp(flag,'plot')
                Rp=Rp+vals.Rp;
                Rn=Rn+vals.Rn;
                if strcmp(flag,'plot')
                    values.Qslt=values.Qslt+vals.qt;
                    values.Rpslt=values.Rpslt+vals.Rp;
                    values.Rnslt=values.Rnslt+vals.Rn;
                end
            end
        end
    end
  else
    values.nt_Nslt(jk,1:num)=0;
  end
end

% band tails
if strcmp(flag,'plot')
    values.Qbt(1:num)=0;
    values.Rpbt(1:num)=0;
    values.Rnbt(1:num)=0;
end
if strcmp(simp.btail,'on')
    % valence band tails (donor-like)
    for jk=1:simp.nbtquad
      if simp.Nvbt_eff(jk,1) > 0 || simp.Nvbt_eff(jk,2) > 0
        zz.Nt=a_linear(x,a,b,simp.Nvbt_eff(jk,1),simp.Nvbt_eff(jk,2))/norm.n;
        zz.et=a_linear(x,a,b,simp.etvbt_eff(jk,1),simp.etvbt_eff(jk,2))/norm.v+log(simp.gdb); % Etd=Ec-Etrap
        zz.cp=a_linear(x,a,b,simp.cpvb(1),simp.cpvb(2))/norm.cap_area;
        zz.cn=a_linear(x,a,b,simp.cnvb(1),simp.cnvb(2))/norm.cap_area;
        zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
        zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s;
        try zz.nt_last(1,:)=in.oldntNvbt(jk,:);
            try zz.nt_last(2,:)=in.oldoldntNvbt(jk,:); end
        catch zz.nt_last=0; end;
        if strcmp(flag,'eq') || strcmp(flag,'neq')
            [vals, ders]=slt_d(flag,fdflag,zz);
            values.nt_Nvbt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            dQtdp=dQtdp+ders.dqtdp;
            dQtdn=dQtdn+ders.dqtdn;
            if strcmp(flag,'neq')
                Rp=Rp+vals.Rp;
                dRpdp=dRpdp+ders.dRpdp;
                dRpdn=dRpdn+ders.dRpdn;
                Rn=Rn+vals.Rn;
                dRndn=dRndn+ders.dRndn;
                dRndp=dRndp+ders.dRndp;
            end
        elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
            vals=slt_d(flag,fdflag,zz);
            values.nt_Nvbt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            if strcmp(flag,'vals') || strcmp(flag,'plot')
                Rp=Rp+vals.Rp;
                Rn=Rn+vals.Rn;
            end
              if strcmp(flag,'plot')
                  values.Qbt=values.Qbt+vals.qt;
                  values.Rpbt=values.Rpbt+vals.Rp;
                  values.Rnbt=values.Rnbt+vals.Rn;
              end
        end
      else
        values.nt_Nvbt(jk,1:num)=0;
      end
    end    
    
    % conduction band tails (acceptor-like)
    for jk=1:simp.nbtquad
      if simp.Ncbt_eff(jk,1) > 0 || simp.Ncbt_eff(jk,2) > 0
        zz.Nt=a_linear(x,a,b,simp.Ncbt_eff(jk,1),simp.Ncbt_eff(jk,2))/norm.n;
        zz.et=a_linear(x,a,b,simp.etcbt_eff(jk,1),simp.etcbt_eff(jk,2))/norm.v+log(simp.gab); % Eta=Etrap-Ev
        zz.cp=a_linear(x,a,b,simp.cpcb(1),simp.cpcb(2))/norm.cap_area;
        zz.cn=a_linear(x,a,b,simp.cncb(1),simp.cncb(2))/norm.cap_area;
        zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
        zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s; 
        try zz.nt_last(1,:)=in.oldntNcbt(jk,:);
            try zz.nt_last(2,:)=in.oldoldntNcbt(jk,:); end
        catch zz.nt_last=0; end;   
        if strcmp(flag,'eq') || strcmp(flag,'neq')
            [vals ders]=slt_a(flag,fdflag,zz);
            values.nt_Ncbt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            dQtdp=dQtdp+ders.dqtdp;
            dQtdn=dQtdn+ders.dqtdn;
            if strcmp(flag,'neq')
                Rp=Rp+vals.Rp;
                dRpdp=dRpdp+ders.dRpdp;
                dRpdn=dRpdn+ders.dRpdn;
                Rn=Rn+vals.Rn;
                dRndn=dRndn+ders.dRndn;
                dRndp=dRndp+ders.dRndp;
            end
        elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
            vals=slt_a(flag,fdflag,zz);
            values.nt_Ncbt(jk,:)=vals.nt;
            Qt=Qt+vals.qt;
            if strcmp(flag,'vals') || strcmp(flag,'plot')
                Rp=Rp+vals.Rp;
                Rn=Rn+vals.Rn;
                if strcmp(flag,'plot')
                    values.Qbt=values.Qbt+vals.qt;
                    values.Rpbt=values.Rpbt+vals.Rp;
                    values.Rnbt=values.Rnbt+vals.Rn;
                end
            end
        end
      else
        values.nt_Ncbt(jk,1:num)=0;
      end
    end
end

% amphoteric states
values.Q3(1:num)=0;
values.Rp3(1:num)=0;
values.Rn3(1:num)=0;
for jk=1:simp.nummv3
  if simp.Nmv3(jk,1) > 0 || simp.Nmv3(jk,2) > 0
    zz.nt3=a_linear(x,a,b,simp.Nmv3(jk,1),simp.Nmv3(jk,2))/norm.n;
    zz.e3p=a_linear(x,a,b,simp.Etp3(jk,1),simp.Etp3(jk,2))/norm.v;
    zz.e3m=a_linear(x,a,b,simp.Etm3(jk,1),simp.Etm3(jk,2))/norm.v;
    zz.cpp3=a_linear(x,a,b,simp.cpp3(jk,1),simp.cpp3(jk,2))/norm.cap_area;
    zz.cnp3=a_linear(x,a,b,simp.cnp3(jk,1),simp.cnp3(jk,2))/norm.cap_area;
    zz.cpm3=a_linear(x,a,b,simp.cpm3(jk,1),simp.cpm3(jk,2))/norm.cap_area;
    zz.cnm3=a_linear(x,a,b,simp.cnm3(jk,1),simp.cnm3(jk,2))/norm.cap_area;
    zz.vthp=a_linear(x,a,b,simp.vthp(1),simp.vthp(2))/norm.s;
    zz.vthn=a_linear(x,a,b,simp.vthn(1),simp.vthn(2))/norm.s;
    if strcmp(flag,'eq') || strcmp(flag,'neq')
        [vals ders]=a_amphoteric3(flag,fdflag,zz);
        values.nt_Nmvp3(jk,:)=vals.nsp;
        values.nt_Nmv03(jk,:)=vals.ns0;
        values.nt_Nmvm3(jk,:)=vals.nsm;
        Qt=Qt+vals.qs3;
        dQtdp=dQtdp+ders.dqsdp;
        dQtdn=dQtdn+ders.dqsdn;
        if strcmp(flag,'neq')
            Rp=Rp+vals.Rp3;
            dRpdp=dRpdp+ders.dRp3dp;
            dRpdn=dRpdn+ders.dRp3dn;
            Rn=Rn+vals.Rn3;
            dRndn=dRndn+ders.dRn3dn;
            dRndp=dRndp+ders.dRn3dp;
        end
    elseif strcmp(flag,'eqvals') || strcmp(flag,'vals') || strcmp(flag,'plot')
        vals=a_amphoteric3(flag,fdflag,zz);
        values.nt_Nmvp3(jk,:)=vals.nsp;
        values.nt_Nmv03(jk,:)=vals.ns0;
        values.nt_Nmvm3(jk,:)=vals.nsm;
        Qt=Qt+vals.qs3;
        if strcmp(flag,'vals') || strcmp(flag,'plot')
            Rp=Rp+vals.Rp3;
            Rn=Rn+vals.Rn3;
            if strcmp(flag,'plot')
                values.Q3=values.Q3+vals.qs3;
                values.Rp3=values.Rp3+vals.Rp3;
                values.Rn3=values.Rn3+vals.Rn3;
            end    
        end
    end
  else
    values.nt_Nmvp3(jk,1:num)=0;
    values.nt_Nmv03(jk,1:num)=0;
    values.nt_Nmvm3(jk,1:num)=0;
  end
end

% radiative recombination
zz.B=a_linear(x,a,b,simp.B(1),simp.B(2))/norm.B;
if strcmp(flag,'neq')
    [vals ders]=r_rad(flag,zz);
    Rp=Rp+vals.R;
    dRpdp=dRpdp+ders.dRdp;
    dRpdn=dRpdn+ders.dRdn;
    Rn=Rn+vals.R;
    dRndp=dRndp+ders.dRdp;
    dRndn=dRndn+ders.dRdn;
elseif strcmp(flag,'vals') || strcmp(flag,'plot')
    vals=r_rad(flag,zz);
    Rp=Rp+vals.R;
    Rn=Rn+vals.R;
    if strcmp(flag,'plot')
        values.Rrad(jk,:)=vals.R;
    end
end

% Auger recombination
zz.Cp=a_linear(x,a,b,simp.Cp(1),simp.Cp(2))/norm.C;
zz.Cn=a_linear(x,a,b,simp.Cn(1),simp.Cn(2))/norm.C;
if strcmp(flag,'neq')
    [vals ders]=r_auger(flag,zz);
    Rp=Rp+vals.R;
    dRpdp=dRpdp+ders.dRdp;
    dRpdn=dRpdn+ders.dRdn;
    Rn=Rn+vals.R;
    dRndp=dRndp+ders.dRdp;
    dRndn=dRndn+ders.dRdn;
elseif strcmp(flag,'vals')  || strcmp(flag,'plot')
    vals=r_auger(flag,zz);
    Rp=Rp+vals.R;
    Rn=Rn+vals.R;
    if strcmp(flag,'plot')
        values.Rauger(jk,:)=vals.R;
    end
end

% populate output structures
% always needed (band parameters - vp,vn - already handled)
values.Nt(1:num)=Qt;
values.ks(1:num)=a_linear(x,a,b,simp.ks(1),simp.ks(2))/norm.ks;
% needed for non-eq
if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    if strcmp(simp.up_model,'C-T')
        umin=a_linear(x,a,b,simp.up_min(1),simp.up_min(2));
        umax=a_linear(x,a,b,simp.up_max(1),simp.up_max(2));
        Nref=a_linear(x,a,b,simp.up_nref(1),simp.up_nref(2));
        values.up(1:num)=a_ctmob(Nion,umin,umax,Nref,simp.up_beta)/norm.u;
    elseif strcmp(simp.up_model,'linear')
      values.up(1:num)=a_linear(x,a,b,simp.up(1),simp.up(2))/norm.u;
    else
        error('a_custom_semi.m: This should never happen')
    end
    if strcmp(simp.un_model,'C-T')
        umin=a_linear(x,a,b,simp.un_min(1),simp.un_min(2));
        umax=a_linear(x,a,b,simp.un_max(1),simp.un_max(2));
        Nref=a_linear(x,a,b,simp.un_nref(1),simp.un_nref(2));
        values.un(1:num)=a_ctmob(Nion,umin,umax,Nref,simp.un_beta)/norm.u;
    elseif strcmp(simp.un_model,'linear')
      values.un(1:num)=a_linear(x,a,b,simp.un(1),simp.un(2))/norm.u;
    else
        error('a_custom_semi.m: This should never happen')
    end
    values.Rp(1:num)=Rp;
    values.Rn(1:num)=Rn;
end
if strcmp(flag,'eq') || strcmp(flag,'neq')
    derivs.dNtdp(1:num)=dQtdp;
    derivs.dNtdn(1:num)=dQtdn;
    if strcmp(flag,'neq')
        derivs.dRpdp(1:num)=dRpdp;
        derivs.dRpdn(1:num)=dRpdn;
        derivs.dRndp(1:num)=dRndp;
        derivs.dRndn(1:num)=dRndn;
    end
end