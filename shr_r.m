function [vals derivs] = shr_r(flag,fd,in)
% charge associated with traps is assumed to be negligible
% recombination only

if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    p=in.p;
    n=in.n;
    po=in.po;
    no=in.no;
    Nv=in.nv;
    Nc=in.nc;
    et=in.et;
    taup=in.taup;
    taun=in.taun;
    Nvt=in.nvt;
    Nct=in.nct;
    vals.R(1:length(in.p))=0;
    derivs.dRdp(1:length(in.p))=0;
    derivs.dRdn(1:length(in.p))=0;
      
      if strcmp(fd,'off') % Boltzmann
          etao=log(no./Nc);
      else % Fermi-Dirac   
          etao=rez_fermi(no./Nc);
      end
      ez=exp(etao+et);
      pto=max(eps,1./(1+ez));
      nto=max(eps,ez./(1+ez)); %nto=Nt-pto;
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
      numr=p.*n-p1.*n1;
      dnom=(p+p1).*taun+(n+n1).*taup;
      vals.R=vals.R+numr./dnom;
      if strcmp(flag,'neq')
          if Nvt == inf
              dBdp=0;
          else
              dBdp=-1./(Nvt-po);
          end
          if Nct == inf
              dAdn=0;
          else
              dAdn=-1./(Nct-no);
          end
          dnumrdp=n-p1.*dBdp./B.*n1;
          dnumrdn=p-p1.*n1.*dAdn./A;
          ddnomdp=(1+p1.*dBdp./B).*taun;
          ddnomdn=(1+n1.*dAdn./A).*taup;
          derivs.dRdp=derivs.dRdp-numr./dnom./dnom.*ddnomdp+dnumrdp./dnom;
          derivs.dRdn=derivs.dRdn-numr./dnom./dnom.*ddnomdn+dnumrdn./dnom;
      end
else
    error('shr_r: @%$##&!')
end