function [values derivs dev]=a_get_params(dev,flag)
% defaults to flag='eq'
%
% flag='eq': get values/derivs for equibilbrium solution only
% flag='eqvals': get values for vp, vn, ks, & Nt only (can have only 1 output arg)
% flag='neq': get all values/derivs
% flag='vals': get all values (can have only 1 output arg)

if strcmp(dev.nD,'1D') ~= 1; error('1D only supported.'); end

if nargin == 1; flag='eq'; end

ne=dev.mesh.num_ele;

rdt=dev.OpCond.rdt;
rdtold=dev.OpCond.rdtold;

ele_reg(1:ne)=dev.ele.reg(1:ne);

ref=dev.ref;
norm=dev.norm;

% initialize values, derivs
values.vpl(1:ne)=0;
values.vnl(1:ne)=0;
values.vpr(1:ne)=0;
values.vnr(1:ne)=0;
if strcmp(flag,'band') == 0 
    values.Ntl(1:ne)=0;
    values.Ntr(1:ne)=0;
    values.ksl(1:ne)=0;
    values.ksr(1:ne)=0;
    if strcmp(flag,'neq') || strcmp(flag,'vals')
        values.upl(1:ne)=0;
        values.upr(1:ne)=0;
        values.unl(1:ne)=0;
        values.unr(1:ne)=0;
        values.Rpl(1:ne)=0;
        values.Rpr(1:ne)=0;
        values.Rnl(1:ne)=0;
        values.Rnr(1:ne)=0;
    end
end

if strcmp(flag,'eq') || strcmp(flag,'neq')
    derivs.dvpldpl(1:ne)=0;
    derivs.dvnldnl(1:ne)=0;
    derivs.dNtldpl(1:ne)=0;
    derivs.dNtldnl(1:ne)=0;
    derivs.dvprdpr(1:ne)=0;
    derivs.dvnrdnr(1:ne)=0;
    derivs.dNtrdpr(1:ne)=0;
    derivs.dNtrdnr(1:ne)=0;
    if strcmp(flag,'neq')
        derivs.dRpldpl(1:ne)=0;
        derivs.dRpldnl(1:ne)=0;
        derivs.dRprdpr(1:ne)=0;
        derivs.dRprdnr(1:ne)=0;
        derivs.dRnldpl(1:ne)=0;
        derivs.dRnldnl(1:ne)=0;
        derivs.dRnrdpr(1:ne)=0;
        derivs.dRnrdnr(1:ne)=0;
    end
end

% set generation rate
if (strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')) && strcmp(dev.OpCond.Generation(1).type,'dark') == 0 
    if isnan(dev.OpCond.scale_factor); dev.OpCond.scale_factor=1; end
    SF=dev.OpCond.scale_factor;
    if strcmp(flag,'vals') || strcmp(flag,'plot')
      if SF ~= 1; error('a_get_params.m: flag=vals/plot and SF ~= 1'); end
      [Gl,Gr]=a_setgen(dev);
      if strcmp(flag,'vals')
          values.Gl(1:ne)=Gl;
          values.Gr(1:ne)=Gr;
      else
          values.G(1:2:2*ne-1)=Gl*dev.norm.rg;
          values.G(2:2:2*ne)=Gr*dev.norm.rg;
      end
      dev.ele.Gl=Gl;
      dev.ele.Gr=Gr;
    else % Scale G to turn up illumination slowly
      if SF == 1
        [Gl Gr]=a_setgen(dev);
        values.Gl(1:ne)=Gl;
        values.Gr(1:ne)=Gr;
      elseif SF < 1
        [Gl,Gr]=a_setgen(dev);
        if dev.newton.current_dvmax < dev.newton.SF_test
          dev.OpCond.scale_factor=min(1,SF*dev.OpCond.scale_mult);
          SF=dev.OpCond.scale_factor;
        end
        values.Gl(1:ne)=SF*Gl;
        values.Gr(1:ne)=SF*Gr;
      else
        error('a_get_params.m: SF = %g > 1',SF)
      end
    end
else % dark or equilibrium
    if strcmp(flag,'plot')
        values.G(1:2*ne)=0;
    else
        values.Gl(1:ne)=0;
        values.Gr(1:ne)=0;
        dev.ele.Gl=values.Gl(1:ne);
        dev.ele.Gr=values.Gr(1:ne);
    end 
end

% do each region separately
nreg=length(dev.reg);   
for ireg=1:nreg

    % identify material type and matno
    mat=dev.reg(ireg).mat;
    matno=dev.reg(ireg).matno;
    indx=1:ne;
    em=indx(ele_reg==ireg); % indices for elements in region ireg
    inl=[];
    inr=[];
    inl.rdt=rdt;
    inr.rdt=rdt;
    inl.rdtold=rdtold;
    inr.rdtold=rdtold;
    inl.omega=dev.OpCond.omega;
    inr.omega=dev.OpCond.omega;
    % left side of element
    inl.x=dev.node.pos(em);
    inl.xt=min(dev.node.pos(em));
    inl.xb=max(dev.node.pos(em+1));
    inl.p=dev.ele.pl(em);
    inl.n=dev.ele.nl(em);
    inl.E(1:length(em))=0; % not used for 'semiconductor'
    % right side of element
    inr.x=dev.node.pos(em+1);
    inr.xt=min(dev.node.pos(em));
    inr.xb=max(dev.node.pos(em+1));
    inr.p=dev.ele.pr(em);
    inr.n=dev.ele.nr(em);
    inr.E(1:length(em))=0; % not used for 'semiconductor'
    if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
        % left side of element
        inl.po=dev.ele.plo(em);
        inl.no=dev.ele.nlo(em);
        % right side of element
        inr.po=dev.ele.pro(em);
        inr.no=dev.ele.nro(em);
    end
    
%---------------------------------------------------------------
%---------------------------------------------------------------
   
    switch mat

        case 'semiconductor'
            simp=dev.semi(matno);
            simp.minN=dev.misc.minN;
            
            if rdt > 0 % need old nt's for transient mode of operation
               
                % donor traps
                inl.oldntNd=dev.oldnt.reg(ireg).Ndl;
                inr.oldntNd=dev.oldnt.reg(ireg).Ndr;
                % acceptor traps
                inl.oldntNa=dev.oldnt.reg(ireg).Nal;
                inr.oldntNa=dev.oldnt.reg(ireg).Nar;
                % deep single level traps
                inl.oldntNslt=dev.oldnt.reg(ireg).Nsltl;
                inr.oldntNslt=dev.oldnt.reg(ireg).Nsltr;
                % band tails
                inl.oldntNvbt=dev.oldnt.reg(ireg).Nvbtl;
                inr.oldntNvbt=dev.oldnt.reg(ireg).Nvbtr;
                inl.oldntNcbt=dev.oldnt.reg(ireg).Ncbtl;
                inr.oldntNcbt=dev.oldnt.reg(ireg).Ncbtr;
                % 3 charge state amphoteric traps
                inl.oldntNmvp3=dev.oldnt.reg(ireg).Nmv3pl;
                inr.oldntNmvp3=dev.oldnt.reg(ireg).Nmv3pr;
                inl.oldntNmv03=dev.oldnt.reg(ireg).Nmv30l;
                inr.oldntNmv03=dev.oldnt.reg(ireg).Nmv30r;
                inl.oldntNmvm3=dev.oldnt.reg(ireg).Nmv3ml;
                inr.oldntNmvm3=dev.oldnt.reg(ireg).Nmv3mr;
                if rdtold > 0
                    % donor traps
                    inl.oldoldntNd=dev.oldoldnt.reg(ireg).Ndl;
                    inr.oldoldntNd=dev.oldoldnt.reg(ireg).Ndr;
                    % acceptor traps
                    inl.oldoldntNa=dev.oldoldnt.reg(ireg).Nal;
                    inr.oldoldntNa=dev.oldoldnt.reg(ireg).Nar;
                    % deep single level traps
                    inl.oldoldntNslt=dev.oldoldnt.reg(ireg).Nsltl;
                    inr.oldoldntNslt=dev.oldoldnt.reg(ireg).Nsltr;
                    % band tails
                    inl.oldoldntNvbt=dev.oldoldnt.reg(ireg).Nvbtl;
                    inr.oldoldntNvbt=dev.oldoldnt.reg(ireg).Nvbtr;
                    inl.oldoldntNcbt=dev.oldoldnt.reg(ireg).Ncbtl;
                    inr.oldoldntNcbt=dev.oldoldnt.reg(ireg).Ncbtr;
                    % 3 charge state amphoteric traps
                    inl.oldoldntNmvp3=dev.oldoldnt.reg(ireg).Nmv3pl;
                    inr.oldoldntNmvp3=dev.oldoldnt.reg(ireg).Nmv3pr;
                    inl.oldoldntNmv03=dev.oldoldnt.reg(ireg).Nmv30l;
                    inr.oldoldntNmv03=dev.oldoldnt.reg(ireg).Nmv30r;
                    inl.oldoldntNmvm3=dev.oldoldnt.reg(ireg).Nmv3ml;
                    inr.oldoldntNmvm3=dev.oldoldnt.reg(ireg).Nmv3mr;
                end
            end
            
            if strcmp(flag,'eq') || strcmp(flag,'neq') || strcmp(flag,'band')
                [valsl,dersl]=a_custom_semi(inl,simp,ref,norm,dev.misc.fdflag,flag);        
                [valsr,dersr]=a_custom_semi(inr,simp,ref,norm,dev.misc.fdflag,flag);
            else
                valsl=a_custom_semi(inl,simp,ref,norm,dev.misc.fdflag,flag);        
                valsr=a_custom_semi(inr,simp,ref,norm,dev.misc.fdflag,flag);
            end
            
            % save ks
            if strcmp(flag,'band') == 0
                dev.ele.ksl(em)=valsl.ks;
                dev.ele.ksr(em)=valsr.ks;
                dev.ele.ntl(em)=valsl.Nt;
                dev.ele.ntr(em)=valsr.Nt;
            end
            
            %save current nt for each species of trap
            if strcmp(flag,'band') == 0
                % donor traps
                dev.nt.reg(ireg).Ndl=valsl.nt_Nd;
                dev.nt.reg(ireg).Ndr=valsr.nt_Nd;
                % acceptor traps
                dev.nt.reg(ireg).Nal=valsl.nt_Na;
                dev.nt.reg(ireg).Nar=valsr.nt_Na;
                % deep single level traps
                dev.nt.reg(ireg).Nsltl=valsl.nt_Nslt;
                dev.nt.reg(ireg).Nsltr=valsr.nt_Nslt;
                % band tails
                dev.nt.reg(ireg).Nvbtl=valsl.nt_Nvbt;
                dev.nt.reg(ireg).Nvbtr=valsr.nt_Nvbt;
                dev.nt.reg(ireg).Ncbtl=valsl.nt_Ncbt;
                dev.nt.reg(ireg).Ncbtr=valsr.nt_Ncbt;
                % 3 charge state amphoteric traps
                dev.nt.reg(ireg).Nmv3pl=valsl.nt_Nmvp3;
                dev.nt.reg(ireg).Nmv3pr=valsr.nt_Nmvp3;
                dev.nt.reg(ireg).Nmv30l=valsl.nt_Nmv03;
                dev.nt.reg(ireg).Nmv30r=valsr.nt_Nmv03;
                dev.nt.reg(ireg).Nmv3ml=valsl.nt_Nmvm3;
                dev.nt.reg(ireg).Nmv3mr=valsr.nt_Nmvm3;
            end
            
            % always need these
            values.vpl(em)=valsl.vp;
            values.vnl(em)=valsl.vn;
            values.vpr(em)=valsr.vp;
            values.vnr(em)=valsr.vn;
            
            if strcmp(flag,'band') == 0 && strcmp(flag,'plot') == 0
              % for eq, just need these
              values.Ntl(em)=valsl.Nt;
              values.ksl(em)=valsl.ks;
              values.Ntr(em)=valsr.Nt;
              values.ksr(em)=valsr.ks;
              if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
                values.upl(em)=valsl.up;
                values.upr(em)=valsr.up;
                values.unl(em)=valsl.un;
                values.unr(em)=valsr.un;
                values.Rpl(em)=valsl.Rp;
                values.Rpr(em)=valsr.Rp;
                values.Rnl(em)=valsl.Rn;
                values.Rnr(em)=valsr.Rn;
              end
            end

            if strcmp(flag,'plot')
                lem=length(em);
                % fundamental parameters
                values.VP(2*(em(1):em(lem))-1)=valsl.vp*dev.norm.v;
                values.VP(2*(em(1):em(lem)))=valsr.vp*dev.norm.v;
                values.VN(2*(em(1):em(lem))-1)=valsl.vn*dev.norm.v;
                values.VN(2*(em(1):em(lem)))=valsr.vn*dev.norm.v;
                values.KS(2*(em(1):em(lem))-1)=valsl.ks*dev.norm.ks;
                values.KS(2*(em(1):em(lem)))=valsr.ks*dev.norm.ks;
                values.NT(2*(em(1):em(lem))-1)=valsl.Nt*dev.norm.n;
                values.NT(2*(em(1):em(lem)))=valsr.Nt*dev.norm.n;
                values.UP(2*(em(1):em(lem))-1)=valsl.up*dev.norm.u;
                values.UP(2*(em(1):em(lem)))=valsr.up*dev.norm.u;
                values.UN(2*(em(1):em(lem))-1)=valsl.un*dev.norm.u;
                values.UN(2*(em(1):em(lem)))=valsr.un*dev.norm.u;
                values.RP(2*(em(1):em(lem))-1)=valsl.Rp*dev.norm.rg;
                values.RP(2*(em(1):em(lem)))=valsr.Rp*dev.norm.rg;
                values.RN(2*(em(1):em(lem))-1)=valsl.Rn*dev.norm.rg;
                values.RN(2*(em(1):em(lem)))=valsr.Rn*dev.norm.rg;
                % band parameters
                values.CHI(2*(em(1):em(lem))-1)=valsl.chi;
                values.CHI(2*(em(1):em(lem)))=valsr.chi;
                values.EG(2*(em(1):em(lem))-1)=valsl.Eg;
                values.EG(2*(em(1):em(lem)))=valsr.Eg;
                values.NC(2*(em(1):em(lem))-1)=valsl.Nc;
                values.NC(2*(em(1):em(lem)))=valsr.Nc;
                values.NV(2*(em(1):em(lem))-1)=valsl.Nv;
                values.NV(2*(em(1):em(lem)))=valsr.Nv;
                % trap/recombination parameters
                values.NDP(:,2*(em(1):em(lem))-1)=valsl.Ndp;
                values.NDP(:,2*(em(1):em(lem)))=valsr.Ndp;
                values.NAM(:,2*(em(1):em(lem))-1)=valsl.Nam;
                values.NAM(:,2*(em(1):em(lem)))=valsr.Nam;
                values.R_RAD(2*(em(1):em(lem))-1)=valsl.Rrad*dev.norm.rg;
                values.R_RAD(2*(em(1):em(lem)))=valsr.Rrad*dev.norm.rg;
                values.R_AUGER(2*(em(1):em(lem))-1)=valsl.Rauger*dev.norm.rg;
                values.R_AUGER(2*(em(1):em(lem)))=valsr.Rauger*dev.norm.rg;
                values.R_SHR(:,2*(em(1):em(lem))-1)=valsl.Rshr*dev.norm.rg;
                values.R_SHR(:,2*(em(1):em(lem)))=valsr.Rshr*dev.norm.rg;
                values.ND(:,2*(em(1):em(lem))-1)=valsl.Ndd*dev.norm.n;
                values.ND(:,2*(em(1):em(lem)))=valsr.Ndd*dev.norm.n;
                values.ND_ionized(:,2*(em(1):em(lem))-1)=valsl.Qd*dev.norm.n;
                values.ND_ionized(:,2*(em(1):em(lem)))=valsr.Qd*dev.norm.n;
                values.RP_ND(:,2*(em(1):em(lem))-1)=valsl.Rpd*dev.norm.rg;
                values.RP_ND(:,2*(em(1):em(lem)))=valsr.Rpd*dev.norm.rg;
                values.RN_ND(:,2*(em(1):em(lem))-1)=valsl.Rnd*dev.norm.rg;
                values.RN_ND(:,2*(em(1):em(lem)))=valsr.Rnd*dev.norm.rg;
                values.NA(:,2*(em(1):em(lem))-1)=valsl.Naa*dev.norm.n;
                values.NA(:,2*(em(1):em(lem)))=valsr.Naa*dev.norm.n;
                values.NA_ionized(:,2*(em(1):em(lem))-1)=-valsl.Qa*dev.norm.n;
                values.NA_ionized(:,2*(em(1):em(lem)))=-valsr.Qa*dev.norm.n;
                values.RP_NA(:,2*(em(1):em(lem))-1)=valsl.Rpa*dev.norm.rg;
                values.RP_NA(:,2*(em(1):em(lem)))=valsr.Rpa*dev.norm.rg;
                values.RN_NA(:,2*(em(1):em(lem))-1)=valsl.Rna*dev.norm.rg;
                values.RN_NA(:,2*(em(1):em(lem)))=valsr.Rna*dev.norm.rg;
                values.Q_SLT(:,2*(em(1):em(lem))-1)=valsl.Qslt*dev.norm.n;
                values.Q_SLT(:,2*(em(1):em(lem)))=valsr.Qslt*dev.norm.n;
                values.RP_SLT(:,2*(em(1):em(lem))-1)=valsl.Rpslt*dev.norm.rg;
                values.RP_SLT(:,2*(em(1):em(lem)))=valsr.Rpslt*dev.norm.rg;
                values.RN_SLT(:,2*(em(1):em(lem))-1)=valsl.Rnslt*dev.norm.rg;
                values.RN_SLT(:,2*(em(1):em(lem)))=valsr.Rnslt*dev.norm.rg;
                values.Q_BT(:,2*(em(1):em(lem))-1)=valsl.Qbt*dev.norm.n;
                values.Q_BT(:,2*(em(1):em(lem)))=valsr.Qbt*dev.norm.n;
                values.RP_BT(:,2*(em(1):em(lem))-1)=valsl.Rpbt*dev.norm.rg;
                values.RP_BT(:,2*(em(1):em(lem)))=valsr.Rpbt*dev.norm.rg;
                values.RN_BT(:,2*(em(1):em(lem))-1)=valsl.Rnbt*dev.norm.rg;
                values.RN_BT(:,2*(em(1):em(lem)))=valsr.Rnbt*dev.norm.rg;
            end

            if strcmp(flag,'eq') || strcmp(flag,'neq') || strcmp(flag,'band')
                derivs.dvpldpl(em)=dersl.dvpdp;
                derivs.dvnldnl(em)=dersl.dvndn;
                derivs.dvprdpr(em)=dersr.dvpdp;
                derivs.dvnrdnr(em)=dersr.dvndn;
                if strcmp(flag,'neq') || strcmp(flag,'eq')
                  derivs.dNtldpl(em)=dersl.dNtdp;
                  derivs.dNtldnl(em)=dersl.dNtdn;
                  derivs.dNtrdpr(em)=dersr.dNtdp;
                  derivs.dNtrdnr(em)=dersr.dNtdn;
                end
                if strcmp(flag,'neq')
                  derivs.dRpldpl(em)=dersl.dRpdp;
                  derivs.dRpldnl(em)=dersl.dRpdn;
                  derivs.dRprdpr(em)=dersr.dRpdp;
                  derivs.dRprdnr(em)=dersr.dRpdn;
                  derivs.dRnldpl(em)=dersl.dRndp;
                  derivs.dRnldnl(em)=dersl.dRndn;
                  derivs.dRnrdpr(em)=dersr.dRndp;
                  derivs.dRnrdnr(em)=dersr.dRndn;
                end
            end
            
        otherwise

            mat
            size(mat)
            error('a_set_params: material not found');

    end

end

end