function [J F]=a_compute_jac_neutral_1d(dev)

nnodes=dev.mesh.num_nod;


% The Jacobi matrix is tridiagonal. Main diagonal han nnodes entries and
% the sub- and super-diagonals each have nnodes-2 entries.


ji(1:nnodes)=1:nnodes; % row index for sparse matrix
jj(1:nnodes)=1:nnodes; % column index for sparse matrix
js(1:nnodes)=1; % matrix value at (ji,jj) 
F(1:nnodes)=0; % rhs (residual)

[values derivs]=a_get_params(dev,'eq');

% 1st node
        
p=dev.ele.pl(1);
n=dev.ele.nl(1);
  
%vp,vn not explicitly needed here
dvpdp=derivs.dvpldpl(1);
% dependence of vp on p,V is ignored in Jacobian
dvndn=derivs.dvnldnl(1);
% dependence of vp on p,V is ignored in Jacobian
    
dpdv=p/(p*dvpdp-1);
dndv=n/(1-n*dvndn);
 
Nt=values.Ntl(1);
dNtdp=derivs.dNtldpl(1);
dNtdn=derivs.dNtldnl(1);
% dependence of Nt on V is ignored in Jacobian
dNtdv=dNtdp*dpdv+dNtdn*dndv;

Fv=p-n+Nt;
dFdv=dpdv-dndv+dNtdv;

% rhs 
F(1)=Fv/dFdv;

%for i=2:nnodes-1
    
    % get values for V
    vi=dev.node.v(2:nnodes-1);
        
    pil=dev.ele.pr(1:nnodes-2);
    nil=dev.ele.nr(1:nnodes-2);
    pir=dev.ele.pl(2:nnodes-1);
    nir=dev.ele.nl(2:nnodes-1);
    
    hl=dev.ele.h(1:nnodes-2);
    hr=dev.ele.h(2:nnodes-1);
    
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

    Fv=hl/2.*(pil-nil+Ntil)+hr/2.*(pir-nir+Ntir);
    dFdvi=hl/2.*(dpildvi-dnildvi+dNtildvi)+hr/2.*(dpirdvi-dnirdvi+dNtirdvi);

    % rhs
    F(2:nnodes-1)=Fv./dFdvi;
    
%end

% last node

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
   
% rhs
F(nnodes)=Fv/dFdv;

J=sparse(ji,jj,js,nnodes,nnodes);