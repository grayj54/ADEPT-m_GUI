classdef TestMenu
    properties
        test1 = 'start'
    end
    methods
        function open
            % opens test menu using class' current properties
            
            % create and then hide the UI as it is being constructed ------
            hTestMenu = figure('Visible', 'off', 'Position', ...
                [800, 500, 800, 500], 'Name', 'Test Menu', 'MenuBar', ...
                'none', 'ToolBar', 'none');
            
             % construct build menu components ----------------------------
             
             % Initialize the UI. -----------------------------------------
             % Change units to normalized so components resize automatically.
             
             % make UI visible
             hTestMenu.Visible = 'on';
        end
    end
end