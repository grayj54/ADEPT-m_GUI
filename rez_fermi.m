function rez_fermi = rez_fermi(x)
% inverse function to the Fermi integral "fermi(x,k=1/2)"
% (after Blakemore, Solid State Electronics (1982), p. 1067, eq. (38))
% x must be > 0

if min(x)<=0
   error('rez_fermi.m: x has to be > 0');
end

x = x(:)';
m = find(x);

m1 = find(x == 1);
if ~isempty(m1)
	A(m1) = -0.5;					          % limiting value of the 1st term for x -> 1
end
m2 = find(x ~= 1);
if ~isempty(m2)
   A(m2) = log(x(m2))./(1-x(m2).^2);    % 1st term otherwise
end

num = 3 * sqrt (pi) * x(m)/4;
klamm1 = 3 * sqrt(pi) .* x(m)/4;
klamm = 0.24 + 1.08 .* klamm1.^(2/3);
den = 1 + 1./klamm.^2;
B = num.^(2/3)./den;      % 2nd term

eta = A + B;
rez_fermi = eta;