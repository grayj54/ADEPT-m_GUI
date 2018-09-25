function [jp,jn,jd,Rpint,Rnint,Gint]=p_get_currents(dev)

if dev.OpCond.rdt == 0
    [~,jp,jn,Rint,Gint]=a_jtot_ss(dev,1);
    Rpint=Rint;
    Rnint=Rint;
    jd=zeros(1,length(jp));
else
    [~,jp,jn,jd,Rpint,Rnint,Gint]=a_jtot_tr(dev,1);
end