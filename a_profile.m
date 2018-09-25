function [C]=a_profile(x,prof)
% for use with Ndp, Nam, N.d, N.a

switch char(prof.kind)
    case 'linear'
        C=a_linear(x,prof.xt,prof.xb,prof.yt,prof.yb);
    case 'erfc'
        C=prof.Co*erfc(abs(prof.dir*(x-prof.xo))/2/sqrt(prof.Dt));
    case 'gaussian'
        C=prof.Co*exp(-(x-prof.xo).^2/2/prof.sigma^2);
    case 'exp'
        C=prof.Co*exp(-abs(prof.dir*(x-prof.xo))/prof.L);
    otherwise
        error('a_profile.m: impurity profile not supported')
end
C(C<prof.minN)=prof.minN;

