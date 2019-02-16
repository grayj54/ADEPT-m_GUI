function [dev,ierr]=a_process_inputs(inputs,dev)
%
global CONST
ierr=0;

dev.nD=inputs.nD;
dev.description=inputs.title;
dev.input_file=inputs.input_file;
dev.inputs=inputs;
dev.OpCond.mode='equilibrium';
dev.const=CONST;

[dev,kerr]=a_pdev(inputs,dev);
ierr+ierr+kerr;

[dev,kerr]=a_pmisc(inputs,dev);
ierr+ierr+kerr;
dev=a_setnorm(dev); % set normalization constants

[dev,kerr]=a_pmesh(inputs,dev);
ierr+ierr+kerr;

[dev,kerr]=a_procbc(inputs,dev,'top');
ierr+ierr+kerr;

for i=1:length(inputs.layer)
    [dev,kerr]=a_pcustom(inputs,dev,i);
    ierr+ierr+kerr;
end

[dev,kerr]=a_procbc(inputs,dev,'bottom');
ierr+ierr+kerr;