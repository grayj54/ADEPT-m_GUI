function jtotal=a_jtot(dev)

if dev.OpCond.rdt == 0
    jtotal=a_jtot_ss(dev,0);
    jtotal=jtotal*dev.norm.j;
else
    jtotal=a_jtot_tr(dev,0);
    jtotal=jtotal*dev.norm.j;
end