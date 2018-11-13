function [jno,djndn1,djndn2,djnddv]=a_jn(h,un,n1,n2,dv)

%compute terms so division by zero is avoided
%if abs(dv)<1e-10
%    evn=1-dv;
%    tn=-1;
%    ttn=n2;
%else
%    evn=exp(-dv);
%    tn=dv./(evn-1);
%    ttn=(n2.*evn-n1)./(evn-1);
%end
z=(abs(dv)<1.e-10);
x=(abs(dv)>=1.e-10);
evn(z)=1-dv(z);
tn(z)=-1;
ttn(z)=n2(z);
evn(x)=exp(-dv(x));
tn(x)=dv(x)./(evn(x)-1);
ttn(x)=(n2(x).*evn(x)-n1(x))./(evn(x)-1);
%compute current derivatives
%djn/dn1
djndn1=un./h.*tn;

%djp/dp2
djndn2=-un./h.*evn.*tn;

%djp/ddv
djnddv=-un./h.*(ttn-evn.*tn.*(n2-ttn));

%compute current
jno=-un./h.*(n2.*evn-n1).*tn;

end