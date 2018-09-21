function [Voc,t,newdev]=A_OCVdecay(DevOP0)
global CONST
a_init;

frac=.25;
olddev=DevOP0;

t(1)=0;
Voc(1)=olddev.OpCond.Va;

tstep=1e-8;
t(2)=tstep;
[newdev Voc(2) Joc]=A_applyOpCond(olddev,'transient','J=',0,'delta_t=',tstep,'Illum=','dark');
dztest=newdev.misc.trans_dzmax;
V=Voc(2)
J=Joc
olddev=newdev;

icnt=2;
t(2)=tstep;
while t(icnt) < .0005  %&& icnt < 20

    if dztest > 1.5*frac
        % redo timestep
        if icnt == 2
            mode='transient';
            tstep=tstep/dztest;
        else
            mode='transient2';
            tstep=tstep/2;
%             z1=dztest
%             pause
        end
    elseif dztest < 0.5*frac
        icnt=icnt+1;
        olddev=newdev;
        mode='transient2';
        tstep=min([2*tstep,2e-6]);
%         z2=dztest
%         pause
    else
        icnt=icnt+1;
        olddev=newdev;
        mode='transient2';
        tstep=tstep;
    end
    t(icnt)=t(icnt-1)+tstep;
    [newdev Voc(icnt) Joc]=A_applyOpCond(olddev,mode,'J=',0,'delta_t=',tstep,'Illum=','dark');
    dztest=newdev.misc.trans_dzmax;
    icnt
    vvoc=Voc(icnt)
    Joc
end

plot(t,Voc)
hold on
xlabel('time (s)')
ylabel('Open-Circuit Voltage (V)')

end