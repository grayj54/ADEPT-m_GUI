function [G]=monogen_back(x,n_pass,Rf,Rb,phiW,theta_inc,rndx,alpha,alpha_fc)
% Compute generation rate, G(x) for light incident from x=W (back)
% x = mesh for G. gnodes are all nodes plus element midpoints. must be an odd number of nodes.
% n_pass = number of passes
% Rf = front internal reflectance
% Rb = back internal relectance
% phi0 = irradiance at normal incidence (#/cm^2);
% theta_inc = angle of incidence
% rndx = refractive index of absorber (use index of thickest material)
% alpha = absorption coeff between gnodes (1/cm)
% alpha_fc = free carrier absorption coeff between gnodes (1/cm)

phiW=phiW*cos(theta_inc);
theta=asin(sin(theta_inc)./sqrt(rndx)); % assume originating medium rndx=1
alpha=alpha./cos(theta);
alpha_fc=alpha_fc./cos(theta);
alfsum=alpha+alpha_fc;
n=length(x);
if mod(n,2) == 1
    % OK, n is odd
else
     error('length(x) must be an odd number')
end

G(1:n-1)=0;

phiB=phiW;
for p=1:n_pass

    if mod(p,2) == 0 % even number
    
        phiA=phi(1)*Rf;
        ii=[1:n 2:n];
        jj=[1:n 1:n-1];
        kk=[ones(1,n) -eax];
        M=sparse(ii,jj,kk);
        b=zeros(n,1);
        b(1,1)=phiA;
        phi=(M\b)';
        G=G+aratio./delx.*(phi(1:n-1)-phi(2:n));
    
    else % odd number
    
        if p > 1 % first pass not due to internal reflection
          phiB=phi(n)*Rb;
        end
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