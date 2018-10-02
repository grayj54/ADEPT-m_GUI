function ADEPTm_GUI
    % Creates main page menu and calls other modules to build the other
    % menus after their respective buttons are clicked on.
    close all;
    clear;
    clc;
    
    % create and then hide the UI as it is being constructed --------------
    hMainMenu = figure('Visible', 'off', 'Position', [20, 575, 500, 250],...
        'Name', 'Main Menu', 'MenuBar', 'none', 'ToolBar', 'none');
    
    % construct main menu components --------------------------------------
    hBuildButton   = uicontrol(hMainMenu, 'Style', 'pushbutton', 'String', ...
        'Build', 'Position', [50, 50, 100, 100], 'Callback', ...
        {@buildButton_Callback});

    hTestButton    = uicontrol(hMainMenu, 'Style', 'pushbutton', 'String', ...
        'Test', 'Position', [200, 50, 100, 100], 'Callback', ...
        {@testButton_Callback});

    hExamineButton = uicontrol(hMainMenu, 'Style', 'pushbutton', 'String', ...
        'Examine', 'Position', [350, 50, 100, 100], 'Callback', ...
         {@examineButton_Callback});

    hTitleText     = uicontrol(hMainMenu, 'Style', 'text', 'String', ...
        'ADEPT-m', 'Position', [50, 175, 150, 50], 'FontSize', 24);
    
    % Initialize the UI. --------------------------------------------------
    % Change units to normalized so components resize automatically.
    hMainMenu.Units = 'normalized';
    hBuildButton.Units = 'normalized';
    hTestButton.Units = 'normalized';
    hExamineButton.Units = 'normalized';
    hTitleText.Units = 'normalized';
    
    % make UI visible
    hMainMenu.Visible = 'on';
    
    % make menu classes ---------------------------------------------------
    % make build menu
    buildMenu = BuildMenu;
    
    % make test menu
    testMenu = TestMenu;
    
    % make examine menu
    % examineMenu = ExamineMenu;
    
	% Main Menu Callbacks -------------------------------------------------
    function buildButton_Callback(source, eventdata)
        % Open Build Menu and return user changed values
        buildMenu.openMenu;
    end

    function testButton_Callback(source, eventdata)
        % Open Test Menu
        testMenu.openMenu;
    end

    function examineButton_Callback(source, eventdata)
        % Open Examine Menu
        % examineMenu.open;
    end
end