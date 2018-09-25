function [CVanalysis]=A_CV(DevEQ)
global CONST
a_init;

if strcmp(DevEQ.OpCond.mode,'equilibrium') ~= 1
    error('A_C-V: starting operating condition must be ''equilibrium''')
end

frequency=60;

% voltage steps
Dold=DevEQ;
ii=0;

for vv=0:-0.1:-3
  ii=ii+1;
  [Dnew,Va(ii),Jtot(ii)]=A_applyOpCond(Dold,'steady-state','V=',vv);
  Dold=Dnew;
  [Dnew,Vac,Jac]=A_applyOpCond(Dold,'small-signal','freq=',frequency,'ac_signal','Vac');

  Y=Jac/Vac;
  Jreal(ii)=real(Jac);
  Jimag(ii)=imag(Jac);
  Jabs(ii)=abs(Jac);
  C(ii)=imag(Y)/2/pi/frequency;
  G(ii)=real(Y);
  YY(ii)=Y;
end

kk=length(C);
yy=1./C./C;
slope=(yy(2:kk)-yy(1:kk-1))./(Va(2:kk)-Va(1:kk-1));
Nb=-2/CONST.q/10/CONST.e0./slope;

% plot(Va,Jreal)
% hold on
% plot(Va,Jimag)
% plot(Va,Jabs)

plot(Va,1./(C.*C),'*');
hold on
xlabel('Voltage (V)')
ylabel('1/C^2 (cm^4/F^2)')
%print('-djpeg','IVtest.jpg')

CVanalysis.Vc=Va;
CVanalysis.f=frequency;
CVanalysis.Y=YY;
CVanalysis.C=C;
CVanalysis.G=G;
CVanalysis.Vn=0.5*(Va(1:kk-1)+Va(2:kk));
CVanalysis.N=Nb;
CVanalysis.Jreal=Jreal;
CVanalysis.Jimag=Jimag;
CVanalysis.Jabs=Jabs;
CVanalysis.Dev=Dnew;

fprintf('\n\n N_b = %.2e cm^-3\n\n',sum(Nb)/length(Nb));