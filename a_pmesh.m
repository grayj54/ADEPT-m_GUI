function [dev,kerr]=a_pmesh(inputs,dev)

kerr=0;

dev.mesh.method=char(inputs.mesh.ip(1).set{1});
dev.mesh.num_nod=floor(inputs.mesh.ip(2).set(1));
dev.mesh.max_nodes=dev.mesh.num_nod;
dev.mesh.num_ele=dev.mesh.num_nod-1;
dev.mesh.n_smooth=inputs.mesh.ip(5).set(1);
if dev.mesh.n_smooth < 0
    dev.mesh.n_smooth=floor(0.5*dev.mesh.num_nod);
end
% convert h_min to cm
if strcmp(inputs.mesh.ip(3).name,'h_min_A')
    dev.mesh.h_min=1e-8*inputs.mesh.ip(3).set(1);
elseif strcmp(inputs.mesh.ip(3).name,'h_min_nm')
    dev.mesh.h_min=1e-7*inputs.mesh.ip(3).set(1);
elseif strcmp(inputs.mesh.ip(3).name,'h_min_um')
    dev.mesh.h_min=1e-4*inputs.mesh.ip(3).set(1);
else
    dev.mesh.h_min=inputs.mesh.ip(3).set(1);
end

hmax=inputs.mesh.ip(4).set(1);
if strcmp(inputs.mesh.ip(4).name,'h_max_A')
    dev.mesh.h_max=1e-8*hmax;
elseif strcmp(inputs.mesh.ip(4).name,'h_max_nm')
    dev.mesh.h_max=1e-7*hmax;
elseif strcmp(inputs.mesh.ip(4).name,'h_max_um')
    dev.mesh.h_max=1e-4*hmax;
else
    dev.mesh.h_max=hmax;
end
if hmax < dev.mesh.h_min
    dev.mesh.h_max=-1;
end

dev.mesh.maxrh=inputs.mesh.ip(5).set(1);

dev.mesh.maxrD=inputs.mesh.ip(6).set(1);

dev.mesh.sharp=char(inputs.mesh.ip(7).set{1});

dev.mesh.Dth=inputs.mesh.ip(8).set(1);

