function [jpo,djpdp1,djpdp2,djpddv]=a_jp(h,up,p1,p2,dv)

%compute terms so division by zero is avoided
%if abs(dv)<1e-10
%    evp=1+dv;
%    tp=1;
%    ttp=p2;
%else
%    evp=exp(dv);
%    tp=dv./(evp-1);
%    ttp=(p2.*evp-p1)./(evp-1);
%end
z=(abs(dv)<1.e-10);
x=(abs(dv)>=1.e-10);
evp(z)=1+dv(z);
tp(z)=1;
ttp(z)=p2(z);
evp(x)=exp(dv(x));
tp(x)=dv(x)./(evp(x)-1);
ttp(x)=(p2(x).*evp(x)-p1(x))./(evp(x)-1);

%compute current derivatives
%djp/dp1
djpdp1=up./h.*tp;

%djp/dp2
djpdp2=-up./h.*evp.*tp;

%djp/ddv
djpddv=-up./h.*(ttp+evp.*tp.*(p2-ttp));

%compute current
jpo=-up./h.*(p2.*evp-p1).*tp;

end