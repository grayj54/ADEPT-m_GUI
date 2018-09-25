function [data]=p_extract(dev)

nn=dev.mesh.num_nod;
ne=dev.mesh.num_ele;

% save thermal voltage/energy
data.kTq=dev.norm.v;
data.fd=dev.misc.fdflag;

% get node parameters
data.NODE.X=dev.node.pos;
data.NODE.V=dev.node.v*dev.norm.v;
data.NODE.ZP=dev.node.zp*dev.norm.v;
data.NODE.ZN=dev.node.zn*dev.norm.v;
data.NODE.VO=dev.node.vo*dev.norm.v;
data.NODE.ZPO=dev.node.zpo*dev.norm.v;
data.NODE.ZNO=dev.node.zno*dev.norm.v;

% get parameters with single value in element
[jp,jn,jd,Rpint,Rnint,Gint]=p_get_currents(dev);
jp=jp*dev.norm.j;
jn=jn*dev.norm.j;
jd=jd*dev.norm.j;
Rpint=Rpint*dev.norm.j;
Rnint=Rnint*dev.norm.j;
Gint=Gint*dev.norm.j;
[data.ELE1.X,data.ELE1.Jp]=a_pdata(data.NODE.X,jp,1);
[~,data.ELE1.Jn]=a_pdata(data.NODE.X,jn,0);
[~,data.ELE1.Jd]=a_pdata(data.NODE.X,jd,0);
dv=(dev.node.v(1:nn-1)-dev.node.v(2:nn))*dev.norm.v;
dx=(dev.node.pos(2:nn)-dev.node.pos(1:nn-1));
E(1:ne)=dv./dx;
[~,data.ELE1.E]=a_pdata(data.NODE.X,E,0);
kks=0.5*(dev.ele.ksl+dev.ele.ksr)*dev.norm.ks;
D(1:ne)=dev.const.e0*kks.*E;
[~,data.ELE1.D]=a_pdata(data.NODE.X,D,0);
dvo=(dev.node.vo(1:nn-1)-dev.node.vo(2:nn))*dev.norm.v;
Eo(1:ne)=dvo./dx;
[~,data.ELE1.Eo]=a_pdata(data.NODE.X,Eo,0);
Do(1:ne)=dev.const.e0*kks.*Eo;
[~,data.ELE1.Do]=a_pdata(data.NODE.X,Do,0);

% Rint and Gint
xi(1:nn)=dev.node.pos;
xi(nn+1:2*ne+1)=(dev.node.pos(1:nn-1)+dev.node.pos(2:nn))/2;
data.INT.X=sort(xi);
xi=data.INT.X;
data.INT.RPINT=Rpint*dev.norm.rg;
data.INT.RNINT=Rnint*dev.norm.rg;
data.INT.GINT=Gint*dev.norm.rg;

% get parameters with L/R values in element
P(1:2:2*ne-1)=dev.ele.pl(1:ne)*dev.norm.n;
P(2:2:2*ne)=dev.ele.pr(1:ne)*dev.norm.n;
[data.ELE2.X,data.ELE2.P]=a_pdata(xi,P,1);
PO(1:2:2*ne-1)=dev.ele.plo(1:ne)*dev.norm.n;
PO(2:2:2*ne)=dev.ele.pro(1:ne)*dev.norm.n;
[~,data.ELE2.PO]=a_pdata(xi,PO,0);
N(1:2:2*ne-1)=dev.ele.nl(1:ne)*dev.norm.n;
N(2:2:2*ne)=dev.ele.nr(1:ne)*dev.norm.n;
[~,data.ELE2.N]=a_pdata(xi,N,0);
NO(1:2:2*ne-1)=dev.ele.nlo(1:ne)*dev.norm.n;
NO(2:2:2*ne)=dev.ele.nro(1:ne)*dev.norm.n;
[~,data.ELE2.NO]=a_pdata(xi,NO,0);

values=a_get_params(dev,'plot');

% fundamental parameters
VP=values.VP(1:2*ne);
[~,data.ELE2.VP]=a_pdata(xi,VP,0);
VN=values.VN(1:2*ne);
[~,data.ELE2.VN]=a_pdata(xi,VN,0);
KS=values.KS(1:2*ne);
[~,data.ELE2.KS]=a_pdata(xi,KS,0);
NTO(1:2:2*ne-1)=dev.ele.ntlo*dev.norm.n;
NTO(2:2:2*ne)=dev.ele.ntro*dev.norm.n;
[~,data.ELE2.NTO]=a_pdata(xi,NTO,0);
NT=values.NT(1:2*ne);
[~,data.ELE2.NT]=a_pdata(xi,NT,0);
UP=values.UP(1:2*ne);
[~,data.ELE2.UP]=a_pdata(xi,UP,0);
UN=values.UN(1:2*ne);
[~,data.ELE2.UN]=a_pdata(xi,UN,0);
RP=ppos(values.RP(1:2*ne));
[~,data.ELE2.RP]=a_pdata(xi,RP,0);
RN=ppos(values.RN(1:2*ne));
[~,data.ELE2.RN]=a_pdata(xi,RN,0);
G=ppos(values.G(1:2*ne));
[~,data.ELE2.G]=a_pdata(xi,G,0);
% band parameters
CHI=values.CHI(1:2*ne);
[~,data.ELE2.CHI]=a_pdata(xi,CHI,0);
EG=values.EG(1:2*ne);
[~,data.ELE2.EG]=a_pdata(xi,EG,0);
NC=values.NC(1:2*ne);
[~,data.ELE2.NC]=a_pdata(xi,NC,0);
NV=values.NV(1:2*ne);
[~,data.ELE2.NV]=a_pdata(xi,NV,0);
% trap/recombination parameters
NDP=values.NDP(1:2*ne);
[~,data.ELE2.NDP]=a_pdata(xi,NDP,0);
NAM=values.NAM(1:2*ne);
[~,data.ELE2.NAM]=a_pdata(xi,NAM,0);
R_RAD=ppos(values.R_RAD(1:2*ne));
[~,data.ELE2.R_RAD]=a_pdata(xi,R_RAD,0);
R_AUGER=ppos(values.R_AUGER(1:2*ne));
[~,data.ELE2.R_AUGER]=a_pdata(xi,R_AUGER,0);
R_SHR=ppos(values.R_SHR(1:2*ne));
[~,data.ELE2.R_SHR]=a_pdata(xi,R_SHR,0);
ND=values.ND(:,1:2*ne);
[~,data.ELE2.ND]=a_pdata(xi,ND,0);
ND_ionized=values.ND_ionized(1:2*ne);
[~,data.ELE2.ND_ionized]=a_pdata(xi,ND_ionized,0);
RP_ND=ppos(values.RP_ND(1:2*ne));
[~,data.ELE2.RP_ND]=a_pdata(xi,RP_ND,0);
RN_ND=ppos(values.RN_ND(1:2*ne));
[~,data.ELE2.RN_ND]=a_pdata(xi,RN_ND,0);
NA=values.NA(1:2*ne);
[~,data.ELE2.NA]=a_pdata(xi,NA,0);
NA_ionized=values.NA_ionized(1:2*ne);
[~,data.ELE2.NA_ionized]=a_pdata(xi,NA_ionized,0);
RP_NA=ppos(values.RP_NA(1:2*ne));
[~,data.ELE2.RP_NA]=a_pdata(xi,RP_NA,0);
RN_NA=ppos(values.RN_NA(1:2*ne));
[~,data.ELE2.RN_NA]=a_pdata(xi,RN_NA,0);
RP_SLT=ppos(values.RP_SLT(1:2*ne));
[~,data.ELE2.RP_SLT]=a_pdata(xi,RP_SLT,0);
RN_SLT=ppos(values.RN_SLT(1:2*ne));
[~,data.ELE2.RN_SLT]=a_pdata(xi,RN_SLT,0);
Q_SLT=values.Q_SLT(1:2*ne);
[~,data.ELE2.Q_SLT]=a_pdata(xi,Q_SLT,0);
RP_BT=ppos(values.RP_BT(1:2*ne));
[~,data.ELE2.RP_BT]=a_pdata(xi,RP_BT,0);
RN_BT=ppos(values.RN_BT(1:2*ne));
[~,data.ELE2.RN_BT]=a_pdata(xi,RN_BT,0);
Q_BT=values.Q_BT(1:2*ne);
[~,data.ELE2.Q_BT]=a_pdata(xi,Q_BT,0);


