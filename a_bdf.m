function [dudt pwrt_u]=a_bdf(u2,uold,rdt,rdtold);
% uold=[previous pre-previous] zp or zn
% rdt=[current last] reciprocal timestep

if size(uold,1) == 1 && rdtold <= 0
    % solution at the previous timestep is known
    % O(dt)
    dudt=rdt.*(u2-uold(1,:));
    pwrt_u=rdt;
    
elseif size(uold,1) == 2 && rdtold > 0
    % solutions at the 2 previous timesteps are known
    % O(dt^2) even for non-uniform timestep
    u1=uold(1,:);
    u0=uold(2,:);
    dt2=1/rdt;
    dt1=1/rdtold;
    dudt10=(u1-u0)/dt1;
    dudt20=(u2-u0)/(dt2+dt1);
    dudt=dudt10+(dudt20-dudt10)/dt2*(2*dt2+dt1);
    %dudt=dudt10*(1-(2*dt2+dt1)/dt2)+dudt20*(2*dt2+dt1)/dt2;
    %dudt=
    
    pwrt_u=(2*dt2+dt1)/((dt2+dt1)*dt2);
    
else
    size(uold), rdt, rdtold
    error('a_bdf: illegal input')
    
end