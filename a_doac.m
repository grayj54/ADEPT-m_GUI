function [dev,rcode]=a_doac(dev)
global VERBOSE

rcode=0;
nnodes=dev.mesh.num_nod;
ne=nnodes-1;
    
if strcmp(dev.nD,'1D') == 1

    tc=tic;
    [Jac_ac,Fac,dev]=a_compute_jac_neq_1d(dev); % get Jacobi matrix
    time1=toc(tc);
    
    ts=tic;
    if strcmp(dev.newton.show,'on')
        nsig=(log10(1/eps)-log10(condest(Jac_ac,2)));
    end
    uac=-Jac_ac\Fac'; % solve for small signal response
    time2=toc(ts);
    
    tu=tic;
    dev.node.zp_ac=uac(1:3:3*nnodes-2)';
    dev.node.zn_ac=uac(2:3:3*nnodes-1)';
    dev.node.v_ac=uac(3:3:3*nnodes)';

    dev.ele.pl_ac=dev.ele.pl.*dev.node.zp_ac(1:nnodes-1);
    dev.ele.pr_ac=dev.ele.pr.*dev.node.zp_ac(2:nnodes);
    dev.ele.nl_ac=dev.ele.nl.*dev.node.zn_ac(1:nnodes-1);
    dev.ele.nr_ac=dev.ele.nr.*dev.node.zn_ac(2:nnodes);
    
    %get ac current
    [jtac,jp_ac,jn_ac,jd_ac,ql_ac,qr_ac,Rpl_ac,Rpr_ac,Rnl_ac,Rnr_ac]=a_jtot_ac(dev);
    
    dev.ele.jp_ac=jp_ac;
    dev.ele.jn_ac=jn_ac;
    dev.ele.jd_ac=jd_ac;
    dev.ele.ql_ac=ql_ac;
    dev.ele.qr_ac=qr_ac;
    
    dev.ele.Rpl_ac=Rpl_ac;
    dev.ele.Rpr_ac=Rpr_ac;
    dev.ele.Rnl_ac=Rnl_ac;
    dev.ele.Rnr_ac=Rnr_ac;
    
    dev.OpCond.Vac=dev.node.v_ac(1)*dev.norm.v;
    dev.OpCond.Jac=jtac*dev.norm.j;
    time3=toc(tu);
    
    if strcmp(dev.newton.show,'on')
        if VERBOSE; fprintf('Small-signal solution completed. (%.1f)\n',nsig); end
    else
        if VERBOSE; fprintf('Small-signal solution completed.\n'); end
    end
    
    if VERBOSE
        fprintf('-- Setup time = %.6f seconds.\n',time1);
        fprintf('-- Solve time = %.6f seconds.\n',time2);
        fprintf('-- Update time = %.6f seconds.\n\n\n',time3);
    end

    %save for extraction and plotting
    [~,p_jp_ac]=a_pdata(dev.data.NODE.X,jp_ac,0);
    [~,p_jn_ac]=a_pdata(dev.data.NODE.X,jn_ac,0);
    [~,p_jd_ac]=a_pdata(dev.data.NODE.X,jd_ac,0);
    dev.data.ELE1.jp_ac=p_jp_ac*dev.norm.j;
    dev.data.ELE1.jn_ac=p_jn_ac*dev.norm.j;
    dev.data.ELE1.jd_ac=p_jd_ac*dev.norm.j;
    
    p_ac(1:2:2*ne-1)=dev.ele.pl_ac(1:ne)*dev.norm.n;
    p_ac(2:2:2*ne)=dev.ele.pr_ac(1:ne)*dev.norm.n;
    [~,dev.data.ELE2.p_ac]=a_pdata(dev.data.INT.X,p_ac,0);
    
    n_ac(1:2:2*ne-1)=dev.ele.nl_ac(1:ne)*dev.norm.n;
    n_ac(2:2:2*ne)=dev.ele.nr_ac(1:ne)*dev.norm.n;
    [~,dev.data.ELE2.n_ac]=a_pdata(dev.data.INT.X,n_ac,0);
    
    Rn_ac(1:2:2*ne-1)=dev.ele.Rnl_ac(1:ne)*dev.norm.rg;
    Rn_ac(2:2:2*ne)=dev.ele.Rnr_ac(1:ne)*dev.norm.rg;
    [~,dev.data.ELE2.Rn_ac]=a_pdata(dev.data.INT.X,Rn_ac,0);
    
    Rp_ac(1:2:2*ne-1)=dev.ele.Rpl_ac(1:ne)*dev.norm.rg;
    Rp_ac(2:2:2*ne)=dev.ele.Rpr_ac(1:ne)*dev.norm.rg;
    [~,dev.data.ELE2.Rp_ac]=a_pdata(dev.data.INT.X,Rp_ac,0);
    
    q_ac(1:2:2*ne-1)=dev.ele.ql_ac(1:ne)*dev.norm.n;
    q_ac(2:2:2*ne)=dev.ele.qr_ac(1:ne)*dev.norm.n;
    [~,dev.data.ELE2.nq_ac]=a_pdata(dev.data.INT.X,q_ac,0);
   
    dev.data.NODE.zp_ac=dev.node.zp_ac*dev.norm.v;
    dev.data.NODE.zn_ac=dev.node.zn_ac*dev.norm.v;
    dev.data.NODE.v_ac=dev.node.v_ac*dev.norm.v; 
else
    error('Only 1D simulations currently implemented')
end


