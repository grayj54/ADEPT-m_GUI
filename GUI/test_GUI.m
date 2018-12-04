function test_GUI
    htest = figure('Visible', 'off', ...
    'Position', [775, 50, 750, 775], ...
    'Name', 'testing tab theory', ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'Units', 'normalized', ...
    'ToolBar', 'none');


hTopTabs = uitabgroup(htest);
MyTabArray = [];
MyTabArray(1, 1) = uitab(hTopTabs, 'Title', 'Home');
MyTabArray(1, 2) = uitab(hTopTabs, 'Title', 'Layer 1');
createSubTabs(2);

hAddLayer = uicontrol(MyTabArray(1, 1), ...
    'Style', 'pushbutton', ...
    'String', 'Add Layer', ...
    'Position', [200, 200, 150, 40], ...
    'Callback', @addLayer, ...
    'Units', 'normalized', ...
    'FontSize', 16);

    function createSubTabs(index)
        MyTabArray(2, index) = uitabgroup(MyTabArray(1, index)); 

        MyTabArray(3, index) = uitab(MyTabArray(2, index), 'Title', 'SubTab1');
        MyTabArray(4, index) = uitab(MyTabArray(2, index), 'Title', 'SubTab2');
        MyTabArray(5, index) = uitab(MyTabArray(2, index), 'Title', 'SubTab3');
        % Look into uitab "userdata" property
        % Look into uitab "deleteFcn" property
    end

htest.Visible = 'on';

    function addLayer(~, ~)
        num = size(MyTabArray, 2) + 1;
        title = ['Layer ' num2str(num - 1)];
        MyTabArray(1, num) = uitab(hTopTabs, 'Title', title);
        createSubTabs(num);
    end
end