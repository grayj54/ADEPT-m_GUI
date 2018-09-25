function [dev rcode]=a_frozen(dev)
global VERBOSE

time1=0;
time2=0;
time3=0;

dev.newton.current_dvmax=inf;
oldSF=1;

% solve
for iter=1:dev.newton.itmax
    if strcmp(dev.nD,'1D') == 1

        tc=tic;
        [Jacobi Res dev]=a_compute_jac_fz_1d(dev); % set up Jacobi matrix and residual
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
    tu=tic;
    dev=a_update_neq(dev,dv); % update p, n, and v
    time3=time3+toc(tu);
    if strcmp(dev.newton.show,'on')
        if VERBOSE; fprintf('Iteration %d(%.1f): norm(dv,inf) = %.2e norm(Res,inf) = %.2e\n',iter,nsig,dvmax,resmax); end
    else
        if VERBOSE; fprintf('Iteration %d: norm(dv,inf) = %.2e norm(Res,inf) = %.2e\n',iter,dvmax,resmax); end
    end
    if dvmax < dev.newton.test && iter > 1
        if VERBOSE
            fprintf('\nSetup time = %.6f seconds.\n',time1);
            fprintf('Solve time = %.6f seconds.\n',time2);
            fprintf('Update time = %.6f seconds.\n',time3);
            fprintf('Max dv = %.3e\n',dvmax);
            fprintf('Frozen potential solution converged.\n\n\n');
        end
        rcode=1;
        return;
    end
    
end

rcode=0;
if VERBOSE; fprintf('a_doneq: Frozen potential solution did not converge'); end
