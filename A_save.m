function flag=A_save(item,fname)

try mode=item.OpCond.mode; % test if ADEPT structure
catch
    % test if Illumination structure
    try mode=item.type;  
    catch
        mode='na';
    end
    if strcmp(mode,'uniform') || strcmp(mode,'mono') || strcmp(mode,'spectrum')
        mode='illum';
    elseif strcmp(mode,'gui_input')
        mode='gui_input';
    elseif strcmp(mode,'diktat_input')
        mode='diktat_input';
    else
        mode='na';
    end
end
if nargin == 1
   iname=inputname(1);
else
    iname=fname;
end
if strcmp(iname,'') == 1
    error('A_save: Input must be a simple variable name, not a value.')
end
cmd=strcat(iname,'=item;');
eval(cmd);
if strcmp(mode,'gui_input')
    sname=strcat(iname,'.GUI');
    fprintf('GUI inputs for ADEPT device saved as %s\n\n',sname);
elseif strcmp(mode,'diktat_input')
    sname=strcat(iname,'.DIKTAT');
    fprintf('DIKTAT inputs for ADEPT device saved as %s\n\n',sname);
elseif strcmp(mode,'equilibrium') % single device operating condition
    sname=strcat(iname,'.EQ');
    fprintf('ADEPT device saved as %s\n\n',sname);
elseif strcmp(mode,'steady-state')
    sname=strcat(iname,'.SS');
    fprintf('ADEPT device saved as %s\n\n',sname);
elseif strcmp(mode,'transient')
    sname=strcat(iname,'.TR');
    fprintf('ADEPT device saved as %s\n\n',sname);
elseif strcmp(mode,'small-signal')
    sname=strcat(iname,'.AC');
    fprintf('ADEPT device saved as %s\n\n',sname);
elseif strcmp(mode,'illum')
    sname=strcat(iname,'.ILLUM');
    fprintf('ADEPT device saved as %s\n\n',sname);
else
    sname=strcat(iname,'.mat');
    fprintf('Item saved as %s\n\n',sname);
end

save(sname,iname);

