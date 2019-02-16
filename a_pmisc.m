function [dev,kerr]=a_pmisc(inputs,dev)
global REF CONST

kerr=0;

% REF.t set in a_rdev.m  
REF.chi=inputs.misc.ip(1).set(1);
REF.nc=inputs.misc.ip(2).set(1);
REF.nv=inputs.misc.ip(3).set(1);
REF.eg=inputs.misc.ip(4).set(1);
REF.ks=inputs.misc.ip(5).set(1);
REF.ni=sqrt(REF.nc*REF.nv)*exp(-REF.eg/(CONST.kb*REF.t)/2.0);

dev.misc.fdflag=char(inputs.misc.ip(6).set{1});
dev.newton.itmaxq=floor(inputs.misc.ip(7).set(1));
dev.newton.testq=inputs.misc.ip(8).set(1);
dev.newton.itmax=floor(inputs.misc.ip(9).set(1));
dev.newton.test=inputs.misc.ip(10).set(1);
dev.newton.show=char(inputs.misc.ip(11).set{1});
dev.newton.testq_setup=inputs.misc.ip(12).set(1);
dev.newton.SF_test=inputs.misc.ip(13).set(1);
dev.misc.minN=inputs.misc.ip(14).set(1);
dev.newton.ndiv=inputs.misc.ip(15).set(1);