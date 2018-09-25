   function SampleGUI()
    x=linspace(-2,2,100);
    power=1;
    y=x.^power;
    ctrl_fh = figure; % controls figure handle
    plot_fh = figure; % plot figure handle
    plot(x,y); 
    %startup;
    % uicontrol handles:
    hPwr = uicontrol('Style','edit','Parent',... 
                         ctrl_fh,...
                         'Position',[200 100 100 20],...
                         'String',num2str(power),...
                         'CallBack',@pwrHandler);

    hButton = uicontrol('Style','pushbutton','BackgroundColor','yellow','Parent',ctrl_fh,...  
                        'Position',[200 200 100 20],...
                        'String','Reset','Callback',@reset); 

    function reset(source,event,handles,varargin) % boilerplate argument string
        fprintf('resetting...\n');
        power=1;
        set(hPwr,'String',num2str(power));
        y=x.^power;
        compute_and_draw_plot();
    end
%%%%% BUILD THE DEVICE %%%%%%%%%%%%%%%%%%%
build_button = uicontrol('Style','pushbutton','BackgroundColor','yellow','Parent',ctrl_fh,...  
                        'Position',[100 300 100 20],...
                        'String','Build','Callback',@builder); 



    function builder(source,event,handles,varargin)
      fprintf('building...\n');
      x0=A_build('si_example.1d') 
    end   
%%%%%%%%%%%%%%%%% HELP  %%%%%%%%%%%%

examine_button = uicontrol('Style','pushbutton','BackgroundColor','yellow','Parent',ctrl_fh,...  
                        'Position',[300 300 100 20],...
                        'String','Examine','Callback',@examining); 


function help_adept(source,event,handles,varargin)

      fprintf('helping...\n');
      x0=A_build('si_example.1d') 
      help A_examine
      A_examine
%       A_examine(x0,'eband')
%       A_examine(x0,'eband','range',[0,2])
%       A_examine(x0,'carrier','range',[0,2])

end   

%%%%%%%%%%%%%%%%% EXAMINING  %%%%%%%%%%%%

function examining (source,event,handles,varargin)
    x0=A_build('si_example.1d') 
examining_choices = uicontrol(ctrl_fh,'Style','popupmenu');
examining_choices.Position = [300 250 100 20];
examining_choices.String = {'Carrier Density','Energy Band'};
examining_choices.Callback = @selection;

    function selection(src,event)
        
        val = A_examine(x0,'eband');
        str = A_examine(x0,'carrier','range',[0,2]);
           
        str{val};
        disp(['Selection: ' str{val}]);
    end

end
%%%%%%%%%%%%%%%%%%%%%
    function pwrHandler(source,event,handles,varargin) 
        power=str2num(get(hPwr,'string'));
        fprintf('Setting power to %s\n',get(hPwr,'string'));
        compute_and_draw_plot();
    end

    function compute_and_draw_plot()
        y=x.^power;
        figure(plot_fh); plot(x,y);
    end
end