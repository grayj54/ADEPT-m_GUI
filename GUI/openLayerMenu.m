function [hLayerMenu] = openLayerMenu(devObj)
    hLayerMenu = figure('Visible', 'off', ...
        'Position', [775, 50, 750, 775], ...
        'Name', 'Layer Menu', ...
        'NumberTitle', 'off', ...
        'MenuBar', 'none', ...
        'Units', 'normalized', ...
        'ToolBar', 'none');

    hTopTabs = uitabgroup(hLayerMenu);
    MyTabArray = {};
    MyTabArray{1, 1} = uitab(hTopTabs, 'Title', 'Home');
    MyTabArray{1, 2} = uitab(hTopTabs, 'Title', 'Layer 1');

    % Construct Layer Home Menu Components --------------------------------
    hTableTitleText = makeText(MyTabArray{1, 1}, 'Device Layers:',...
        [50, 580, 150, 30], 'left',  16);
    
    hLayerTable = uitable(MyTabArray{1, 1}, ...
        'position',[50, 225, 596, 350],...
        'fontsize',9,...
        'ColumnName',{'Select', 'Layer Name', 'Semiconductor Model Type', ...
        'Layer Thickness', 'Thickness Units', 'Move Up', 'Move Down'}, ...
        'Data', {false, 'Layer 1', 'Custom', '-999', 'A', 'Move Up', ...
                'Move Down'},...
        'ColumnFormat', ({'logical', 'char', {'Custom', 'Simple', ...
                            'Silicon', 'GaAs', 'Germainium'}, 'char', ...
                            devObj.layers(1).ip(1).units, [], []}),...
        'ColumnEditable', [true true true true true false false], ...
        'Units', 'normalized', ...
        'CellEditCallback', @editTable, ...
        'CellSelectionCallback', @moveRows);

    hDevStatText = makeText(MyTabArray{1, 1}, ...
        'Device Statistics:', [50, 715, 175, 25], 'left',  16);
         
    hNumLayersText = makeText(MyTabArray{1, 1}, ...
        ['Number of Layers:  ' getNumLayers()], [50, 680, 300, 25], ...
        'left', 16);
    
    hDevThickUnitDropdown = makeDropdown(MyTabArray{1, 1}, ...
        devObj.layers(1).ip(1).units, [550, 655, 60, 20], ...
        14, @SetDevThickStat, devObj.layers(1).ip(1), 'name');
    
    hDevThickText = makeText(MyTabArray{1, 1}, ...
        ['Device Thickness:  ' getDevThickness()], [50, 645, 500, 25], ...
        'left', 16);
    
    hAddLayerTopButton = makeButton(MyTabArray{1, 1}, ...
        'Add Layer To Top', [50, 150, 300, 40], 16, @addLayerTop);
    
    hAddLayerBottomButton = makeButton(MyTabArray{1, 1}, ...
        'Add Layer To Bottom', [50, 95, 300, 40], 16, @addLayerBottom);
    
    hDeleteSelectedButton = makeButton(MyTabArray{1, 1}, ...
        'Delete Selected', [50, 40, 300, 40], 16, @deleteLayer);
    
    % Build Default Layer 1
    createSubTabs(2);
    
    hLayerMenu.Visible = 'on';
    
    function SetDevThickStat(~, ~)
        hDevThickText.String = ['Device Thickness:  ' getDevThickness()];
    end

    function strnum = getDevThickness(~, ~, ~)
        numLayers = size(hLayerTable.Data, 1);
        unitArray = hLayerTable.Data(:, 5); % cell array
        lengthArray = hLayerTable.Data(:,4); % cell array
        
        sum = 0;
        for i = 1:numLayers
            add = str2num(lengthArray{i});
            switch unitArray{i}
                case 'cm'
                    sum = sum + (add*10^8); % convert to A 
                case 'mm'
                    sum = sum + (add*10^7); % convert to A
                case 'um'
                    sum = sum + (add*10^4); % convert to A
                case 'nm'
                    sum = sum + (add*10); % convert to A
                case 'A'
                    sum = sum + add;
                case 'Choose'
                    % Do nothing or send a alert box at the end to infom
                    % the user to chose units for rows [x, y, ...].
            end
        end
        
        % add logic for selected units of dev thickness
        selectedUnit = hDevThickUnitDropdown.String{hDevThickUnitDropdown.Value};
        switch selectedUnit
            case 'cm'
                sum = sum/(10^8);
            case 'mm'
                sum = sum/(10^7);
            case 'um'
                sum = sum/(10^4);
            case 'nm'
                sum = sum/10;
            case 'A'
                % do nothing
            otherwise
                sum = '-999';
        end
        
        strnum = sprintf('%.5f', sum);
    end
    
    function createSubTabs(index)
        MyTabArray{2, index} = uitabgroup(MyTabArray{1, index}); 
        MyTabArray{3, index} = uitab(MyTabArray{2, index}, 'Title', 'Basic Parameters');
        MyTabArray{4, index} = uitab(MyTabArray{2, index}, 'Title', 'Trap Parameters');
        % Look into uitab "userdata" property
        % Look into uitab "deleteFcn" property
        
        layersIP = devObj.layers(index-1).ip;
        
        % Build Basic Parameters Tab Visuals ------------------------------
        hOpenOptParamMenu = makeButton(MyTabArray{3, index}, ...
            'Edit Optical Parameters', [50, 20, 300, 40], ...
            16, @openOptParamMenu);
    
        hParamText = makeText(MyTabArray{3, index}, ...
            'Parameters:', [40, 710, 150, 40], 'left', 16);
        
        hStarttext = makeText(MyTabArray{3, index}, 'Start', ...
            [450, 725, 100, 25], 'center', 14);
        
        hEndtext = makeText(MyTabArray{3, index}, 'End', ...
            [575, 725, 100, 25], 'center', 14);
        
        hEleAffinText = makeText(MyTabArray{3, index}, ...
            [layersIP(3).full_name ' (' layersIP(3).units '):'], ...
            [225, 690, 200, 20], 'right', 12);

        hEleAffinMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(3), [450, 690, 100, 20], 12, ...
            {@UpdateParams, layersIP(3)}, 'num');
        
        hEleAffinMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(3), [575, 690, 100, 20], 12, ...
            {@UpdateParams, layersIP(3)}, 'num');

        hBandgapText = makeText(MyTabArray{3, index}, ...
            [layersIP(4).full_name ' (' layersIP(4).units '):'],...
            [25, 655, 400, 20], 'right', 12);

        hBandgapMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(4), [450, 655, 100, 20], 12, ...
            {@UpdateParams, layersIP(4)}, 'num');
        
        hBandgapMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(4), [575, 655, 100, 20], 12, ...
            {@UpdateParams, layersIP(4)}, 'num');

        hDieleConstText = makeText(MyTabArray{3, index}, ...
            [layersIP(5).full_name ':'], [25, 620, 400, 20], ...
            'right', 12);

        hDieleConstMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(5), [450, 620, 100, 20], 12, ...
            {@UpdateParams, layersIP(5)}, 'num');
        
        hDieleConstMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(5), [575, 620, 100, 20], 12, ...
            {@UpdateParams, layersIP(5)}, 'num');

        hConductBandText = makeText(MyTabArray{3, index}, ...
            [layersIP(6).full_name ' (' layersIP(6).units '):'], ...
            [25, 585, 400, 20], 'right', 12);

        hConductBandMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(6), [450, 585, 100, 20], 12, ...
            {@UpdateParams, layersIP(6)}, 'num');
        
        hConductBandMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(6), [575, 585, 100, 20], 12, ...
            {@UpdateParams, layersIP(6)}, 'num');

        hValenceBandText = makeText(MyTabArray{3, index}, ...
            [layersIP(7).full_name ' (' layersIP(7).units '):'], ...
            [25, 550, 400, 20], 'right', 12);

        hValenceBandMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(7), [450, 550, 100, 20], 12, ...
            {@UpdateParams, layersIP(7)}, 'num');

        hValenceBandMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(7), [575, 550, 100, 20], 12, ...
            {@UpdateParams, layersIP(7)}, 'num');
        
        hElecThermVelocityText = makeText(MyTabArray{3, index}, ...
            [layersIP(10).full_name ' (' layersIP(10).units '):'], ...
            [25, 515, 400, 20], 'right', 12);

        hElecThermVelocityMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(10), [450, 515, 100, 20], 12, ...
            {@UpdateParams, layersIP(10)}, 'num');
        
        hElecThermVelocityMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(10), [575, 515, 100, 20], 12, ...
            {@UpdateParams, layersIP(10)}, 'num');

        hHoleThermVelocityText = makeText(MyTabArray{3, index}, ...
            [layersIP(11).full_name ' (' layersIP(11).units '):'], ...
            [25, 480, 400, 20], 'right', 12);

        hHoleThermVelocityMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(11), [450, 480, 100, 20], 12, ...
            {@UpdateParams, layersIP(11)}, 'num');
        
        hHoleThermVelocityMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(11), [575, 480, 100, 20], 12, ...
            {@UpdateParams, layersIP(11)}, 'num');
        
        hPlotAxis = axes(MyTabArray{3, index}, ...
            'Units', 'normalized',...
            'Position', [0.1, 0.15, .4, .4]); 
        
        % ip for C-T mobility starts at 117        
        % choices are 'linear' and 'C-T' which are vague
        % Electron Mobility
        hElecText = makeText(MyTabArray{3, index}, ...
            'Electrons:', [450, 440, 100, 20], 'left', 12);
        
        hElecMobModelDropdown = makeDropdown(MyTabArray{3, index}, ...
            layersIP(117).values, [575, 445, 100, 20], 10, ...
            {@UpdateElecMobilityModel, layersIP(117)}, layersIP(117), 'set');     
        
        hElecMobMaxText = makeText(MyTabArray{3, index}, ...
            'max:',  [450, 355, 100, 20], 'center', 12);
        
        hElecMobStartText = makeText(MyTabArray{3, index}, ...
            'Start value:',  [450, 355, 100, 20], 'center', 12);
        
        hElecMobMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(118), [575, 355, 100, 20], 12, ...
            {@UpdateParams, layersIP(118)}, 'num');
        
        hElecMobMinText = makeText(MyTabArray{3, index}, ...
            'min:', [450, 320, 100, 20], 'center', 12);
        
        hElecMobEndText = makeText(MyTabArray{3, index}, ...
            'End Value:', [450, 320, 100, 20], 'center', 12);
        
        hElecMobMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(119), [575, 320, 100, 20], 12, ...
            {@UpdateParams, layersIP(119)}, 'num');
        
        hElecMobNrefText = makeText(MyTabArray{3, index}, ...
            'Nref:', [450, 285, 100, 20], 'center', 12);
        
        hElecMobNrefEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(120), [575, 285, 100, 20], 12, ...
            {@UpdateParams, layersIP(120)}, 'num');
        
        hElecMobAlphaText = makeText(MyTabArray{3, index}, ...
            'alpha:', [450, 250, 100, 20], 'center', 12);
        
        hElecMobAlphaEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(121), [575, 250, 100, 20], 12, ...
            {@UpdateParams, layersIP(121)}, 'num');
        
        hElecMobMaxText.Visible = 'off';
        hElecMobMinText.Visible = 'off';
        hElecMobNrefText.Visible = 'off';
        hElecMobNrefEdit.Visible = 'off';
        hElecMobNrefText.Enable = 'off';
        hElecMobAlphaText.Visible = 'off';
        hElecMobAlphaEdit.Visible = 'off';
        hElecMobAlphaEdit.Enable = 'off';
        
        hEqAxes = axes(MyTabArray{3, index}, ...
            'Units', 'normalized',...
            'Position', [0, 0, 1, 1], ...
            'Color', 'none', 'XColor', 'none', 'YColor', 'none'); 
        
        % Linear Model
        Eq1 = '$\mu = (\mu_{end} - \mu_{start}) N + \mu_{start}$'; 
        
        % Must use text() function since it is on axes and uicontrol()
        % doesn't support latex syntax.
        hEq1Text = text(hEqAxes, 0.59, 0.53, Eq1, ...  
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq1Text.Visible = 'on';
        % Caughey-Thomas Model
        Eq2 = '$\mu = \frac{\mu_{max} - \mu_{min}}{1 + (\frac{N}{N_{ref}})^{\alpha}} + \mu_{min}$';
        
        hEq2Text = text(hEqAxes, 0.64, 0.53, Eq2, ... 
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq2Text.Visible = 'off';
        
        % Hole Mobility
        hHoleText = makeText(MyTabArray{3, index}, ...
            'Holes:', [450, 210, 100, 20], 'left', 12);
        
        hHoleMobModelDropdown = makeDropdown(MyTabArray{3, index}, ...
            layersIP(122).values, [575, 215, 100, 20], 10, ...
            @UpdateHoleMobilityModel, layersIP(122), 'set');     
        
        hHoleMobMaxText = makeText(MyTabArray{3, index}, ...
            'max:',  [450, 125, 100, 20], 'center', 12);
        
        hHoleMobStartText = makeText(MyTabArray{3, index}, ...
            'Start value:',  [450, 125, 100, 20], 'center', 12);
        
        hHoleMobMaxEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(123), [575, 125, 100, 20], 12, ...
            {@UpdateParams, layersIP(123)}, 'num');
        
        hHoleMobMinText = makeText(MyTabArray{3, index}, ...
            'min:', [450, 90, 100, 20], 'center', 12);
        
        hHoleMobEndText = makeText(MyTabArray{3, index}, ...
            'End Value:', [450, 90, 100, 20], 'center', 12);
        
        hHoleMobMinEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(124), [575, 90, 100, 20], 12, ...
            {@UpdateParams, layersIP(124)}, 'num');
        
        hHoleMobNrefText = makeText(MyTabArray{3, index}, ...
            'Nref:', [450, 55, 100, 20], 'center', 12);
        
        hHoleMobNrefEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(125), [575, 55, 100, 20], 12, ...
            {@UpdateParams, layersIP(125)}, 'num');
        
        hHoleMobAlphaText = makeText(MyTabArray{3, index}, ...
            'alpha:', [450, 20, 100, 20], 'center', 12);
        
        hHoleMobAlphaEdit = makeEditBox(MyTabArray{3, index}, ...
            layersIP(126), [575, 20, 100, 20], 12, ...
            {@UpdateParams, layersIP(126)}, 'num');
        
        hHoleMobMaxText.Visible = 'off';
        hHoleMobMinText.Visible = 'off';
        hHoleMobNrefText.Visible = 'off';
        hHoleMobNrefEdit.Visible = 'off';
        hHoleMobNrefText.Enable = 'off';
        hHoleMobAlphaText.Visible = 'off';
        hHoleMobAlphaEdit.Visible = 'off';
        hHoleMobAlphaEdit.Enable = 'off';
        
        hEqAxes = axes(MyTabArray{3, index}, ...
            'Units', 'normalized',...
            'Position', [0, 0, 1, 1], ...
            'Color', 'none', 'XColor', 'none', 'YColor', 'none'); 
        
        % Linear Model
        % Must use text() function since it is on axes and uicontrol()
        % doesn't support latex syntax.
        hEq3Text = text(hEqAxes, 0.59, 0.23, Eq1, ...  
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq3Text.Visible = 'on';
        % Caughey-Thomas Model
        hEq4Text = text(hEqAxes, 0.64, 0.23, Eq2, ... 
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq4Text.Visible = 'off';
        
        % Plot Mobility
        plotMobility();
        
        % Build Trap Parameters Tab Visuals -------------------------------
%         hFixedIonDonorDensityText = makeText(MyTabArray{4, index}, ...
%             'Fixed ionized donor density (#/cm^-3):', [75, 740, 350, 20], ...
%             'right', 12);
% 
%         hFixedIonDonorDensityEdit = makeEditBox(MyTabArray{4, index}, ...
%             '0.00', [450, 740, 100, 20], 12, @UpdateFixedIonDonorDensity);
%         
%         hFixedIonAcceptorDensityText = makeText(MyTabArray{4, index}, ...
%             'Fixed ionized acceptor density (#/cm^-3):', ...
%             [75, 700, 350, 20], 'right', 12);
% 
%         hFixedIonAcceptorDensityEdit = makeEditBox(MyTabArray{4, index}, ...
%             '0.00', [450, 700, 100, 20], 12, ...
%             @UpdateFixedIonAcceptorDensity);
%         
%         hDonorDensityText = makeText(MyTabArray{4, index}, ...
%             'Donor density (#/cm^-3):', [75, 660, 350, 20], 'right', 12);
% 
%         hDonorDensityEdit = makeEditBox(MyTabArray{4, index}, ...
%             '0.00', [450, 660, 100, 20], 12, @UpdateDonorDensity);
%         
%         hDonorEnergyText = makeText(MyTabArray{4, index}, ...
%             'Donor energy Ec-Et (eV):', [75, 620, 350, 20], ...
%             'right', 12);
% 
%         hDonorEnergyEdit = makeEditBox(MyTabArray{4, index}, ...
%             '-100.00', [450, 620, 100, 20], 12, @UpdateDonorEnergy);
%         
%         hRecombTypeText = makeText(MyTabArray{4, index}, ...
%             'Recombination Type:', [75, 580, 350, 20], 'right', 12);
% 
%         hRecombTypeDropdown = makeDropdown(MyTabArray{4, index}, ...
%             {'Radiative', 'Auger', 'SHR', 'SLT'}, [450, 580, 150, 20], ...
%             12, @ShowSelectedRecombFields);
%         
%         hRecombCoeffText = makeText(MyTabArray{4, index}, ...
%             'Recombination coefficient (cm^3/s):', [75, 540, 350, 20], ...
%             'right', 12);
% 
%         hRecombCoeffEdit = makeEditBox(MyTabArray{4, index}, ...
%             '0.00', [450, 540, 100, 20], 12, @UpdateRecombCoeff);
%         
%         hHoleRecombCoeffText = makeText(MyTabArray{4, index}, ...
%             'Hole Recombination coefficient (cm^6/s):', ...
%             [75, 540, 350, 20], 'right', 12);
%         hHoleRecombCoeffText.Visible = 'off';
% 
%         hHoleRecombCoeffEdit = makeEditBox(MyTabArray{4, index}, ...
%             '0.00', [450, 540, 100, 20], 12, @UpdateHoleRecombCoeff);   
%         hHoleRecombCoeffEdit.Visible = 'off';
%       
%         hElecRecombCoeffText = makeText(MyTabArray{4, index}, ...
%             'Electron Recombination coefficient (cm^6/s):', ...
%             [75, 500, 350, 20], 'right', 12);
%         hElecRecombCoeffText.Visible = 'off';
% 
%         hElecRecombCoeffEdit = makeEditBox(MyTabArray{4, index}, ...
%             '0.00', [450, 500, 100, 20], 12, @UpdateElecRecombCoeff);
%         hElecRecombCoeffEdit.Visible = 'off';
        
        
        
        % Build Basic Parameters Tab Functions ----------------------------
        function UpdateParams(hObject, eventData, editedIP)
            plotMobility();
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
        
        function UpdateElecMobilityModel(hObject, eventData, editedIP)
            % Make all related text and edit boxes invisible.
%             hEq1Text.Visible = 'off';
            hEq1Text.Visible = 'off';
            hEq2Text.Visible = 'off';
            hElecMobMaxText.Visible = 'off';
            hElecMobMinText.Visible = 'off';
            hElecMobNrefText.Visible = 'off';
            hElecMobNrefEdit.Visible = 'off';
            hElecMobNrefText.Enable = 'off';
            hElecMobAlphaText.Visible = 'off';
            hElecMobAlphaEdit.Visible = 'off';
            hElecMobAlphaEdit.Enable = 'off';
            hElecMobStartText.Visible = 'off';
            hElecMobEndText.Visible = 'off';
            
            % Make relevant text and edit boxes visible.
            switch hObject.String{hObject.Value} 
                case 'linear'
                    hEq1Text.Visible = 'on';
                    hElecMobStartText.Visible = 'on';
                    hElecMobEndText.Visible = 'on';
                case 'C-T'
                    hEq2Text.Visible = 'on';
                    hElecMobMaxText.Visible = 'on';
                    hElecMobMinText.Visible = 'on';
                    hElecMobNrefText.Visible = 'on';
                    hElecMobNrefEdit.Visible = 'on';
                    hElecMobNrefText.Enable = 'on';
                    hElecMobAlphaText.Visible = 'on';
                    hElecMobAlphaEdit.Visible = 'on';
                    hElecMobAlphaEdit.Enable = 'on';
                otherwise
                    % do nothing
            end
            
            % edit ip struct
            UpdateIP(hObject, devObj, editedIP.full_name);
            
        end        
        
        function UpdateHoleMobilityModel(hObject, eventData, editedIP)
            % Make all related text and edit boxes invisible.
%             hEq1Text.Visible = 'off';
            hEq3Text.Visible = 'off';
            hEq4Text.Visible = 'off';
            hHoleMobMaxText.Visible = 'off';
            hHoleMobMinText.Visible = 'off';
            hHoleMobNrefText.Visible = 'off';
            hHoleMobNrefEdit.Visible = 'off';
            hHoleMobNrefText.Enable = 'off';
            hHoleMobAlphaText.Visible = 'off';
            hHoleMobAlphaEdit.Visible = 'off';
            hHoleMobAlphaEdit.Enable = 'off';
            hHoleMobStartText.Visible = 'off';
            hHoleMobEndText.Visible = 'off';
            
            % Make relevant text and edit boxes visible.
            switch hObject.String{hObject.Value} 
                case 'linear'
                    hEq3Text.Visible = 'on';
                    hHoleMobStartText.Visible = 'on';
                    hHoleMobEndText.Visible = 'on';
                case 'C-T'
                    hEq4Text.Visible = 'on';
                    hHoleMobMaxText.Visible = 'on';
                    hHoleMobMinText.Visible = 'on';
                    hHoleMobNrefText.Visible = 'on';
                    hHoleMobNrefEdit.Visible = 'on';
                    hHoleMobNrefText.Enable = 'on';
                    hHoleMobAlphaText.Visible = 'on';
                    hHoleMobAlphaEdit.Visible = 'on';
                    hHoleMobAlphaEdit.Enable = 'on';
                otherwise
                    % do nothing
            end
            
            % edit ip struct
            num = 1; % num should be the position of the layer that was edited
            UpdateIP(hObject, devObj, editedIP.full_name, num);
            
        end        
        
        function plotMobility
            elecModel = hElecMobModelDropdown.String{hElecMobModelDropdown.Value};
            holeModel = hHoleMobModelDropdown.String{hHoleMobModelDropdown.Value};
            
            switch elecModel
                case 'linear'
                    startVal = str2double(hElecMobMaxEdit.String);
                    endVal = str2double(hElecMobMinEdit.String);
                    NElec = logspace(1, 21, 21);
                    muElec = linspace(startVal,endVal,21);
                case 'C-T'
                    % Do something else
                otherwise
                    % Do nothing
            end
            
            switch holeModel
                case 'linear'
                    startVal = str2double(hHoleMobMaxEdit.String);
                    endVal = str2double(hHoleMobMinEdit.String);
                    NHole = logspace(1, 21, 21);
                    muHole = linspace(startVal,endVal,21);
                case 'C-T'
                    % Do something else
                otherwise
                    % Do nothing
            end
            
            muPlot = semilogx(hPlotAxis, NElec, muElec, 'r', NHole, muHole, 'b');
            legend(muPlot, 'Electron Mobility', 'Hole Mobility');
            hPlotAxis.XLabel.String = 'Concentration N';
            hPlotAxis.YLabel.Interpreter ='tex';
            hPlotAxis.YLabel.String = '\mu';
            hPlotAxis.Title.String = 'Mobility';
            hPlotAxis.Title.FontSize = 16;
            hPlotAxis.XGrid = 'on';
            
        end
        % Build Trap Parameters Tab Functions -----------------------------
              
        function ShowSelectedRecombFields(hObject, eventData)
            % Hide all Recomb Fields
            hRecombCoeffText.Visible = 'off';
            hRecombCoeffEdit.Visible = 'off';
            hHoleRecombCoeffText.Visible = 'off';
            hHoleRecombCoeffEdit.Visible = 'off';
            hElecRecombCoeffText.Visible = 'off';
            hElecRecombCoeffEdit.Visible = 'off';
            
            selection = hObject.String{hObject.Value};
            % Switch Case to show correct fields
            switch selection
                case 'Radiative'
                    hRecombCoeffText.Visible = 'on';
                    hRecombCoeffEdit.Visible = 'on';
                case 'Auger'
                    hHoleRecombCoeffText.Visible = 'on';
                    hHoleRecombCoeffEdit.Visible = 'on';
                    hElecRecombCoeffText.Visible = 'on';
                    hElecRecombCoeffEdit.Visible = 'on';
                case 'SHR'
                case 'SLT'
                otherwise
                    % Do nothing
            end
        end
    end
    
    function editTable(~, callBackData)
       %  contained in callBackData is: 
       %  Indices which is a 1x2 array containing the row and column 
       %  indices of the cell the user edited.
       %  PreviousData which is the data in the cell before it was edited
       %  EditData which it the user entered value
       %  NewData which is the value that MATLAB wrote to the Data property
       %  array. Usually the same as EditData.
       %  Error which contains the error message
       %  Source which is the table object executing the callback
       %  EventName which is allways 'CellEdit'
       
       switch callBackData.Indices(2)
           case 2 % Layer Name was edited
               row = callBackData.Indices(1);
               if MyTabArray{1, row+1}.Title == callBackData.PreviousData
                   MyTabArray{1, row+1}.Title = callBackData.NewData;
               end
           case 3 % Semiconductor model type was edited
               row = callBackData.Indices(1);
               switch callBackData.EditData
                   case 'Simple'
                   case 'Custom'
                   case 'Silicon'
                       
                       if MyTabArray{1, row+1}.Title == hLayerTable.Data{row, 2}
                           currentTab = MyTabArray{3, row+1};
                           % Set values in ip to silicon
                           
                           % Show new values on layer tab
                           
                           % Set all edit boxes' enable to 'off'
                           
                       end
                       
                   case 'GaAs'
                   case 'Germanium'
                   otherwise
               end
               
           case 4 % Layer thickness was edited
               % Reset Device Statistics
               SetDevThickStat();
           case 5 % Thickness units was edited
               % Reset Device Statistics
               SetDevThickStat();
           case 6 % Move Up is not editable
               
           case 7 % Move Down was selected
           otherwise
               % No funciton yet; Do Nothing
       end
       
    end

    function moveRows(~,callbackData)
       if callbackData.Indices(2) == 6
           if callbackData.Indices(1) ~= 1
               row = callbackData.Indices(1);
               oneUp = row - 1;

               % Swap table enteries
               swapEntry1 = hLayerTable.Data(oneUp, :);
               swapEntry2 = hLayerTable.Data(row, :);
               hLayerTable.Data(:) = [hLayerTable.Data(1:oneUp-1,:); ...
                   swapEntry2; swapEntry1; hLayerTable.Data(row+1:end,:)];
                           
               % Swap children for tab visual
               swapChild1 = hTopTabs.Children(oneUp+1);
               swapChild2 = hTopTabs.Children(row+1);
               hTopTabs.Children(:) = [hTopTabs.Children(1:oneUp); ...
                   swapChild2; swapChild1; hTopTabs.Children(row+2:end)];

               % Sway tabs in MyTabArray
               swapHold1 = MyTabArray(:,oneUp+1);
               swapHold2 = MyTabArray(:,row+1);
               MyTabArray(:) = [MyTabArray(:,1:oneUp) swapHold2 ...
                   swapHold1 MyTabArray(:,row+2:end)];
               
           end
       elseif callbackData.Indices(2) == 7
           if callbackData.Indices(1) ~= size(hLayerTable.Data, 1)
               row = callbackData.Indices(1);
               oneDown = row + 1;

               % Swap table enteries
               swapEntry1 = hLayerTable.Data(oneDown, :);
               swapEntry2 = hLayerTable.Data(row, :);
               hLayerTable.Data(:) = [hLayerTable.Data(1:row-1,:); ...
                   swapEntry1; swapEntry2; hLayerTable.Data(oneDown+1:end,:)];
                           
               % Swap children for tab visual
               swapChild1 = hTopTabs.Children(oneDown+1);
               swapChild2 = hTopTabs.Children(row+1);
               hTopTabs.Children(:) = [hTopTabs.Children(1:row); ...
                   swapChild1; swapChild2; hTopTabs.Children(oneDown+2:end)];

               % Sway tabs in MyTabArray
               swapHold1 = MyTabArray(:,oneDown+1);
               swapHold2 = MyTabArray(:,row+1);
               MyTabArray(:) = [MyTabArray(:,1:row) swapHold1 ...
                   swapHold2 MyTabArray(:,oneDown+2:end)];
           end
       end
    end

    function addLayerTop(~, ~)
        % Create subtabs
        num = size(MyTabArray, 2) + 1;
        title = ['Layer ' num2str(num - 1)];
        
        % Prevent default names that already exist
        check = 1;
        while check == 1
            for i = 1:size(hLayerTable.Data, 1)
                if strcmp(title, hLayerTable.Data{i, 2})
                    num = num + 1;
                    title = ['Layer ' num2str(num - 1)];
                    break;
                end
                
                if i == size(hLayerTable.Data, 1)
                    check = 0;
                end 
            end
        end
        
        MyTabArray{1, num} = uitab(hTopTabs, 'Title', title);
        createSubTabs(num);
        
        % Put MyTabArray in correct order
        swapHold = MyTabArray(:,num);
        MyTabArray(:) = [MyTabArray(:,1) swapHold MyTabArray(:,2:end-1)];
        
        % Put Children in correct order to daisplay tabs in correct order
        tab = hTopTabs.Children(end);
        hTopTabs.Children(:) = [hTopTabs.Children(1); tab; ...
            hTopTabs.Children(2:end-1)];
        
        % Add new tab data into table in correct order
        newData = {false, title, 'Choose', '-999', 'Choose', 'Move Up', ...
                'Move Down'};
        hLayerTable.Data = [newData; hLayerTable.Data];
        
        % Change statistic visual
        hNumLayersText.String =  ['Number of Layers:  ' getNumLayers()];
        
    end

    function addLayerBottom(~, ~)
        num = size(MyTabArray, 2) + 1;
        title = ['Layer ' num2str(num - 1)];
        
        % Prevent default names that already exist
        check = 1;
        while check == 1
            for i = 1:size(hLayerTable.Data, 1)
                if strcmp(title, hLayerTable.Data{i, 2})
                    num = num + 1;
                    title = ['Layer ' num2str(num - 1)];
                    break;
                end
                
                if i == size(hLayerTable.Data, 1)
                    check = 0;
                end 
            end
        end
        
        MyTabArray{1, num} = uitab(hTopTabs, 'Title', title);
        createSubTabs(num);
        newData = {false, title, 'Choose', '-999', 'Choose', 'Move Up', ...
                'Move Down'};
        hLayerTable.Data = [hLayerTable.Data; newData];
        
        % Change visual
        hNumLayersText.String =  ['Number of Layers:  ' getNumLayers()];
    end

    function deleteLayer(~, ~)
        % Find selected entries titles then delete from table
        selected = {};
        count = 0;
        for i = 1:size(hLayerTable.Data, 1)
            if hLayerTable.Data{i, 1} == true
                selected = [selected; hLayerTable.Data{i, 2}];
                count = count + 1;
            end
        end
        
        while count ~= 0
            for i = 1:size(hLayerTable.Data, 1)
                if hLayerTable.Data{i, 1} == true
                    hLayerTable.Data(i, :) = [];
                    count = count - 1;
                    break;
                end
            end
        end
        
        % Reset Device Statistics
        hNumLayersText.String = ['Number of Layers:  ' getNumLayers()];
        SetDevThickStat();
              
        % delete entries from myTab Array
        for k = 1:size(selected, 1)
            for j = 2:size(MyTabArray, 2)
                currentTab = MyTabArray{1, j};
                if strcmp(selected{k}, currentTab.Title)
                    currentTab.Parent = [];
                    MyTabArray(:,j) = [];
                    break;
                end
            end
        end

    end

    function strnum = getNumLayers
        num = size(hLayerTable.Data, 1);
        strnum = sprintf('%d', num);
    end

    
end