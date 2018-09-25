function [Gacl,Gacr,Jgen_ac]=a_setGac(dev)

    [Gacl,Gacr]=a_setgen(dev);
    h=dev.ele.h/2;
    Jgen_ac=sum(Gacl.*h+Gacr.*h)*dev.norm.j;