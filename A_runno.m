function runno=A_runno(dev)
%
if isa(dev,'Adept')
    runno=dev.runno;
else
    error('Input argument must be an Adept object.')
end