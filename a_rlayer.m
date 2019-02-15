function [inputs,kerr]=a_rlayer(p,inputs,ltitle,nlayer)
global VERBOSE A_FID

% default layer type
ltype='semiconductor'; % 'insulator' is a future option to include

% determine layer type

for i=1:p.nvar
    if strcmp(p.var(i).name,'ltype') || strcmp(p.var(i).name,'layer_type')
        ltype=p.var(i).val{1};
        break;
    end
end

switch ltype
    case {'semiconductor' 'semi'}
        [inputs,kerr]=a_rcustom(p,inputs,ltitle,nlayer);
    otherwise
        kerr=1;
        if VERBOSE; fprintf('a_rlayer.m: layer type not supported.'); end
end
