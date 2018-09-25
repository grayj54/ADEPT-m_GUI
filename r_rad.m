function [vals derivs] = r_rad(flag,in)
% band-band radiative recombination

if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    p=in.p;
    n=in.n;
    po=in.po;
    no=in.no;
    Nv=in.nv;
    Nc=in.nc;
    Nvt=in.nvt;
    Nct=in.nct;
    BB=in.B;
    
    if Nct == inf
        A=1;
    else
        A=(Nct-n)./(Nct-no);
    end
    if Nvt == inf
        B=1;
    else
        B=(Nvt-p)./(Nvt-po);
    end
    
    vals.R=BB.*(p.*n-no.*po.*A.*B);

    if strcmp(flag,'neq')
        if Nvt == inf
            dBdp=0;
        else
            dBdp=-1./(Nvt-po);
        end
        if Nct == inf
            dAdn=0;
        else
            dAdn=-1./(Nct-no);
        end
        derivs.dRdp=BB.*n-no.*po.*A.*dBdp;
        derivs.dRdn=BB.*p-no.*po.*B.*dAdn;
    end
else
    error('r_rad: @%$##&!')
end