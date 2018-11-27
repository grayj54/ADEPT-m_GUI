classdef A_const
    
    properties (Constant)
        % set physical constants. values taken from
        % http://physics.nist.gov/cuu/Constants/index.html
        % on 4/30/2016
        q=1.6021766208e-19 % 1.602 176 6208(98) x 10^-19 C
        kb=8.6173303e-5    % 8.617 3303(50) x 10^-5 eV K^-1
        e0=8.854187817e-14 % 8.854 187 817 x 10^-14 F cm^-1
        hp=6.626070040e-34 % 6.626 070 040(81) x 10^-34 J s
        c=2.99792458e8     % 2.997 924 58 x 10^8 m s^-1
        abs_zero=-273.15   % absolute zero in deg Celsius (exact)
    
        %     % ADEPT.F
        %     q=1.602e-19; 
        %     kb=8.617343e-5;
        %     e0=8.854e-14;
        %     hp=6.625e-34;
        %     c=2.998e8; 
        %     abs_zero=-273.15;     
    end
        
    methods
        function disp(obj)
            fprintf('    q=%.14g C\n',obj.q);
            fprintf('    kb=%.14g eV/K\n',obj.kb);
            fprintf('    e0=%.14g F/cm\n',obj.e0);
            fprintf('    hp=%.14g J-s\n',obj.hp);
            fprintf('    c=%.14g m/s\n',obj.c);
            fprintf('    abs_zero=%.14g deg C\n',obj.abs_zero);
            fprintf('\n')
        end
        function b=subsref(a,s)
            if length(s) > 1; error('A_const access error - use ''.'' method.'); end
            switch s(1).type
                case '.'
                    switch s(1).subs
                        case 'q'
                            b=a.q;
                        case 'kb'
                            b=a.kb;
                        case 'e0'
                            b=a.e0;
                        case 'hp'
                            b=a.hp;
                        case 'c'
                            b=a.c;
                        case 'abs_zero'
                            b=a.abs_zero;
                        otherwise
                            error('A_const.%s not defined',s(1).subs)
                    end
                otherwise
                    error('A_const access error - use ''.'' method.')
            end
        end

    end
    
end
        