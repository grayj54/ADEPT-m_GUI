function switchMenu_GUI
    % practice_GUI make front page that leads to other pages
    % Three buttons, Build, Test, Examine
    % intial page, Build page, Test page, and Examine page
    
    % create and then hide the UI as it is being constructed
    mainMenu = figure('Visible', 'off', 'Position', [350, 200, 800, 500],...
        'Name', 'Main Menu');
        
    buildMenu = figure('Visible', 'off', 'Position', [350, 200, 800, 500],...
        'Name', 'Build Menu');
    
    testMenu = figure('Visible', 'off', 'Position', [350, 200, 800, 500],...
        'Name', 'Test Menu');
    
    examineMenu = figure('Visible', 'off', 'Position', [350, 200, 800, 500],...
        'Name', 'Examine Menu');
    
    
    %construct the components
    hBuild   = uicontrol(mainMenu, 'Style', 'pushbutton', 'String', 'Build', ...
         'Position', [150, 200, 100, 100], 'Callback', ...
         {@buildButton_Callback});

    hTest    = uicontrol(mainMenu, 'Style', 'pushbutton', 'String', 'Test', ...
         'Position', [350, 200, 100, 100], 'Callback', ...
         {@testButton_Callback});

    hExamine = uicontrol(mainMenu, 'Style', 'pushbutton', 'String', 'Examine', ...
         'Position', [550, 200, 100, 100], 'Callback', ...
         {@examineButton_Callback});

    htext = uicontrol(mainMenu, 'Style', 'text', 'String', 'ADEPT-m', 'Position', ...
        [150, 300, 100, 100]); %font size needs to be increased
    
    hBackToMain1 = uicontrol(buildMenu, 'Style', 'pushbutton', 'String', 'Back', ...
         'Position', [50, 450, 70, 30], 'Callback', ...
         {@backToMain_Callback});
     
    hBackToMain2 = uicontrol(testMenu, 'Style', 'pushbutton', 'String', 'Back', ...
         'Position', [50, 450, 70, 30], 'Callback', ...
         {@backToMain_Callback}); 
    
    hBackToMain3 = uicontrol(examineMenu, 'Style', 'pushbutton', 'String', 'Back', ...
         'Position', [50, 450, 70, 30], 'Callback', ...
         {@backToMain_Callback});
    
    % Initialize the UI.
    % Change units to normalized so components resize automatically.
    mainMenu.Units = 'normalized';
    hBuild.Units = 'normalized';
    hTest.Units = 'normalized';
    hExamine.Units = 'normalized';
    htext.Units = 'normalized';
    hBackToMain1.Units = 'normalized';
    hBackToMain2.Units = 'normalized';
    hBackToMain3.Units = 'normalized';
    
    % move GUI to center of screen
    movegui(mainMenu, 'center')
    movegui(buildMenu, 'center')
    movegui(testMenu, 'center')
    movegui(examineMenu, 'center')
    
    % make UI visible
    mainMenu.Visible = 'on';
    
    function buildButton_Callback(source, eventdata)
        %Switch screens to build menu
        hideMenus();
        openMenu('Build');
    end

    function testButton_Callback(source, eventdata)
        %Switch screens to test menu
        hideMenus();
        openMenu('Test');
    end

    function examineButton_Callback(source, eventdata)
        %Switch screens to examine menu
        hideMenus();
        openMenu('Examine');
    end

    function backToMain_Callback(source, eventdata)
        % hide current menu, show main menu
        hideMenus();
        openMenu('Main');
    end
    
    function hideMenus()
        % set all menus visible property to off
        mainMenu.Visible = 'off';
        buildMenu.Visible = 'off';
        testMenu.Visible = 'off';
        examineMenu.Visible = 'off';
    end

    function openMenu(str)
        % set desired menu's visible property to on
        switch str
            case 'Build'
                buildMenu.Visible = 'on';
            case 'Test'
                testMenu.Visible = 'on';
            case 'Examine'
                examineMenu.Visible = 'on';
            otherwise
                mainMenu.Visible = 'on';
        end
    end
end
