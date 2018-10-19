function [IVanalysis]=A_IV(DevEQ,Illum)
global A_FID

if strcmp(DevEQ.OpCond.mode,'equilibrium') ~= 1
    error('A_I-V: starting operating condition must be ''equilibrium''')
end

mode='steady-state';

Dev{1}=DevEQ;
Va(1)=0;
Jtot(1)=0;


% voltage steps
Dold=DevEQ;
vv=0;
ii=0;
for vv=0.01:0.1:.8
  ii=ii+1;
  [Dnew,Va(ii),Jtot(ii)]=A_applyOpCond(Dold,mode,'V=',vv,'Illum=','dark');
  Dold=Dnew;
end

ha=figure;
semilogy(Va,Jtot,'*');
print('-djpeg','IVtest.jpg')
%pause
%close(ha)

IVanalysis.Va=Va;
IVanalysis.Jt=Jtot;