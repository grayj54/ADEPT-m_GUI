function [alpha,alpha_fc,rndx]=get_optical(dev,wl)
%
nreg=length(dev.reg);
ne=dev.mesh.num_ele;

Ewl=dev.const.hp/dev.const.q*dev.const.c*1e6/wl;

% initial absorption coeff arrays
alfl(1:ne)=0;
alfr(1:ne)=0;
afcl(1:ne)=0;
afcr(1:ne)=0;

% set absortion coefficients
indx=1:ne;
ele_reg(1:ne)=[dev.ele.reg(1:ne)];
for ireg=1:nreg
    em=indx(ele_reg==ireg); % indices for elements in region ireg
    aleft=zeros(1,length(em));
    aright=zeros(1,length(em));
    xl=dev.node.pos(em);
    al=min(dev.node.pos(em));
    bl=max(dev.node.pos(em+1));
    xr=dev.node.pos(em+1);
    ar=min(dev.node.pos(em));
    br=max(dev.node.pos(em+1));

    % e-h pair generation
    if strcmp(dev.Optical.opt_abs_model(ireg).alpha_model,'none')
      % alpha=0
    elseif strcmp(dev.Optical.opt_abs_model(ireg).alpha_model,'simple')
      for jk=1:dev.Optical.opt_abs_model(ireg).numalf
          Egl(1:length(em))=a_linear(xl,al,bl,dev.Optical.opt_abs_model(ireg).Eg(jk,1),dev.Optical.opt_abs_model(ireg).Eg(jk,2));
          Egr(1:length(em))=a_linear(xr,ar,br,dev.Optical.opt_abs_model(ireg).Eg(jk,1),dev.Optical.opt_abs_model(ireg).Eg(jk,2));
          A1(1:length(em))=a_linear(xl,al,bl,dev.Optical.opt_abs_model(ireg).A1(1),dev.Optical.opt_abs_model(ireg).A1(2));
          A2=dev.Optical.opt_abs_model(ireg).A2;
          A3=dev.Optical.opt_abs_model(ireg).A3;
          aleft(Ewl>=Egl)=(A1(Ewl>=Egl)/Ewl^A3).*((Ewl-Egl(Ewl>=Egl)).^A2);
          alfl(em)=alfl(em)+aleft;
          A1(1:length(em))=a_linear(xr,ar,br,dev.Optical.opt_abs_model(ireg).A1(1),dev.Optical.opt_abs_model(ireg).A1(2));
          aright(Ewl>=Egr)=(A1(Ewl>=Egr)/Ewl^A3).*((Ewl-Egr(Ewl>=Egr)).^A2);
          alfr(em)=alfr(em)+aright;
          clear A1 Egl Egr
      end
    elseif strcmp(dev.Optical.opt_abs_model(ireg).alpha_model,'file')
        fwl=dev.Optical.opt_abs_model(ireg).alpha_data.wl;
        falf=dev.Optical.opt_abs_model(ireg).alpha_data.alpha;
        alfl(em)=interp1(fwl,falf,wl,'linear',0);
        alfr=alfl;
    else
        error('get_optical.m: Model not supported')
    end
    
    % free carrier absorption
    if strcmp(dev.Optical.opt_abs_model(ireg).alpha_fc,'off')
      % alpha_fc=0
    else
      pl=dev.ele.pl*dev.norm.n;
      pr=dev.ele.pr*dev.norm.n;
      nl=dev.ele.nl*dev.norm.n;
      nr=dev.ele.nr*dev.norm.n;
      fcnl=a_linear(xl,al,bl,dev.Optical.opt_abs_model(ireg).fcn(1),dev.Optical.opt_abs_model(ireg).fcn(2));
      fcnr=a_linear(xr,ar,br,dev.Optical.opt_abs_model(ireg).fcn(1),dev.Optical.opt_abs_model(ireg).fcn(2));
      bn=dev.Optical.opt_abs_model(ireg).bn;
      fcpl=a_linear(xl,al,bl,dev.Optical.opt_abs_model(ireg).fcp(1),dev.Optical.opt_abs_model(ireg).fcp(2));
      fcpr=a_linear(xr,ar,br,dev.Optical.opt_abs_model(ireg).fcp(1),dev.Optical.opt_abs_model(ireg).fcp(2));
      bp=dev.Optical.opt_abs_model(ireg).bp;
      afcl(em)=fcnl*nl*wl^bn+fcpl*pl*wl^bp;
      afcr(em)=fcnr*nr*wl^bn+fcpr*pr*wl^bp;
    end    
    
end

% e-h pair generation
alpha(1:2:2*ne-1)=alfl;
alpha(2:2:2*ne)=alfr;

% free carrier absorption
alpha_fc(1:2:2*ne-1)=afcl;
alpha_fc(2:2:2*ne)=afcr;

% set index of refraction
rndx(1:2:2*ne-1)=sqrt(dev.ele.ksl*dev.norm.ks);
rndx(2:2:2*ne)=sqrt(dev.ele.ksr*dev.norm.ks);