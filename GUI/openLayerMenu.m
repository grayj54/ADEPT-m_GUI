function hLayerMenu = openLayerMenu(devObj)

global CONST
CONST = A_const;

hLayerMenu = figure('Visible', 'off', ...
    'Position', [575, 50, 550, 575], ...
    'Name', 'Set Parameters for Bulk of Device', ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'Units', 'normalized', ...
    'ToolBar', 'none');


% Construct Main Menu Components ------------------------------------------


hTitleText     = uicontrol(hLayerMenu, ...
    'Style', 'text', ...
    'String', 'ADEPT-m', ...
    'Position', [200, 375, 150, 150], ...
    'Units', 'normalized', ...
    'FontSize', 24);



hDropDown = uicontrol(hLayerMenu, ...
                 'style','pop',...
                 'position',[200, 175, 150, 150],...
                 'fontsize',12,...
                 'fontweight','bold',... 
                 'string',{'Add new layer', 'Delete last layer', '1'},...
                 'Callback', @AddLayer, ...
                 'value',1);
             
hSaveButton = uicontrol(hLayerdownMenu, ...
    'Style', 'pushbutton', ...
    'String', 'Save', ...
    'Position', [480, 15, 75, 40], ...
    'Callback', @SavePress, ...
    'Units', 'normalized', ...
    'FontSize', 16);

% Initialize the UI. ------------------------------------------------------

% make UI visible
hLayerMenu.Visible = 'on';

% make new objects --------------------------------------------------------
% open build menu
device = Adept;

% make test menu
% environment = Environment;

% make examine menu
% examineMenu = ExamineMenu;

% Main Menu Callbacks -----------------------------------------------------

% Main Menu Utility Functions ---------------------------------------------

end

function AddLayer(hObject,devObj)
    current_entries = cellstr(get(hObject, 'String'));
    current_entries{end}
    option_sel = get(hObject,'Value');
    if option_sel == 1
        current_entries{end+1} = str2num(current_entries{end}) + 1;
        set(hObject, 'String', current_entries);
    
    elseif option_sel == 2 && (current_entries{end} ~= '1')
        current_entries(end) = [];
        set(hObject, 'String', current_entries);
    
    elseif option_sel ~= 1 
        openBulkMenu(devObj,1,current_entries(option_sel))
    end
        
end




