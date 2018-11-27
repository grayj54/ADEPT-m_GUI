function [QEanalysis]=A_QE1(Deveq)
global CONST
a_init;

Illum0.type='spectrum';
Illum0.top_or_bottom='top';
Illum0.spectrum='am1.5g';
Illum0.inc_angle=0;

wl=linspace(.1,1.1,11);
kk=0;
for k=-7:3
    
    kk=kk+1;
    
    if k == -7
        Dev=A_applyOpCond(Deveq,'steady-state','V=',0,'Illum=','dark');
    else
        Illum0.X=10^k;
        Dev=A_applyOpCond(Deveq,'steady-state','V=',0,'Illum=',Illum0)
    end


    Illum.type='mono';
    Illum.top_or_bottom='top';
    Illum.J_Inc=1e-4;
    Illum.inc_angle=0;

    JJ(kk)=Dev.OpCond.Jt;

    for iwl=1:length(wl)
        Illum.wl=wl(iwl);
        if Dev.OpCond.Gon == 0
            [~,~,Jwl]=A_applyOpCond(Dev,'steady-state','V=',0,'Illum=',Illum);
        else
            [~,~,Jwl]=A_applyOpCond(Dev,'steady-state','V=',0,'Illum=','keep','Illum=',Illum);
        end
        Jqe(iwl)=Jwl-JJ(kk);
    end

    shadow=Dev.bc.top.shadow;
    Rext=Dev.bc.top.Rext;

    QEanalysis.wl=wl;
    QEanalysis.J=JJ;
    QEanalysis.EQE=Jqe/Illum.J_Inc;
    QEanalysis.IPCE=Jqe/(1-shadow)/(1-Rext)/Illum.J_Inc;

    if length(wl) > 1
%         plot(QEanalysis.wl,QEanalysis.EQE);
%         hold on;
        plot(QEanalysis.wl,QEanalysis.IPCE);
        hold on;
        xlabel('wavelength (microns)')
        ylabel('Quantum Efficiency')
        %legend('EQE','IPCE','Location','Best')
    end

end

