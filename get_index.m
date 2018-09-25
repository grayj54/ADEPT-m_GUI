function [rndx]=get_index(dev,wl)

% set index of refraction
rndx(1:2:2*ne-1)=sqrt(dev.ele.ksl*dev.norm.ks);
rndx(2:2:2*ne)=sqrt(dev.ele.ksr*dev.norm.ks);

