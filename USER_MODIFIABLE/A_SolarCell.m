function [SCanalysis]=A_SolarCell(DevEQ,illum)
% [SCanalysis]=A_SolarCell(DevEQ,illum))
%
% DevEQ = ADEPT data structure for device at equilibrium (from A_build)
% illum = illumination data structure (see A_setillum)
%
global CONST
a_init;

if strcmp(A_mode(DevEQ),'equilibrium') ~= 1
    error('A_SolarCell: starting operating condition must be ''equilibrium''')
end

mode='steady-state';
SCanalysis.info=sprintf('ADEPT-m SolarCell Analysis for %s',A_runno(DevEQ));

% Short-Circuit
[DevSC,Vsc,Jsc]=A_applyOpCond(DevEQ,mode,'V=',0,'Illum=',illum);
VV(1)=0;
JJ(1)=Jsc;

% step up voltage
j=Jsc;
Dold=DevSC;
v=0;
p=0;
vmp=0;
vstep=0.1;
ii=1;
while j > 0
  v=v+vstep;
  ii=ii+1;
  [Dnew,v,j]=A_applyOpCond(Dold,mode,'V=',v,'Illum=','keep');
  pnew=v*j;
  if pnew > p
    vmp=v;
    DevMP=Dnew;
  end
  p=pnew;
  Dold=Dnew;
  if j > 0
    VV(ii)=v;
    JJ(ii)=j;
  end
end

% Open-Circuit
[DevOC,Voc,Joc]=A_applyOpCond(Dold,mode,'J=',0,'Illum=','keep');
VV(ii)=Voc;
JJ(ii)=0;

% Max Power
Vmp=a_findMP(DevOC,vmp-vstep,vmp+vstep);
[DevMP,Vmp,Jmp]=A_applyOpCond(DevOC,mode,'V=',Vmp,'Illum=','keep');
VV(ii+1)=Vmp;
JJ(ii+1)=Jmp;

% add points between Vmp and Voc
nj=length(JJ);
jsteps=6;
dj=Jmp/jsteps;
jj=Jmp;
Dold=DevMP;
for ii=nj+1:nj+jsteps-1
  jj=jj-dj;
  [Dnew,VV(ii),JJ(ii)]=A_applyOpCond(Dold,mode,'J=',jj,'Illum=','keep');
  Dold=Dnew;  
end

[VV isort]=sort(VV);
JJ=JJ(isort);

FF=Vmp*Jmp/Voc/Jsc;
if strcmp(illum.type,'spectrum')
    eff=Vmp*Jmp/DevOC.OpCond.Generation.spec.sdata.Pinc;
end

sV(1:50)=linspace(0,Vmp,50);
sV(51:100)=linspace(1.0001*Vmp,Voc,50);
sJ=interp1(VV,JJ,sV,'pchip');
sJ(100)=0;
fig=figure;
try fig.Name='Solar Cell Characteristic'; end
plot([0 Vmp Vmp],[Jmp Jmp 0],'r');
hold on
plot(VV,JJ,'*');
plot(Vmp,Jmp,'ro');
plot(sV,sJ,'k');
xlabel('Voltage (V)');
ylabel('Current Density (A/cm^2)')
if strcmp(illum.type,'spectrum')
    sctitle=sprintf('%s @ %g Suns',DevOC.OpCond.Generation.spec.sdata.info,illum.X);
else
    sctitle='';
end
title(sctitle);
pvoc=sprintf('V_{OC} = %.3f V',Voc);
pjsc=sprintf('J_{SC} = %.3g A/cm^2',Jsc);
pvmp=sprintf('V_{MP} = %.3f V',Vmp);
pjmp=sprintf('J_{MP} = %.3g A/cm^2',Jmp);
pff=sprintf('FF = %.3f',FF);
if strcmp(illum.type,'spectrum')
  peff=sprintf('\x03B7 = %.3f',eff);
else
  peff='';
end
disp('Use mouse to place text.')
gtext({pvoc,pjsc,pvmp,pjmp,pff,peff});
hold off

SCanalysis.Voc=Voc;
SCanalysis.Jsc=Jsc;
SCanalysis.Vmp=Vmp;
SCanalysis.Jmp=Jmp;
SCanalysis.FF=FF;
if strcmp(illum.type,'spectrum')
   SCanalysis.eff=Vmp*Jmp/DevOC.OpCond.Generation.spec.sdata.Pinc;
end
SCanalysis.V=sV;
SCanalysis.J=sJ;
SCanalysis.DevSC=DevSC;
SCanalysis.DevMP=DevMP;
SCanalysis.DevOC=DevOC;


