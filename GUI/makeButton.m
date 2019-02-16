function buttonHandle = makeButton(parent, name, position, fontSize, funcNameHandle) 
% To make code more readable use this funciton when setting up buttons
% parent is the tab or figure that the object is located on
% name is the text that will appear on the button in ''
% position is a 1x4 array [x y w h] where x is the distance from
% the left side of the figure, y is the distance from the bottom of
% the figure, w is the width of the textbox, and h is the height of
% the object.
% fontSize is the size of the text
% funcNameHandle is the name of the callback function to be associated with
% clicking the button and must be preceded by an @ sign.

buttonHandle = uicontrol(parent, ...
    'Style', 'pushbutton', ...
    'String', name, ...
    'Position', position, ...
    'Units', 'normalized', ...
    'FontSize', fontSize, ...
    'Callback', funcNameHandle);
end