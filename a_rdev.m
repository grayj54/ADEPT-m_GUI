function [inputs,kerr]=a_rdev(p,inputs)
global A_FID

ip=a_init_dev;

[ip,kerr]=a_diktat(p,ip,A_FID);

inputs.device.ip=ip;