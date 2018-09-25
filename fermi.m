function fermi= fermi(x,k)
% fermi(x,k)
% Fermi integral of order k = -1/2, 1/2 oder 3/2 
% rational approximation after Cody and Thacher, Math. Comput. 21 (1967), 30
% F(x) includes division by Gamma funktion
% Chebyshev 5-point approximation

if nargin < 2, k=1/2; end
n = k+3/2;

if n ~= 1 && n ~= 2 && n ~= 3
	error('    improper coefficient')
end
%gkp1=gamma(k+1);
x = x(:)';
xbreak = 1;
m = find(x <= xbreak);
if ~isempty(m)
   % coefficients for x<= 1
   % first column: k=-1/2  second column: k=1/2  third column: k=3/2
   
   p0 = [-1.253314128820     -3.133285305570e-1  -2.349963985406e-1];
   p1 = [-1.723663557701     -4.161873852293e-1  -2.927373637547e-1];
   p2 = [-6.559045729258e-1  -1.502208400588e-1  -9.883097588738e-2];
   p3 = [-6.342283197682e-2  -1.339579375173e-2  -8.251386379551e-3];
	p4 = [-1.488383106116e-5  -1.513350700138e-5  -1.874384153223e-5];

   q0 = [1.0                  1.0                 1.0];
	q1 = [2.191780925980       1.872608675902      1.608597109146];
   q2 = [1.605812955406       1.145204446578      8.275289530880e-1];
   q3 = [4.443669527481e-1    2.570225587573e-1   1.522322382850e-1];
   q4 = [3.624232288112e-2    1.639902543568e-2   7.695120475064e-3];

   sum_p = p0(n) + p1(n).*exp(1.*x(m)) + p2(n).*exp(2.*x(m)) + p3(n).*exp(3.*x(m)) + p4(n).*exp(4.*x(m));
	sum_q = q0(n) + q1(n).*exp(1.*x(m)) + q2(n).*exp(2.*x(m)) + q3(n).*exp(3.*x(m)) + q4(n).*exp(4.*x(m));
   F(m) = exp(x(m)).*(gamma(k+1) + exp(x(m)).*sum_p./sum_q);
end

m = find((x > xbreak) & (x <= 4.));
if ~isempty(m)
   % coefficients for 1 < x <= 4
   
   	p0 = [1.0738127694      6.78176626660e-1   1.1530213402];
   	p1 = [5.6003303660      6.33124017910e-1   1.0591558972];
   	p2 = [3.6882211270      2.94479651772e-1   4.6898803095e-1];
   	p3 = [1.1743392816      8.01320711419e-2   1.1882908784e-1];
		p4 = [2.3641935527e-1   1.33918212940e-2   1.9438755787e-2];

   	q0 = [1.0               1.0                1.0];
		q1 = [4.6031840667      1.43740400397e-1   3.7348953841e-2];
   	q2 = [4.3075910674e-1   7.08662148450e-2   2.3248458137e-2];
   	q3 = [4.2151132145e-1   2.34579494735e-3  -1.3766770874e-3];
   	q4 = [1.1832601601e-2  -1.29449928835e-5   4.6466392781e-5];

		sum_p = p0(n) + p1(n).*x(m) + p2(n).*x(m).^2 + p3(n).*x(m).^3 + p4(n).*x(m).^4;
		sum_q = q0(n) + q1(n).*x(m) + q2(n).*x(m).^2 + q3(n).*x(m).^3 + q4(n).*x(m).^4;
   	F(m) = sum_p./sum_q;
end

m = find(x > 4.0);
if ~isempty(m)
     % coefficients for 4 < x
     % for large x is F=2/(3*gamma(1.5))*x^1.5
      
		p0 = [-8.222559330e-1   8.2244997626e-1   2.46740023684];
   	p1 = [-3.620369345e1    2.0046303393e1    2.19167582368e2];
   	p2 = [-3.015385410e3    1.8268093446e3    1.23829379075e4];
   	p3 = [-7.049871579e4    1.2226530374e4    2.20667724968e5];
		p4 = [-5.698145924e4    1.4040750092e5    8.49442920034e5];

   	q0 = [1.0               1.0               1.0];
		q1 = [3.935689841e1     2.3486207659e1    8.91125140619e1];
   	q2 = [3.568756266e3     2.2013483743e3    5.04575669667e3];
   	q3 = [4.181893625e4     1.1442673596e4    9.09075946304e4];
   	q4 = [3.385138907e5     1.6584715900e5    3.89960915641e5];
      
      x1(m) = 1./x(m).^2;	
		sum_p = p0(n) + p1(n).*x1(m) + p2(n).*x1(m).^2 + p3(n).*x1(m).^3 + p4(n).*x1(m).^4;
		sum_q = q0(n) + q1(n).*x1(m) + q2(n).*x1(m).^2 + q3(n).*x1(m).^3 + q4(n).*x1(m).^4;
   	F(m) = x(m).^(k+1) .* (1/(k+1) + sum_p./(sum_q.*x(m).*x(m)));
end

fermi = F./gamma(k+1);