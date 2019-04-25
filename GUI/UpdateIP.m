function UpdateIP(hObject, dev, param_edited, varargin)
% hObject is the handle of the object edited
% eventData is various statistics of the callback
% dev is the inputs struct that is being edited
% param_edited is the parameter of the inputs struct that is being edited
% varargin is for handles needed to perform tasks

default = defaultDevObj();

switch param_edited
    case 'Device Title'
        % Sets desc to new user entered string
        dev.title = hObject.String;
        
    case default.device(1).ip(1).full_name % Operating Temperature
        % Sets device operating temperature to user entered value
        num = str2double(varargin{1}.String);
        if ~isnan(num)
            dev.device(1).ip(1).set = num;
            
            if (varargin{2}.Value == 2)
                dev.device(1).ip(1).name = 'T_C';
            elseif (varargin{2}.Value == 1)
                dev.device(1).ip(1).name = 'T_K';
            end
                
        else
            errordlg('Temperature must be a number!','Invalid Entry')
            varargin{1}.String = '';
        end
        
    case default.device(1).ip(2).full_name % Device Type
        % Sets type of device to selected
        typeVal = hObject.Value;
        typeStr = hObject.String;
        dev.device(1).ip(2).set = typeStr{typeVal};
        
    case default.device(1).ip(3).full_name 
        % 'Number of light ray passes considered under illumination'
        
    case default.layers(1).ip(1).full_name % 'Layer thickness'
        
    case default.layers(1).ip(3).full_name % 'Electron affinity'
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(3).set(varargin{2}) = val;
        
    case default.layers(1).ip(4).full_name % 'Semiconductor bandgap'
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(4).set(varargin{2}) = val;
        
    case default.layers(1).ip(5).full_name % 'Dielectric constant'
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(5).set(varargin{2}) = val;
        
    case default.layers(1).ip(6).full_name 
        % Conduction band effective density-of-states
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(6).set(varargin{2}) = val;
        
    case default.layers(1).ip(7).full_name 
        % Valence band effective density of states (#/cm^3)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(7).set(varargin{2}) = val;
        
    case default.layers(1).ip(10).full_name 
        % electron thermal velocity (cm/s) 
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(10).set(varargin{2}) = val;
        
    case default.layers(1).ip(11).full_name % hole thermal velocity (cm/s)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(11).set(varargin{2}) = val;
        
    case default.layers(1).ip(14).full_name % Electron mobility
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(14).set(varargin{2}) = val;
        
    case default.layers(1).ip(15).full_name % Hole mobility
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(15).set(varargin{2}) = val;
        
    case default.layers(1).ip(117).full_name % Mobility model for electrons
        dev.layers(varargin{1}).ip(117).set = hObject.String{hObject.Value};
        
    case default.layers(1).ip(118).full_name
        % un(max) for C-T model (2)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(118).set = [val, val];
        
    case default.layers(1).ip(119).full_name
        % un(min) for C-T model (2)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(119).set = [val, val];
        
    case default.layers(1).ip(120).full_name
        % Reference dopant concentration for C-T model (2)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(120).set = [val, val];
        
    case default.layers(1).ip(121).full_name
        % Exponent for C-T model
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(121).set = val;
        
    case default.layers(1).ip(122).full_name % Mobility model for holes
        dev.layers(varargin{1}).ip(122).set = hObject.String{hObject.Value};
        
    case default.layers(1).ip(123).full_name
        % up(max) for C-T model (2)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(123).set = [val, val];
        
    case default.layers(1).ip(124).full_name
        % up(min) for C-T model (2)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(124).set = [val, val];
        
    case default.layers(1).ip(125).full_name
        % Reference dopant concentration for C-T model (2)
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(125).set = [val, val];
        
    case default.layers(1).ip(126).full_name
        % Exponent for C-T model
        val = str2double(hObject.String);
        dev.layers(varargin{1}).ip(126).set = val;
        
    otherwise
        % Throw error
end

end