function [value units]=A_get_const(const)
%q, hp, kb, e0, c
%
%physical constants obtained from:
%
%   http://physics.nist.gov/cuu/Constants/index.html
%
% on 7/19/2007 (see A_init.m)
%
%disp(' ')
%disp('<a href="http://physics.nist.gov/cuu/Constants/index.html">NIST Web Site</a>')
%disp(' ')
global ADEPT_INIT_FLAG

if nargin == 0
    value=NaN;
    units='none';
    error('ERROR: constant not specified')
    return
end

if ADEPT_INIT_FLAG == 1
else
    a_init
end

global CONST
switch const
    case {'Q','q','e','charge'}
        value=CONST.q;
        units='C';
        return
    case {'KB','kb','Boltzmann Constant'}
        value=CONST.kb;
        units='eV/K';
        return
    case {'E0','e0','electric constant'}
        value=CONST.e0;
        units='F/cm';
        return
    case {'HP','hp','Planck Constant'}
        value=CONST.hp;
        units='J-s';
        return        
    case {'C','c','speed of light'}
        value=CONST.c;
        units='cm/s';
        return
    otherwise
        value=NaN;
        units='none';
        disp('ERROR: unknown constant')
        return
end
