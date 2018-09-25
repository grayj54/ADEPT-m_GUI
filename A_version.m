function A_version
global ADEPT_INIT_FLAG CONST A_FID ADEPT_VERSION

if isempty(ADEPT_INIT_FLAG)
    a_init;
else    
    fprintf('\nADEPT.m Version: %s\n\n',ADEPT_VERSION);
    fprintf('Author: Jeffery L. Gray, grayj@purdue.edu');
    fprintf('\n        School of Electrical and Computer Engineering');
    fprintf('\n        Purdue University');
    fprintf('\n        West Lafayette, IN 47907\n\n');

    fprintf('ADEPT-m is a research/educational tool and is supplied free of\n')
    fprintf('charge to users as-is. No warranty, expressed or implied, is\n')
    fprintf('made by the author, the School of Electrical & Computer Engineering,\n')
    fprintf('or Purdue Universty. Neither the author, the School of Electrical\n')
    fprintf('& Computer Engineering, nor Purdue University assume any legal\n')
    fprintf('liability or responsibility for the accuracy or usefulness of\n')
    fprintf('ADEPT-m. This software cannot be distributed for commercial\n')
    fprintf('purposes without the express written permission of the\n')
    fprintf('author, the School of Electrical & Computer Engineering, and\n')
    fprintf('Purdue Universty.\n')

    fprintf('\nUsers can have access to the physical constants used in ADEPT-m\n');
    fprintf('by accessing the static data type A_const:\n\n'); 
    fprintf('    Fundamental charge, A_const.q = %.14g C\n',CONST.q);
    fprintf('    Boltzmann Constant, A_const.kb = %.14g eV/K\n',CONST.kb);
    fprintf('    Vacuum permittivity, A_const.e0 = %.14g F/cm\n',CONST.e0);
    fprintf('    Planck''s Constant, A_const.hp = %.14g J-s\n',CONST.hp);
    fprintf('    Speed of light, A_const.c = %.14g m/s\n',CONST.c);
    fprintf('    Absolute zero, A_const.abs_zero = %.2f deg Celsius\n\n',CONST.abs_zero);
end

end

