function [vals derivs] = r_auger(flag,in)
% intrinsic Auger recombination

if strcmp(flag,'neq') || strcmp(flag,'vals') || strcmp(flag,'plot')
    p=in.p;
    n=in.n;
    po=in.po;
    no=in.no;
    Nv=in.nv;
    Nc=in.nc;
    Nvt=in.nvt;
    Nct=in.nct;
    Cp=in.Cp;
    Cn=in.Cn;
    
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
    
    vals.R=(Cp.*p+Cn.*n).*(p.*n-no.*po.*A.*B);

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
        derivs.dRdp=(Cp.*p+Cn.*n).*(n-no.*po.*A.*dBdp)+Cp.*(p.*n-no.*po.*A.*B);
        derivs.dRdn=(Cp.*p+Cn.*n).*(p-no.*po.*B.*dAdn)+Cn.*(p.*n-no.*po.*A.*B);
    end
else
    error('shr_r: @%$##&!')
end