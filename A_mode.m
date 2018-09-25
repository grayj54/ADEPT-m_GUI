function mode=A_mode(dev)
%
if isa(dev,'Adept')
    mode=dev.OpCond.mode;
else
    error('Input argument must be an Adept object.')
end