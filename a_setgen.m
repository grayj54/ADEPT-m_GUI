function [Gl,Gr]=a_setgen(dev)
%
global CONST

ne=dev.mesh.num_ele;
if strcmp(dev.OpCond.mode,'small-signal')
     if strcmp(dev.OpCond.set_ac,'Gac_uniform')
         GGG.type='uniform';
         GGG.uniform.J_gen=sqrt(2)/2*(1+1i);
     elseif strcmp(dev.OpCond.set_ac,'Gac_mono')
         GGG.type='mono';
         GGG.mono.top_or_bottom=dev.OpCond.ac_torb;
         GGG.mono.J_Inc=1;
         GGG.mono.wl=dev.OpCond.ac_wl;
         GGG.mono.angle=dev.OpCond.ac_angle;
     elseif strcmp(dev.OpCond.set_ac,'Gac_spectrum')
         GGG.type='spectrum';
         GGG.spec.top_or_bottom=dev.OpCond.ac_torb;
         GGG.spec.sdata=get_sdata(dev.OpCond.ac_spec);
         GGG.spec.sdata.flux=GGG.spec.sdata.flux/GGG.sdata.n_photon/CONST.q;
         GGG.spec.X=1e-3*sqrt(2)/2*(1+1i);
         GGG.spec.angle=dev.OpCond.ac_angle;
     elseif strcmp(dev.OpCond.set_ac,'Vac')
         Gl(1:ne)=0;
         Gr(1:ne)=0;
         return
     else
         error('a_setgen.m: ac gereration type not recognized')
     end
else
    GGG=dev.OpCond.Generation;
    if (dev.OpCond.FC_on == 0 && dev.OpCond.Gset == 1)
      Gl=dev.ele.Gl;
      Gr=dev.ele.Gr;
      return
    end
end    

Gl(1:ne)=0;
Gr(1:ne)=0;
for ll=1:length(GGG)

    if strcmp(GGG(ll).type,'dark')
        return;
    end    
    
    if strcmp(GGG(ll).type,'uniform')
    
        if length(GGG(ll).uniform.J_Gen) == 1
            devW=dev.node.pos(ne+1);
            aGl(1:ne)=GGG(ll).uniform.J_Gen/dev.const.q/devW;
            aGr(1:ne)=GGG(ll).uniform.J_Gen/dev.const.q/devW;
        elseif length(GGG(ll).uniform.J_Gen) == length(dev.reg)
            nreg=length(dev.reg);
            ele_reg(1:ne)=[dev.ele.reg(1:ne)];
            for ireg=1:nreg
                indx=1:dev.mesh.num_ele;
                regW=dev.reg(ireg).thick;
                em=indx(ele_reg==ireg); % indices for elements in region ireg
                aGl(em)=GGG(ll).uniform.J_Gen(ireg)/dev.const.q/regW;
                aGr(em)=GGG(ll).uniform.J_Gen(ireg)/dev.const.q/regW;
                clear em
            end
        else
            error('a_get_params: length of J_gen must be 1 or # layers');
        end
    
    elseif strcmp(GGG(ll).type,'mono')

        if strcmp(GGG(ll).mono.top_or_bottom,'top')
          wlfr=GGG(ll).mono.wl;
          Jinc_fr=GGG(ll).mono.J_Inc;
          theta_fr=GGG(ll).mono.angle;
          [aGl,aGr]=monogenf(dev,wlfr,Jinc_fr,theta_fr);
        elseif strcmp(GGG(ll).mono.top_or_bottom,'bottom')
          wlba=GGG(ll).mono.wl;    
          Jinc_ba=GGG(ll).mono.J_Inc;
          theta_ba=GGG(ll).mono.angle;
          [aGl,aGr]=monogenb(dev,wlba,Jinc_ba,theta_ba);
        else
          error('a_setgen.m: direction of illumination improperly specified')
        end
    
    elseif strcmp(GGG(ll).type,'spectrum')
    
        if strcmp(GGG(ll).spec.top_or_bottom,'top')
          wlfr=GGG(ll).spec.sdata.wl;
          Jinc_fr=GGG(ll).spec.sdata.flux*CONST.q*GGG(ll).spec.X;
          theta_fr=GGG(ll).spec.angle;
          [aGlii,aGrii]=monogenf(dev,wlfr(1),Jinc_fr(1),theta_fr);
          dwlR=0.5*(wlfr(2)-wlfr(1));
          aGl=dwlR*aGlii;
          aGr=dwlR*aGrii;
          nwl=length(GGG(ll).spec.sdata.wl);
          for ii=2:nwl-1
            dwlL=dwlR;
            dwlR=0.5*(wlfr(ii+1)-wlfr(ii));
            [aGlii,aGrii]=monogenf(dev,wlfr(ii),Jinc_fr(ii),theta_fr);
            aGl=aGl+(dwlL+dwlR)*aGlii;
            aGr=aGr+(dwlL+dwlR)*aGrii;
          end
          [aGlii,aGrii]=monogenf(dev,wlfr(nwl),Jinc_fr(nwl),theta_fr);
          aGl=aGl+dwlR*aGlii;
          aGr=aGr+dwlR*aGrii;
        elseif strcmp(GGG(ll).spec.top_or_bottom,'bottom')
          wlba=GGG(ll).spec.sdata.wl;    
          Jinc_ba=GGG(ll).spec.sdata.flux*CONST.q*GGG(ll).spec.X;
          theta_ba=GGG(ll).spec.angle;
          [aGlii,aGrii]=monogenb(dev,wlba(1),Jinc_ba(1),theta_ba);
          dwlR=0.5*(wlba(2)-wlba(1));
          aGl=dwlR*aGlii;
          aGr=dwlR*aGrii;
          nwl=length(GGG(ll).spec.sdata.wl);
          for ii=2:nwl-1
            dwlL=dwlR;
            dwlR=0.5*(wlba(ii+1)-wlba(ii));
            [aGlii,aGrii]=monogenb(dev,wlba(ii),Jinc_ba(ii),theta_ba);
            aGl=aGl+(dwlL+dwlR)*aGlii;
            aGr=aGr+(dwlL+dwlR)*aGrii;
          end
          [aGlii,aGrii]=monogenb(dev,wlba(nwl),Jinc_ba(nwl),theta_ba);
          aGl=aGl+dwlR*aGlii;
          aGr=aGr+dwlR*aGrii;
        else
          error('a_setgen.m: direction of illumination improperly specified')
        end 
       
    else
        error('a_setgen: Generation type not found');
    end
    
    Gl=Gl+aGl;
    Gr=Gr+aGr;
    
end

Gl=Gl/dev.norm.rg;
Gr=Gr/dev.norm.rg;