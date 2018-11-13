function [J F]=a_compute_jac_eq_1d(dev)

nnodes=dev.mesh.num_nod;


% The Jacobi matrix is tridiagonal. Main diagonal han nnodes entries and
% the sub- and super-diagonals each have nnodes-2 entries.


ji(1:3*nnodes-2)=0; % row index for sparse matrix
jj(1:3*nnodes-2)=0; % column index for sparse matrix
js(1:3*nnodes-2)=0; % matrix value at (ji,jj) 
F(1:nnodes)=0; % rhs (residual)

[values derivs]=a_get_params(dev,'eq');

% 1st node
if strcmp(dev.bc.top.eq_bc,'neutral') == 1
        
    p=dev.ele.pl(1);
    n=dev.ele.nl(1);
    
    %ks not explicitly needed here
    
    %vp,vn not explicitly needed here
    dvpdp=derivs.dvpldpl(1); % dependence of vp on n,V is ignored in Jacobian
    dvndn=derivs.dvnldnl(1); % dependence of vn on p,V is ignored in Jacobian
    
    dpdv=p/(p*dvpdp-1);
    dndv=n/(1-n*dvndn);
    
    Nt=values.Ntl(1);
    dNtdp=derivs.dNtldpl(1);
    dNtdn=derivs.dNtldnl(1);
    % dependence of Nt on V is ignored in Jacobian
    dNtdv=dNtdp*dpdv+dNtdn*dndv;
    
    Fv=p-n+Nt;
    dFdv=dpdv-dndv+dNtdv;
    
elseif strcmp(dev.bc.top.eq_bc,'Schottky') == 1;

    v=dev.node.v(1);
    v_neutral=dev.bc.top.v_neutral;
    n_neutral=dev.bc.top.n_neutral;
    phim=dev.bc.top.phim/dev.norm.v;
    chi=dev.bc.top.chi/dev.norm.v;
    Nc=dev.bc.top.Nc/dev.norm.n;
    if strcmp(dev.misc.fdflag,'on')
        eta=rez_fermi(n_neutral/Nc); %Fermi-Dirac
    else
        eta=log(n_neutral/Nc); %Boltzmann
    end
    EcmEf_fb=-eta;
    
    Fv=v-(v_neutral+phim-chi-EcmEf_fb);
    dFdv=1;
    
else
    error('a_compute_jac_eq_1d: Undefined BC')
end

% main diagonal 
ji(1)=1;
jj(1)=1;
js(1)=1;
% super-diagonal 
ji(2)=1;
jj(2)=2;
js(2)=0;
% rhs 
F(1)=Fv/dFdv;

%for i=2:nnodes-1
    
    % get values for V
    vl=dev.node.v(1:nnodes-2);
    vi=dev.node.v(2:nnodes-1);
    vr=dev.node.v(3:nnodes);
    
    pil=dev.ele.pr(1:nnodes-2);
    nil=dev.ele.nr(1:nnodes-2);
    pir=dev.ele.pl(2:nnodes-1);
    nir=dev.ele.nl(2:nnodes-1);
    
    hl=dev.ele.h(1:nnodes-2);
    hr=dev.ele.h(2:nnodes-1);
    
    % get values for ks
    ksl=0.5*(values.ksl(1:nnodes-2)+values.ksr(1:nnodes-2));
    ksr=0.5*(values.ksl(2:nnodes-1)+values.ksr(2:nnodes-1));
    
    % get values for Nt
    Ntil=values.Ntr(1:nnodes-2);
    dNtildpil=derivs.dNtrdpr(1:nnodes-2);
    dNtildnil=derivs.dNtrdnr(1:nnodes-2);
    Ntir=values.Ntl(2:nnodes-1);
    dNtirdpir=derivs.dNtldpl(2:nnodes-1);
    dNtirdnir=derivs.dNtldnl(2:nnodes-1);
    
    % get values for vp,vn
    dvpildpil=derivs.dvprdpr(1:nnodes-2);
    dvnildnil=derivs.dvnrdnr(1:nnodes-2);
    dvpirdpir=derivs.dvpldpl(2:nnodes-1);
    dvnirdnir=derivs.dvnldnl(2:nnodes-1);  

    dpildvi=pil./(pil.*dvpildpil-1);
    dnildvi=nil./(1-nil.*dvnildnil);
    dpirdvi=pir./(pir.*dvpirdpir-1);
    dnirdvi=nir./(1-nir.*dvnirdnir);
    
    dNtildvi=dNtildpil.*dpildvi+dNtildnil.*dnildvi;
    dNtirdvi=dNtirdpir.*dpirdvi+dNtirdnir.*dnirdvi;

    Fv=ksl./hl.*vl-(ksl./hl+ksr./hr).*vi+ksr./hr.*vr+hl/2.*(pil-nil+Ntil)+hr/2.*(pir-nir+Ntir);
    dFdvl=ksl./hl;
    dFdvi=-(ksl./hl+ksr./hr)+hl/2.*(dpildvi-dnildvi+dNtildvi)+hr/2.*(dpirdvi-dnirdvi+dNtirdvi);
    dFdvr=ksr./hr;
    
    % sub-diagonal 
    ji(3:3:3*nnodes-6)=2:nnodes-1;
    jj(3:3:3*nnodes-6)=1:nnodes-2;
    js(3:3:3*nnodes-6)=dFdvl./dFdvi;
    % main diagonal 
    ji(4:3:3*nnodes-5)=2:nnodes-1;
    jj(4:3:3*nnodes-5)=2:nnodes-1;
    js(4:3:3*nnodes-5)=1;
    % super-diagonal 
    ji(5:3:3*nnodes-4)=2:nnodes-1;
    jj(5:3:3*nnodes-4)=3:nnodes;
    js(5:3:3*nnodes-4)=dFdvr./dFdvi;
    % rhs
    F(2:nnodes-1)=Fv./dFdvi;
    
%end

% last node
if strcmp(dev.bc.bottom.eq_bc,'neutral') == 1; 

    p=dev.ele.pr(nnodes-1);
    n=dev.ele.nr(nnodes-1);
    
    %ks not explicitly needed here
    
    %vp,vn not explicitly needed here
    dvpdp=derivs.dvprdpr(nnodes-1);
    % dependence of vp on p,V is ignored in Jacobian
    dvndn=derivs.dvnrdnr(nnodes-1);
    % dependence of vp on p,V is ignored in Jacobian
    
    dpdv=p/(p*dvpdp-1);
    dndv=n/(1-n*dvndn);
    
    Nt=values.Ntr(nnodes-1);
    dNtdp=derivs.dNtrdpr(nnodes-1);
    dNtdn=derivs.dNtrdnr(nnodes-1);
    % explicit dependence of Nt on V is ignored in Jacobian
    dNtdv=dNtdp*dpdv+dNtdn*dndv;
    
    Fv=p-n+Nt;
    dFdv=dpdv-dndv+dNtdv;
   
elseif strcmp(dev.bc.bottom.eq_bc,'Schottky') == 1;

    v=dev.node.v(nnodes);
    v_neutral=dev.bc.bottom.v_neutral;
    n_neutral=dev.bc.bottom.n_neutral;
    phim=dev.bc.bottom.phim/dev.norm.v;
    chi=dev.bc.bottom.chi/dev.norm.v;
    Nc=dev.bc.bottom.Nc/dev.norm.n;
    if strcmp(dev.misc.fdflag,'on')
        eta=rez_fermi(n_neutral/Nc); %Fermi-Dirac
    else
        eta=log(n_neutral/Nc); %Boltzmann
    end
    EcmEf_fb=-eta;
    
    Fv=v-(v_neutral+phim-chi-EcmEf_fb);
    dFdv=1;
    
else
    error('a_compute_jac_eq_1d: Undefined BC')
end

% sub-diagonal    
    ji(3*nnodes-3)=nnodes;
    jj(3*nnodes-3)=nnodes-1;
    js(3*nnodes-3)=0;
    % main diagonal
    ji(3*nnodes-2)=nnodes;
    jj(3*nnodes-2)=nnodes;
    js(3*nnodes-2)=1;
    % rhs
    F(nnodes)=Fv/dFdv;

J=sparse(ji,jj,js,nnodes,nnodes);