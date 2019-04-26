function [inputs,kerr]=a_rmesh(p,inputs)
global A_FID

ip=a_init_mesh;

[ip,kerr]=a_diktat(p,ip,A_FID);

inputs.mesh.ip=ip;