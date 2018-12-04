function hBuildMenu = open_devname(devObj, count)

% hDevNameMenu = figure('Visible', 'off', 'Position', ...
%                 [945, 460, 570, 365], 'Name', 'Build Menu', 'MenuBar', ...
%                 'none', 'ToolBar', 'none');
if count == 0           
    prompt = {'Enter the name of the device'};
else
    prompt = {'No name entered. Please enter the name of the device'};
end
title = 'Device Name';

answer = inputdlg(prompt,title,[1 40]);

if ~isempty(answer)
    if ~isempty(answer{1})
        devObj.input_file = answer{1};
        hBuildMenu = openBuildMenu(devObj);
    else
        open_devname(devObj, 1);
    end
end

end
