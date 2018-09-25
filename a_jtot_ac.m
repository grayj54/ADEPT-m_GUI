function [jtac,jp_ac,jn_ac,jd_ac,ql_ac,qr_ac,Rpl_ac,Rpr_ac,Rnl_ac,Rnr_ac]=a_jtot_ac(dev)
% steady-state only
% current flows in the positive x direction
global M_OR_O

[values,derivs]=a_get_params(dev,'neq');

n=dev.mesh.num_nod;

h=dev.ele.h;
h1=h(1);
hnm1=h(n-1);

v1=dev.node.v(1);
v2=dev.node.v(2);
vnm1=dev.node.v(n-1);
vn=dev.node.v(n);

p1=dev.ele.pl(1);
p2=dev.ele.pr(1);
pnm1=dev.ele.pl(n-1);
pn=dev.ele.pr(n-1);

n1=dev.ele.nl(1);
n2=dev.ele.nr(1);
nnm1=dev.ele.nl(n-1);
nn=dev.ele.nr(n-1);

vp1=values.vpl(1);
vp2=values.vpr(1);
vpnm1=values.vpl(n-1);
vpn=values.vpr(n-1);

vn1=values.vnl(1);
vn2=values.vnr(1);
vnnm1=values.vnl(n-1);
vnn=values.vnr(n-1);

up1=0.5*(values.upl(1)+values.upr(1));
upnm1=0.5*(values.upl(n-1)+values.upr(n-1));

un1=0.5*(values.unl(1)+values.unr(1));
unnm1=0.5*(values.unl(n-1)+values.unr(n-1));

Rpl_ac=derivs.dRprdpr.*dev.ele.pr_ac+derivs.dRprdnr.*dev.ele.nr_ac;
Rpr_ac=derivs.dRpldpl.*dev.ele.pl_ac+derivs.dRpldnl.*dev.ele.nl_ac;
Rnl_ac=derivs.dRnrdnr.*dev.ele.nr_ac+derivs.dRnrdpr.*dev.ele.pr_ac;
Rnr_ac=derivs.dRnldnl.*dev.ele.nl_ac+derivs.dRnldpl.*dev.ele.pl_ac;

dpdtl=1i*dev.OpCond.omega*dev.ele.pl_ac;
dpdtr=1i*dev.OpCond.omega*dev.ele.pr_ac;
dndtl=1i*dev.OpCond.omega*dev.ele.nl_ac;
dndtr=1i*dev.OpCond.omega*dev.ele.nr_ac;

if strcmp(dev.OpCond.set_ac(1:3),'Gac')
    Gil=dev.ele.Gl_ac;
    Gir=dev.ele.Gr_ac;
else
    Gil(1:n-1)=0;
    Gir(1:n-1)=0;
end

if p1 > n1

    Gcumf(1)=0;
    Rncum(1)=0;
    dndtcum(1)=0;
    Gcumf(2:n-1)=cumsum(0.5*(h(1:n-2).*Gir(1:n-2)+h(2:n-1).*Gil(2:n-1)));
    Rncum(2:n-1)=cumsum(0.5*(h(1:n-2).*Rnr_ac(1:n-2)+h(2:n-1).*Rnl_ac(2:n-1)));
    dndtcum(2:n-1)=cumsum(0.5*(h(1:n-2).*dndtr(1:n-2)+h(2:n-1).*dndtl(2:n-1)));
    dv=(v2+vn2)-(v1+vn1);
    [~,djndn1,djndn2,djnddv]=a_jn(h1,un1,n1,n2,dv);
    jn_ac0=djndn1*dev.ele.nl_ac(1)+djndn2*dev.ele.nr_ac(1)+djnddv*(dev.node.v_ac(2)-dev.node.v_ac(1));
    jn_ac=jn_ac0-(Gcumf-Rncum-dndtcum);
    
    Gcumr(n-1)=0;
    Rpcum(n-1)=0;
    dpdtcum(n-1)=0;
%     if strcmp(M_OR_O,'MatLab')
%         Gcumr(1:n-2)=cumsum(0.5*(h(1:n-2).*Gir(1:n-2)+h(2:n-1).*Gil(2:n-1)),'reverse');
%         Rpcum(1:n-2)=cumsum(0.5*(h(1:n-2).*Rpr_ac(1:n-2)+h(2:n-1).*Rpl_ac(2:n-1)),'reverse');
%         dpdtcum(1:n-2)=cumsum(0.5*(h(1:n-2).*dpdtr(1:n-2)+h(2:n-1).*dpdtl(2:n-1)),'reverse');
%     else
        Gcumr(1:n-2)=fliplr(cumsum(fliplr(0.5*(h(1:n-2).*Gir(1:n-2)+h(2:n-1).*Gil(2:n-1)))));
        Rpcum(1:n-2)=fliplr(cumsum(fliplr(0.5*(h(1:n-2).*Rpr_ac(1:n-2)+h(2:n-1).*Rpl_ac(2:n-1)))));
        dpdtcum(1:n-2)=fliplr(cumsum(fliplr(0.5*(h(1:n-2).*dpdtr(1:n-2)+h(2:n-1).*dpdtl(2:n-1)))));
%     end
    dv=(vn-vpn)-(vnm1-vpnm1);
    [~,djpdpnm1,djpdpn,djpddv]=a_jp(hnm1,upnm1,pnm1,pn,dv);
    jp_acn=djpdpnm1*dev.ele.pl_ac(n-1)+djpdpn*dev.ele.pr_ac(n-1)+djpddv*(dev.node.v_ac(n)-dev.node.v_ac(n-1));
    jp_ac=jp_acn-(Gcumr-Rpcum-dpdtcum);

else

    Gcumf(1)=0;
    Rpcum(1)=0;
    dpdtcum(1)=0;
    Gcumf(2:n-1)=cumsum(0.5*(h(1:n-2).*Gir(1:n-2)+h(2:n-1).*Gil(2:n-1)));
    Rpcum(2:n-1)=cumsum(0.5*(h(1:n-2).*Rpr_ac(1:n-2)+h(2:n-1).*Rpl_ac(2:n-1)));
    dpdtcum(2:n-1)=cumsum(0.5*(h(1:n-2).*dpdtr(1:n-2)+h(2:n-1).*dpdtl(2:n-1)));
    dv=(v2-vp2)-(v1-vp1);
    [~,djpdp1,djpdp2,djpddv]=a_jp(h1,up1,p1,p2,dv);
    jp_ac0=djpdp1*dev.ele.pl_ac(1)+djpdp2*dev.ele.pr_ac(1)+djpddv*(dev.node.v_ac(2)-dev.node.v_ac(1));
    jp_ac=jp_ac0+(Gcumf-Rpcum-dpdtcum);
    
    Gcumr(n-1)=0;
    Rncum(n-1)=0;
    dndtcum(n-1)=0;
%     if strcmp(M_OR_O,'MatLab')
%         Gcumr(1:n-2)=cumsum(0.5*(h(1:n-2).*Gir(1:n-2)+h(2:n-1).*Gil(2:n-1)),'reverse');
%         Rncum(1:n-2)=cumsum(0.5*(h(1:n-2).*Rnr_ac(1:n-2)+h(2:n-1).*Rnl_ac(2:n-1)),'reverse');
%         dndtcum(1:n-2)=cumsum(0.5*(h(1:n-2).*dndtr(1:n-2)+h(2:n-1).*dndtl(2:n-1)),'reverse');
%     else
        Gcumr(1:n-2)=fliplr(cumsum(fliplr(0.5*(h(1:n-2).*Gir(1:n-2)+h(2:n-1).*Gil(2:n-1)))));
        Rncum(1:n-2)=fliplr(cumsum(fliplr(0.5*(h(1:n-2).*Rnr_ac(1:n-2)+h(2:n-1).*Rnl_ac(2:n-1)))));
        dndtcum(1:n-2)=fliplr(cumsum(fliplr(0.5*(h(1:n-2).*dndtr(1:n-2)+h(2:n-1).*dndtl(2:n-1)))));
%     end
    dv=(vn+vnn)-(vnm1+vnnm1);
    [~,djndnnm1,djndnn,djnddv]=a_jn(hnm1,unnm1,nnm1,nn,dv);
    jn_acn=djndnnm1*dev.ele.nl_ac(n-1)+djndnn*dev.ele.nr_ac(n-1)+djnddv*(dev.node.v_ac(n)-dev.node.v_ac(n-1));
    jn_ac=jn_acn+(Gcumr-Rncum-dndtcum);
    
end

ks=0.5*(values.ksl+values.ksr);
jd_ac=-1i*dev.OpCond.omega*ks.*(dev.node.v_ac(2:n)-dev.node.v_ac(1:n-1))./h;
% find max ac displacement current and use to get total current
[~,ir]=max(abs(real(jd_ac)));
real_jtac=real(jp_ac(ir))+real(jn_ac(ir))+real(jd_ac(ir));
[~,ii]=max(abs(imag(jd_ac)));
imag_jtac=imag(jp_ac(ii))+imag(jn_ac(ii))+imag(jd_ac(ii));
jtac=real_jtac+1i*imag_jtac;
jd_ac=jtac-jp_ac-jn_ac;

ql_ac=derivs.dNtldpl.*dev.ele.pl_ac+derivs.dNtldnl.*dev.ele.nl_ac;
qr_ac=derivs.dNtrdpr.*dev.ele.pr_ac+derivs.dNtrdnr.*dev.ele.nr_ac;
