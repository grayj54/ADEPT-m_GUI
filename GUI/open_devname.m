function hBuildMenu = open_devname(devObj)

%device = Adept;

hDevNameMenu = figure('Visible', 'off', 'Position', ...
                [945, 460, 570, 365], 'Name', 'Build Menu', 'MenuBar', ...
                'none', 'ToolBar', 'none');
           

prompt = {'Enter the name of the device'};
title = 'Device Name';


answer = insputdlg(prompt,title,[1 40]);
devObj.input_file = answer;

hBuildMenu = openBuildMenu(devObj, 1);

end
