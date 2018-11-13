function dev=set_pn_newt(dev);
% set p and n to be consistent with the potential (v)
% using fixed point iteration
    
    nn=dev.mesh.num_nod;
    ne=dev.mesh.num_ele;
    
    v(1:nn)=dev.node.v(1:nn);
    
    test=inf;
    
    % starting values
    xpl=log(dev.ele.pl);
    xpr=log(dev.ele.pr);
    xnl=log(dev.ele.nl);
    xnr=log(dev.ele.nr);    
    
    iter=0;
    while test > dev.newton.testq && iter < 100
       
        iter=iter+1;
        
        [vals ders]=a_get_params(dev,'band');
        
        vpl=vals.vpl;
        vpr=vals.vpr;
        vnl=vals.vnl;
        vnr=vals.vnr;
        dvpldpl=ders.dvpldpl;
        dvprdpr=ders.dvprdpr;
        dvnldnl=ders.dvnldnl;
        dvnrdnr=ders.dvnrdnr;
        
        dxpl=-(xpl-vpl+v(1:nn-1))./(1-exp(xpl).*dvpldpl);
        dxpr=-(xpr-vpr+v(2:nn))./(1-exp(xpr).*dvprdpr);
        dxnl=-(xnl-vnl-v(1:nn-1))./(1-exp(xnl).*dvnldnl);
        dxnr=-(xnr-vnr-v(2:nn))./(1-exp(xnr).*dvnrdnr);
        
        xpl=xpl+dxpl;
        xpr=xpr+dxpr;
        xnl=xnl+dxnl;
        xnr=xnr+dxnr;
        
        dev.ele.pl=exp(xpl);
        dev.ele.pr=exp(xpr);
        dev.ele.nl=exp(xnl);
        dev.ele.nr=exp(xnr);
        
        test=norm(dxpl,inf)+norm(dxnl,inf)+ norm(dxpr,inf)+norm(dxnr,inf);

    end
    
    if iter >= 100; error('set_pn_newt: unable to converge to consistent p, n.'); end
    