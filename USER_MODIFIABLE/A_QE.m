function [QEanalysis]=A_QE(Dev,wl)

Illum.type='mono';
Illum.top_or_bottom='top';
Illum.J_Inc=1e-6;
Illum.inc_angle=0;

JJ=Dev.OpCond.Jt;
Jgen0=abs(Dev.OpCond.Jgen);

for iwl=1:length(wl)
    Illum.wl=wl(iwl);
    [DevWL,~,Jwl]=A_applyOpCond(Dev,'steady-state','Illum=','keep','Illum=',Illum);
    Jqe(iwl)=Jwl-JJ;
    Jgen(iwl)=DevWL.OpCond.Jgen-Jgen0;
end

[shadow,Rext]=A_get_surface_optics(Dev,'top');

QEanalysis.wl=wl;
QEanalysis.EQE=Jqe/Illum.J_Inc; % External Quantum Efficiency
QEanalysis.IPCE=Jqe/(1-shadow)/(1-Rext)/Illum.J_Inc;  % Incident Photon Collection Efficiency
QEanalysis.IQE=Jqe./Jgen; % Internal Quantum Efficiency

if length(wl) > 1
    fig=figure;
    fig.Name='Quantum Efficiency';
    plot(QEanalysis.wl,QEanalysis.EQE,'k');
    hold on;
    plot(QEanalysis.wl,QEanalysis.IPCE,'b');
    plot(QEanalysis.wl,QEanalysis.IQE,'r');
    xlabel('Wavelength (microns)')
    ylabel('Quantum Efficiency')
    legend('EQE','IPCE','IQE','Location','Best')
end


