function D=get_D(dev)

vals=a_get_params(dev);
nn=dev.mesh.num_nod;
dv=dev.node.v(2:nn)-dev.node.v(1:nn-1);
h=dev.node.pos(2:nn)-dev.node.pos(1:nn-1);
ks=0.5*(vals.ksl+vals.ksr);
D=ks.*dv./h;
D=D*dev.norm.ks*dev.norm.v/dev.norm.x;
%Dth=max(D)/1000;
Dth=dev.mesh.Dth; %threshold D field
sD=sign(D);
sD(sD==0)=1;
D=abs(D);
D(D<Dth)=Dth;
D=sD.*D;
