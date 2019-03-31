function editBoxHandle = makeEditBox(parent, text_Obj, position, fontSize, ...
    funcNameHandle, mode) 
% To make code more readable use this funciton when setting up buttons
% parent is the tab or figure that the object is located on
% text_Obj is either the ip struct that contains the default and/or set fields 
% which determines the text that will appear in the edit box OR the exact 
% text that will be displayed in the edit box.
% position is a 1x4 array [x y w h] where x is the distance from
% the left side of the figure, y is the distance from the bottom of
% the figure, w is the width of the textbox, and h is the height of
% the object.
% fontSize is the size of the text
% funcNameHandle is the name of the callback function to be associated with
% editing the contents and must be preceded by an @ sign.
% mode is 'str' if var is the exact text to be displayed OR 'num' if var is
% a struct containing a specific struct within the ip struct.

editBoxHandle = uicontrol(parent, ...
    'Style', 'edit', ...
    'String', getContent(text_Obj, mode), ...
    'Position', position, ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', fontSize, ...
    'Callback', funcNameHandle);

    function str = getContent(thing, mode)
        switch mode
            case 'str'
                str = thing;
            case 'num'
                str = getNum(thing);
            otherwise
                str = '';
        end
    end
        
    function str = getNum(obj)
        if ~isfield(obj, 'set')
            obj.set = obj.default(1);
        end
        
        str = num2str(obj.set);
        
    end
end