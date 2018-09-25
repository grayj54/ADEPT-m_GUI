function dev=a_setup(dev)
global A_FID CONST VERBOSE

% set equilibrium operating conditions
dev.OpCond.mode='equilibrium';
dev.OpCond.T_K=dev.ref.t;
dev.OpCond.T_C=dev.ref.t+CONST.abs_zero;
dev.OpCond.setv=1; % set voltage
dev.OpCond.Va=0; % in Volts
dev.OpCond.va=0; % normalized
dev.OpCond.Jt=0; % in A/cm^2
dev.OpCond.jt=0; % normalized
dev.OpCond.Generation=make_Generation;
dev.OpCond.Generation(1).type='dark';
dev.OpCond.scale_factor=1;
dev.OpCond.time_step=inf; % in seconds
dev.OpCond.rdt=0; % normalized 1/time_step
dev.OpCond.rdtold=-1; % previous normalized 1/time_step (if it exists)
dev.OpCond.freq=0; % small-signal frequency in radians/sec
dev.OpCond.omega=0; % normalized
dev.OpCond.set_ac='none';

if strcmp(dev.nD,'1D') == 1

    if strcmp(dev.mesh.method,'uniform')
        if VERBOSE; fprintf(A_FID,'\n--- Set up uniform mesh\n\n'); end
        dev.mesh.num_ele=dev.mesh.num_nod-1;
        nreg=length(dev.reg);
        x=linspace(0,dev.reg(nreg).max,dev.mesh.num_nod);
        dev.node.pos(1)=x(1);
        for i=2:dev.mesh.num_nod
            dev.node.pos(i)=x(i); % =[x y z]
            e=i-1;
            dev.ele.h(e)=(x(i)-x(i-1))/dev.norm.x;
            dev.ele.reg(e)=a_in_region(dev,0.5*(x(i-1)+x(i)));
        end
        %initial guess
        if VERBOSE; fprintf(A_FID,'\n--- Generate initial guess for a_doeq\n\n'); end
        %dev=setv_neutral1(dev);
        dev=a_doeq(dev,1);
        % initialize carrier conc arrays (needed for band parameter setup)
        dev.ele.nl(1:dev.mesh.num_ele)=1;
        dev.ele.pl(1:dev.mesh.num_ele)=1;
        dev.ele.nr(1:dev.mesh.num_ele)=1;
        dev.ele.pr(1:dev.mesh.num_ele)=1;       
        dev=set_pn_newt(dev);
    elseif strcmp(dev.mesh.method,'Adebug')
        if VERBOSE; fprintf(A_FID,'\n--- Set up debugging mesh\n\n'); end
        dev.mesh.num_nod=5;
        dev.mesh.num_ele=dev.mesh.num_nod-1;
        nreg=length(dev.reg);
        x=[0,1e-6,2e-6,3e-6,4e-6];
        dev.node.pos(1)=x(1);
        for i=2:dev.mesh.num_nod
            dev.node.pos(i)=x(i); % =[x y z]
            e=i-1;
            dev.ele.h(e)=(x(i)-x(i-1))/dev.norm.x;
            dev.ele.reg(e)=a_in_region(dev,0.5*(x(i-1)+x(i)));
        end
        %initial guess
        if VERBOSE; fprintf(A_FID,'\n--- Generate initial guess for a_doeq\n\n'); end
        %dev=setv_neutral1(dev);
        dev=a_doeq(dev,1);
        dev.ele.nl(1:dev.mesh.num_ele)=1;
        dev.ele.pl(1:dev.mesh.num_ele)=1;
        dev.ele.nr(1:dev.mesh.num_ele)=1;
        dev.ele.pr(1:dev.mesh.num_ele)=1;
        dev=set_pn_newt(dev);
    elseif strcmp(dev.mesh.method,'auto')
        if VERBOSE; fprintf(A_FID,'\n--- Set up automatic mesh\n\n'); end
        save_testq=dev.newton.testq;
        dev.newton.testq=dev.newton.testq_setup;
        dev=a_setmesh(dev);
        dev.newton.testq=save_testq;
    else
        error('a_setup: method not found')
    end
end

% determine if there is any free carrier absorption, if not
% Gext(x) will not change, i.e., independent of p and n
% photon recycling will be strictly additive
dev.OpCond.FC_on=0;
for ireg=1:length(dev.reg)
  if strcmp(dev.Optical.opt_abs_model(ireg).alpha_fc,'on'); dev.OpCond.FC_on=1; end
end

ne=dev.mesh.num_ele;
dev.ele.Gl(1:ne)=0;
dev.ele.Gr(1:ne)=0;
dev.OpCond.Gset=1; % indicates G(x) has been computed

%dev=ADEPT(dev)
