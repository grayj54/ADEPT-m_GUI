function [QEanalysis]=A_QEac(Dev,wl,freq)
% [QEanalysis]=A_QEac(Dev,wl)
%
% Dev = ADEPT object at operating condition for which QE is conducted
% wl = QE wavelength array (um)
% freq = frequency of ac illumination
%

mode='small-signal';

Illum.type='Gac_mono';
Illum.top_or_bottom='top';
Illum.inc_angle=0;

if nargin == 2
    freq=60;
end

for iwl=1:length(wl)
    Illum.wl=wl(iwl);
    [DevWL,Vwl,Jwl]=A_applyOpCond(Dev,mode,'ac_signal',Illum,'freq=',freq);
    Jqe(iwl)=abs(Jwl);
    Jgen(iwl)=abs(DevWL.OpCond.Jgen_ac);
end

[shadow,Rext]=A_get_surface_optics(Dev,'top');

QEanalysis.wl=wl;
QEanalysis.EQE=Jqe; % External Quantum Efficiency
QEanalysis.IPCE=Jqe/(1-shadow)/(1-Rext); % Incident Photon Collection Efficiency
QEanalysis.IQE=Jqe./Jgen; % Internal Quantum Efficiency
QEanalysis.DevWL=DevWL;

if length(wl) > 1
    fig=figure;
    fig.Name='Quantum Efficiency (ssac)';
    plot(QEanalysis.wl,QEanalysis.EQE,'k');
    hold on;
    plot(QEanalysis.wl,QEanalysis.IPCE,'b');
    plot(QEanalysis.wl,QEanalysis.IQE,'r');
    xlabel('Wavelength (microns)')
    ylabel('Quantum Efficiency')
    legend('EQE','IPCE','IQE','Location','Best')
    title(Dev.description)
    hold off
end



