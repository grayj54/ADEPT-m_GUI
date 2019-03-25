function [hLayerMenu, layers] = openLayerMenu(devObj)
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
        'Data', {false, 'Layer 1', 'Choose', '-999', 'Choose', 'Move Up', ...
                'Move Down'},...
        'ColumnFormat', ({'logical', 'char', {'Simple', 'Custom', 'Silicon',...
                            'GaAs', 'Germainium'}, 'char', {'cm', 'mm', 'um',...
                            'nm', 'A'}, [], []}),...
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
        {'cm', 'mm', 'um', 'nm', 'A'}, [550, 655, 60, 20], ...
        14, @SetDevThickStat);
    
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
    
    function createSubTabs(index)
        MyTabArray{2, index} = uitabgroup(MyTabArray{1, index}); 
        MyTabArray{3, index} = uitab(MyTabArray{2, index}, 'Title', 'Basic Parameters');
        MyTabArray{4, index} = uitab(MyTabArray{2, index}, 'Title', 'Trap Parameters');
        % Look into uitab "userdata" property
        % Look into uitab "deleteFcn" property
        
        % Build Basic Parameters Tab Visuals ------------------------------
        hOpenOptParamMenu = makeButton(MyTabArray{3, index}, ...
            'Edit Optical Parameters', [50, 40, 300, 40], ...
            16, @openOptParamMenu);
        
        hDevThickText = makeText(MyTabArray{1, 1}, ...
            '', [50, 645, 500, 25], 'left', 16);
        SetDevThickStat();
    
        hParamText = makeText(MyTabArray{3, index}, ...
            'Parameters:', [50, 700, 150, 40], 'left', 16);
        
        hEleAffinText = makeText(MyTabArray{3, index}, ...
            'Electron Affinity (eV):', [225, 720, 200, 20], 'right', 12);

        hEleAffinEdit = makeEditBox(MyTabArray{3, index}, ...
            '4.00', [450, 720, 100, 20], 12, @UpdateEleAffin);

        hBandgapText = makeText(MyTabArray{3, index}, ...
            'Bandgap (eV):', [225, 680, 200, 20], 'right', 12);

        hBandgapEdit = makeEditBox(MyTabArray{3, index}, ...
            '1.00', [450, 680, 100, 20], 12, @UpdateBandgap);

        hDieleConstText = makeText(MyTabArray{3, index}, ...
            'Dielectric Constant:', [225, 640, 200, 20], ...
            'right', 12);

        hDieleConstEdit = makeEditBox(MyTabArray{3, index}, ...
            '10.00', [450, 640, 100, 20], 12, @UpdateDieleConst);

        hConductBandText = makeText(MyTabArray{3, index}, ...
            'Conduction Band Effective Density of States (#/cm^3):', ...
            [25, 600, 400, 20], 'right', 12);

        hConductBandEdit = makeEditBox(MyTabArray{3, index}, ...
            '1.00E+19', [450, 600, 100, 20], 12, @UpdateConductBand);

        hValenceBandText = makeText(MyTabArray{3, index}, ...
            'Valence Band Effective Density of States (#/cm^3):', ...
            [25, 560, 400, 20], 'right', 12);

        hValenceBandEdit = makeEditBox(MyTabArray{3, index}, ...
            '1.00E+19', [450, 560, 100, 20], 12, @UpdateValenceBand);

        hElecThermVelocityText = makeText(MyTabArray{3, index}, ...
            'Electron Thermal Velocity (cm/s):', [25, 520, 400, 20], ...
            'right', 12);

        hElecThermVelocityEdit = makeEditBox(MyTabArray{3, index}, ...
            '1.00E+07', [450, 520, 100, 20], 12, @UpdateElecThermVelocity);

        hHoleThermVelocityText = makeText(MyTabArray{3, index}, ...
            'Hole Thermal Velocity (cm/s):', [25, 480, 400, 20], ...
            'right', 12);

        hHoleThermVelocityEdit = makeEditBox(MyTabArray{3, index}, ...
            '1.00E+07', [450, 480, 100, 20], 12, @UpdateHoleThermVelocity);
        
        hMobilityModelText = makeText(MyTabArray{3, index}, ...
            'Mobility Model:', [50, 420, 150, 40], 'left', 16);
        
        hMobilityModelDropdown = makeDropdown(MyTabArray{3, index}, ...
            {'Constant', 'Sloped Linear', 'Caughey-Thomas'}, ...
            [225, 440, 225, 20], 16, @UpdateMobilityModel);
        
        hEqAxes = axes(MyTabArray{3, index}, ...
            'Units', 'normalized',...
            'Position', [0, 0, 1, 1], ...
            'Color', 'none', 'XColor', 'none', 'YColor', 'none');
        
        % Constant Model
        Eq1 = '$\mu = y$'; % y is a constant that the user enters and is assigned to both u_min and u_max
        
        % Must use text() function since it is on axes and uicontrol()
        % doesn't support latex syntax.
        hEq1Text = text(hEqAxes, 0.07, 0.475, Eq1, ... 
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq1Text.Visible = 'on';
        
        % Sloped Liner Model
        Eq2 = '$\mu = (\frac{\mu_{end} - \mu_{start}}{Layer\ Thickness}) N + \mu_{start}$'; 
        
        hEq2Text = text(hEqAxes, 0.07, 0.475, Eq2, ...  
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq2Text.Visible = 'off';
        % Caughey-Thomas Model
        Eq3 = '$\mu = \frac{\mu_{max} - \mu_{min}}{1 + (\frac{N}{N_{ref}})^{\alpha}} + \mu_{min}$';
        
        hEq3Text = text(hEqAxes, 0.07, 0.475, Eq3, ... 
            'Interpreter', 'latex', ...
            'BackgroundColor', 'c', ...
            'FontSize', 14); 
        
        hEq3Text.Visible = 'off';
        
%         hHoleMobilityText = makeText(MyTabArray{3, index}, ...
%             'Hole Mobility (cm^2/V-s):', [225, 440, 200, 20], ...
%             'right', 12);
% 
%         hHoleMobilityEdit = makeEditBox(MyTabArray{3, index}, ...
%             '100.00', [450, 440, 100, 20], 12, @UpdateHoleMobility);
% 
%         hElecMobilityText = makeText(MyTabArray{3, index}, ...
%             'Electron Mobility (cm^2/V-s):', [200, 400, 225, 20], ...
%             'right', 12);
% 
%         hElecMobilityEdit = makeEditBox(MyTabArray{3, index}, ...
%             '100.00', [450, 400, 100, 20], 12, @UpdateElecMobility);
        
        % Build Trap Parameters Tab Visuals -------------------------------
        hFixedIonDonorDensityText = makeText(MyTabArray{4, index}, ...
            'Fixed ionized donor density (#/cm^-3):', [75, 740, 350, 20], ...
            'right', 12);

        hFixedIonDonorDensityEdit = makeEditBox(MyTabArray{4, index}, ...
            '0.00', [450, 740, 100, 20], 12, @UpdateFixedIonDonorDensity);
        
        hFixedIonAcceptorDensityText = makeText(MyTabArray{4, index}, ...
            'Fixed ionized acceptor density (#/cm^-3):', ...
            [75, 700, 350, 20], 'right', 12);

        hFixedIonAcceptorDensityEdit = makeEditBox(MyTabArray{4, index}, ...
            '0.00', [450, 700, 100, 20], 12, ...
            @UpdateFixedIonAcceptorDensity);
        
        hDonorDensityText = makeText(MyTabArray{4, index}, ...
            'Donor density (#/cm^-3):', [75, 660, 350, 20], 'right', 12);

        hDonorDensityEdit = makeEditBox(MyTabArray{4, index}, ...
            '0.00', [450, 660, 100, 20], 12, @UpdateDonorDensity);
        
        hDonorEnergyText = makeText(MyTabArray{4, index}, ...
            'Donor energy Ec-Et (eV):', [75, 620, 350, 20], ...
            'right', 12);

        hDonorEnergyEdit = makeEditBox(MyTabArray{4, index}, ...
            '-100.00', [450, 620, 100, 20], 12, @UpdateDonorEnergy);
        
        hRecombTypeText = makeText(MyTabArray{4, index}, ...
            'Recombination Type:', [75, 580, 350, 20], 'right', 12);

        hRecombTypeDropdown = makeDropdown(MyTabArray{4, index}, ...
            {'Radiative', 'Auger', 'SHR', 'SLT'}, [450, 580, 150, 20], ...
            12, @ShowSelectedRecombFields);
        
        hRecombCoeffText = makeText(MyTabArray{4, index}, ...
            'Recombination coefficient (cm^3/s):', [75, 540, 350, 20], ...
            'right', 12);

        hRecombCoeffEdit = makeEditBox(MyTabArray{4, index}, ...
            '0.00', [450, 540, 100, 20], 12, @UpdateRecombCoeff);
        
        hHoleRecombCoeffText = makeText(MyTabArray{4, index}, ...
            'Hole Recombination coefficient (cm^6/s):', ...
            [75, 540, 350, 20], 'right', 12);
        hHoleRecombCoeffText.Visible = 'off';

        hHoleRecombCoeffEdit = makeEditBox(MyTabArray{4, index}, ...
            '0.00', [450, 540, 100, 20], 12, @UpdateHoleRecombCoeff);   
        hHoleRecombCoeffEdit.Visible = 'off';
      
        hElecRecombCoeffText = makeText(MyTabArray{4, index}, ...
            'Electron Recombination coefficient (cm^6/s):', ...
            [75, 500, 350, 20], 'right', 12);
        hElecRecombCoeffText.Visible = 'off';

        hElecRecombCoeffEdit = makeEditBox(MyTabArray{4, index}, ...
            '0.00', [450, 500, 100, 20], 12, @UpdateElecRecombCoeff);
        hElecRecombCoeffEdit.Visible = 'off';
        
        
        
        % Build Basic Parameters Tab Functions ----------------------------
        function UpdateEleAffin(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateBandgap(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateDieleConst(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateConductBand(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateValenceBand(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateElecThermVelocity(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateHoleThermVelocity(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateMobilityModel(hObject, eventData)
            % Make all related text and edit boxes invisible.
            hEq1Text.Visible = 'off';
            hEq2Text.Visible = 'off';
            hEq3Text.Visible = 'off';
            
            % Make relevant text and edit boxes visible.
            switch hObject.String{hObject.Value} 
                case 'Constant'
                    hEq1Text.Visible = 'on';
                case 'Sloped Linear'
                    hEq2Text.Visible = 'on';
                case 'Caughey-Thomas'
                    hEq3Text.Visible = 'on';
                otherwise
                    % do nothing
            end
            
            % edit adept/class object
            
        end
        
%         function UpdateHoleMobility(hObject, eventData)
%             % edits adept/class object
%         end
%         
%         function UpdateElecMobility(hObject, eventData)
%             % edits adept/class object
%         end
        
        
        % Build Trap Parameters Tab Functions -----------------------------
        function UpdateFixedIonDonorDensity(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateFixedIonAcceptorDensity(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateDonorDensity(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateDonorEnergy(hObject, eventData)
            % edits adept/class object
        end
        
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
        
        function UpdateRecombCoeff(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateHoleRecombCoeff(hObject, eventData)
            % edits adept/class object
        end
        
        function UpdateElecRecombCoeff(hObject, eventData)
            % edits adept/class object
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
                           % Set values in class to silicon
                           
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
end