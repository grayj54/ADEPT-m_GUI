function [inputs,kerr]=a_readbc(p,inputs,torb)
global A_FID

ip=a_init_bc;

[ip,kerr]=a_diktat(p,ip,A_FID);

if strcmp(torb,'top')
    inputs.top.ip=ip;
else
    inputs.bottom.ip=ip;
end
