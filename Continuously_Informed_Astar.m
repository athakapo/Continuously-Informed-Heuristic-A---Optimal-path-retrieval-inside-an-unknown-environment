function varargout = Continuously_Informed_Astar(varargin)
% CONTINUOUSLY_INFORMED_ASTAR MATLAB code for Continuously_Informed_Astar.fig
%      CONTINUOUSLY_INFORMED_ASTAR, by itself, creates a new CONTINUOUSLY_INFORMED_ASTAR or raises the existing
%      singleton*.
%
%      H = CONTINUOUSLY_INFORMED_ASTAR returns the handle to a new CONTINUOUSLY_INFORMED_ASTAR or the handle to
%      the existing singleton*.
%
%      CONTINUOUSLY_INFORMED_ASTAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTINUOUSLY_INFORMED_ASTAR.M with the given input arguments.
%
%      CONTINUOUSLY_INFORMED_ASTAR('Property','Value',...) creates a new CONTINUOUSLY_INFORMED_ASTAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Continuously_Informed_Astar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Continuously_Informed_Astar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Continuously_Informed_Astar

% Last Modified by GUIDE v2.5 01-Sep-2017 00:02:17

% Begin initialization code - DO NOT EDIT
addpath('matlabFunctions')
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Continuously_Informed_Astar_OpeningFcn, ...
                   'gui_OutputFcn',  @Continuously_Informed_Astar_OutputFcn, ...
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


% --- Executes just before Continuously_Informed_Astar is made visible.
function Continuously_Informed_Astar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Continuously_Informed_Astar (see VARARGIN)

% Choose default command line output for Continuously_Informed_Astar
handles.weightDefaultValue = 1.2;
handles.output = hObject;
%handles.ValidExperimntSetUp = 0;
handles.times=0;
handles.stop_now = 0;
set(handles.save_button,'Enable','off')
set(handles.abort_button,'Enable','off')
set(handles.start_button,'Enable','off')
set(handles.submit_button,'Enable','on')
set(handles.weight,'Enable','off')
set(handles.weight,'String',handles.weightDefaultValue)
s = sprintf('Button tooltip line 1\nButton tooltip line 2');
set(handles.text19,'TooltipString', ['<100 and >2'])
set(handles.text20,'TooltipString', ['<70% of the total cells'])
set(handles.submit_button,'TooltipString', ['Also, renew the obstacles'' locations'])
%set(gcf,'pos',[10 10 200 50])

 %set(handles.methodgroup,'SelectionChangeFcn',@methodgroup_SelectionChangeFcn);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Continuously_Informed_Astar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Continuously_Informed_Astar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\
weight=handles.weightDefaultValue;
if (handles.times==1)
    cla(handles.axes1,'reset');
    disable(hObject, eventdata, handles);
    handles=InitializeMainAxes(handles,handles.SIMULparam.gridT,...
    handles.SIMULparam.goalCells,handles.SIMULparam.robotInitPos,...
    handles.SIMULparam.rows,handles.SIMULparam.cols,handles.SIMULparam.sizeCell,...
    handles.SIMULparam.pauseTime);
end
u = get(get(handles.methodgroup,'SelectedObject'),'Tag');
switch u
case 'CIA_button'
    alg=9;
case 'A_button'
   alg=1;
case 'weigted_button'
   weight=str2num(get(handles.weight,'String'));
   alg=8;
otherwise
     alg=0;
end
disable(hObject, eventdata, handles);
set(handles.abort_button,'Enable','on')
algorithm_call(alg,weight,hObject,handles)
set(handles.abort_button,'Enable','off')
enable(hObject, eventdata, handles);
handles.times=1;
guidata(hObject, handles);

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gridT=handles.SIMULparam.gridT;
ob=size(handles.SIMULparam.obstacles,1);
goalCells=handles.SIMULparam.goalCells;
robotInitPos=handles.SIMULparam.robotInitPos;
sizeCell=handles.SIMULparam.sizeCell;
rows=handles.SIMULparam.rows;
cols=handles.SIMULparam.cols;
obstacles=handles.SIMULparam.obstacles;
uisave({'gridT','goalCells','robotInitPos','sizeCell','rows','cols','ob',...
    'obstacles'},strcat('Experiment_',num2str(cols),'x',num2str(rows),'_',num2str(ob),'_obstacles'))
guidata(hObject, handles);



function weight_Callback(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of weight as text
%        str2double(get(hObject,'String')) returns contents of weight as a double
weight=str2num(get(handles.weight,'String'));

if isempty(weight) 
    set(handles.weight,'ForegroundColor','red')
    set(handles.start_button,'Enable','off') 
else
    set(handles.weight,'ForegroundColor','black')
    if strcmp(get(handles.submit_button, 'Enable'),'on') && strcmp(get(handles.save_button, 'Enable'),'on')
        set(handles.start_button,'Enable','on') 
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.x_goal,'ForegroundColor','black')
set(handles.y_goal,'ForegroundColor','black')
set(handles.x_start,'ForegroundColor','black')
set(handles.y_start,'ForegroundColor','black')
set(handles.rows_size,'ForegroundColor','black')
set(handles.columns_size,'ForegroundColor','black')
set(handles.num_ob,'ForegroundColor','black')
cla(handles.axes1,'reset'); 
handles.times=0;
[filename pathname]=uigetfile({'*.mat','File Selector'});
fullpathname = strcat(pathname,filename);
handles.file_name=fullpathname;
load(fullpathname)
set(handles.rows_size,'String',num2str(cols))
set(handles.columns_size,'String',num2str(rows))
set(handles.x_start,'String',num2str(robotInitPos(2)))
set(handles.y_start,'String',num2str(robotInitPos(1)))
set(handles.x_goal,'String',num2str(goalCells(2)))
set(handles.y_goal,'String',num2str(goalCells(1)))
set(handles.num_ob,'String',strcat(num2str(ob)))
if ValidEnviromentalParameters(hObject, eventdata, handles) 
    disable(hObject, eventdata, handles);
    handles = main(0,0,0,0,0,0,0,fullpathname,handles);
    enable(hObject, eventdata, handles);
    set(handles.save_button,'Enable','off')
end
guidata(hObject, handles);


function rows_size_Callback(hObject, eventdata, handles)
% hObject    handle to rows_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rows_size as text
%        str2double(get(hObject,'String')) returns contents of rows_size as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rows_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rows_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function num_ob_Callback(hObject, eventdata, handles)
% hObject    handle to num_ob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_ob as text
%        str2double(get(hObject,'String')) returns contents of num_ob as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function num_ob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_ob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to robot_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_start as text
%        str2double(get(hObject,'String')) returns contents of robot_start as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to robot_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of robot_goal as text
%        str2double(get(hObject,'String')) returns contents of robot_goal as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to robot_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to rows_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rows_size as text
%        str2double(get(hObject,'String')) returns contents of rows_size as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rows_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to num_ob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_ob as text
%        str2double(get(hObject,'String')) returns contents of num_ob as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_ob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in submit_butto
function submit_button_Callback(hObject, eventdata,handles)
% hObject    handle to submit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
cla(handles.axes1,'reset'); 
handles.times=0;
full_map='';
x_size=str2num(get(handles.rows_size,'String'));
y_size = str2num(get(handles.columns_size,'String'));

x_s = str2num(get(handles.x_start,'String'));
y_s = str2num(get(handles.y_start,'String'));

x_g = str2num(get(handles.x_goal,'String'));
y_g = str2num(get(handles.y_goal,'String'));

num_obstacles=str2num(get(handles.num_ob,'String'));
disable(hObject, eventdata, handles);
handles = main(x_size,y_size,x_s,y_s,x_g,y_g,num_obstacles,full_map,handles);
enable(hObject, eventdata, handles);
%handles.ValidExperimntSetUp = 1;
%set(handles.save_button,'Enable','on')
guidata(hObject, handles);


function enable(hObject, eventdata, handles)
set(handles.load_button,'Enable','on')
set(handles.submit_button,'Enable','on')
set(handles.save_button,'Enable','on')
set(handles.start_button,'Enable','on')
set(handles.rows_size,'Enable','on')
set(handles.columns_size,'Enable','on')
set(handles.x_start,'Enable','on')
set(handles.y_start,'Enable','on')
set(handles.x_goal,'Enable','on')
set(handles.y_goal,'Enable','on')
set(handles.num_ob,'Enable','on')
set(handles.CIA_button,'Enable','on')
set(handles.A_button,'Enable','on')
set(handles.weigted_button,'Enable','on')
%set(handles.weight,'Enable','on')


function disable(hObject, eventdata, handles)
set(handles.load_button,'Enable','off')
set(handles.submit_button,'Enable','off')
set(handles.save_button,'Enable','off')
set(handles.start_button,'Enable','off')
set(handles.rows_size,'Enable','off')
set(handles.columns_size,'Enable','off')
set(handles.x_start,'Enable','off')
set(handles.y_start,'Enable','off')
set(handles.x_goal,'Enable','off')
set(handles.y_goal,'Enable','off')
set(handles.num_ob,'Enable','off')
set(handles.CIA_button,'Enable','off')
set(handles.A_button,'Enable','off')
set(handles.weigted_button,'Enable','off')
%set(handles.weight,'Enable','off')


% --- Executes on button press in abort_button.
function abort_button_Callback(hObject, eventdata, handles)
% hObject    handle to abort_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stop_now = 1;
guidata(hObject, handles); % Update handles structure


function columns_size_Callback(hObject, eventdata, handles)
% hObject    handle to columns_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of columns_size as text
%        str2double(get(hObject,'String')) returns contents of columns_size as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles); % Update handles structure

% --- Executes during object creation, after setting all properties.
function columns_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to columns_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_start_Callback(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_start as text
%        str2double(get(hObject,'String')) returns contents of x_start as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles); % Update handles structure

% --- Executes during object creation, after setting all properties.
function x_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_start_Callback(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_start as text
%        str2double(get(hObject,'String')) returns contents of y_start as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function y_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function x_goal_Callback(hObject, eventdata, handles)
% hObject    handle to x_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_goal as text
%        str2double(get(hObject,'String')) returns contents of x_goal as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function x_goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y_goal_Callback(hObject, eventdata, handles)
% hObject    handle to y_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_goal as text
%        str2double(get(hObject,'String')) returns contents of y_goal as a double
ValidEnviromentalParameters(hObject, eventdata, handles);
guidata(hObject, handles); % Update handles structure

% --- Executes during object creation, after setting all properties.
function y_goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y=ValidEnviromentalParameters(hObject, eventdata, handles)
y=0;
%handles.ValidExperimntSetUp = 0;
set(handles.save_button,'Enable','off')

maxNumOfCells = 100;
minNumOfCells = 2;
maxPerObs = 0.7;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

l_xGoal = str2num(get(handles.x_goal,'String'));
l_yGoal = str2num(get(handles.y_goal,'String'));
l_xStart = str2num(get(handles.x_start,'String'));
l_yStart = str2num(get(handles.y_start,'String'));
l_rowsSize = str2num(get(handles.rows_size,'String'));
l_colsSize = str2num(get(handles.columns_size,'String'));
l_numOb = str2num(get(handles.num_ob,'String'));

set(handles.x_goal,'ForegroundColor','black')
set(handles.y_goal,'ForegroundColor','black')
set(handles.x_start,'ForegroundColor','black')
set(handles.y_start,'ForegroundColor','black')
set(handles.rows_size,'ForegroundColor','black')
set(handles.columns_size,'ForegroundColor','black')
set(handles.num_ob,'ForegroundColor','black')



if isempty(l_rowsSize) || l_rowsSize>maxNumOfCells || l_rowsSize<minNumOfCells
    set(handles.rows_size,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif isempty(l_colsSize) || l_colsSize>maxNumOfCells || l_colsSize<minNumOfCells
    set(handles.columns_size,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif isempty(l_xGoal) || l_xGoal<1
    set(handles.x_goal,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif isempty(l_yGoal) || l_yGoal<1
    set(handles.y_goal,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif isempty(l_xStart) || l_xStart<1
    set(handles.x_start,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif isempty(l_yStart) || l_yStart<1
    set(handles.y_start,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif l_xGoal>l_rowsSize
    set(handles.rows_size,'ForegroundColor','red')
    set(handles.x_goal,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif l_yGoal>l_colsSize
    set(handles.columns_size,'ForegroundColor','red')
    set(handles.y_goal,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif l_xStart>l_rowsSize
    set(handles.rows_size,'ForegroundColor','red')
    set(handles.x_start,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')
elseif l_yStart>l_colsSize
    set(handles.columns_size,'ForegroundColor','red')
    set(handles.y_start,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')   
elseif isempty(l_numOb) || l_numOb>(l_rowsSize*l_colsSize)*maxPerObs || l_numOb<0
    set(handles.num_ob,'ForegroundColor','red')
    set(handles.submit_button,'Enable','off')
    set(handles.start_button,'Enable','off')   
else
    set(handles.submit_button,'Enable','on')
    %set(handles.start_button,'Enable','on')
    y=1;
end
guidata(hObject, handles); % Update handles structure

function methodgroup_CreateFcn(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes when selected object is changed in methodgroup.
function methodgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in methodgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(get(handles.methodgroup,'SelectedObject'),'Tag'),'weigted_button')
    set(handles.weight,'Enable','on')
else
    set(handles.weight,'Enable','off')
    set(handles.weight,'String',handles.weightDefaultValue)
    weight_Callback(hObject, eventdata, handles)
end
guidata(hObject, handles); % Update handles structure  


% --- Executes during object deletion, before destroying properties.
function CIA_button_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to CIA_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
