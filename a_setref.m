function dev=a_setref(dev)

global REF CONST

% save REF
dev.ref=REF;

% set normalization parameters
dev.norm.D=1; % diffusion coeff (cm^2/s)   
dev.norm.t=REF.t; % temperature (deg K)
dev.norm.v=CONST.kb*dev.norm.t; % potential, voltage, energy (V, eV)
dev.norm.n=dev.ref.ni; % carrier concentration (#/cm^3)
if dev.norm.n == 0
    error('a_input0_1d.m: carrier normalization factor is zero to machine precision\m')
end
dev.norm.ks=dev.ref.ks; % dielectric constant (no units)
dev.norm.x=sqrt(dev.norm.ks*CONST.e0*dev.norm.v/dev.norm.n/CONST.q); % distance (cm)
dev.norm.rg=dev.norm.D*dev.norm.n/dev.norm.x/dev.norm.x; % recombination rate (#/cm^3/s)
dev.norm.j=CONST.q*dev.norm.D*dev.norm.n/dev.norm.x; % current density (A/cm^2)
dev.norm.time=dev.norm.x*dev.norm.x/dev.norm.D; % time, lifetime (s)
dev.norm.u=dev.norm.D/dev.norm.v; % mobility (cm^2/V/s) -- Diffusion coeff noramized to 1
dev.norm.s=dev.norm.D/dev.norm.x; % recombination velocity, thermal velocity (cm/s)
dev.norm.B=dev.norm.rg/dev.norm.n^2; % radiative recomb coeff (cm^3/s)
dev.norm.C=dev.norm.rg/dev.norm.n^3; % Auger recomb coeff (cm^6/s)
dev.norm.cap_area=1/dev.norm.n/dev.norm.time/dev.norm.s; % capture cross-section (cm^2)
