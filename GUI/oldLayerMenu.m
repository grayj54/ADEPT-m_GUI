function [hLayerMenu, layers] = openLayerMenu(devObj)

global CONST
CONST = A_const;

hLayerMenu = figure('Visible', 'off', ...
            'Position', [575, 50, 550, 575], ...
            'Name', 'Set Parameters for Bulk of Device', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Units', 'normalized', ...
            'ToolBar', 'none');


% Construct Layer Menu Components ------------------------------------------


hTitleText = uicontrol(hLayerMenu, ...
            'Style', 'text', ...
            'String', 'ADEPT-m', ...
            'Position', [200, 375, 150, 150], ...
            'Units', 'normalized', ...
            'FontSize', 24);

hListBox = uicontrol(hLayerMenu, ...
            'style','listbox',...
            'position',[200, 175, 150, 150],...
            'fontsize',12,...
            'fontweight','bold',... 
            'string',{'Add new layer', 'Delete last layer', '1'},...
            'Callback', @AddLayer, ...
            'value',1);
             
hSaveButton = uicontrol(hLayerMenu, ...
            'Style', 'pushbutton', ...
            'String', 'Save', ...
            'Position', [480, 15, 75, 40], ...
            'Callback', @SavePress, ...
            'Units', 'normalized', ...
            'FontSize', 16);

% Initialize the UI. ------------------------------------------------------

% make UI visible
hLayerMenu.Visible = 'on';
layers = [];
% make new objects --------------------------------------------------------
function AddLayer(hObject, ~)
    current_entries = cellstr(get(hObject, 'String'));
    current_entries{end};
    option_sel = get(hObject,'Value');
    if option_sel == 1
        current_entries{end+1} = str2num(current_entries{end}) + 1;
        set(hObject, 'String', current_entries);
    
    elseif option_sel == 2 && (current_entries{end} ~= '1')
        current_entries(end) = [];
        set(hObject, 'String', current_entries);
    
    elseif option_sel ~= 1 
        disp(['test', current_entries(option_sel), option_sel(1)]);
        [~, layers{option_sel(1)-2}] = openBulkMenu(devObj,1,current_entries(option_sel));
    end
end

    function SavePress(~, ~)
        % If user didn't touch defaults then make sure they are assigned to
        % adept object. Note: the 1 can be anything it just needs a second 
        % input arg
        
        % Brings up new menu for saving the device properties
           
        global data_list 
        data_list(4) = layers;%save layers of the device into the 4th data
        save('Myfunction.mat','data_list');%save the data into myfunction mat
        x = devObj.input_file;

        movefile('/GUI_Devices/Myfunction.mat', [x '.GUI']);%rename the current file 
        questdlg('Save Complete!', 'Save Complete', 'OK', 'OK');
    end
end




