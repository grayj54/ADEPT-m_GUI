function [inputs,kerr]=a_rcustom(p,inputs,ltitle,nlayer)
global A_FID

ip=a_init_custom;

[ip,kerr]=a_diktat(p,ip,A_FID); % decode diktat

inputs.layer(nlayer).describe=ltitle; % --> dev.reg(nlayer).describe
inputs.layer(nlayer).ip=ip; % --> dev.reg(nlayer).rip
