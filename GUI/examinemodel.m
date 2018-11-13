function varargout = examinemodel(varargin)
% EXAMINEMODEL MATLAB code for examinemodel.fig
%      EXAMINEMODEL, by itself, creates a new EXAMINEMODEL or raises the existing
%      singleton*.
%
%      H = EXAMINEMODEL returns the handle to a new EXAMINEMODEL or the handle to
%      the existing singleton*.
%
%      EXAMINEMODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXAMINEMODEL.M with the given input arguments.
%
%      EXAMINEMODEL('Property','Value',...) creates a new EXAMINEMODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before examinemodel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to examinemodel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help examinemodel

% Last Modified by GUIDE v2.5 16-Oct-2018 11:24:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @examinemodel_OpeningFcn, ...
                   'gui_OutputFcn',  @examinemodel_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before examinemodel is made visible.
function examinemodel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to examinemodel (see VARARGIN)

% Choose default command line output for examinemodel
handles.output = hObject;
handles.plotchoice = 'none';
handles.unit = 'um';
handles.flag1 = 1;
handles.flag2 = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes examinemodel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = examinemodel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in devices.
function devices_Callback(hObject, eventdata, handles)
% hObject    handle to devices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns devices contents as cell array
%        contents{get(hObject,'Value')} returns selected item from devices


% --- Executes during object creation, after setting all properties.
function devices_CreateFcn(hObject, eventdata, handles)
% hObject    handle to devices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in range.
function range_Callback(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ranges();


% --- Executes on selection change in plotchoice.
function plotchoice_Callback(hObject, eventdata, handles)
% hObject    handle to plotchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');
command = char(str(val));
switch command
    case 'Plot Choice'
        handles.plotchoice = 'none';
        handles.flag2 = 0;
    case 'eband'
        handles.plotchoice = 'eband';
        handles.flag2 = 1;
    case 'carrier'
        handles.plotchoice = 'carrier';
        handles.flag2 = 1;
end
guidata(hObject, handles);


% Hints: contents = cellstr(get(hObject,'String')) returns plotchoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotchoice


% --- Executes during object creation, after setting all properties.
function plotchoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotchoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unit.
function unit_Callback(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject, 'Value');
command1 = char(str(val));
switch command1
    case 'Units'
        handles.unit = 'none';
        handles.flag1 = 1;
    case 'cm'
        handles.unit = 'cm';
        handles.flag1 = 1;
    case 'um'
        handles.unit = 'um';
        handles.flag1 = 1;
    case 'nm'
        handles.unit = 'nm';
        handles.flag1 = 1;
    case 'A'
        handles.unit = 'A';
        handles.flag1 = 1;
end
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns unit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit


% --- Executes during object creation, after setting all properties.
function unit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlow = getappdata(0,'xlow');
xhigh = getappdata(0,'xhigh');
if(handles.flag1 && handles.flag2)
    global x0;
    A_examine(x0,handles.plotchoice,'range',[xlow, xhigh]);
end
