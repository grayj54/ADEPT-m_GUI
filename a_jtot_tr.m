function [jtotal,Jp,Jn,Jd,Rpint,Rnint,Gint]=a_jtot_tr(dev,pflag)
% transient
% current flows in the positive x direction

rdt=dev.OpCond.rdt;
rdtold=dev.OpCond.rdtold;
n=dev.mesh.num_nod;
ne=n-1;

values=a_get_params(dev,'vals');

h=dev.ele.h;

v=dev.node.v;

if rdt > 0
vold(1,:)=dev.node.vold(1,:);
zpold(1,:)=dev.node.zpold(1,:);
znold(1,:)=dev.node.znold(1,:);
if rdtold > 0
    vold(2,:)=dev.node.vold(2,:);
    zpold(2,:)=dev.node.zpold(2,:);
    znold(2,:)=dev.node.znold(2,:);
end
end

vpl=values.vpl;
vpr=values.vpr;
vnl=values.vnl;
vnr=values.vnr;

up1=0.5*(values.upl(1)+values.upr(1));
upn=0.5*(values.upl(n-1)+values.upr(n-1));

un1=0.5*(values.unl(1)+values.unr(1));
unn=0.5*(values.unl(n-1)+values.unr(n-1));

Rpl=values.Rpl;
Rpr=values.Rpr;
Rnl=values.Rnl;
Rnr=values.Rnr;

Gl=values.Gl;
Gr=values.Gr;

pl=dev.ele.pl;
pr=dev.ele.pr;
zp=dev.node.zp;
nl=dev.ele.nl;
nr=dev.ele.nr;
zn=dev.node.zn;

if rdt > 0
    dzpdt=a_bdf(zp,zpold,rdt,rdtold);
    dpldt(1:n-1)=pl(1:n-1).*dzpdt(1:n-1);
    dprdt(1:n-1)=pr(1:n-1).*dzpdt(2:n);

    dzndt=a_bdf(zn,znold,rdt,rdtold);
    dnldt(1:n-1)=nl(1:n-1).*dzndt(1:n-1);
    dnrdt(1:n-1)=nr(1:n-1).*dzndt(2:n);
else
    dpldt(1:n-1)=0;
    dprdt(1:n-1)=0;
    dnldt(1:n-1)=0;
    dnrdt(1:n-1)=0;
end

dpndtsum=sum(0.5*(h(1:n-2).*(dpldt(2:n-1)+dnldt(2:n-1))+h(2:n-1).*(dprdt(2:n-1)+dnrdt(2:n-1))));


% method requires minority currents at ends
if pl(1) > nl(1)

    Gcumf(1)=0;
    Rncum(1)=0;
    dndtcum(1)=0;
    Gcumf(2:n-1)=cumsum(0.5*(h(1:n-2).*Gr(1:n-2)+h(2:n-1).*Gl(2:n-1)));
    Rncum(2:n-1)=cumsum(0.5*(h(1:n-2).*Rnr(1:n-2)+h(2:n-1).*Rnl(2:n-1)));
    dndtcum(2:n-1)=cumsum(0.5*(h(1:n-2).*dnrdt(1:n-2)+h(2:n-1).*dnldt(2:n-1)));
    dv=(v(2)+vnr(1))-(v(1)+vnl(1));
    jn0=a_jn(h(1),un1,nl(1),nr(1),dv);
    Jn=jn0-(Gcumf-Rncum-dndtcum);
    
    Gcumr(n-1)=0;
    Rpcum(n-1)=0;
    dpdtcum(n-1)=0;
    Gcumr(1:n-2)=cumsum(0.5*(h(1:n-2).*Gr(1:n-2)+h(2:n-1).*Gl(2:n-1)),'reverse');
    Rpcum(1:n-2)=cumsum(0.5*(h(1:n-2).*Rpr(1:n-2)+h(2:n-1).*Rpl(2:n-1)),'reverse');
    dpdtcum(1:n-2)=cumsum(0.5*(h(1:n-2).*dprdt(1:n-2)+h(2:n-1).*dpldt(2:n-1)),'reverse');
    dv=(v(n)-vpr(n-1))-(v(n-1)-vpl(n-1));
    jpW=a_jp(h(n-1),upn,pl(n-1),pr(n-1),dv);
    Jp=jpW+(Gcumr-Rpcum-dpdtcum);

else

    Gcumf(1)=0;
    Rpcum(1)=0;
    dpdtcum(1)=0;
    Gcumf(2:n-1)=cumsum(0.5*(h(1:n-2).*Gr(1:n-2)+h(2:n-1).*Gl(2:n-1)));
    Rpcum(2:n-1)=cumsum(0.5*(h(1:n-2).*Rpr(1:n-2)+h(2:n-1).*Rpl(2:n-1)));
    dpdtcum(2:n-1)=cumsum(0.5*(h(1:n-2).*dprdt(1:n-2)+h(2:n-1).*dpldt(2:n-1)));
    dv=(v(2)-vpr(1))-(v(1)-vpl(1));
    jp0=a_jp(h(1),up1,pl(1),pr(1),dv);
    Jp=jp0+(Gcumf-Rpcum-dpdtcum);
    
    Gcumr(n-1)=0;
    Rncum(n-1)=0;
    dndtcum(n-1)=0;
    Gcumr(1:n-2)=cumsum(0.5*(h(1:n-2).*Gr(1:n-2)+h(2:n-1).*Gl(2:n-1)),'reverse');
    Rncum(1:n-2)=cumsum(0.5*(h(1:n-2).*Rnr(1:n-2)+h(2:n-1).*Rnl(2:n-1)),'reverse');
    dv=(v(n)+vnr(n-1))-(v(n-1)+vnl(n-1));
    dndtcum(1:n-2)=cumsum(0.5*(h(1:n-2).*dnrdt(1:n-2)+h(2:n-1).*dnldt(2:n-1)),'reverse');
    jnW=a_jn(h(n-1),unn,nl(n-1),nr(n-1),dv);
    Jn=jnW+(Gcumr-Rncum-dndtcum);

end

if rdt > 0
    ks=0.5*(values.ksl+values.ksr);
    Dfield=-ks.*(v(2:n)-v(1:n-1))./h;
    Dfield_old(1,1:n-1)=-ks.*(vold(1,2:n)-vold(1,1:n-1))./h;
    if rdtold > 0
        Dfield_old(2,1:n-1)=-ks.*(vold(2,2:n)-vold(2,1:n-1))./h;
    end
    jd=a_bdf(Dfield,Dfield_old,rdt,rdtold);
    % find max displacement current and use to get total current
    [~,im]=max(abs(jd));
    jtotal=Jp(im)+Jn(im)+jd(im);
    Jd=jtotal-Jp-Jn;
else
    Jd(1:ne)=0;
    jtotal=Jp(1)+Jn(1);
end

if pflag
    Gh(1:2:2*ne-1)=0.5*h(1:ne).*Gl(1:ne);
    Gh(2:2:2*ne)=0.5*h(1:ne).*Gr(1:ne);
    Rph(1:2:2*ne-1)=0.5*h(1:ne).*Rpl(1:ne);
    Rph(2:2:2*ne)=0.5*h(1:ne).*Rpr(1:ne);
    Rnh(1:2:2*ne-1)=0.5*h(1:ne).*Rnl(1:ne);
    Rnh(2:2:2*ne)=0.5*h(1:ne).*Rnr(1:ne);
    Gint(1:2*ne+1)=0;
    Rpint(1:2*ne+1)=0;
    Rnint(1:2*ne+1)=0;
    Rpint(1)=-Jp(1);
    Rnint(1)=Jn(1);
    for ii=2:2*ne
        Gint(ii)=Gint(ii-1)+Gh(ii-1);
        Rpint(ii)=Rpint(ii-1)+Rph(ii-1);
        Rnint(ii)=Rnint(ii-1)+Rnh(ii-1);
    end
    Gint(2*ne+1)=Gint(2*ne)+Gh(2*ne);
    Rpint(2*ne+1)=Rpint(2*ne)+Jp(ne);
    Rnint(2*ne+1)=Rpint(2*ne)-Jn(ne);
end
