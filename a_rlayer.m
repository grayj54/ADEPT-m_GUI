function [dev kerr]=a_rlayer(p,dev,fout,ltitle,nlayer,thick)
global VERBOSE

dev.reg(nlayer).describe=ltitle;

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
        [dev kerr]=a_rcustom(p,dev,fout,ltitle,nlayer,thick);
    otherwise
        kerr=1;
        if VERBOSE; fprintf('a_rlayer.m: layer type not supported.'); end
end
