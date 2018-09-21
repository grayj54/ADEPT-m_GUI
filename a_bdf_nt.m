function [rdt_eff nt_last_eff]=a_bdf_nt(ntold,rdt,rdtold);
% uold=[previous pre-previous]
% rdt=[current last] reciprocal timestep

if rdt > 0 && rdtold <= 0
    % solution at the previous timestep is known
    % O(dt)
    rdt_eff=rdt;
    nt_last_eff=ntold(1,:);
    
elseif rdt > 0 && rdtold > 0
    % solutions at the 2 previous timesteps are known
    % O(dt^2) even for non-uniform timestep
    nt1=ntold(1,:);
    nt0=ntold(2,:);
    dt2=1/rdt;
    dt1=1/rdtold;
    A=(2*dt2+dt1)/dt1/dt2-(2*dt2+dt1)/(dt1+dt2)/dt2-1/dt1;
    B=1/dt1-(2*dt2+dt1)/dt1/dt2;
    C=(2*dt2+dt1)/(dt1+dt2)/dt2;
    rdt_eff=C;
    nt_last_eff=(-A*nt0-B*nt1)/C;
    
else
    size(ntold), rdt, rdtold
    error('a_bdf: illegal input')
    
end