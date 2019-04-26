function [strct,ierr]=a_diktat(pp,ip,fout)
% interpret diktat 'pp' from definitions in 'ip'
% results placed in 'struct'
%
% ip.aliases --> parameter name(s)
% ip.type --> parameter type ('number', 'string', or 'empty')
% ip.n --> [min rows,max rows;min cols,max cols] for parameter value
% ip.range --> numeric value range for type='number'
% ip.values --. possible strings for type='string'
% ip.default --> default value
% ip.set --> parameter value(s) (scalar or array)
%
global VERBOSE

ierr=0;

% check for valid inputs
for i=1:length(ip); ip(i).pp=[]; end
for j=1:pp.nvar
    found=0;
    [hname,ndx]=is_hashed(pp.var(j).name);
    if ndx < 0
        ierr=ierr+1;
        if VERBOSE; fprintf(fout,'Invalid index for %s\n',pp.var(j).name); end
    end
    pp.var(j).ndx=ndx;
    pp.var(j).name=hname;
    for i=1:length(ip)
        for k=1:length(ip(i).aliases)
            if strcmp(pp.var(j).name,ip(i).aliases{k})
                found=1;
                if length(ip(i).pp) == ndx
                    ierr=ierr+1;
                    ip(i).pp(ndx)=j;
                    if VERBOSE; fprintf(fout,'Duplicate index for %s\n',pp.var(j).name); end
                elseif length(ip(i).pp) < ndx
                    ip(i).pp(ndx)=j;
                else
                    if ip(i).pp(ndx) == 0
                        ip(i).pp(ndx)=j;
                    else
                        ierr=ierr+1;
                        ip(i).pp(ndx)=j;
                        if VERBOSE; fprintf(fout,'Duplicate index for %s\n',pp.var(j).name); end
                    end
                end

                if strcmp(pp.var(j).type,ip(i).type) == 0
                    ierr=ierr+1;
                    if VERBOSE; fprintf(fout,'Invalid variable type for %s\n',pp.var(j).name); end
                end
                if ndx > 1
                    try iok=ip(i).indexed;
                        if iok ~= 1
                            ierr=ierr+1;
                            if VERBOSE; fprintf(fout,'%s - cannot be indexed.\n',pp.var(j).name); end
                        end
                    catch
                        ierr=ierr+1;
                        if VERBOSE; fprintf(fout,'%s - cannot be indexed.\n',pp.var(j).name); end
                    end
                end
                break;
            end
        end
        if found
            break; 
        end
    end
    if found == 0
        ierr=ierr+1;
        if VERBOSE; fprintf(fout,'Invalid input parameter: %s\n',pp.var(j).name); end
    end
end

if ierr > 0
    if VERBOSE; fprintf(fout,'Errors on diktat\n'); end
    return
end

% assign values
for i=1:length(ip)
    if isempty(ip(i).pp) % set to default values
        ip(i).name=ip(i).aliases{1};
        ip(i).set=ip(i).default;
        ip(i).default_used(1)=1;
    elseif length(ip(i).pp) == 1 % ip(i) appears once
        ip(i).name=pp.var(ip(i).pp).name;
        ip(i).set=pp.var(ip(i).pp).val;
        ip(i).default_used(1)=0;
    else % ip(i) is indexed > 1
        nset=0;
        for ik=1:length(ip(i).pp)
            if ip(i).pp(ik) > 0
                if nset == 0
                    ip(i).name=pp.var(ip(i).pp(ik)).name;
                    nset=1;
                end
            end
            % check for mix of '/' and '#'
            slash=0;
            hash=0;
            for k=1:length(ip(i).pp)
                j=ip(i).pp(k);
                if j > 0
                    if size(pp.var(j).val,1) > 1; slash=slash+1; end
                    if pp.var(j).ndx > 0; hash=hash+1; end
                end
            end
            if hash*slash > 0 % both hash and slash are > 0
                ierr=ierr+1;
                if VERBOSE; fprintf(fout,'a_diktat.m: Mixing of ''#'' and ''/'' not allowed for %s - cannot continue.\n',pp.var(j).name); end
                return;
            elseif slash > 0 % multiple ip(j) with '/' list (even if single value)
                j=ip(i).pp(1);
                start=1;
                stop=size(pp.var(j).val,1);
                ip(i).set(start:stop)=pp.var(j).val;
                for k=2:length(ip(i).pp)
                    j=ip(i).pp(k);
                    start=stop+1;
                    stop=stop+length(pp.var(j).val);
                    ip(i).set(start:stop)=pp.var(j).val;
                end
            else % multiple indexed ('#') ip(j)
                j=ip(i).pp(1);
                if j > 0
                    if size(pp.var(j).val,1) > 1
                        ierr=ierr+1;
                        if VERBOSE; fprintf(fout,'a_diktat.m: Mixing of ''#'' and ''/'' not allowed for %s - cannot continue.\n',pp.var(j).name); end
                        return;
                    end
                end
                % check for duplicate indices
                for l=1:length(ip(i).pp)-1
                    jl=ip(i).pp(l);
                    if jl > 0
                    ndxA=pp.var(jl).ndx;
                        for k=l+1:length(ip(i).pp)
                            jk=ip(i).pp(k);
                            ndxB=pp.var(jk).ndx;
                            if ndxA == ndxB
                                ierr=ierr+1;
                                if VERBOSE; fprintf(fout,'a_diktat.m: duplicate index for %s - cannot continue.\n',pp.var(j).name); end
                                return;
                            end
                        end
                    end
                end
                maxndx=0;
                for k=1:length(ip(i).pp)
                    j=ip(i).pp(k);
                    if j > 0
                        if pp.var(j).ndx > maxndx
                            maxndx=pp.var(j).ndx;
                        end
                    end
                end
                for k0=1:maxndx
                    ip(i).set(k0,:)=ip(i).default;
                    ip(i).default_used(k)=1;
                end
                for k=1:length(ip(i).pp)
                    j=ip(i).pp(k);
                    if j > 0
                        ind=pp.var(j).ndx;
                        ip(i).set(ind,:)=pp.var(j).val;
                        ip(i).default_used(k)=0;
                    end
                end
            end 
        end
    end
end
    
for i=1:length(ip)
    % check for validity of inputs
    [lr,lc]=size(ip(i).set);
    if lr > 0 && lc > 0
        if lr < ip(i).n(1,1) || lr > ip(i).n(1,2) || lc < ip(i).n(2,1) || lc > ip(i).n(2,2)
            ierr=ierr+1;
            if VERBOSE; fprintf(fout,'Incorrect number of values for %s\n',ip(i).name); end
        end
        if isempty(ip(i).range) == 0 && strcmp(ip(i).type,'number')
            for m=1:lr
              for n=1:lc
                 if ip(i).set(m,n) < ip(i).range(1) || ip(i).set(m,n) > ip(i).range(2)
                     ierr=ierr+1;
                     if VERBOSE; fprintf(fout,'Input out of range for %s\n',ip(i).name); end
                 end
              end
            end
        elseif isempty(ip(i).values) == 0 && strcmp(ip(i).type,'string')
            ok=1;
            for m=1:lr
            for n=1:lc
                found=0;
                for nn=1:length(ip(i).values)
                    if strcmp(ip(i).set{m,n},ip(i).values{nn}) || strcmp(ip(i).values{nn},'*')
                        found=1;
                    end
                end
                if found == 0
                    ierr=ierr+1;
                    if VERBOSE; fprintf(fout,'Invalid input string for %s\n',ip(i).name); end
                end
            end
            end
            if ok == 0
                ierr=ierr+1;
                if VERBOSE; fprintf(fout,'Invalid input for %s\n',ip(i).name); end
            end
        end
        
    elseif (lr == 0 && lc > 0) || (lc == 0 && lr > 0)
        ierr=ierr+1;
        if VERBOSE; fprintf(fout,'Invalid size for %s\n',ip(i).name); end
            
    end
end

if ierr > 0
    error('a_diktat.m: Errors found on diktat')
else
    for i=1:length(ip)
        strct(i).aliases=ip(i).aliases;
        try strct(i).units=ip(i).units; end
        try strct(i).full_name=ip(i).full_name; end
        strct(i).type=ip(i).type;
        strct(i).n=ip(i).n;
        strct(i).range=ip(i).range;
        strct(i).values=ip(i).values;
        strct(i).default=ip(i).default;
        strct(i).name=ip(i).name; % alias used
        strct(i).set=ip(i).set; % set value
      % strct(i).default_used=ip(i).default_used;
    end
end