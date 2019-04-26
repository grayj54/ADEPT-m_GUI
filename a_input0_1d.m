function [inputs,ierr]=a_input0_1d(source)

global REF A_FID VERBOSE

%
% available diktats:
%
% *device
% misc
% mesh
% bc
% *filter
% filter
%*layer
% layer
% device

fin=fopen(source,'rt');
if fin == -1
    error('cannot open %s',source);
end
inputs.nD='1D'; % --> dev.nD
inputs.input_file=source; % --> dev.input_file
inputs.type='diktat_input';

scan=1;
ldiktat='none';
ierr=0;
kerr=0;
nc=0; % initialize diktat count
nt=0; % *title count
nm=0; % mesh diktat count
nmisc=0; % misc diktat count
nbc=0; % bc diktat count
ns=0; % solve diktat count
nart=0;
narb=0;
nlayer=0;

while scan == 1
    
    p = parser(fin);
    if p.err == -1 % end of file reached
        scan=0;
        continue;
    end

    nc=nc+1; % keep track of number of diktats
    if VERBOSE; fprintf(A_FID,'%3d: %s\n',nc,char(p.statement(1))); end
    
    for i=2:p.nl
        if VERBOSE; fprintf(A_FID,'     %s\n',char(p.statement(i))); end
    end
    if p.err > 2
	  if VERBOSE; fprintf(A_FID,'      *---* %s\n',p.errmess); end
	  ierr=ierr+1;
    end

    if strcmp(ldiktat,'*layer')
          if strcmp(p.diktat,'layer') == 0
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* a layer diktat must follow a *layer diktat!!\n'); end
          end
    end
    if strcmp(ldiktat,'*filter')
          if strcmp(p.diktat,'filter') == 0
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* a filter diktat must follow a *filter diktat\n'); end
          end
    end
    if strcmp(ldiktat,'*ar')
          if strcmp(p.diktat,'ar') == 0
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* an ar diktat must follow a *ar diktat\n'); end
          end
    end

% interpret diktat

    % *title diktat
    if strcmp(p.diktat,'*') || strcmp(p.diktat,'*title')
        nt=nt+1;
        if nc == 1 && nt == 1
	        [inputs.title,kerr]=a_title(p,A_FID); % --> dev.description
        end 
        if kerr > 0
            ierr=ierr+1;
        end
        if nt > 1
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* only 1 *title diktat allowed\n'); end
        end
        if nc > 1
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* the *title diktat must be first\n'); end
        end
        
    % mesh diktat
    elseif strcmp(p.diktat,'mesh')
        nm=nm+1;
        if nm == 1
            [inputs,kerr]=a_rmesh(p,inputs);
            if kerr > 0
                ierr=ierr+1;
            end
        else
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* only 1 mesh diktat allowed\n'); end
        end
    % device diktat    
    elseif strcmp(p.diktat,'device') == 1
        ns=ns+1;
        if ns == 1
	        [inputs,kerr]=a_rdev(p,inputs);
            if kerr > 0
                ierr=ierr+1;
            end
        else
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* only 1 device diktat allowed\n'); end
        end
    % misc diktat    
    elseif strcmp(p.diktat,'misc')
        nmisc=nmisc+1;
        if ns == 0
           ierr=ierr+1;
           if VERBOSE; fprintf(A_FID,'      *---* a device diktat must preceed the misc diktat\n'); end
           REF.t=300; % so that a_rmisc will run
        end
        if nmisc == 1
	        [inputs,kerr]=a_rmisc(p,inputs);
            if kerr > 0
                ierr=ierr+1;
            end
        else
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* only 1 misc diktat allowed\n'); end
        end
    % bc diktat    
    elseif strcmp(p.diktat,'bc')
        nbc=nbc+1;
        if nbc == 1
            if nlayer > 0
                ierr=ierr+1;
                if VERBOSE; fprintf(A_FID,'      *---* bc diktat must preceed first layer diktat\n'); end
            end
	        [inputs,kerr]=a_readbc(p,inputs,'top');
            if kerr > 0
                ierr=ierr+1;
            end
        elseif nbc == 2
	        [inputs,kerr]=a_readbc(p,inputs,'bot');
            if kerr > 0
                ierr=ierr+1;
            end
        else
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* only 2 bc diktats allowed\n'); end
        end
    % *ar diktat
    elseif strcmp(p.diktat,'*ar')
        [ftitle kerr]=a_ftitle(p);
        if kerr > 0
            ierr=ierr+1;
        end
    % ar diktat
%     elseif strcmp(p.diktat,'ar')
%         if nlayer == 0
%             nart=nart+1;
%             if strcmp(ldiktat,'*ar') == 0
%                 ftitle=sprintf('Top ar layer # %d',nart);
%             end
%             [inputs,kerr]=a_filteri(p,inputs,A_FID,ftitle,'top',nart);
%             if kerr > 0
%                 ierr=ierr+1;
%             end
%         else
%             narb=narb+1;
%             if strcmp(ldiktat,'*filter') == 0 || strcmp(ldiktat,'*ar') == 0
%                 ftitle=sprintf('Bottom ar layer # %d',narb);
%             end
%             [inputs,kerr]=a_filteri(p,inputs,A_FID,ftitle,'bot',ftype,narb);
%             if kerr > 0
%                 ierr=ierr+1;
%             end;
%         end
	% *layer diktat
    elseif strcmp(p.diktat,'*layer')
        [ltitle,kerr]=a_ltitle(p);
        if kerr > 0
            ierr=ierr+1;
        end
    % layer diktat
    elseif strcmp(p.diktat,'layer')
        nlayer=nlayer+1;
        if nbc > 1
            ierr=ierr+1;
            if VERBOSE; fprintf(A_FID,'      *---* no layer diktats permitted after 2nd bc diktat\n'); end
            end
        if strcmp(ldiktat,'*layer') == 0
            ltitle=sprintf('Layer # %d',nlayer);
        end
	      [inputs,kerr]=a_rlayer(p,inputs,ltitle,nlayer);
        if kerr > 0
            ierr=ierr+1;
        end
    % undefined diktat
	else
	  ierr=ierr+1;
      if VERBOSE; fprintf(A_FID,'      *---* %s is an undefined diktat\n',p.diktat); end
    end
    ldiktat=p.diktat;
end

% set default description
if nt == 0
    inputs.dscription='Puedue University ADEPT-m Simulation';
end

% if no mesh diktat, set defaults
if nm == 0
    p.nvar=0;
    [inputs,kerr]=a_rmesh(p,inputs);
    if kerr > 0
        ierr=ierr+1;
        if VERBOSE; fprintf(A_FID,'Error setting mesh defaults\n'); end
    end
end

% there must be a device diktat
if ns == 0
    ierr=ierr+1;
    if VERBOSE; fprintf(A_FID,'Error, there must be a device diktat\n'); end
end

% if no misc diktat, set defaults
if nmisc == 0
    p.nvar=0;
    if ns == 0;REF.t=-1;end % so that a_rmisc will run
    [inputs,kerr]=a_rmisc(p,inputs);
    if kerr > 0
        ierr=ierr+1;
        if VERBOSE; fprintf(A_FID,'Error setting misc defaults\n'); end
    end
end

% if no bc diktat, set defaults
if nbc == 0
    p.nvar=0;
    [inputs,kerr]=a_readbc(p,inputs);
    if kerr > 0
        ierr=ierr+1;
        if VERBOSE; fprintf(A_FID,'Error setting bc defaults\n'); end
    end
end

% if no layer diktats, error
if nlayer == 0
    if VERBOSE; fprintf(A_FID,'There must be at least 1 layer diktat\n'); end
end

fclose(fin);
try fflush(A_FID);
catch
end
