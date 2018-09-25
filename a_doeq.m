function [dev rcode]=a_doeq(dev,neutral)
global A_FID VERBOSE

if nargin == 1
    neutral=0;
end
if neutral ~= 1 && neutral ~= 0
    error('a_doeq.m: neutral must be 1 or 0')
end
if neutral
    dev.ele.nl(1:dev.mesh.num_ele)=1;
    dev.ele.pl(1:dev.mesh.num_ele)=1;
    dev.ele.nr(1:dev.mesh.num_ele)=1;
    dev.ele.pr(1:dev.mesh.num_ele)=1;
    dev.node.v(1:dev.mesh.num_nod)=0;
end

dvmaxl=inf;
dvmaxm=dvmaxl;

time1=0;
time2=0;
time3=0;

% solve for equilibrium
for iter=1:dev.newton.itmaxq
    
    if strcmp(dev.nD,'1D') == 1

        tc=tic;
        if neutral
            [Jacobi Res]=a_compute_jac_neutral_1d(dev); % set up Jacobi matrix and residual
        else
            [Jacobi Res]=a_compute_jac_eq_1d(dev); % set up Jacobi matrix and residual
        end
        time1=time1+toc(tc);
        ts=tic;
        if strcmp(dev.newton.show,'on')
            nsig=(log10(1/eps)-log10(condest(Jacobi,2)));
        end
        dv=-Jacobi\Res'; % solve for dv
        time2=time2+toc(ts);
    else
        error('Only 1D simulations currently implemented')
    end
    
    dvmax=norm(dv,inf);
    resmax=norm(Res,inf);

    tu=tic;
    dev=a_update_eq(dev,dv); % update p, n, and v
    time3=time3+toc(tu);

    if strcmp(dev.newton.show,'on')
        if VERBOSE; fprintf(A_FID,'Iteration %d(%.1f): norm(dv,inf) = %.2e norm(Res,inf) = %.2e\n',iter,nsig,dvmax,resmax); end
    else
        if VERBOSE; fprintf(A_FID,'Iteration %d: norm(dv,inf) = %.2e norm(Res,inf) = %.2e\n',iter,dvmax,resmax); end
    end
    
     if isnan(dvmax) || isnan(resmax)
        error('a_doeq.m: ERROR')
    end   

    if dvmax < dev.newton.testq %&& iter > 1 && dvmax <= dvmaxl && dvmax <= dvmaxm
        if VERBOSE
            fprintf(A_FID,'\nSetup time = %.6f seconds.\n',time1);
            fprintf(A_FID,'Solve time = %.6f seconds.\n',time2);
            fprintf(A_FID,'Update time = %.6f seconds.\n',time3);
            fprintf(A_FID,'Max dv = %.3e\n',dvmax);
        end
        if neutral
            dev.bc.top.v_neutral=dev.node.v(1);
            dev.bc.top.n_neutral=dev.ele.nl(1);
            dev.bc.top.p_neutral=dev.ele.pl(1);
            dev.bc.bottom.v_neutral=dev.node.v(dev.mesh.num_nod);
            dev.bc.bottom.n_neutral=dev.ele.nr(dev.mesh.num_ele);
            dev.bc.bottom.p_neutral=dev.ele.pr(dev.mesh.num_ele);
            if VERBOSE; fprintf(A_FID,'Neutral solution converged.\n\n\n'); end
        else
            if VERBOSE; fprintf(A_FID,'Equilibrium solution converged.\n\n\n'); end
        end
        rcode=1;
        try fflush(A_FID);
        catch
        end
        return;
    end
    dvmaxl=dvmax;
    if dvmax < dvmaxm
        dvmaxm=dvmax;
    end
    
end

rcode=0;
if VERBOSE; fprintf(A_FID,'doeq: Did not converge'); end

