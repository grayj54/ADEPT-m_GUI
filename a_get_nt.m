function [nts]=a_get_nt(dev,rdt,rdtold)

if rdt > 0 % current time step
    nts.oldnt=dev.nt;
    if rdtold > 0 % previous time step
        nts.oldoldnt=dev.oldnt;
    end
end