function a_init
% a_init initializes global quantities
% 
global ADEPT_INIT_FLAG A_FID ADEPT_VERSION CONST APATH VERBOSE M_OR_O

if ADEPT_INIT_FLAG == 1
    
    return

else
    
    ADEPT_INIT_FLAG=1;
    
    CONST=A_const;
    
    VERBOSE=1; % verbose
    
    A_FID=1; % set default text output to stdout
    
    APATH=getenv('$ADEPT_HOME');
    
    M_OR_O=getenv('$MatLab_or_Octave');
    
    ADEPT_VERSION='ADEPT-m Beta B.9 [2/14/2019 (c) 2016, 2017, 2018, 2019]';
    
    A_version;
   
end