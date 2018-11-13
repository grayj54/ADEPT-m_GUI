function A_verbose(verbose)
% set or toggle global parameter VERBOSE
% verobose = {'on' 'off' 'toggle')

global VERBOSE

if nargin == 0 % toggle
    if VERBOSE == 1
        VERBOSE=0;
    else
        VERBOSE=1;
    end
    return;
end

if strcmp(verbose,'toggle')
    if VERBOSE == 1
        VERBOSE=0;
    else
        VERBOSE=1;
    end
elseif strcmp(verbose,'on')
    VERBOSE=1;
else
    VERBOSE=0;
end
