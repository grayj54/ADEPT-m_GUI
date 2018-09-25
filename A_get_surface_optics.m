function [shadow,Rext]=A_get_surface_optics(Dev,torb)

if strcmp(torb,'top')
    shadow=Dev.bc.top.shadow;
    Rext=Dev.bc.top.Rext;
elseif strcmp(torb,'bottom')
    shadow=Dev.bc.bottom.shadow;
    Rext=Dev.bc.bottom.Rext;
else
    error('A_get_surface_optics: torb must be ''top'' ot ''bottom''')
end