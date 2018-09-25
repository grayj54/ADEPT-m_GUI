function [vb,dvbdc]=a_vbfd(c,Nb,fdflag,flag)
%
% dvb = degeneracy effect on band parameter (normalized): vb=vb0+dvb
% ddvbdc = derivative wrt carrier 'c' (normalized)
%
% c = carrier concentration (normalized) < 1D array >
% Nb = effective density of states in band (normalized) < scalar or 1D array >
%
% needs to be modified to work for 2D and 3D 'c', 'Nb' arrays

% set for Boltzman
vb(1:length(c))=0;
dvbdc(1:length(c))=0;

if strcmp(fdflag,'off'); return; end % if F-D off, return

% Fermi-Dirac
eta=rez_fermi(c./Nb);
vb=log(c./(Nb.*exp(eta)));

if strcmp(flag,'vals') || strcmp(flag,'eqvals') || strcmp(fdflag,'off') || strcmp(fdflag,'on_val'); return; end % derivative not needed
  fm12=fermi(eta,-1/2);
  %fp12=fermi(eta,1/2);
  fp12=c./Nb;
  dvbdeta=fm12./fp12-1;
  detadc=1./Nb./fm12;
  dvbdc=dvbdeta.*detadc;
  con=c./Nb;
  %dvbdc(con<1e-3)=0;
end  

