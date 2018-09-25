function [dev,rcode]=a_doneq(dev)

global VERBOSE

rcode=0;

time1=0;
time2=0;
time3=0;

dev.newton.current_dvmax=inf;
oldSF=1;

% solve
ldvmax=inf;
lresmax=inf;
dv_cnt=0;
res_cnt=0;
iter=0;
while iter <= dev.newton.itmax
    iter=iter+1;
    if strcmp(dev.nD,'1D') == 1

        tc=tic;
        [Jacobi Res dev]=a_compute_jac_neq_1d(dev); % set up Jacobi matrix and residual
        time1=time1+toc(tc);
        ts=tic;
        if strcmp(dev.newton.show,'on')
            condno=condest(Jacobi,2);
            if isnan(condno)
                error('Jacobian is badly ill-conditioned')
            end
            nsig=(log10(1/eps)-log10(condno));
        end
        dv=-Jacobi\Res'; % solve for dv
        time2=time2+toc(ts);
    else
        error('Only 1D simulations currently implemented')
    end
    
    dvmax=norm(dv,inf); 
    dev.newton.current_dvmax=dvmax;
    resmax=norm(Res,inf);
    
    if dvmax > ldvmax 
        dv_cnt=dv_cnt+1;
    else
        dv_cnt=0;
    end
    ldvmax=dvmax;
    
    if resmax > lresmax
        res_cnt=res_cnt+1;
    else
        res_cnt=0;
    end
    lresmax=resmax;
    
    tu=tic;
    dev=a_update_neq(dev,dv); % update p, n, and v
    time3=time3+toc(tu);
    if dev.OpCond.scale_factor <= 1 && oldSF ~= dev.OpCond.scale_factor && strcmp(dev.OpCond.Generation(1).type,'dark') == 0
        if VERBOSE; fprintf('-- Scaling up light intensity, SF= %g\n',dev.OpCond.scale_factor); end
        oldSF=dev.OpCond.scale_factor;
        iter=1;
        dv_cnt=0;
        res_cnt=0;
    end
    if strcmp(dev.newton.show,'on')
        if VERBOSE; fprintf('Iteration %d(%.1f): norm(dv,inf) = %.2e norm(Res,inf) = %.2e\n',iter,nsig,dvmax,resmax); end
    else
        if VERBOSE; fprintf('Iteration %d: norm(dv,inf) = %.2e norm(Res,inf) = %.2e\n',iter,dvmax,resmax); end
    end
    if isnan(dvmax) || isnan(resmax) || (dv_cnt > dev.newton.ndiv && res_cnt > dev.newton.ndiv)
        error('a_doeq.m: ERROR')
    end
    
    if dvmax < dev.newton.test && dev.OpCond.scale_factor == 1 %&& iter > 1
        rcode=1;
        break;
    end
    
end

if VERBOSE
    fprintf('\nSetup time = %.6f seconds.\n',time1);
    fprintf('Solve time = %.6f seconds.\n',time2);
    fprintf('Update time = %.6f seconds.\n',time3);
    fprintf('Max dv = %.3e\n',dvmax);
end

if rcode == 1
    if strcmp(dev.OpCond.mode,'equilibrium')
        if VERBOSE; fprintf('Equilibrium solution converged.\n\n\n'); end
    else
        if VERBOSE; fprintf('Non-equilibrium solution converged.\n\n\n'); end
    end
else
    if strcmp(dev.OpCond.mode,'equilibrium')
        if VERBOSE; fprintf('Equilibrium solution did not converge.\n\n\n'); end
    else
        if VERBOSE; fprintf('Non-equilibrium solution did not converge.\n\n\n'); end
    end
end
