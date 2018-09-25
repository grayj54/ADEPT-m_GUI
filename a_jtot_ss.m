function [jtotal,jp,jn,Rint,Gint]=a_jtot_ss(dev,pflag)
% steady-state only
% current flows in the positive x direction

n=dev.mesh.num_nod;
ne=n-1;
Gh(1:2*ne)=0;
Rh(1:2:ne)=0;
Rint=0;
Gint=0;

values=a_get_params(dev,'vals');

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
upn=0.5*(values.upl(n-1)+values.upr(n-1));

un1=0.5*(values.unl(1)+values.unr(1));
unn=0.5*(values.unl(n-1)+values.unr(n-1));

Ril(2:n-1)=values.Rpr(1:n-2); % Rp=Rn in steady-state
Rir(2:n-1)=values.Rpl(2:n-1);

Gil(2:n-1)=values.Gr(1:n-2);
Gir(2:n-1)=values.Gl(2:n-1);

Gsum=sum(0.5*(h(1:n-2).*Gil(2:n-1)+h(2:n-1).*Gir(2:n-1)));
Rsum=sum(0.5*(h(1:n-2).*Ril(2:n-1)+h(2:n-1).*Rir(2:n-1)));

% method requires minority currents at ends
if p1 > n1

    dv=(v2+vn2)-(v1+vn1);
    jn0=a_jn(h1,un1,n1,n2,dv);
    dv=(vn-vpn)-(vnm1-vpnm1);
    jpw=a_jp(hnm1,upn,pnm1,pn,dv);
    jtotal=(jn0+jpw-Gsum+Rsum);
    
    if pflag
        Gh(1:2:2*ne-1)=0.5*h(1:ne).*values.Gl(1:ne);
        Gh(2:2:2*ne)=0.5*h(1:ne).*values.Gr(1:ne);
        Rh(1:2:2*ne-1)=0.5*h(1:ne).*values.Rpl(1:ne);
        Rh(2:2:2*ne)=0.5*h(1:ne).*values.Rpr(1:ne);
        Gint(1)=0;
        Rint(1)=jn0;
        for ii=2:2*ne
            Gint(ii)=Gint(ii-1)+Gh(ii-1);
            Rint(ii)=Rint(ii-1)+Rh(ii-1);
        end
        Gint(2*ne+1)=Gint(2*ne)+Gh(2*ne);
        Rint(2*ne+1)=Rint(2*ne)+jpw;

        jn(1)=jn0;
        for ii=2:ne
            jn(ii)=jn(ii-1)-Gh(2*(ii-1))-Gh(2*(ii-1)+1)+Rh(2*(ii-1))+Rh(2*(ii-1)+1);
        end
        jp=jtotal-jn;
    end
else

    dv=(vn+vnn)-(vnm1+vnnm1);
    jnw=a_jn(hnm1,unn,nnm1,nn,dv);
    dv=(v2-vp2)-(v1-vp1);
    jp0=a_jp(h1,up1,p1,p2,dv);
    jtotal=(jp0+jnw+Gsum-Rsum);
    
    if pflag
        Gh(1:2:2*ne-1)=0.5*h(1:ne).*values.Gl(1:ne);
        Gh(2:2:2*ne)=0.5*h(1:ne).*values.Gr(1:ne);
        Rh(1:2:2*ne-1)=0.5*h(1:ne).*values.Rpl(1:ne);
        Rh(2:2:2*ne)=0.5*h(1:ne).*values.Rpr(1:ne);
        Gint(1)=0;
        Rint(1)=-jp0;
        for ii=2:2*ne
            Gint(ii)=Gint(ii-1)+Gh(ii-1);
            Rint(ii)=Rint(ii-1)+Rh(ii-1);
        end
        Gint(2*ne+1)=Gint(2*ne)+Gh(2*ne);
        Rint(2*ne+1)=Rint(2*ne)-jnw;

        jp(1)=jp0;
        for ii=2:ne
            jp(ii)=jp(ii-1)+Gh(2*(ii-1))+Gh(2*(ii-1)+1)-Rh(2*(ii-1))-Rh(2*(ii-1)+1);
        end
        jn=jtotal-jp;
    end
end
