function dropdownHandle = makeDropdown(parent, choices, position, ...
    fontSize, funcNameHandle, obj, mode) 
% To make code more readable use this funciton when setting up dropdowns
% parent is the tab or figure that the object is located on
% choices is a cell array containing character array of the dropdown's
% chioces. e.g. {'this', 'is', 'an', 'example'}
% position is a 1x4 array [x y w h] where x is the distance from
% the left side of the figure, y is the distance from the bottom of
% the figure, w is the width of the textbox, and h is the height of
% the object.
% fontSize is the size of the text
% funcNameHandle is the name of the callback function to be associated with
% the dropdown and must be preceded by an @ sign.
% obj is the ip struct that contains the aliases, units, set, and name
% values for the desired dropdown
% mode is either 'set' or 'name'. 'name' should be chosen if the dropdown's 
% starting value is based on aliases, otherwise choose 'set'.

dropdownHandle = uicontrol(parent, ...
    'Style', 'popupmenu', ...
    'String', choices, ...
    'Position', position, ...
    'Value', getVal(obj, choices, mode), ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', fontSize, ...
    'Callback', funcNameHandle);

    function val = getVal(obj_struct, array, mode)
        switch mode
            case 'set'
                val = getChoiceVal(obj_struct, array);
            case 'name'
                val = getNameVal(obj_struct);
            otherwise
                val = 1;
        end
    end

    function val = getChoiceVal(obj, array)
        if ~isfield(obj, 'set')
            if contains(obj.default{1}, '_')
                newID = strrep(obj.default{1}, '_', ' ');
                obj.set = newID;
            else
                obj.set = obj.default{1};
            end
        else
            if isempty(obj.set)
                if contains(obj.default{1}, '_')
                    newID = strrep(obj.default{1}, '_', ' ');
                    obj.set = newID;
                else
                    obj.set = obj.default{1};
                end
            end
        end
        
        for i = 1:size(array, 2)
            if strcmp(obj.set, array{i})
                val = i;
                break;
            end
        end
    end

    function val = getNameVal(obj)
        if ~isfield(obj, 'name')
            obj.name = obj.aliases{1};
        else
            if isempty(obj.name)
                obj.name = obj.aliases{1};
            end
        end
        
        for i = 1:size(obj.aliases, 2)
            if strcmp(obj.name, obj.aliases{i})
                val = i;
                break;
            end
        end
    end
end