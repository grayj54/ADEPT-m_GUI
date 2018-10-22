classdef BuildMenu
    properties
        type = 'Solar Cell'
        tempUnit = 'K'
        temp = 279
        Desc = ''
    end
    methods (Static)
        function openMenu
            % opens build menu using class' current properties
            
            % create and then hide the UI as it is being constructed ------
            hBuildMenu = figure('Visible', 'off', 'Position', ...
                [945, 460, 570, 365], 'Name', 'Build Menu', 'MenuBar', ...
                'none', 'ToolBar', 'none');
            
            % construct build menu components ----------------------------
             
            hTitleText = uicontrol(hBuildMenu, 'Style', 'text', 'String', ...
                'ADEPT-m: Build Device', 'Position', [15, 310, 350, 40], ...
                'FontSize', 24);
                 
            hTypeText = uicontrol(hBuildMenu, 'Style', 'text', 'String', ...
               'Device Type:', 'Position', [15, 240, 100, 20], 'FontSize',...
               12, 'HorizontalAlignment', 'left'); 
        
             hDescText = uicontrol(hBuildMenu, 'Style', 'text', 'String', ...
                'Description:', 'Position', [15, 205, 90, 20], 'FontSize',...
               12, 'HorizontalAlignment', 'left'); 
                
             hTempText = uicontrol(hBuildMenu, 'Style', 'text', 'String', ...
                 'Temperature:', 'Position', [15, 135, 100, 20], 'FontSize',...
               12, 'HorizontalAlignment', 'left');
         
              hDevStructText = uicontrol(hBuildMenu, 'Style', 'text', ...
                  'String', 'Device Structure', 'FontSize', 12, 'Position', ...
                  [405, 280, 150, 20]);
                   
             hTopDevButton = uicontrol(hBuildMenu, 'Style', 'pushbutton', ...
                 'String', 'Top of Device', 'Position', [405, 240, 150, 25], ...
                 'Callback', {@TopDevPress}, 'FontSize', 12); 
              
             hDevBulkButton = uicontrol(hBuildMenu, 'Style', 'pushbutton', ...
                 'String', 'Device Bulk', 'Position', [405, 125, 150, 100], ...
                 'Callback', {@DevBulkPress}, 'FontSize', 12);
              
             hBottomDevButton = uicontrol(hBuildMenu, 'Style', 'pushbutton', ...
                 'String', 'Bottom of Device', 'FontSize', 12, 'Position', ...
                 [405, 85, 150, 25], 'Callback', {@BottomDevPress});
              
             hAdvancedButton = uicontrol(hBuildMenu, 'Style', 'pushbutton', ...
                 'String', 'Advanced', 'Position', [15, 15, 125, 40], ...
                 'Callback', {@AdvancedPress}, 'FontSize', 16);
             
             hSaveButton = uicontrol(hBuildMenu, 'Style', 'pushbutton', ...
                 'String', 'Save', 'Position', [480, 15, 75, 40], ...
                 'Callback', {@SavePress}, 'FontSize', 16);
              
             hTypeDropdown = uicontrol(hBuildMenu, 'Style', 'popupmenu', ...
                 'String', {'Solar Cell', 'Other'}, 'Position', ...
                 [130, 240, 100, 20], 'Callback', {@UpdateTypeSelected});
              
             hTempUnitDropdown = uicontrol(hBuildMenu, 'Style', 'popupmenu', ...
                 'String', {'K', 'C'}, 'Position', [195, 135, 35, 20], ...
                 'Callback', {@UpdateTempUnitSelected});
             
             hDescField = uicontrol(hBuildMenu, 'Style', 'edit', 'Position', ...
                 [15, 170, 350, 20], 'Callback', {@UpdateDesc}, ...
                 'HorizontalAlignment', 'left');
              
              hTempField = uicontrol(hBuildMenu, 'Style', 'edit', 'Position', ...
                 [130, 135, 50, 20], 'Callback', {@UpdateTemp}, ...
                 'HorizontalAlignment', 'left');
              
            % Initialize the UI. -----------------------------------------
            % Change units to normalized so components resize automatically.
             
            hBuildMenu.Units = 'normalized';
            hTitleText.Units = 'normalized';
            hTypeText.Units = 'normalized';
            hDescText.Units = 'normalized';
            hTempText.Units = 'normalized';
            hDevStructText.Units = 'normalized';
            hTopDevButton.Units = 'normalized';
            hDevBulkButton.Units = 'normalized';
            hBottomDevButton.Units = 'normalized';
            hAdvancedButton.Units = 'normalized';
            hSaveButton.Units = 'normalized';
            hTypeDropdown.Units = 'normalized';
            hTempUnitDropdown.Units = 'normalized';
            hDescField.Units = 'normalized';
            hTempField.Units = 'normalized';
            
            % make UI visible
            hBuildMenu.Visible = 'on';
        end
        
        % Build Menu Callbacks --------------------------------------------
        
%         function test_Callback
%             
%         end
    end
end