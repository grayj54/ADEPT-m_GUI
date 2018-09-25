function [Gl Gr]=monogenf(dev,wlfr,Jinc_fr,angle_fr)

    % get device parameters
    x=dev.node.pos;
    nn=dev.mesh.num_nod;
    x(nn+1:2*nn-1)=0.5*(x(1:nn-1)+x(2:nn));
    x=sort(x);
    n_pass=dev.Optical.npass;
    Rf=dev.bc.top.Rint;
    Rb=dev.bc.bottom.Rint;
    if strcmp(dev.bc.top.Rextfile,'constant')
      Rfront=dev.bc.top.Rext;
    else
      error('monogen.m: not implemented yet')
    end
    Sfront=dev.bc.top.shadow;
   
    % get operating condition parameters
    phi0=(1-Rfront)*(1-Sfront)*Jinc_fr*cos(angle_fr)/dev.const.q;
    if phi0 > 0
      [alpha alpha_fc rndx]=get_optical(dev,wlfr);
      [Gf]=monogen_front(x,n_pass,Rf,Rb,phi0,angle_fr,rndx,alpha,alpha_fc);
    else
      Gf(1:2*nn-2)=0;
    end

    Gl(1:nn-1)=Gf(1:2:2*nn-3);
    Gr(1:nn-1)=Gf(2:2:2*nn-2);