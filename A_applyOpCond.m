function [newdev,Vv,Jj]=A_applyOpCond(dev,mode,varargin)
% function [newdev,Vv,Jj]=A_applyOpCond(dev,mode,OC1,val1,OC2,val2,OC3,val3,...)
%
% currently, operating temperature cannot be changed and is set in A_build.m
%
% dev:  a data structure describing the device being simulated, and, based on mode is -
% 
% mode: sets mode of operation
%
%       mode='steady-state': dev is the initial guess for new operating conditions
%       mode='transient': dev is the initial guess for new operating conditions
%       mode='small-signal': dev is the solution to which small-signal is applied 
%  
% OCi:  a string defining (one of) the new operating conditions
% vali: string or data structure
%
% ----------------------------
%       -- For mode = 'transient'
%
%          if OCi = 'delta_t', then vali is the time step in seconds. If not set, then use dev time step if dev was in transient mode.
%                              Must be set if dev was not in transient mode.
%          
%       -- For modes 'steady-state' and 'transient', varargin can set multiple operating conditions (must be an even # of varargin arguments)
%
%          if OCi = 'V=', then vali is the applied voltage (V)
%          if OCi = 'J=', then vali is the injected current (A/cm^2)
%                         [only one of 'V=' or 'J=' can occur and not both. If neither appear, then applied voltage/injected current
%                          from dev are used]
%
%          if OCi = 'Illum=', then vali is a string or data structure containing [more than 1 permitted]:
%
%                   if no 'Illum=' appear, then illumination conditions from dev are kept
%
%                   if vali = 'keep', illumination condtions from dev kept - can be added to
%                 
%                   if vali = 'replace', illumination conditions from dev are discarded (default if any 'Illum=' appear)
%                 
%                   if vali = 'dark', illumiation condtition set to 'dark', not compatible with 'keep'
%                                     and is redundant with 'replace' 
%
%              For remaining options, vali is a data structure
%
%                   if vali.type = 'uniform', then vali is a data structure
%
%                                  vali.J_Gen is either a scalar or an array of length # of regions
%                   
%                   if vali.type = 'mono', then
%
%                                  vali.top_or_bottom ='top' or ='bottom'
%                                  vali.J_Inc: equivalent incident current (A/cm^2)
%                                  vali.wl: wavelength of light (microns)
%                                  vali.inc_angle (degrees)                  
%                   
%                   if vali.type = 'spectrum', then
%
%                                  vali.top_or_bottom ='top' or ='bottom'
%                                  vali.spectrum is spectrum file name
%                                  vali.X is concentration factor 
%                                  vali.inc_angle (degrees)                   
%
%       -- If mode='small-signal', then vali is a data structure used to set small signal applied voltage or
%                                  illumination - only one can be set.
%                                  Also, cannot set "V=", "J=", or "Illum="
%                                  
%
%          if OCi = 'freq=', then vali is the small signal frequency in Hz. (mandatory)
%
%          if OCi = 'ac_signal', then vali is a data structure containing [only 1 permitted]:
%
%                   if vali = 'Vac', no other info needed 
%                   
%                   if vali.type = 'Gac_uniform', then vali is a data structure
%
%                                  vali.Gac is either a scalar or an array of length # of regions
%                                  0 <= Gac <= 1 (at least one value must equal 1)
%                   
%                   if vali.type = 'Gac_mono', then vali is a data structure
%
%                                  vali.top_or_bottom ='top' or ='bottom'
%                                  vali.wl: wavelength of light (microns)
%                                  vali.inc_angle (degrees)                  
%                   
%                   if vali.type = 'Gac_spectrum', then vali is a data structure
%
%                                  vali.top_or_bottom ='top' or ='bottom'
%                                  vali.spectrum is spectrum file name (reduced to small signal, but relative
%                                                                       intensities retained.
%                                  vali.inc_angle (degrees)                   
%
%
global VERBOSE

a_init; % should be first statement in all A_xxxx functions

% decode input arguments

if nargin < 2; error('A_applyOpCond.m: dev and mode must be set'); end

nOC=nargin-2;
if nOC == 0; error('A_applyOpCond.m: at least one OC must be set'); end
if mod(nOC,2) == 1; error('A_applyOpCond.m: mismatched input arguments'); else nOC=nOC/2; end

for ioc=1:nOC
  OC{ioc}=varargin{2*ioc-1};
  val{ioc}=varargin{2*ioc};
end
for ii=1:nOC % all OC must be a character string
    if ischar(OC{ii}) == 0; error('A_applyOpCond.m: OC must be a character string'); end
end

SFstart=1e-30;
SFmult=1000;

nOpCond.mode=mode;
nOpCond.T_C=dev.OpCond.T_C;
nOpCond.T_K=dev.OpCond.T_K;
nGeneration=make_Generation;

switch mode

  case {'steady-state' 'transient' 'transient2'}
      
    njv=0;
    ndt=0;
    nillum=0;
    ndark=0;
    nkeep=0;
    nrep=0;
    for ii=1:nOC
        if strcmp(OC{ii},'V=')
            if strcmp(mode,'small-signal')
                error('Cannot set applied voltage for small-signal mode')
            end
            njv=njv+1;
            if njv > 1; error('A_applyOpCond.m: V or J can be set only once'); end
            nOpCond.setv=1;
            vii=val{ii};
            if isnumeric(vii) && length(vii) == 1
              nOpCond.Va=vii;
              nOpCond.Jt=0;
            else
              error('A_applyOpCond.m: illegal applied voltage')
            end
        elseif strcmp(OC(ii),'J=')
            if strcmp(mode,'small-signal')
                error('Cannot set applied current for small-signal mode')
            end
            njv=njv+1;
            if njv > 1; error('A_applyOpCond.m: V or J can be set only once'); end
            nOpCond.setv=0;
            jii=val{ii};
            if isnumeric(jii) && length(jii) == 1
              nOpCond.Jt=jii;
              nOpCond.Va=0;
            else
              error('A_applyOpCond.m: illegal injected current')
            end
        elseif strcmp(OC{ii},'Illum=')
            if strcmp(mode,'small-signal')
                error('Cannot set illumination for small-signal mode')
            end
            if ischar(val{ii})
                valii=val{ii};
                if strcmp(valii,'dark')
                    nillum=nillum+1;
                    ndark=ndark+1;
                    if ndark > 1; error('A_applyOpCond.m: Illum set to dark more than once'); end
                    nOpCond.Generation(nillum).type='dark';
                elseif strcmp(valii,'keep')
                    nkeep=nkeep+1;
                    if nkeep > 1; error('A_applyOpCond.m: keep set more than once'); end
                elseif strcmp(valii,'replace')
                    nrep=nrep+1;
                    if nrep > 1; error('A_applyOpCond.m: replace set more than once'); end
                else
                    error('A_applyOpCond.m: Unrecognized illumination condition(1)')
                end
            elseif isstruct(val{ii})
                a_struct=val{ii};
                if strcmp(a_struct.type,'uniform')
                    nillum=nillum+1;
                    nGeneration(nillum).type='uniform';
%                     nGeneration(nillum).J_Inc=sum(a_struct.J_Gen);
                    nGeneration(nillum).uniform.J_Gen=a_struct.J_Gen;
                elseif strcmp(a_struct.type,'mono')
                    nillum=nillum+1;
                    nGeneration(nillum).type='mono';
                    nGeneration(nillum).mono.top_or_bottom=a_struct.top_or_bottom;
                    nGeneration(nillum).mono.J_Inc=a_struct.J_Inc;
%                     nGeneration(nillum).J_Inc=a_struct.J_Inc;
                    nGeneration(nillum).mono.wl=a_struct.wl;
                    nGeneration(nillum).mono.angle=a_struct.inc_angle;
                elseif strcmp(a_struct.type,'spectrum')
                    nillum=nillum+1;
                    nGeneration(nillum).type='spectrum';
                    nGeneration(nillum).spec.top_or_bottom=a_struct.top_or_bottom;
                    nGeneration(nillum).spec.sfile=a_struct.spectrum;
                    nGeneration(nillum).spec.X=a_struct.X;
                    nGeneration(nillum).spec.angle=a_struct.inc_angle;
                    nGeneration(nillum).spec.sdata=get_sdata(a_struct.spectrum);
%                     nGeneration(nillum).J_Inc=nGeneration(nillum).spec.sdata.Jinc*a_struct.X;
                else
                    error('A_applyOpCond.m: Unrecognized illumination condition(2)')
                end
            else
                error('A_applyOpCond.m: Unrecognized illumination condition(3)')
            end            
        elseif strcmp(OC(ii),'delta_t=') && (strcmp(mode,'transient') || strcmp(mode,'transient2'))
            ndt=ndt+1;
            if ndt > 1; error('A_applyOpCond.m: delta_t can be set only once'); end
            delt=val{ii};
            if isnumeric(delt) && length(delt) == 1
              nOpCond.time_step=delt;
              nOpCond.rdt=dev.norm.time/nOpCond.time_step;
              if strcmp(mode,'transient2')
                  nOpCond.rdtold=dev.OpCond.rdt;
              else
                  nOpCond.rdtold=-1;
              end
              if nOpCond.rdtold == 0; nOpCond.rdtold=-1; end
            else
              error('A_applyOpCond.m: illegal time step')
            end
        elseif strcmp(OC(ii),'SFstart=') && isnumeric(val{ii}) && length(val{ii}) == 1
            SFstart=val{ii};
            if SFstart > 1; SFstart=1; end
            if SFstart < realmin; SFstart=realmin; end
        elseif strcmp(OC(ii),'SFmult=') && isnumeric(val{ii}) && length(val{ii}) == 1
            SFmult=val{ii};
            if SFstart < 10; SFmult=10; end    
        else
            error('A_applyOpCond.m: illegal Operating Condition')
        end
    end % end of for loop
    
    if ndt == 0 && (strcmp(mode,'transient') || strcmp(mode,'transient2')); error('A_applyOpCond.m: delta_t must be set'); end
    if nkeep*nrep > 0; error('A_applyOpCond.m: cannot both keep and replace illumination conditions'); end
    if ndark && nillum > 1; error('A_applyOpCond.m: dark cannot be combined with other illumination conditions'); end
    if nillum == 0
      nOpCond.Generation=dev.OpCond.Generation;
      nkeep=1;
    elseif nkeep == 1 && strcmp(dev.OpCond.Generation(1).type,'dark') && nillum > 0
      error('A_applyOpCond.m: Cannot keep ''dark'' and add to it.')
    elseif nkeep == 1
      nOpCond.Generation=dev.OpCond.Generation;  
      nog=length(dev.OpCond.Generation);
      for ig=1:length(nGeneration)
        nOpCond.Generation(nog+ig)=nGeneration(ig);
      end
      nkeep=0;
    else % else discard illumination condtions from dev
      nOpCond.Generation=nGeneration;
    end
    if njv == 0 % use Va/Jt from dev
        nOpCond.setv=dev.OpCond.setv;
        nOpCond.Jt=dev.OpCond.Jt;
        nOpCond.jt=dev.OpCond.jt;
        nOpCond.Va=dev.OpCond.Va;
        nOpCond.va=dev.OpCond.va;
    end
    nOpCond.freq=0;
    nOpCond.omega=0;
    nOpCond.set_ac='none';
    if ndt == 0
      nOpCond.time_step=inf;
      nOpCond.rdt=0;
      nOpCond.rdtold=-1;
    end
  
  case 'small-signal'
  
    nkeep=1; % small signal is applied to dev operating conditions
    ndark=0;
    nfreq=0;
    nac=0;
    nOpCond.in_mode=dev.OpCond.mode;
    nOpCond.setv=dev.OpCond.setv;
    nOpCond.Jt=dev.OpCond.Jt;
    nOpCond.jt=dev.OpCond.jt;
    nOpCond.Va=dev.OpCond.Va;
    nOpCond.va=dev.OpCond.va;
    nOpCond.Generation=dev.OpCond.Generation;
    nOpCond.time_step=dev.OpCond.time_step;
    nOpCond.rdt=dev.OpCond.rdt;
    nOpCond.rdtold=dev.OpCond.rdtold;
    
    if strcmp(nOpCond.in_mode,'small-signal') || strcmp(nOpCond.in_mode,'frozen')
      error('A_applyOpCond.m: mode of dev cannot be small-signal or frozen')
    end
    for ii=1:nOC
      if strcmp(OC{ii},'freq=')
          nfeq=nfreq+1;
            if nfreq > 1; error('A_applyOpCond.m: only one frequency can be set'); end
          fii=val{ii};
          if isnumeric(fii) && length(fii) == 1
            nOpCond.freq=fii;
            nOpCond.omega=2*pi*nOpCond.freq*dev.norm.time;
          else
            error('A_applyOpCond.m: frequency must be numeric')
          end
      elseif strcmp(OC{ii},'ac_signal')
          nac=nac+1;
          if nac ~= 1; error('A_applyOpCond.m: exactly one ac signal must be set'); end
          acii=val{ii};
          if ischar(acii)
            if strcmp(acii,'Vac')
              nOpCond.set_ac='Vac';
              nOpCond.vac=dev.norm.v;
            else
              error('A_applyOpCond.m: ac signal not recognized(1)')
            end
          elseif isstruct(acii)
              a_struct=val{ii};
              if strcmp(a_struct.type,'Gac_uniform')
                  nOpCond.set_ac='Gac_uniform'
                  nOpCond.Gac=a_struct.Gac;
                  nOpCond.vac=0;
                  nOpCond.Jinc_ac=1;
              elseif strcmp(a_struct.type,'Gac_mono')
                  nOpCond.set_ac='Gac_mono';
                  nOpCond.ac_torb=a_struct.top_or_bottom;
                  nOpCond.ac_wl=a_struct.wl;
                  nOpCond.ac_angle=a_struct.inc_angle;
                  nOpCond.vac=0;
                  nOpCond.Jinc_ac=1;
              elseif strcmp(a_struct.type,'Gac_spectrum')
                  nOpCond.set_ac='Gac_spectrum';
                  nOpCond.ac_torb=a_struct.top_or_bottom;
                  nOpCond.ac_spec=a_struct.spectrum;
                  nOpCond.ac_angle=a_struct.inc_angle;
                  nOpCond.vac=0;
                  nOpCond.Jinc_ac=1;
                else
                    error('A_applyOpCond.m: Unrecognized illumination condition(2)')
                end
          else
            error('A_applyOpCond.m: ac signal not recognized(3)')
          end
      end
      
    end % end of for loop
    if nac ~= 1 && nfreq ~= 1
        error('A_applyOpCond.m: ac small-signal improperly set');
    end
  otherwise
    
    error('A_applyOpCond.m: mode not recognized')
  
end

newdev=dev;
newdev.OpCond=struct;
newdev.OpCond=nOpCond;
newdev.OpCond.FC_on=dev.OpCond.FC_on; % free carrier absorption

% set gereration rate and scale factor
oJt=dev.OpCond.Jt;
nJt=newdev.OpCond.Jt;
newdev.OpCond.scale_mult=SFmult;
ne=dev.mesh.num_ele;
if ndark
  newdev.OpCond.Gset=1;
  newdev.OpCond.scale_factor=1;
  newdev.OpCond.Gon=0;
  newdev.OpCond.Jgen=0;
  newdev.ele.Gl(1:ne)=0;
  newdev.ele.Gr(1:ne)=0;
elseif nkeep
  newdev.OpCond.Gset=1;
  newdev.OpCond.scale_factor=1;
  newdev.OpCond.Gon=1;
else 
  oGl=dev.ele.Gl;
  oGr=dev.ele.Gr;
  newdev.OpCond.Gset=0;
  newdev.OpCond.Gon=1;
  [nGl nGr]=a_setgen(newdev);
  newdev.ele.Gl=nGl;
  newdev.ele.Gr=nGr;
  newdev.OpCond.Gset=1;
  newdev.OpCond.Gon=1;
  h=newdev.ele.h/2;
  oJgen=sum(oGl.*h+oGr.*h)*newdev.norm.j;
  nJgen=sum(nGl.*h+nGr.*h)*newdev.norm.j;
  newdev.OpCond.Jgen=nJgen;
%   nOpCond.Generation(nillum).J_Gen=nJgen;
  rJgen=oJgen/nJgen;
  if rJgen >= .95
    newdev.OpCond.scale_factor=1;
  elseif rJgen < SFstart
    newdev.OpCond.scale_factor=SFstart;
  else 
    newdev.OpCond.scale_factor=rJgen;
   end 
end

Rcontacts=(newdev.bc.top.rc+newdev.bc.bottom.rc)/(newdev.norm.v/newdev.norm.j);

% finish setting up newdev and simulate
rdt=newdev.OpCond.rdt;
rdtold=newdev.OpCond.rdtold;

switch mode
    
        case 'steady-state'
        
        lGen=length(newdev.OpCond.Generation);
        Gentypes='';
        for ig=1:lGen
          gstr=newdev.OpCond.Generation(ig).type;
          if ig < lGen;
            Gentypes=strcat(Gentypes,gstr,'/'); 
          else
           Gentypes=strcat(Gentypes,gstr);
          end
        end
        if strcmp('',Gentypes) == 1; Gentypes='dark'; end
        
        if newdev.OpCond.setv == 1
            if VERBOSE; fprintf('Apply desired operating condition: T=%.1f K; Va=%.3f V; Gen=%s\n',...
                    newdev.OpCond.T_K,newdev.OpCond.Va,Gentypes); end
        else
            if VERBOSE; fprintf('Apply desired operating condition: T=%.1f K; Jt=%.3f A/cm^2; Gen=%s\n',...
                    newdev.OpCond.T_K,newdev.OpCond.Jt,Gentypes); end
        end

        if strcmp(newdev.type,'Solar Cell') 
            %disp('A_applyOpCond: Use active sign convention for dev.type=''Solar_Cell''')
            % active sign convention
            if newdev.ele.plo(1) > newdev.ele.nlo(1)
                newdev.OpCond.va=newdev.OpCond.Va/newdev.norm.v;
                newdev.OpCond.jt=-newdev.OpCond.Jt/newdev.norm.j;
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(2): simulation terminated'); end
                Jj=-a_jtot(newdev);
                Vv=(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v-Rcontacts*Jj;
            else
                newdev.OpCond.va=-newdev.OpCond.Va/newdev.norm.v;
                newdev.OpCond.jt=newdev.OpCond.Jt/newdev.norm.j;
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(3): simulation terminated'); end
                Jj=a_jtot(newdev);
                Vv=-(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v-Rcontacts*Jj;
            end
            newdev.OpCond.Va=Vv;
            newdev.OpCond.Jt=Jj;

        elseif strcmp(newdev.type,'Diode')
            %disp('A_applyOpCond: Use passive sign convention for dev.type=''Diode''')
            % passive sign convention
            if newdev.ele.plo(1) > newdev.ele.nlo(1)
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(4): simulation terminated'); end
                Jj=a_jtot(newdev);
                Vv=(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v+Rcontacts*Jj;
            else
                newdev.OpCond.va=-newdev.OpCond.va;
                newdev.OpCond.jt=-newdev.OpCond.jt;
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(5): simulation terminated'); end
                Jj=-a_jtot(newdev);
                Vv=-(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v+Rcontacts*Jj;
            end
            newdev.OpCond.Va=Vv;
            newdev.OpCond.Jt=Jj;

        elseif strcmp(newdev.type,'Generic')
            % cathode on top, anode on bottom. passive sign convention
            newdev.OpCond.va=newdev.OpCond.Va/newdev.norm.v;
            newdev.OpCond.jt=newdev.OpCond.Jt/newdev.norm.j;
            [newdev error_code]=a_doneq(newdev);
            if error_code == 0; error('A_applyOpCond(4): simulation terminated'); end
            Jj=a_jtot(newdev);
            Vv=(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v+Rcontacts*Jj;
            newdev.OpCond.Va=Vv;
            newdev.OpCond.Jt=Jj;
        else
            error('A_applyOpCond(6): unknown device type')
        end
        
        % save data for extraction
        newdev.data=p_extract(newdev);
    
    case {'transient' 'transient2'}

        if strcmp(mode,'transient2') && (strcmp(dev.mode,'transient') || strcmp(dev.mode,'transient2'))
            % do nothing
        else
            mode='transient';
            newdev.OpCond.mode=mode;
            newdev.mode=mode;
            newdev.OpCond.rdtold=-1;
        end
        
        % get needed parameters at previous time
        newdev.node.vold(1,:)=dev.node.v;
        newdev.node.zpold(1,:)=dev.node.zp;
        newdev.node.znold(1,:)=dev.node.zn;
        newdev.ele.plold(1,:)=dev.ele.pl;
        newdev.ele.prold(1,:)=dev.ele.pr;
        newdev.ele.nlold(1,:)=dev.ele.nl;
        newdev.ele.nrold(1,:)=dev.ele.nr;
        if strcmp(mode,'transient2')
            rdtold=dev.OpCond.rdt;
            newdev.node.vold(2,:)=dev.node.vold(1,:);
            newdev.node.zpold(2,:)=dev.node.zpold(1,:);
            newdev.node.znold(2,:)=dev.node.znold(1,:);
            newdev.ele.plold(2,:)=dev.ele.plold(1,:);
            newdev.ele.prold(2,:)=dev.ele.prold(1,:);
            newdev.ele.nlold(2,:)=dev.ele.nlold(1,:);
            newdev.ele.nrold(2,:)=dev.ele.nrold(1,:);
            newdev.OpCond.rdtold=dev.OpCond.rdt;
        end
        % retrieve nt from previous time(s)
        newdev.oldnt=dev.nt;
        if rdtold > 0 % previous time step
            newdev.oldoldnt=dev.oldnt;
        end
        
        lGen=length(newdev.OpCond.Generation);
        Gentypes='';
        for ig=1:lGen
          gstr=newdev.OpCond.Generation(ig).type;
          if ig < lGen;
            Gentypes=strcat(Gentypes,gstr,'/'); 
          else
           Gentypes=strcat(Gentypes,gstr);
          end
        end
        if strcmp('',Gentypes) == 1; Gentypes='dark'; end
      
        if newdev.OpCond.setv == 1
            if VERBOSE; fprintf('Apply desired operating condition: dt=%.2e sec; T=%.1f K; Va=%.3f V; Gen=%s\n',...
                    newdev.OpCond.time_step,newdev.OpCond.T_K,newdev.OpCond.Va,Gentypes); end
        else
            if VERBOSE; fprintf('Apply desired operating condition: dt=%.2e sec; T=%.1f K; Jt=%.3f A/cm^2; Gen=%s\n',...
                    newdev.OpCond.time_step,newdev.OpCond.T_K,newdev.OpCond.Jt,Gentypes);end
        end
          
        if strcmp(newdev.type,'Solar Cell') 
            %disp('A_applyOpCond: Use active sign convention for dev.type=''Solar_Cell''')
            % active sign convention
            if newdev.ele.plo(1) > newdev.ele.nlo(1)
                newdev.OpCond.va=newdev.OpCond.Va/newdev.norm.v;
                newdev.OpCond.jt=-newdev.OpCond.Jt/newdev.norm.j;
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(2): simulation terminated'); end
                Jj=-a_jtot(newdev);
                Vv=(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v-Rcontacts*Jj;
            else
                newdev.OpCond.va=-newdev.OpCond.Va/newdev.norm.v;
                newdev.OpCond.jt=newdev.OpCond.Jt/newdev.norm.j;
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(3): simulation terminated'); end
                Jj=a_jtot(newdev);
                Vv=-(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v-Rcontacts*Jj;
            end
            newdev.OpCond.Va=Vv;
            newdev.OpCond.Jt=Jj;

        elseif strcmp(newdev.type,'Diode')
            %disp('A_applyOpCond: Use passive sign convention for dev.type=''Diode''')
            % passive sign convention
            if newdev.ele.plo(1) > newdev.ele.nlo(1)
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(4): simulation terminated'); end
                Jj=a_jtot(newdev);
                Vv=(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v+Rcontacts*Jj;
            else
                newdev.OpCond.va=-newdev.OpCond.va;
                newdev.OpCond.jt=-newdev.OpCond.jt;
                [newdev error_code]=a_doneq(newdev);
                if error_code == 0; error('A_applyOpCond(5): simulation terminated'); end
                Jj=-a_jtot(newdev);
                Vv=-(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v+Rcontacts*Jj;
            end
            newdev.OpCond.Va=Vv;
            newdev.OpCond.Jt=Jj;

        elseif strcmp(newdev.type,'Generic')
            % cathode on top, anode on bottom. passive sign convention
            newdev.OpCond.va=newdev.OpCond.Va/newdev.norm.v;
            newdev.OpCond.jt=newdev.OpCond.Jt/newdev.norm.j;
            [newdev error_code]=a_doneq(newdev);
            if error_code == 0; error('A_applyOpCond(4): simulation terminated'); end
            Jj=a_jtot(newdev);
            Vv=(newdev.node.v(1)-newdev.node.vo(1))*newdev.norm.v+Rcontacts*Jj;
            newdev.OpCond.Va=Vv;
            newdev.OpCond.Jt=Jj;
        else
            error('A_applyOpCond(6): unknown device type')
        end
      
        changeinv=max(abs(newdev.node.v-newdev.node.vold(1,:)));
        changeinzp=max(abs(newdev.node.zp-newdev.node.zpold(1,:)));
        changeinzn=max(abs(newdev.node.zn-newdev.node.znold(1,:)));
        newdev.misc.trans_dzmax=max([changeinv,changeinzp,changeinzn]);
      
      % save data for extraction
      newdev.data=p_extract(newdev);
        
    case 'small-signal'

        if strcmp(dev.OpCond.mode,'equilibrium')
            dev.OpCond.mode='steady-state';
        end
        if strcmp(dev.OpCond.mode,'frozen') || strcmp(dev.OpCond.mode,'small-signal') 
            error('A_applyOpCond: Input mode of operation must be ''equilibrium'', ''steady-state'' or ''transient''.')
        end

        if strcmp(newdev.OpCond.set_ac,'Vac')
            if VERBOSE; fprintf('Apply small-signal voltage @ %g Hz\n',newdev.OpCond.freq); end
        else
            if VERBOSE; fprintf('Apply small-signal generation (%s) @ %g Hz\n',newdev.OpCond.set_ac,newdev.OpCond.freq); end
        end
        [newdev error_code]=a_doac(newdev);
        
        Vv=newdev.OpCond.Vac;
        Jj=newdev.OpCond.Jac;
        
    case 'frozen'
        error('A_applyOpCond: ''frozen'' mode of operation not implemented')
        
    otherwise
        error('A_applyOpCond: unknown mode of operation')
end

switch mode
    case 'steady-state'; pre='SS';
    case {'transient' 'transient2'}; pre='TR';
    case 'small-signal'; pre='AC';
    case 'frozen'; pre='FZ';
    otherwise error('mode not recognized');
end
newdev.runno=a_srunno(pre);

