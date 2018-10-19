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
stuff=A_info(DevSC);

% step up voltage
j=Jsc;
Dold=DevSC;
v=0;
p=0;
vmp=0;
vstep=0.05;
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
  VV(ii)=v;
  JJ(ii)=j;
end  

% Open-Circuit
[Voc,Joc,DevOC]=a_findOC(Dold,VV(ii-1),VV(ii));
VV(ii)=Voc;
JJ(ii)=0;

% Max Power
Vmp=a_findMP(DevMP,vmp-vstep,vmp+vstep);
[DevMP,Vmp,Jmp]=A_applyOpCond(DevOC,mode,'V=',Vmp,'Illum=','keep');
VV(ii+1)=Vmp;
JJ(ii+1)=Jmp;

% add points between Vmp and Voc
nv=length(VV);
vsteps=6;
dv=(Voc-Vmp)/vsteps;
vv=Vmp;
Dold=DevMP;
for ii=nv+1:nv+vsteps-1
  vv=vv+dv;
  [Dnew,VV(ii),JJ(ii)]=A_applyOpCond(Dold,mode,'V=',vv,'Illum=','keep');
  Dold=Dnew;  
end

[VV,isort]=sort(VV);
JJ=JJ(isort);

FF=Vmp*Jmp/Voc/Jsc;
if strcmp(illum.type,'spectrum')
    eff=Vmp*Jmp/stuff.spectrum_P_inc;
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
    sctitle=sprintf('%s @ %g Suns',stuff.spectrum_file{1},stuff.spectrum_X);
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
SCanalysis.Joc=Joc;
SCanalysis.Jsc=Jsc;
SCanalysis.Vmp=Vmp;
SCanalysis.Jmp=Jmp;
SCanalysis.FF=FF;
if strcmp(illum.type,'spectrum')
   SCanalysis.eff=Vmp*Jmp/stuff.spectrum_P_inc;
end
SCanalysis.V=sV;
SCanalysis.J=sJ;
SCanalysis.DevSC=DevSC;
SCanalysis.DevMP=DevMP;
SCanalysis.DevOC=DevOC;
end

function [Voc,Joc,DevOC]=a_findOC(dev,Va,Vb)
[~,~,Ja]=A_applyOpCond(dev,'steady-state','V=',Va,'Illum=','keep');
[devb,~,Jb]=A_applyOpCond(dev,'steady-state','V=',Vb,'Illum=','keep');
for k=1:100
    Vc=0.5*(Va+Vb); %bisection
    %Vc=interp1([Ja,Jb],[Va,Vb],0); % interpolation
    [devc,~,Jc]=A_applyOpCond(devb,'steady-state','V=',Vc,'Illum=','keep');
    if Jc == 0
        Voc=Vc;
        Joc=Jc;
        DevOC=devc;
        return;
    elseif Jc*Ja < 0
        Vb=Vc;
        Jb=Jc;
        devb=devc;
    else
        Va=Vc;
        Ja=Jc;
        deva=devc;
    end
    if abs(Jc) < 1e-9 || abs(Va-Vb) < 1e-6 % Voc found
        Voc=Vc;
        Joc=Jc;
        DevOC=devc;
        return;
    end
end
Vc
Jc
error('Voc not found')
end

function [Vmp]=a_findMP(dev,V1,V2)
global mpdev
mpdev=dev;
Vmp=fminbnd(@(V) a_power(V),V1,V2,optimset('display','off'));
end

function p=a_power(V)
global mpdev
[mpdev,Vv,Jj]=A_applyOpCond(mpdev,'steady-state','V=',V,'Illum=','keep');
p=-Vv*Jj;
end

