function dev=a_update_neq(dev,dzv)

if strcmp(dev.nD,'1D') == 1

    n3=length(dzv);
    nn=n3/3;
    
    dzv=a_damp(dzv)';
    dzp=dzv(1:3:n3-2);
    dzn=dzv(2:3:n3-1);
    dv=dzv(3:3:n3);
    
    if strcmp(dev.OpCond.mode,'frozen') == 0
      dev.node.v=dev.node.v+dv;
    end
    dev.node.zp=dev.node.zp+dzp;
    dev.node.zn=dev.node.zn+dzn;
    
    dev.ele.pl=dev.ele.pl.*exp(dzp(1:nn-1));
    dev.ele.pr=dev.ele.pr.*exp(dzp(2:nn));
    dev.ele.nl=dev.ele.nl.*exp(dzn(1:nn-1));
    dev.ele.nr=dev.ele.nr.*exp(dzn(2:nn));
    
else
    error('only 1D supported.')
end