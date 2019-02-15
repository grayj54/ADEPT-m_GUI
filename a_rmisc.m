function [inputs,kerr]=a_rmisc(p,inputs)
global A_FID

ip=a_init_misc;

[ip,kerr]=a_diktat(p,ip,A_FID);

inputs.misc.ip=ip;