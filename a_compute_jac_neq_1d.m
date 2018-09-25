function [J,F,dev]=a_compute_jac_neq_1d(dev)
% va is the notmalized applied voltage

nnodes=dev.mesh.num_nod;

rdt=dev.OpCond.rdt;
if rdt > 0
    rdtold=dev.OpCond.rdtold;
else
    rdtold=-1;
end

if strcmp(dev.OpCond.mode,'equilibrium')
    Rcontacts=0;
else
    Rcontacts=(dev.bc.top.rc+dev.bc.bottom.rc)/(dev.norm.v/dev.norm.j);
end

% The Jacobi matrix is block tridiagonal.

njs=27*nnodes-18;
nrow=3*nnodes;
ncol=3*nnodes;

ji(1:njs)=0; % row index for sparse matrix
jj(1:njs)=0; % column index for sparse matrix
js(1:njs)=0; % matrix value at (ji,jj)
F(1:nrow)=0; % rhs (residual)

[values derivs dev]=a_get_params(dev,'neq');

w=dev.OpCond.omega;
if strcmp(dev.OpCond.set_ac,'Vac') && w > 0
    setvac=1; % small signal voltage
    setgac=0;
elseif strcmp(dev.OpCond.set_ac(1:3),'Gac') && w > 0
    setvac=0;
    setgac=1; % small signal gen rate
    [Gacl,Gacr,dev.OpCond.Jgen_ac]=a_setGac(dev);
    dev.ele.Gl_ac=Gacl;
    dev.ele.Gr_ac=Gacr;
else
    setvac=0;
    setgac=0;
end

% 1st node
if strcmp(dev.bc.top.neq_bc,'ideal') == 1

    pc=dev.ele.plo(1);
    nc=dev.ele.nlo(1);
      
    p1=dev.ele.pl(1);
    n1=dev.ele.nl(1);
    v1=dev.node.v(1);
    p2=dev.ele.pr(1);
    n2=dev.ele.nr(1);
    v2=dev.node.v(2);
    
    if rdt > 0
        v1old(1,1)=dev.node.vold(1,1);
        v2old(1,2)=dev.node.vold(1,2);
    end
    if rdtold > 0
        v1old(2,1)=dev.node.vold(2,1);
        v2old(2,2)=dev.node.vold(2,2);
    end
      
    vp1=values.vpl(1);
    dvp1dp1=derivs.dvpldpl(1);
    vp2=values.vpr(1);
    dvp2dp2=derivs.dvprdpr(1);
    vn1=values.vnl(1);
    dvn1dn1=derivs.dvnldnl(1);
    vn2=values.vnr(1);
    dvn2dn2=derivs.dvnrdnr(1);
      
    % get mesh spacing
    h0=dev.ele.h(1);
      
    up0=0.5*(values.upl(1)+values.upr(1));
    un0=0.5*(values.unl(1)+values.unr(1));
    
    ks0=0.5*(values.ksl(1)+values.ksr(1));
      
    dv0=(v2-vp2)-(v1-vp1);
    [jp0,djp0dp1,djp0dp2,djp0ddv0]=a_jp(h0,up0,p1,p2,dv0);
    djp0dv2=djp0ddv0;
    djp0dv1=-djp0ddv0;
    djp0dvp2=-djp0ddv0;
    djp0dvp1=djp0ddv0;
    djp0dzp2=(djp0dp2+djp0dvp2.*dvp2dp2).*p2;
    djp0dzp1=(djp0dp1+djp0dvp1.*dvp1dp1).*p1;
      
    dv0=(v2+vn2)-(v1+vn1);
    [jn0,djn0dn1,djn0dn2,djn0ddv0]=a_jn(h0,un0,n1,n2,dv0);
    djn0dv2=djn0ddv0;
    djn0dv1=-djn0ddv0;
    djn0dvn2=djn0ddv0;
    djn0dvn1=-djn0ddv0;
    djn0dzn2=(djn0dn2+djn0dvn2.*dvn2dn2).*n2;
    djn0dzn1=(djn0dn1+djn0dvn1.*dvn1dn1).*n1;
  
    if rdt > 0
      Dfield=ks0*(v1-v2)/h0;
      Dfield_old(1,1)=ks0*(v1old(1,1)-v2old(1,2))/h0;
      if rdtold > 0
        Dfield_old(2,1)=ks0*(v1old(2,1)-v2old(2,2))/h0;
      end
      [jd0 djd0dD]=a_bdf(Dfield,Dfield_old,rdt,rdtold);
      djd0dv1=djd0dD*ks0/h0;
      djd0dv2=-djd0dv1;
    else
      jd0=0;
      djd0dv1=0;
      djd0dv2=0;
    end
    %jd0=rdt*ks0*((v1-v2)-(v1old-v2old))/h0;
    
    jtotal=jp0+jn0+jd0;
    
    v02w=(dev.OpCond.va-Rcontacts*jtotal);
    vc=dev.node.vo(1)+v02w; % voltage applied at first node only
    dvcdzp1=-Rcontacts*djp0dzp1;
    dvcdzn1=-Rcontacts*djn0dzn1;
    dvcdv1=-Rcontacts*(djp0dv1+djn0dv1+djd0dv1);
    dvcdzp2=-Rcontacts*djp0dzp2;
    dvcdzn2=-Rcontacts*djn0dzn2;
    dvcdv2=-Rcontacts*(djp0dv2+djn0dv2+djd0dv2);
    
    if dev.OpCond.setv % voltage set
        Fp=p1-pc;
        Fn=n1-nc;
        Fv=v1-vc;
        dFpdzp=p1;
        dFpdzn=0;
        dFpdv=0;
        dFpdzpr=0;
        dFpdznr=0;
        dFpdvr=0;
        dFndzp=0;
        dFndzn=n1;
        dFndv=0;
        dFndzpr=0;
        dFndznr=0;
        dFndvr=0;
        dFvdzp=-dvcdzp1;
        dFvdzn=-dvcdzn1;
        dFvdv=1-dvcdv1;
        dFvdzpr=-dvcdzp2;
        dFvdznr=-dvcdzn2;
        dFvdvr=-dvcdv2;
    else % current set
        Fp=p1-pc;
        Fn=n1-nc;
        Fv=jtotal-dev.OpCond.jt; % Fv=jp0+jn0+jd0-jt
        dFpdzp=p1;
        dFpdzn=0;
        dFpdv=0;
        dFpdzpr=0;
        dFpdznr=0;
        dFpdvr=0;
        dFndzp=0;
        dFndzn=n1;
        dFndv=0;
        dFndzpr=0;
        dFndznr=0;
        dFndvr=0;
        dFvdzp=djp0dzp1;
        dFvdzn=djn0dzn1;
        dFvdv=djp0dv1+djn0dv1+djd0dv1;
        dFvdzpr=djp0dzp2;
        dFvdznr=djn0dzn2;
        dFvdvr=djp0dv2+djn0dv2+djd0dv2;
    end
    
elseif strcmp(dev.bc.top.neq_bc,'non-ideal') == 1

    po1=dev.ele.plo(1);
    no1=dev.ele.nlo(1);
      
    p1=dev.ele.pl(1);
    n1=dev.ele.nl(1);
    v1=dev.node.v(1);
    p2=dev.ele.pr(1);
    n2=dev.ele.nr(1);
    v2=dev.node.v(2);
    
    if rdt > 0
        v1old(1,1)=dev.node.vold(1,1);
        v2old(1,2)=dev.node.vold(1,2);
    end
    if rdtold > 0
        v1old(2,1)=dev.node.vold(2,1);
        v2old(2,2)=dev.node.vold(2,2);
    end
      
    vp1=values.vpl(1);
    dvp1dp1=derivs.dvpldpl(1);
    vp2=values.vpr(1);
    dvp2dp2=derivs.dvprdpr(1);
    vn1=values.vnl(1);
    dvn1dn1=derivs.dvnldnl(1);
    vn2=values.vnr(1);
    dvn2dn2=derivs.dvnrdnr(1);
      
    % get mesh spacing
    h0=dev.ele.h(1);
      
    up0=0.5*(values.upl(1)+values.upr(1));
    un0=0.5*(values.unl(1)+values.unr(1));
    
    ks0=0.5*(values.ksl(1)+values.ksr(1));
      
    dv0=(v2-vp2)-(v1-vp1);
    [jp0,djp0dp1,djp0dp2,djp0ddv0]=a_jp(h0,up0,p1,p2,dv0);
    djp0dv2=djp0ddv0;
    djp0dv1=-djp0ddv0;
    djp0dvp2=-djp0ddv0;
    djp0dvp1=djp0ddv0;
    djp0dzp2=(djp0dp2+djp0dvp2.*dvp2dp2).*p2;
    djp0dzp1=(djp0dp1+djp0dvp1.*dvp1dp1).*p1;
      
    dv0=(v2+vn2)-(v1+vn1);
    [jn0,djn0dn1,djn0dn2,djn0ddv0]=a_jn(h0,un0,n1,n2,dv0);
    djn0dv2=djn0ddv0;
    djn0dv1=-djn0ddv0;
    djn0dvn2=djn0ddv0;
    djn0dvn1=-djn0ddv0;
    djn0dzn2=(djn0dn2+djn0dvn2.*dvn2dn2).*n2;
    djn0dzn1=(djn0dn1+djn0dvn1.*dvn1dn1).*n1;
  
    if rdt > 0
      Dfield=ks0*(v1-v2)/h0;
      Dfield_old(1,1)=ks0*(v1old(1,1)-v2old(1,2))/h0;
      if rdtold > 0
        Dfield_old(2,1)=ks0*(v1old(2,1)-v2old(2,2))/h0;
      end
      [jd0 djd0dD]=a_bdf(Dfield,Dfield_old,rdt,rdtold);
      djd0dv1=djd0dD*ks0/h0;
      djd0dv2=-djd0dv1;
    else
      jd0=0;
      djd0dv1=0;
      djd0dv2=0;
    end
    
    jtotal=jp0+jn0+jd0;
    
    v02w=(dev.OpCond.va-Rcontacts*jtotal);
    vc=dev.node.vo(1)+v02w; % voltage applied at first node only
    dvcdzp1=-Rcontacts*djp0dzp1;
    dvcdzn1=-Rcontacts*djn0dzn1;
    dvcdv1=-Rcontacts*(djp0dv1+djn0dv1+djd0dv1);
    dvcdzp2=-Rcontacts*djp0dzp2;
    dvcdzn2=-Rcontacts*djn0dzn2;
    dvcdv2=-Rcontacts*(djp0dv2+djn0dv2+djd0dv2);
    
    sp=dev.bc.top.sp/dev.norm.s;
    sn=dev.bc.top.sn/dev.norm.s;
    
    if dev.OpCond.setv % voltage set
        if sp == inf
            Fp=p1-po1;
            dFpdzp=p1;
            dFpdzn=0;
            dFpdv=0;
            dFpdzpr=0;
            dFpdznr=0;
            dFpdvr=0;
        else
            Fp=jp0+sp*(p1-po1);
            dFpdzp=djp0dzp1+sp*p1;
            dFpdzn=0;
            dFpdv=djp0dv1;
            dFpdzpr=djp0dzp2;
            dFpdznr=0;
            dFpdvr=djp0dv2;
        end
        if sn == inf
            Fn=n1-no1;
            dFndzp=0;
            dFndzn=n1;
            dFndv=0;
            dFndzpr=0;
            dFndznr=0;
            dFndvr=0;
        else
            Fn=jn0-sn*(n1-no1);
            dFndzp=0;
            dFndzn=djn0dzn1-sn*n1;
            dFndv=djn0dv1;
            dFndzpr=0;
            dFndznr=djn0dzn2;
            dFndvr=djn0dv2;
        end
        Fv=v1-vc;
        dFvdzp=-dvcdzp1;
        dFvdzn=-dvcdzn1;
        dFvdv=1-dvcdv1;
        dFvdzpr=-dvcdzp2;
        dFvdznr=-dvcdzn2;
        dFvdvr=-dvcdv2;
    else % current set
        if sp == inf
            Fp=p1-po1;
            dFpdzp=p1;
            dFpdzn=0;
            dFpdv=0;
            dFpdzpr=0;
            dFpdznr=0;
            dFpdvr=0;
        else
            Fp=jp0+sp*(p1-po1);
            dFpdzp=djp0dzp1+sp*p1;
            dFpdzn=0;
            dFpdv=djp0dv1;
            dFpdzpr=djp0dzp2;
            dFpdznr=0;
            dFpdvr=djp0dv2;
        end
        if sn == inf
            Fn=n1-no1;
            dFndzp=0;
            dFndzn=n1;
            dFndv=0;
            dFndzpr=0;
            dFndznr=0;
            dFndvr=0;
        else
            Fn=jn0-sn*(n1-no1);
            dFndzp=0;
            dFndzn=djn0dzn1-sn*n1;
            dFndv=djn0dv1;
            dFndzpr=0;
            dFndznr=djn0dzn2;
            dFndvr=djn0dv2;
        end
        Fv=jtotal-dev.OpCond.jt; % Fv=jp0+jn0+jd0-jt
        dFvdzp=djp0dzp1;
        dFvdzn=djn0dzn1;
        dFvdv=djp0dv1+djn0dv1+djd0dv1;
        dFvdzpr=djp0dzp2;
        dFvdznr=djn0dzn2;
        dFvdvr=djp0dv2+djn0dv2+djd0dv2;
    end
else

    error('a_compute_jac_neq_1d: Undefined BC')

end

if w > 0
    if setvac == 1
        Fv=-dev.OpCond.vac/dev.norm.v;
    else
        Fv=0;
    end
    dFvdzp=0;
    dFvdzn=0;
    dFvdv=1;
    dFvdzpr=0;
    dFvdznr=0;
    dFvdvr=0;
end
   
% first 3 rows of Jacobi matrix 
ji(1:6)=1;
jj(1:6)=1:6;
ji(7:12)=2;
jj(7:12)=1:6;
ji(13:18)=3;
jj(13:18)=1:6;
js(1)=1;
js(2)=dFpdzn/dFpdzp;
js(3)=dFpdv/dFpdzp;
js(4)=dFpdzpr/dFpdzp;
js(5)=dFpdznr/dFpdzp;
js(6)=dFpdvr/dFpdzp;
js(7)=dFndzp/dFndzn;
js(8)=1;
js(9)=dFndv/dFndzn;
js(10)=dFndzpr/dFndzn;
js(11)=dFndznr/dFndzn;
js(12)=dFndvr/dFndzn;
js(13)=dFvdzp/dFvdv;
js(14)=dFvdzn/dFvdv;
js(15)=1;
js(16)=dFvdzpr/dFvdv;
js(17)=dFvdznr/dFvdv;
js(18)=dFvdvr/dFvdv;  

% rhs 
F(1)=Fp/dFpdzp;
F(2)=Fn/dFndzn;
F(3)=Fv/dFvdv;

%for i=2:nnodes-1

    % get values for p, n, and V
    pl=dev.ele.pl(1:nnodes-2);
    pil=dev.ele.pr(1:nnodes-2);
    pir=dev.ele.pl(2:nnodes-1);
    pr=dev.ele.pr(2:nnodes-1);
    nl=dev.ele.nl(1:nnodes-2);
    nil=dev.ele.nr(1:nnodes-2);
    nir=dev.ele.nl(2:nnodes-1);
    nr=dev.ele.nr(2:nnodes-1);
    vl=dev.node.v(1:nnodes-2);
    vi=dev.node.v(2:nnodes-1);
    vr=dev.node.v(3:nnodes);
    if rdt > 0
        zpi=dev.node.zp(2:nnodes-1);
        zni=dev.node.zn(2:nnodes-1);
        viold=dev.node.vold(1,2:nnodes-1);
        zpiold=dev.node.zpold(1,2:nnodes-1);
        zniold=dev.node.znold(1,2:nnodes-1);
        pilold=dev.ele.prold(1,1:nnodes-2);
        pirold=dev.ele.plold(1,2:nnodes-1);
        nilold=dev.ele.nrold(1,1:nnodes-2);
        nirold=dev.ele.nlold(1,2:nnodes-1);
    end
    if rdtold > 0
        viold(2,:)=dev.node.vold(2,2:nnodes-1);
        zpiold(2,:)=dev.node.zpold(2,2:nnodes-1);
        zniold(2,:)=dev.node.znold(2,2:nnodes-1);
        pilold(2,:)=dev.ele.prold(2,1:nnodes-2);
        pirold(2,:)=dev.ele.plold(2,2:nnodes-1);
        nilold(2,:)=dev.ele.nrold(2,1:nnodes-2);
        nirold(2,:)=dev.ele.nlold(2,2:nnodes-1);
    end
    % get band parameters
    vpl=values.vpl(1:nnodes-2);
    dvpldpl=derivs.dvpldpl(1:nnodes-2);
    vpil=values.vpr(1:nnodes-2);
    dvpildpil=derivs.dvprdpr(1:nnodes-2);
    vpir=values.vpl(2:nnodes-1);
    dvpirdpir=derivs.dvpldpl(2:nnodes-1);
    vpr=values.vpr(2:nnodes-1);
    dvprdpr=derivs.dvprdpr(2:nnodes-1);
    % dependence of vp on n,V is ignored in Jacobian
    vnl=values.vnl(1:nnodes-2);
    dvnldnl=derivs.dvnldnl(1:nnodes-2);
    vnil=values.vnr(1:nnodes-2);
    dvnildnil=derivs.dvnrdnr(1:nnodes-2);
    vnir=values.vnl(2:nnodes-1);
    dvnirdnir=derivs.dvnldnl(2:nnodes-1);
    vnr=values.vnr(2:nnodes-1);
    dvnrdnr=derivs.dvnrdnr(2:nnodes-1) ;
    % dependence of vn on p,V is ignored in Jacobian
    
    % get mesh spacing
    hl=dev.ele.h(1:nnodes-2);
    hr=dev.ele.h(2:nnodes-1);
    
    % get dielectric constant
    ksl=0.5*(values.ksl(1:nnodes-2)+values.ksr(1:nnodes-2));
    ksr=0.5*(values.ksl(2:nnodes-1)+values.ksr(2:nnodes-1));
    % dependence of ks on p,n,V is ignored in Jacobian
    
    % get net trapped charge
    Ntil=values.Ntr(1:nnodes-2);
    dNtildzp=derivs.dNtrdpr(1:nnodes-2).*pil;
    dNtildzn=derivs.dNtrdnr(1:nnodes-2).*nil;
    Ntir=values.Ntl(2:nnodes-1);
    dNtirdzp=derivs.dNtldpl(2:nnodes-1).*pir;
    dNtirdzn=derivs.dNtldnl(2:nnodes-1).*nir;
    % dependence of Nt on V is ignored in Jacobian
    
    % get carrier mobilities
    upl=0.5*(values.upl(1:nnodes-2)+values.upr(1:nnodes-2));
    upr=0.5*(values.upl(2:nnodes-1)+values.upr(2:nnodes-1));
    unl=0.5*(values.unl(1:nnodes-2)+values.unr(1:nnodes-2));
    unr=0.5*(values.unl(2:nnodes-1)+values.unr(2:nnodes-1));
    % dependence of up,un on p,n,V is ignored in Jacobian
    
    % get recombination rates
    Rpil=values.Rpr(1:nnodes-2);
    dRpildzp=derivs.dRprdpr(1:nnodes-2).*pil;
    dRpildzn=derivs.dRprdnr(1:nnodes-2).*nil;
    Rpir=values.Rpl(2:nnodes-1);
    dRpirdzp=derivs.dRpldpl(2:nnodes-1).*pir;
    dRpirdzn=derivs.dRpldnl(2:nnodes-1).*nir;    
    Rnil=values.Rnr(1:nnodes-2);
    dRnildzp=derivs.dRnrdpr(1:nnodes-2).*pil;
    dRnildzn=derivs.dRnrdnr(1:nnodes-2).*nil;
    Rnir=values.Rnl(2:nnodes-1);
    dRnirdzp=derivs.dRnldpl(2:nnodes-1).*pir;
    dRnirdzn=derivs.dRnldnl(2:nnodes-1).*nir;
    % dependence of Rp,Rn on V is ignored in Jacobian
    
    % get generation rate
    Gpil=values.Gr(1:nnodes-2);
    Gpir=values.Gl(2:nnodes-1);
    Gnil=values.Gr(1:nnodes-2);
    Gnir=values.Gl(2:nnodes-1);
    % dependence of Gr,Gl on p,n,V is ignored in Jacobian
    if rdt > 0
        [dzpdt,p_dzpdt_zp]=a_bdf(zpi,zpiold,rdt,rdtold);
        Gpil=Gpil-pil.*dzpdt;
        Gpir=Gpir-pir.*dzpdt;
        dGpildzp=-(pil.*dzpdt+pil.*p_dzpdt_zp);
        dGpirdzp=-(pir.*dzpdt+pir.*p_dzpdt_zp);
        [dzndt,p_dzndt_zn]=a_bdf(zni,zniold,rdt,rdtold);
        Gnil=Gnil-nil.*dzndt;
        Gnir=Gnir-nir.*dzndt;
        dGnildzn=-(nil.*dzndt+nil.*p_dzndt_zn);
        dGnirdzn=-(nir.*dzndt+nir.*p_dzndt_zn);
%         Gpil=Gpil-rdt.*sqrt(pil.*pilold).*(zpi-zpiold);
%         Gpir=Gpir-rdt.*sqrt(pir.*pirold).*(zpi-zpiold);
%         Gnil=Gnil-rdt.*sqrt(nil.*nilold).*(zni-zniold);
%         Gnir=Gnir-rdt.*sqrt(nir.*nirold).*(zni-zniold);
%         dGpildzp=-rdt.*(0.5*sqrt(pilold./pil).*pil.*(zpi-zpiold)+sqrt(pil.*pilold));
%         dGpirdzp=-rdt.*(0.5*sqrt(pirold./pir).*pir.*(zpi-zpiold)+sqrt(pir.*pirold));
%         dGnildzn=-rdt.*(0.5*sqrt(nilold./nil).*nil.*(zni-zniold)+sqrt(nil.*nilold));
%         dGnirdzn=-rdt.*(0.5*sqrt(nirold./nir).*nir.*(zni-zniold)+sqrt(nir.*nirold));
    else
        dGpildzp=0;
        dGpirdzp=0;
        dGnildzn=0;
        dGnirdzn=0;
    end
    
    dvl=(vi-vpil)-(vl-vpl);
    [jpl,djpldpl,djpldpil,djplddvl]=a_jp(hl,upl,pl,pil,dvl);
    djpldvl=-djplddvl;
    djpldvi=djplddvl;
    djpldvpl=djplddvl;
    djpldvpil=-djplddvl;
    djpldzpl=(djpldpl+djpldvpl.*dvpldpl).*pl;
    djpldzp=(djpldpil+djpldvpil.*dvpildpil).*pil;
    
    dvl=(vi+vnil)-(vl+vnl);
    [jnl,djnldnl,djnldnil,djnlddvl]=a_jn(hl,unl,nl,nil,dvl);
    djnldvl=-djnlddvl;
    djnldvi=djnlddvl;
    djnldvnl=-djnlddvl;
    djnldvnil=djnlddvl;
    djnldznl=(djnldnl+djnldvnl.*dvnldnl).*nl;
    djnldzn=(djnldnil+djnldvnil.*dvnildnil).*nil;
    
    dvr=(vr-vpr)-(vi-vpir);
    [jpr,djprdpir,djprdpr,djprddvr]=a_jp(hr,upr,pir,pr,dvr);
    djprdvr=djprddvr;
    djprdvi=-djprddvr;
    djprdvpr=-djprddvr;
    djprdvpir=djprddvr;
    djprdzpr=(djprdpr+djprdvpr.*dvprdpr).*pr;
    djprdzp=(djprdpir+djprdvpir.*dvpirdpir).*pir;
    
    dvr=(vr+vnr)-(vi+vnir);
    [jnr,djnrdnir,djnrdnr,djnrddvr]=a_jn(hr,unr,nir,nr,dvr);
    djnrdvr=djnrddvr;
    djnrdvi=-djnrddvr;
    djnrdvnr=djnrddvr;
    djnrdvnir=-djnrddvr;
    djnrdznr=(djnrdnr+djnrdvnr.*dvnrdnr).*nr;
    djnrdzn=(djnrdnir+djnrdvnir.*dvnirdnir).*nir;
 
% RHS
    Fp=jpr-jpl+hl/2.*(Rpil-Gpil)+hr/2.*(Rpir-Gpir);
    Fn=jnr-jnl+hl/2.*(Gnil-Rnil)+hr/2.*(Gnir-Rnir);
    Fv=ksl./hl.*vl-(ksl./hl+ksr./hr).*vi+ksr./hr.*vr+hl/2.*(pil-nil+Ntil)+hr/2.*(pir-nir+Ntir);
% Jacobian   
    if w > 0
        dFpdzp_ac=-1i*w*(hl/2.*pil+hr/2.*pir);
        dFndzn_ac=1i*w*(hl/2.*nil+hr/2.*nir);
    else
        dFpdzp_ac=0;
        dFndzn_ac=0;
    end
    dFpdzpl=-djpldzpl;
    dFpdznl=0;
    dFpdvl=-djpldvl;
    dFpdzp=djprdzp-djpldzp+hl/2.*(dRpildzp-dGpildzp)+hr/2.*(dRpirdzp-dGpirdzp);
    dFpdzn=hl/2.*dRpildzn+hr/2.*dRpirdzn;
    dFpdv=djprdvi-djpldvi;
    dFpdzpr=djprdzpr;
    dFpdznr=0;
    dFpdvr=djprdvr;
    dFndzpl=0;
    dFndznl=-djnldznl;
    dFndvl=-djnldvl;
    dFndzp=-hl/2.*dRnildzp-hr/2.*dRnirdzp;
    dFndzn=djnrdzn-djnldzn-hl/2.*(dRnildzn-dGnildzn)-hr/2.*(dRnirdzn-dGnirdzn);
    dFndv=djnrdvi-djnldvi;
    dFndzpr=0;
    dFndznr=djnrdznr;
    dFndvr=djnrdvr;
    dFvdzpl=0;
    dFvdznl=0;
    dFvdvl=ksl./hl;
    dFvdzp=hl/2.*(pil+dNtildzp)+hr/2.*(pir+dNtirdzp);
    dFvdzn=hl/2.*(-nil+dNtildzn)+hr/2.*(-nir+dNtirdzn);
    dFvdv=-(ksl./hl+ksr./hr);
    dFvdzpr=0;
    dFvdznr=0;
    dFvdvr=ksr./hr;
    
    % dFp terms
    ind=19:27:njs-44;
    ji(ind)=4:3:nrow-5;   jj(ind)=1:3:ncol-8;   js(ind)=dFpdzpl./dFpdzp;
    ji(ind+1)=4:3:nrow-5; jj(ind+1)=2:3:ncol-7; js(ind+1)=dFpdznl./dFpdzp;
    ji(ind+2)=4:3:nrow-5; jj(ind+2)=3:3:ncol-6; js(ind+2)=dFpdvl./dFpdzp;
    ji(ind+3)=4:3:nrow-5; jj(ind+3)=4:3:ncol-5; js(ind+3)=1+dFpdzp_ac./dFpdzp;
    ji(ind+4)=4:3:nrow-5; jj(ind+4)=5:3:ncol-4; js(ind+4)=dFpdzn./dFpdzp;
    ji(ind+5)=4:3:nrow-5; jj(ind+5)=6:3:ncol-3; js(ind+5)=dFpdv./dFpdzp;
    ji(ind+6)=4:3:nrow-5; jj(ind+6)=7:3:ncol-2; js(ind+6)=dFpdzpr./dFpdzp;
    ji(ind+7)=4:3:nrow-5; jj(ind+7)=8:3:ncol-1; js(ind+7)=dFpdznr./dFpdzp;
    ji(ind+8)=4:3:nrow-5; jj(ind+8)=9:3:ncol;   js(ind+8)=dFpdvr./dFpdzp;
    
    % dFn terms
    ind=28:27:njs-35;
    ji(ind)=5:3:nrow-4;   jj(ind)=1:3:ncol-8;   js(ind)=dFndzpl./dFndzn;
    ji(ind+1)=5:3:nrow-4; jj(ind+1)=2:3:ncol-7; js(ind+1)=dFndznl./dFndzn;
    ji(ind+2)=5:3:nrow-4; jj(ind+2)=3:3:ncol-6; js(ind+2)=dFndvl./dFndzn;
    ji(ind+3)=5:3:nrow-4; jj(ind+3)=4:3:ncol-5; js(ind+3)=dFndzp./dFndzn;
    ji(ind+4)=5:3:nrow-4; jj(ind+4)=5:3:ncol-4; js(ind+4)=1+dFndzn_ac./dFndzn;
    ji(ind+5)=5:3:nrow-4; jj(ind+5)=6:3:ncol-3; js(ind+5)=dFndv./dFndzn;
    ji(ind+6)=5:3:nrow-4; jj(ind+6)=7:3:ncol-2; js(ind+6)=dFndzpr./dFndzn;
    ji(ind+7)=5:3:nrow-4; jj(ind+7)=8:3:ncol-1; js(ind+7)=dFndznr./dFndzn;
    ji(ind+8)=5:3:nrow-4; jj(ind+8)=9:3:ncol;   js(ind+8)=dFndvr./dFndzn;
    
    % dFv terms
    ind=37:27:njs-26;
    ji(ind)=6:3:nrow-3;   jj(ind)=1:3:ncol-8;   js(ind)=dFvdzpl./dFvdv;
    ji(ind+1)=6:3:nrow-3; jj(ind+1)=2:3:ncol-7; js(ind+1)=dFvdznl./dFvdv;
    ji(ind+2)=6:3:nrow-3; jj(ind+2)=3:3:ncol-6; js(ind+2)=dFvdvl./dFvdv;
    ji(ind+3)=6:3:nrow-3; jj(ind+3)=4:3:ncol-5; js(ind+3)=dFvdzp./dFvdv;
    ji(ind+4)=6:3:nrow-3; jj(ind+4)=5:3:ncol-4; js(ind+4)=dFvdzn./dFvdv;
    ji(ind+5)=6:3:nrow-3; jj(ind+5)=6:3:ncol-3; js(ind+5)=dFvdv./dFvdv;
    ji(ind+6)=6:3:nrow-3; jj(ind+6)=7:3:ncol-2; js(ind+6)=dFvdzpr./dFvdv;
    ji(ind+7)=6:3:nrow-3; jj(ind+7)=8:3:ncol-1; js(ind+7)=dFvdznr./dFvdv;
    ji(ind+8)=6:3:nrow-3; jj(ind+8)=9:3:ncol;   js(ind+8)=dFvdvr./dFvdv;
    
    % rhs
    if setvac == 1
        F(4:3:nrow-5)=0;
        F(5:3:nrow-4)=0;
        F(6:3:nrow-3)=0;
    elseif setgac == 1
        F(4:3:nrow-5)=-(hl/2.*Gacl(2:nnodes-1)+hr/2.*Gacr(1:nnodes-2))./dFpdzp;
        F(5:3:nrow-4)=(hl/2.*Gacl(2:nnodes-1)+hr/2.*Gacr(1:nnodes-2))./dFndzn;
        F(6:3:nrow-3)=0;
    else 
        F(4:3:nrow-5)=Fp./dFpdzp;
        F(5:3:nrow-4)=Fn./dFndzn;
        F(6:3:nrow-3)=Fv./dFvdv;
    end
%end

% last node
if strcmp(dev.bc.bottom.neq_bc,'ideal') == 1
  
    pc=dev.ele.pro(nnodes-1);
    nc=dev.ele.nro(nnodes-1);
    vc=dev.node.vo(nnodes); % voltages applied at first node only
       
    p=dev.ele.pr(nnodes-1);
    n=dev.ele.nr(nnodes-1);
    v=dev.node.v(nnodes);
    
    % pp=dpdzp
      pp=p;
    % nn=dndzn
      nn=n;
    
    Fp=p-pc;
    Fn=n-nc;
    Fv=v-vc;
    dFpdzpl=0;
    dFpdznl=0;
    dFpdvl=0;
    dFpdzp=pp;
    dFpdzn=0;
    dFpdv=0;
    dFndzpl=0;
    dFndznl=0;
    dFndvl=0;
    dFndzp=0;
    dFndzn=nn;
    dFndv=0;
    dFvdzpl=0;
    dFvdznl=0;
    dFvdvl=0;
    dFvdzp=0;
    dFvdzn=0;
    dFvdv=1;

elseif strcmp(dev.bc.bottom.neq_bc,'non-ideal') == 1

    po2=dev.ele.pro(nnodes-1);
    no2=dev.ele.nro(nnodes-1);
    vc=dev.node.vo(nnodes); % voltages applied at first node only
    
    p1=dev.ele.pl(nnodes-1);
    n1=dev.ele.nl(nnodes-1);
    v1=dev.node.v(nnodes-1);   
    
    p2=dev.ele.pr(nnodes-1);
    n2=dev.ele.nr(nnodes-1);
    v2=dev.node.v(nnodes);
    
    vp1=values.vpl(nnodes-1);
    dvp1dp1=derivs.dvpldpl(nnodes-1);
    vp2=values.vpr(nnodes-1);
    dvp2dp2=derivs.dvprdpr(nnodes-1);
    vn1=values.vnl(nnodes-1);
    dvn1dn1=derivs.dvnldnl(nnodes-1);
    vn2=values.vnr(nnodes-1);
    dvn2dn2=derivs.dvnrdnr(nnodes-1);
      
    % get mesh spacing
    hw=dev.ele.h(nnodes-1);
      
    upw=0.5*(values.upl(nnodes-1)+values.upr(nnodes-1));
    unw=0.5*(values.unl(nnodes-1)+values.unr(nnodes-1));
    
    ksw=0.5*(values.ksl(nnodes-1)+values.ksr(nnodes-1));
      
    dvw=(v2-vp2)-(v1-vp1);
    [jpw,djpwdp1,djpwdp2,djpwddvw]=a_jp(hw,upw,p1,p2,dvw);
    djpwdv2=djpwddvw;
    djpwdv1=-djpwddvw;
    djpwdvp2=-djpwddvw;
    djpwdvp1=djpwddvw;
    djpwdzp2=(djpwdp2+djpwdvp2.*dvp2dp2).*p2;
    djpwdzp1=(djpwdp1+djpwdvp1.*dvp1dp1).*p1;
      
    dvw=(v2+vn2)-(v1+vn1);
    [jnw,djnwdn1,djnwdn2,djnwddvw]=a_jn(hw,unw,n1,n2,dvw);
    djnwdv2=djnwddvw;
    djnwdv1=-djnwddvw;
    djnwdvn2=djnwddvw;
    djnwdvn1=-djnwddvw;
    djnwdzn2=(djnwdn2+djnwdvn2.*dvn2dn2).*n2;
    djnwdzn1=(djnwdn1+djnwdvn1.*dvn1dn1).*n1;
    
    sp=dev.bc.bottom.sp/dev.norm.s;
    sn=dev.bc.bottom.sn/dev.norm.s;

    if sp == inf
        Fp=p2-po2;
        dFpdzpl=0;
        dFpdznl=0;
        dFpdvl=0;
        dFpdzp=p2;
        dFpdzn=0;
        dFpdv=0;
    else
        Fp=jpw-sp*(p2-po2);
        dFpdzpl=djpwdzp1;
        dFpdznl=0;
        dFpdvl=djpwdv1;
        dFpdzp=djpwdzp2-sp*p2;
        dFpdzn=0;
        dFpdv=djpwdv2;
    end
    if sn == inf
        Fn=n2-no2;
        dFndzpl=0;
        dFndznl=0;
        dFndvl=0;
        dFndzp=0;
        dFndzn=n2;
        dFndv=0;
    else
        Fn=jnw+sn*(n2-no2);
        dFndzpl=0;
        dFndznl=djnwdzn1;
        dFndvl=djnwdv1;
        dFndzp=0;
        dFndzn=djnwdzn2+sn*n2;
        dFndv=djnwdv2;
    end
    Fv=v2-vc;
    dFvdzpl=0;
    dFvdznl=0;
    dFvdvl=0;
    dFvdzp=0;
    dFvdzn=0;
    dFvdv=1;

else
    error('a_compute_jac_neq_1d: Undefined BC')
end

% modify if w > 0 (reference node for voltage)
if w > 0
    Fv=0;
    dFvdzp=0;
    dFvdzn=0;
    dFvdv=1;
    dFvdzpl=0;
    dFvdznl=0;
    dFvdvl=0; 
end

% last 3 rows of Jacobi matrix 
ji(njs-17:njs-12)=nrow-2;
jj(njs-17:njs-12)=ncol-5:ncol;
ji(njs-11:njs-6)=nrow-1;
jj(njs-11:njs-6)=ncol-5:ncol;
ji(njs-5:njs)=nrow;
jj(njs-5:njs)=ncol-5:ncol;
js(njs-17)=dFpdzpl/dFpdzp;
js(njs-16)=dFpdznl/dFpdzp;
js(njs-15)=dFpdvl/dFpdzp;
js(njs-14)=1;
js(njs-13)=dFpdzn/dFpdzp;
js(njs-12)=dFpdv/dFpdzp;
js(njs-11)=dFndzpl/dFndzn;
js(njs-10)=dFndznl/dFndzn;
js(njs-9)=dFndvl/dFndzn;
js(njs-8)=dFndzp/dFndzn;
js(njs-7)=1;
js(njs-6)=dFndv/dFndzn;
js(njs-5)=dFvdzpl/dFvdv;
js(njs-4)=dFvdznl/dFvdv;
js(njs-3)=dFvdvl/dFvdv;
js(njs-2)=dFvdzp/dFvdv;
js(njs-1)=dFvdzn/dFvdv;
js(njs)=1;

% rhs
F(nrow-2)=Fp/dFpdzp;
F(nrow-1)=Fn/dFndzn;
F(nrow)=Fv/dFvdv;

%populate sparse Jacobi matrix array
J=sparse(ji,jj,js,3*nnodes,3*nnodes);

% JJ=full(J)
% F
