function p=a_power(V)
global mpdev

[mpdev,Vv,Jj]=A_applyOpCond(mpdev,'steady-state','V=',V,'Illum=','keep');

p=-Vv*Jj;