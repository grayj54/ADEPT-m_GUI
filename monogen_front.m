function [G]=monogen_front(x,n_pass,Rf,Rb,phi0,theta_inc,rndx,alpha,alpha_fc)
% Compute generation rate, G(x) for light incident from x=0 (front)
% x = mesh for G. gnodes are all nodes plus element midpoints. must be an odd number of nodes.
% n_pass = number of passes
% Rf = front internal reflectance
% Rb = back internal relectance
% phi0 = irradiance at normal incidence (#/cm^2);
% theta_inc = angle of incidence
% rndx = refractive index of absorber between gnodes
% alpha = absorption coeff between gnodes (1/cm)
% alpha_fc = free carrier absorption coeff between gnodes (1/cm)

phi0=phi0*cos(theta_inc);
theta=asin(sin(theta_inc)./sqrt(rndx)); % assume originating medium rndx=1
alpha=alpha./cos(theta);
alpha_fc=alpha_fc./cos(theta);
alfsum=alpha+alpha_fc;
aratio(alfsum==0)=1;
aratio(alfsum~=0)=alpha(alfsum~=0)./alfsum(alfsum~=0);
n=length(x);
if mod(n,2) == 1
    % OK, n is odd
else
     error('length(x) must be an odd number')
end
delx=x(2:n)-x(1:n-1);
eax=exp(-alfsum.*delx);

G(1:n-1)=0;

phiA=phi0;
for p=1:n_pass

    if mod(p,2) == 1 % odd number
   
        if p > 1 % first pass not due to internal reflection
          phiA=phi(1)*Rf;
        end
        ii=[1:n 2:n];
        jj=[1:n 1:n-1];
        kk=[ones(1,n) -eax];
        M=sparse(ii,jj,kk);
        b=zeros(n,1);
        b(1,1)=phiA;
        phi=(M\b)';
        G=G+aratio./delx.*(phi(1:n-1)-phi(2:n));
    
    else %even number
    
        phiB=phi(n)*Rb;
        ii=[1:n 1:n-1];
        jj=[1:n 2:n];
        kk=[ones(1,n) -eax];
        M=sparse(ii,jj,kk);
        b=zeros(n,1);
        b(n,1)=phiB;
        phi=(M\b)';
        G=G+aratio./delx.*(phi(2:n)-phi(1:n-1));
    
    end

end