function [dev,kerr]=a_pdev(inputs,dev)
global REF CONST VERBOSE

kerr=0;
dev.T=double(inputs.device.ip(1).set);
if strcmp(inputs.device.ip(1).name,'T_C')
    dev.T=dev.T-CONST.abs_zero;
end
if dev.T <= 0
    kerr=kerr+1;
    if VERBOSE; fprintf('a_rdev.m: T must be > 0\n'); end
end
REF.t=dev.T;

type=char(inputs.device.ip(2).set{1});
if strcmp(type,'solar_cell') ||strcmp(type,'Solar_Cell')
    dev.type='Solar Cell';
elseif strcmp(type,'diode') ||strcmp(type,'Diode')
    dev.type='Diode';
elseif strcmp(type,'generic') ||strcmp(type,'Generic')
    dev.type='Generic';
end

dev.Optical.npass=double(inputs.device.ip(3).set);