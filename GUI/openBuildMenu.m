function hBuildMenu = openBuildMenu(devObj)
% opens build menu using class' current properties
% If newCheck == 0, user is editing a preexisting device and object
% parameters are not empty/ don't need to set defaults
% If newCheck == 1, user is creating a new device and therefore the
% defaults need to be set.

% create and then hide the UI as it is being constructed ------
hBuildMenu = figure('Visible', 'off', ...
    'Position', [20, 150, 570, 365], ...
    'Name', 'Build Menu', ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'Units', 'normalized', ...
    'ToolBar', 'none');
% construct build menu components ----------------------------

hBuildTitleText = makeText(hBuildMenu, 'ADEPT-m: Build Device',...
    [15, 310, 350, 40], 'left', 24);

hDevNameText = makeText(hBuildMenu, ['Device File:  ' devObj.input_file], ...
    [15, 100, 355, 20], 'left', 12);

hTypeText = makeText(hBuildMenu, 'Device Type:', [15, 240, 100, 20], ...
    'left', 12);

<<<<<<< HEAD
hDescText = makeText(hBuildMenu, 'Description:', [15, 205, 90, 20], ...
    'left', 12);
=======
hDevNameText_fromBuildWindow = uicontrol(hBuildMenu, ...
    'Style', 'text', ...
    'String', devObj.input_file, ...
    'Position', [130, 100, 350, 20], ...
    'FontSize', 12, ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left');
>>>>>>> 5a779391b49835271467c439c7e7d79a58f3ba45

hTempText = makeText(hBuildMenu, [devObj.device(1).ip(1).full_name ':'], ...
    [15, 135, 175, 20], 'left', 12);

hDevStructText = makeText(hBuildMenu, 'Device Structure', ...
    [405, 280, 150, 20], 'center', 12);

hDevBulkButton = makeButton(hBuildMenu, 'Device Bulk', ...
    [405, 125, 150, 100], 12, @DevBulkPress);

hTopDevButton = makeButton(hBuildMenu, 'Top of Device', ...
    [405, 220, 150, 25], 12, @TopDevPress);

hBottomDevButton = makeButton(hBuildMenu, 'Bottom of Device', ...
    [405, 105, 150, 25], 12, @BottomDevPress);

hAdvancedButton = makeButton(hBuildMenu, 'Advanced', ...
    [15, 15, 125, 40], 16, @AdvancedPress);

hSaveButton = makeButton(hBuildMenu, 'Save', [480, 15, 75, 40], ...
    16, @SavePress);

deviceIP = devObj.device(1).ip;

hTypeDropdown = makeDropdown(hBuildMenu, ...
    {'Solar Cell', 'Diode', 'Generic'}, [130, 240, 100, 20], 11, ...
    {@UpdateParams, deviceIP(2)}, deviceIP(2), 'set');

hTempUnitDropdown = makeDropdown(hBuildMenu, deviceIP(1).units, ...
    [270, 135, 35, 20], 11, {@UpdateParams, deviceIP(1)}, deviceIP(1), ...
    'name');
    
hDescField = makeEditBox(hBuildMenu, devObj.title, [15, 170, 350, 20], ...
    12, {@UpdateParams, 'Device Title'}, 'str');

hTempField = makeEditBox(hBuildMenu, deviceIP(1), ...
    [205, 135, 50, 20], 12, {@UpdateParams, deviceIP(1)}, 'num');

% DevNameText = makeText(hBuildMenu, 'Enter device name', ...
%     [15, 100, 150, 20], 'left', 12);

% DevNameEdit = makeEditBox(hBuildMenu, 'Enter name here', ...
%     [15, 70, 180, 20], 12, @UpdateName);

<<<<<<< HEAD
=======
% DevNameBox = uicontrol(hBuildMenu, ...d
%     'Style', 'edit', ...
%     'String', 'Enter name here', ...
%     'Position', [15, 70, 180, 20], ...
%     'Callback', @UpdateName, ...
%     'Units', 'normalized', ...
%     'HorizontalAlignment', 'left');
>>>>>>> 5a779391b49835271467c439c7e7d79a58f3ba45
% Initialize the UI. ------------------------------------------
% make UI visible
hBuildMenu.Visible = 'on';

% Build Menu Callbacks ----------------------------------------
    function UpdateParams(hObject, eventData, editedIP)
       if isfield(editedIP, 'full_name')
           if strcmp(editedIP.full_name, 'Operating Temperature')
               UpdateIP(hObject, devObj, editedIP.full_name, hTempField, ...
                   hTempUnitDropdown);
           else
               UpdateIP(hObject, devObj, editedIP.full_name);
           end
       else
           UpdateIP(hObject, devObj, editedIP);
       end
    end

    function TopDevPress(hObject, callbackdata)
        % Brings up new menu for selecting properties for the top
        % of device
        hTopMenu = openTopMenu(devObj,1);
        
    end

    function DevBulkPress(~, ~)
        % Brings up new menu for selecting properties for the bulk
        % of the device

        hLayerMenu = openLayerMenu(devObj);
        
    end

    function BottomDevPress(hObject, callbackdata)
        % Brings up new menu for selecting properties for the
        % bottom of device
          hBottomMenu = openBottomMenu(devObj,1);

    end

    function AdvancedPress(hObject, callbackdata)
        % Brings up new menu for selecting advanced properties for
        % the device
        hAdvMenu = openAdvMenu(devObj,1,1);
        
    end

    function SavePress(~, ~)
        % If user didn't touch defaults then make sure they are assigned to
        % adept object. Note: the 1 can be anything it just needs a second 
        % input arg
<<<<<<< HEAD
%         UpdateTypeSelected(hTypeDropdown, 1);
%         UpdateDesc(hDescField, 1);
%         UpdateTemp(1, 1);
%         
%         % Brings up new menu for saving the device properties
%         disp(['Device Type Selected: ' devObj.type]);
%         temp = sprintf('%.2f', devObj.T);
%         disp(['Temp of Device: ' temp]);
%         disp(['Desc of Device: ' devObj.description]);
%         
%         global data_list 
%         data_list = strings([10,10]);%initiate a data list string that gather the data
%         data_list(1) = devObj.type;%save type of the device into the first data
%         data_list(2) = devObj.T;%save the temperature into the data_list 2
%         data_list(3) = devObj.description;%save the description into the data_list 3
%         save('Myfunction.mat','data_list');%save the data into myfunction mat
%         x = devObj.input_file;

%         movefile('/GUI_Devices/Myfunction.mat', [x '.GUI']);%rename the current file 
        currentFolder = pwd;
        filename = devObj.input_file(1: length(devObj.input_file)-4);
        errorCode = A_save(devObj, filename);
        if errorCode 
            uiwait(errordlg('Save Failed!', 'Error'));
        else
            uiwait(msgbox('Save Complete!', 'Success'));
        end
        
=======
        UpdateTypeSelected(hTypeDropdown, 1);
        UpdateDesc(hDescField, 1);
        UpdateTemp(hTempField, 1);
        
        % Brings up new menu for saving the device properties
        disp(['Device Type Selected: ' devObj.type]);
        temp = sprintf('%.2f', devObj.T);
        disp(['Temp of Device: ' temp]);
        disp(['Desc of Device: ' devObj.description]);
        
        global data_list 
        data_list = strings([10,10]);%initiate a data list string that gather the data
        data_list(1) = devObj.type;%save type of the device into the first data
        data_list(2) = devObj.T;%save the temperature into the data_list 2
        data_list(3) = devObj.description;%save the description into the data_list 3
        save('Myfunction.mat','data_list');%save the data into myfunction mat
        x = devObj.input_file;

        movefile('/GUI_Devices/Myfunction.mat', [x '.GUI']);%rename the current file 

        
        questdlg('Save Complete!', 'Save Complete', 'OK', 'OK');
>>>>>>> 5a779391b49835271467c439c7e7d79a58f3ba45
    end

    %function UpdateName(hObject, ~)
        % Sets Adept object's name to new user entered string
        % devObj.input_file = hObject.String;
        % disp(['Device Name: ' devObj.input_file]);
    %end

end

        