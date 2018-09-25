function [Gl Gr]=monogenb(dev,wlba,Jinc_ba,angle_ba)

    % get device parameters
    x=dev.node.pos;
    nn=dev.mesh.num_nod;
    x(nn+1:2*nn-1)=0.5*(x(1:nn-1)+x(2:nn));
    x=sort(x);
    n_pass=dev.Optical.npass;
    Rf=dev.bc.top.Rint;
    Rb=dev.bc.bottom.Rint;
    if strcmp(dev.bc.bottom.Rextfile,'constant')
      Rback=dev.bc.bottom.Rext;
    else
      error('monogen.m: not implemented yet')
    end
    Sback=dev.bc.bottom.shadow;
    
    % get operating condition parameters
    phiW=(1-Rback)*(1-Sback)*Jinc_ba*cos(angle_ba)/dev.const.q;
    if phiW > 0
      [alpha,alpha_fc,rndx]=get_optical(dev,wlba);
      [Gb]=monogen_back(x,n_pass,Rf,Rb,phiW,angle_ba,rndx,alpha,alpha_fc);
    else
      Gb(1:2*nn-2)=0;
    end

    Gl(1:nn-1)=Gb(1:2:2*nn-3);
    Gr(1:nn-1)=Gb(2:2:2*nn-2);