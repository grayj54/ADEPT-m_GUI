function list = getBuiltDevices
    % Iterates through device folder and makes a list of device
    % names.
    
    listing = dir('**/*.GUI');
    %if size(listing, 1) == 0
        %list = {'No Devices Built'};
    %else
        list = cell([size(listing, 1), 1]);
        for i = 1:size(listing, 1)
            file = strsplit(listing(i).name, '.');
            title = file{1};
            list{i} = title;;
        end
    %end
end