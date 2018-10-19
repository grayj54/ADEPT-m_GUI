function flag=A_save(item)

try mode=item.OpCond.mode; % test if ADEPT structure
catch
    % test if Illumination structure
    try mode=item.type;  
    catch
        mode='na';
    end
    if strcmp(mode,'uniform') || strcmp(mode,'mono') || strcmp(mode,'spectrum')
        mode='illum';
    else
        mode='na';
    end
end
iname=inputname(1);
if strcmp(iname,'') == 1
    error('A_save: Input must be a simple variable name, not a value.')
end
cmd=strcat(iname,'=item;');
eval(cmd);
if strcmp(mode,'gui_input')
    sname=strcat(iname,'.GUI');
    fprintf('GUI input file for ADEPT device saved as %s\n\n',sname);
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

