function varargout = ADEPTm_GUI(varargin)
% ADEPT-m  is a simulation toolbox for researching photovoltaic cells.
% Creates main page menu and calls other modules to build the other
%   menus after their respective buttons are clicked on.
    
close all;
global CONST
CONST = A_const;

% Initialization tasks
mInputArgs = varargin; % Command line arguments
mOutputArgs = {}; % Variable for storing output
    
% create and then hide the UI as it is being constructed ------------------
hMainMenu = figure('MenuBar', 'none', ...
    'Name', 'Main Menu', ...
    'NumberTitle', 'off',...
    'Position', [20, 575, 500, 250], ...
    'ToolBar', 'none', ...
    'Units', 'normalized', ...
    'Visible', 'off');
    
% Construct Main Menu Components ------------------------------------------
hBuildButton   = uicontrol(hMainMenu, ...
    'Style', 'pushbutton', ...
    'String', 'Build', ...
    'Position', [50, 50, 100, 100], ...
    'Units', 'normalized', ...
    'Callback', @buildButton_Callback);

hTestButton    = uicontrol(hMainMenu, ...
    'Style', 'pushbutton', ...
    'String', 'Test', ...
    'Position', [200, 50, 100, 100], ...
    'Units', 'normalized', ...
    'Callback', @testButton_Callback);

hExamineButton = uicontrol(hMainMenu, ...
    'Style', 'pushbutton', ...
    'String', 'Examine', ...
    'Position', [350, 50, 100, 100], ...
    'Units', 'normalized', ...
    'Callback', @examineButton_Callback);

hTitleText     = uicontrol(hMainMenu, ...
    'Style', 'text', ...
    'String', 'ADEPT-m', ...
    'Position', [50, 175, 150, 50], ...
    'Units', 'normalized', ...
    'FontSize', 24);

% Initialize the UI. ------------------------------------------------------

% make UI visible
hMainMenu.Visible = 'on';

% make new objects --------------------------------------------------------
% open build menu
device = Adept;

% make test menu
% environment = Environment;

% make examine menu
% examineMenu = ExamineMenu;

% Main Menu Callbacks -----------------------------------------------------
function buildButton_Callback(~, ~)
    % Open Build Menu and return user changed values
    open_devname(device);
end

function testButton_Callback(~, ~)
    % Open Test Menu if devices exist
    %devList =  {'Device 1', 'Device 2'}; %getBuiltDevices();
    %if devList.length ~= 0
     %   openTestMenu(environment, devList);
   % else
        %device.openBuildMenu;
        %error('Build a device first');
    %end

    newTest();

end

function examineButton_Callback(~, ~)
    % Open Examine Menu

    examinemodel;

end

% Main Menu Utility Functions ---------------------------------------------

end
