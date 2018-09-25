function [vals derivs] = slt_a(flag,fd,in)
% acceptor-like single level trap
% filled traps are negatively charged
% et = (Et'-Ev)/kT
% eta = (Ev-Fp)/kT

sml=realmin^(1/4);
nt_last=in.nt_last;

if strcmp(flag,'eq') || strcmp(flag,'eqvals')
    po=in.p;
    no=in.n;
    Nv=in.nv;
    Nc=in.nc;
    Nt=in.Nt;
    et=in.et;
    if strcmp(fd,'off') % Boltzmann
        etao=log(po./Nv);    
    else % Fermi-Dirac
        etao=rez_fermi(po./Nv);
    end
    ez=exp(etao+et);
    nto=Nt./(1+ez);
    vals.nt=nto;
    vals.qt=-nto;
    if strcmp(flag,'eq')
       if strcmp(fd,'off') % Boltzmann
           detaodp=1./po;    
       else % Fermi-Dirac
           detaodp=1./Nv./fermi(etao,-1/2);
       end
       derivs.dqtdp(1:length(nto))=0;
       derivs.dqtdn(1:length(nto))=0;
       derivs.dqtdp(Nt>0)=nto(Nt>0).*nto(Nt>0)./Nt(Nt>0).*exp(etao(Nt>0)+et(Nt>0)).*detaodp(Nt>0);
    end
elseif strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    rdt=in.rdt; %reciprocal time step
    rdtold=in.rdtold; %reciprocal time step
    p=in.p;
    n=in.n;
    po=in.po;
    no=in.no;
    Nv=in.nv;
    Nc=in.nc;
    Nt=in.Nt;
    et=in.et;
    cp=in.cp.*in.vthp;
    cn=in.cn.*in.vthn;
    Nvt=in.nvt;
    Nct=in.nct;    
    if strcmp(fd,'off') % Boltzmann
        etao=log(po./Nv);    
    else % Fermi-Dirac   
        etao=rez_fermi(po./Nv);
    end
    ez=exp(etao+et);
    nto=Nt./(1+ez);
    pto=Nt.*ez./(1+ez); %pto=Nt-nto;
    if Nct == inf
        A=1;
    else
        A=(Nct-n)./(Nct-no);
    end
    if Nvt == inf
        B=1;
    else
        B=(Nvt-p)./(Nvt-po);
    end
    p1=B.*nto.*po./pto;
    n1=A.*pto.*no./nto;
    if rdt > 0 
        [rdt_eff,nt_last_eff]=a_bdf_nt(nt_last,rdt,rdtold);
        if min(nt_last_eff) < 0
            %fprintf('nt_last_eff < 0, try smaller timestep\n')
            nt_last_eff(nt_last_eff<0)=sml;
        elseif min(Nt-nt_last_eff) < 0
            %fprintf('nt_last_eff > Nt, try smaller timestep\n')
            nt_last_eff((Nt-nt_last_eff)<0)=Nt((Nt-nt_last_eff)<0);
        end
    else
        rdt_eff=0;
        nt_last_eff=0;
    end
    numer=Nt.*(cn.*n+cp.*p1)+rdt_eff*nt_last_eff;
    denom=cn.*(n+n1)+cp.*(p+p1)+rdt_eff;
    nt=min(Nt,numer./denom);
    pt=Nt-nt;
    vals.nt=nt;
    vals.qt=-nt;
    numr=Nt.*(p.*n-p1.*n1);
    dnom=(p+p1)./cn+(n+n1)./cp;
    R=numr./dnom;
    vals.Rp=R;
    vals.Rn=R;
    if strcmp(flag,'neq')
        if Nvt == inf
            dp1dp=0;
        else
            dp1dp=-p1./(Nvt-po)./B;
        end
        if Nct == inf
            dn1dn=0;
        else
            dn1dn=-n1./(Nct-no)./A;
        end
      if in.omega == 0
        dntdn=-numer./denom./denom.*cn.*(1+dn1dn)+Nt.*cn./denom;
        dntdp=-numer./denom./denom.*cp.*(1+dp1dp)+Nt.*cp.*dp1dp./denom;
        derivs.dqtdn=-dntdn;
        derivs.dqtdp=-dntdp;
        dnumrdp=Nt.*(n-dp1dp.*n1);
        dnumrdn=Nt.*(p-p1.*dn1dn);
        ddnomdp=(1+dp1dp)./cn;
        ddnomdn=(1+dn1dn)./cp;
        derivs.dRpdp=-numr./dnom./dnom.*ddnomdp+dnumrdp./dnom;
        derivs.dRpdn=-numr./dnom./dnom.*ddnomdn+dnumrdn./dnom;
        derivs.dRndp=derivs.dRpdp;
        derivs.dRndn=derivs.dRpdn;
        if rdt > 0 % transient -- modify Rp and Rn
            dntdt=(nt-nt_last_eff)*rdt_eff;
            vals.Rp=vals.Rp-cp.*(p+p1)./dnom.*dntdt;
            vals.Rn=vals.Rn+cn.*(n+n1)./dnom.*dntdt;
            dRpp=cp./dnom.*dntdt-cp.*(p+p1)./dnom./dnom.*ddnomdp.*dntdt+cp.*(p+p1)./dnom.*rdt_eff.*dntdp;
            dRpn=-cp.*(p+p1)./dnom./dnom.*ddnomdn.*dntdt+cp.*(p+p1)./dnom.*rdt_eff.*dntdn;
            dRnn=cn./dnom.*dntdt+cn.*(n+n1)./dnom./dnom.*ddnomdn.*dntdt+cn.*(n+n1)./dnom.*rdt_eff.*dntdn;
            dRnp=cn.*(n+n1)./dnom./dnom.*ddnomdp.*dntdt+cn.*(n+n1)./dnom.*rdt_eff.*dntdp;
            derivs.dRpdp=derivs.dRpdp-dRpp;
            derivs.dRpdn=derivs.dRpdn-dRpn;
            derivs.dRndn=derivs.dRndn+dRnn;
            derivs.dRndp=derivs.dRndp+dRnp;
        end
      else % use for small signal 
        vals.Rp=cp.*[nt.*p-p1.*pt];
        vals.Rn=cn.*[pt.*n-n1.*nt];
        dntdn=-numer./denom./denom.*cn.*(1+dn1dn)+Nt.*cn./denom;
        dntdp=-numer./denom./denom.*cp.*(1+dp1dp)+Nt.*cp.*dp1dp./denom;
        dptdn=-dntdn;
        dptdp=-dntdp;
        derivs.dqtdn=-dntdn;
        derivs.dqtdp=-dntdp;
        derivs.dRpdp=cp.*[nt+p.*dntdp-p1.*dptdp-pt.*dp1dp];
        derivs.dRpdn=cp.*[p.*dntdn-p1.*dptdn];
        derivs.dRndp=cn.*[n.*dptdp-n1.*dntdp];
        derivs.dRndn=cn.*[pt+n.*dptdn-n1.*dntdn-nt.*dn1dn];
      end
    end
else
    error('slt_a: @%$##&!')
end