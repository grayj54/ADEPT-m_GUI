function [dev,kerr]=a_procbc(inputs,dev,torb)
global REF CONST
kerr=0;

if strcmp(torb,'top')
    if strcmp(char(inputs.top.ip(3).set{1}),'ideal') || strcmp(char(inputs.top.ip(3).set{1}),'ohmic')
        dev.bc.top.eq_bc='neutral';
        dev.bc.top.neq_bc='ideal';
        if inputs.top.ip(1).set(1) < inf || inputs.top.ip(2).set(1) < inf
            disp('cannot set Sn or Sp for contact=ideal');
            kerr=kerr+1;
        end
        dev.bc.top.sp=inf;
        dev.bc.top.sn=inf;
    elseif strcmp(char(inputs.top.ip(3).set{1}),'blocking')
        dev.bc.top.eq_bc='neutral';
        dev.bc.top.neq_bc='non-ideal';
        dev.bc.top.sp=inputs.top.ip(1).set(1);
        dev.bc.top.sn=inputs.top.ip(2).set(1);
    elseif strcmp(char(inputs.top.ip(3).set{1}),'Schottky')
        dev.bc.top.eq_bc='Schottky';
        dev.bc.top.neq_bc='non-ideal';
        dev.bc.top.phim=inputs.top.ip(9).set(1);
        dev.bc.top.sp=inputs.top.ip(1).set(1);
        dev.bc.top.sn=inputs.top.ip(2).set(1);
    end
    dev.bc.top.rc=inputs.top.ip(4).set(1);
    dev.bc.top.shadow=inputs.top.ip(5).set(1);
    dev.bc.top.Rext=inputs.top.ip(6).set(1);
    dev.bc.top.Rint=inputs.top.ip(7).set(1);
    dev.bc.top.Rextfile=char(inputs.top.ip(8).set{1});
    
else % bottom    
    if strcmp(char(inputs.bottom.ip(3).set{1}),'ideal') || strcmp(char(inputs.bottom.ip(3).set{1}),'ohmic')
        dev.bc.bottom.eq_bc='neutral';
        dev.bc.bottom.neq_bc='ideal';
        if inputs.bottom.ip(1).set(1) < inf || inputs.bottom.ip(2).set(1) < inf
            disp('cannot set Sn or Sp for contact=ideal');
            kerr=kerr+1;
        end
        dev.bc.bottom.sp=inf;
        dev.bc.bottom.sn=inf;
    elseif strcmp(char(inputs.bottom.ip(3).set{1}),'blocking')
        dev.bc.bottom.eq_bc='neutral';
        dev.bc.bottom.neq_bc='non-ideal';
        dev.bc.bottom.sp=inputs.bottom.ip(1).set(1);
        dev.bc.bottom.sn=inputs.bottom.ip(2).set(1);
    elseif strcmp(char(inputs.bottom.ip(3).set{1}),'Schottky')
        dev.bc.bottom.eq_bc='Schottky';
        dev.bc.bottom.neq_bc='non-ideal';
        dev.bc.bottom.phim=inputs.bottom.ip(9).set(1);
        dev.bc.bottom.sp=inputs.bottom.ip(1).set(1);
        dev.bc.bottom.sn=inputs.bottom.ip(2).set(1);
    end
    dev.bc.bottom.rc=inputs.bottom.ip(4).set(1);
    dev.bc.bottom.shadow=inputs.bottom.ip(5).set(1);
    dev.bc.bottom.Rext=inputs.bottom.ip(6).set(1);
    dev.bc.bottom.Rint=inputs.bottom.ip(7).set(1);
    dev.bc.bottom.Rextfile=char(inputs.bottom.ip(8).set{1});
    
end