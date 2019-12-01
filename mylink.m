function varargout = mylink(varargin)
% MYLINK MATLAB code for mylink.fig
%      MYLINK, by itself, creates a new MYLINK or raises the existing
%      singleton*.
%      H = MYLINK returns the handle to a new MYLINK or the handle to
%      the existing singleton*.
%      MYLINK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYLINK.M with the given input arguments.
% Last Modified by GUIDE v2.5 24-Nov-2019 13:24:04
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mylink_OpeningFcn, ...
    'gui_OutputFcn',  @mylink_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...clear
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

% --- Executes just before mylink is made visible.
function mylink_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mylink (see VARARGIN)
% Choose default command line output for mylink
handles.output = hObject;
handles.robot = [];  % the robot
handles.theta1 = 0;  % joint 1
handles.theta2 = 0;  % joint 2
handles.theta3 = 0;  % joint 3
handles.theta4 = 0;

handles.filename = '';
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = mylink_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.theta1 = get (hObject,'Value');
disp(handles.theta1);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);

set(handles.edit4,'String', T.t(1));
set(handles.edit5,'String', T.t(2));
set(handles.edit6,'String', T.t(3));

set(handles.edit1, 'String',handles.theta1*180/pi);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.theta2 = get(hObject, 'Value');
disp(handles.theta2);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');

T= handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
%display(T);

set(handles.edit4,'String', T.t(1));
set(handles.edit5,'String', T.t(2));
set(handles.edit6,'String', T.t(3));

set(handles.edit2, 'String',handles.theta2*180/pi);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.theta3 = get (hObject,'Value')/180*pi;
disp(handles.theta3);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
%display(T);
set(handles.edit4,'String', T.t(1));
set(handles.edit5,'String', T.t(2));
set(handles.edit6,'String', T.t(3));

set(handles.edit3, 'String',handles.theta1);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in Robot.
function Robot_Callback(hObject, eventdata, handles)
% hObject    handle to Robot (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
L(1) = Revolute ('d', 2.5, 'a', 8.2, 'alpha', 0, 'offset', 0*pi/180 , 'qlim', [-180*pi/180 15*pi/180]); %DH parameters for Link1
L(2) = Revolute ('d', 0.7, 'a', 9, 'alpha', pi/2 ,'offset', (35)*pi/180, 'qlim', [0*pi/180 200*pi/180]); %DH parameters for Link2
L(3) = Revolute ('d', 2.6, 'a', 0, 'alpha', pi/2, 'offset', 0); %DH parameters for Link3
L(4) = Revolute ('d', 8.5, 'a', 0, 'alpha', 0, 'offset', 0*pi/180);

handles.robot = SerialLink(L, 'name', 'robot');
warning('off','all');

handles.robot.base = [1 0 0 0; 0 1 0 10.2; 0 0 1 5.3; 0 0 0 1]; % base of robot

T= handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');

theta1_deg= handles.theta1*180/pi;
theta2_deg= handles.theta2*180/pi;
theta3_deg= handles.theta3*180/pi;

set(handles.edit1, 'String',theta1_deg);
set(handles.edit2, 'String',theta2_deg);
set(handles.edit3, 'String',theta3_deg);

set(handles.edit4, 'String', T.t(1));
set(handles.edit5, 'String', T.t(2));
set(handles.edit6, 'String', T.t(3));

% Update handles structure
guidata(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.theta1 = str2double(get(hObject,'String'))
disp(handles.theta1);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
set(handles.edit4, 'String', T.t(1));
set(handles.edit5, 'String', T.t(2));
set(handles.edit6, 'String', T.t(3));
theta1_deg= handles.theta1*180/pi;
set(handles.slider1,'Value',theta1_deg); %generates Slider1 value
% update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

handles.theta2 = str2double(get(hObject,'String'))
disp(handles.theta2);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
set(handles.edit4, 'String', T.t(1));
set(handles.edit5, 'String', T.t(2));
set(handles.edit6, 'String', T.t(3));
set(handles.slider2,'Value',handles.theta2); %generates Slider2 value
% update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.theta3 = str2double(get(hObject,'String'))
disp(handles.theta3);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');

set(handles.edit4, 'String', T.t(1));
set(handles.edit5, 'String', T.t(2));
set(handles.edit6, 'String', T.t(3));

set(handles.slider3,'Value',handles.theta3); %generates Slider3 value
% update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
disp('edit4 called');
T.t(1) = str2double(get(hObject,'String'));
theta1_origin = -2.6603;
theta2_origin = 1.5845;
handles.theta1 = theta1_origin;
handles.theta2 = theta2_origin;
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4], 'deg');
% update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
disp('edit5 called');
T.t(2) = str2double(get(hObject,'String'));
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4]); %plotting robot by giving three angles
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
set(handles.slider1,'Value',str2double(get(hObject,'String')));
set(handles.slider2,'Value',str2double(get(hObject,'String')));
set(handles.slider3,'Value',str2double(get(hObject,'String')));
set(handles.edit1, 'String',handles.theta1);
set(handles.edit2, 'String',handles.theta2);
set(handles.edit3, 'String',handles.theta3);
% update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
disp('edit6 called');
T.t(3) = str2double(get(hObject,'String'));

handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
T = handles.robot.fkine([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
set(handles.slider1,'Value',str2double(get(hObject,'String')));
set(handles.slider2,'Value',str2double(get(hObject,'String')));
set(handles.slider3,'Value',str2double(get(hObject,'String')));
set(handles.edit1, 'String',handles.theta1);
set(handles.edit2, 'String',handles.theta2);
set(handles.edit3, 'String',handles.theta3);
% update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Function to calculate Average Error of DH Parameters.
function  AverageError = Objective_Fun(A)
%Objective_Fun finds the error from measured distance
%   A is a 3x4 matrix with the DH parameters for the
%   assignment 1 robot. This function will create the
%   robot from the assigned parameters and find the error
%   using the sum averaging method.
%   This will optimize the DH parameters
%   Each row of A will coorespond to each link with each parameter
%   going d, a , alpha, offset

%Create robot
clear L
deg = pi/180;

L(1) = Revolute('d', A(1,1), ...    % link length (Dennavit-Hartenberg notation)
    'a', A(1,2), ...                % link offset (Dennavit-Hartenberg notation)
    'alpha', A(1,3), ...            % link twist (Dennavit-Hartenberg notation)
    'offset', A(1,4), ...           %Offsets
    'qlim', [-100 100]*deg);        % minimum and maximum joint angle

L(2) = Revolute('d', A(2,1), 'a', A(2,2), 'alpha', A(2,3),... %Link 2, same params as L(1)
    'offset', A(2,4), 'qlim', [-60 160]*deg );

L(3) = Revolute('d', A(3,1), 'a', A(3,2), 'alpha', A(3,3),... %Link 3, same params as L(1)
    'offset', A(3,4), 'qlim', [-100 60]*deg );

sets = [0 0 0; 0 1.2217 0; 0 2.79 0; -1.57 1.22 0; -1.57 2.79 0];
T1 = [1 0 0 0; 0 1 0 9.5 ; 0 0 1 5.4; 0 0 0 1];
T2 = [1 0 0 0; 0 1 0 8.4; 0 0 1 2; 0 0 0 1];
Obj_Fun_Robot = SerialLink(L, 'name', 'Roboto1', 'base', T1, 'tool', T2);
measure_vals = [21.5,22.9,12,10.8,11.2];
model_vals = zeros(1,5);
sum = 0;

for i = 1:1:5
    coord = sets(i, 1:3);                       %Pulls out the coordinates from sets
    T = Obj_Fun_Robot.fkine(coord);             %finds the transform matrix of each set
    t = transl(T);                              %pulls out the translation matrix
    squares = (T.t(1)^2) + (T.t(2)^2) ;         %squares all values of translation
    model_vals(i) = sqrt(squares)               %finds and stores the squareroot
    e(i) = abs(measure_vals(i)-model_vals(i));
    sum = sum+e(i);
end
AverageError = mean(sum)

%Plot Optimization Erros
%Using data collected after Optimization iterations:
trials = [1 2 3 4]; %number of error calculation trials
errorSet = [1.2 1.15 1.06 0.95]; %average errors
figure(2), plot(trials,errorSet, '-o'), grid on
title('Optimization of DH Parameter Error')
xlabel('Trials') , ylabel('Average Error')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
optimizedDHParams = fminsearch (@(B) Objective_Fun(B), [0,8.5,0,0;2.5,9.5,1.57,0.39;0,0,0,0])

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1

%import the drawRobot class here
T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
handles.robot.plot ([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);

handles.path = pathFinderRobot();      % initiate the object of class drawRobot
valbutton = get(hObject,'Value')  % fetch the value of the checkbox
handles.theta3 = (45/180)*pi;
%if the button is pressed, open the files,to void rewriting of the file, when
%checkbox is unchecked after keypress functionality is over
if valbutton == 1
    fid = fopen('shapesinfo.txt','w');
    fid2 = fopen('position.txt','w');
end
shift = 1;
while(valbutton)
    f = gcf;    %gets current figure
    val = 0;      %initialize val for switch case
    disp('Press button')
    
    w = waitforbuttonpress
    if(w==1)
        val = double(get(f,'CurrentCharacter'))
        TF = isempty(val); %error handling incase val is empty
        if(TF == 1)
            val=0
        end
        switch (val)
            case 97 %diagonal
                disp('Moving diagonal');
                T.t(1) = T.t(1) - 0.2828
                T.t(2) = T.t(2) - 0.2828
                %T.t(1);
                val = 0;
            case 28 %Right
                disp('decrease in x');
                T.t(1) = T.t(1) - 0.1
                %T.t(1)
                val=0;
            case 29 %Left
                disp('increase in x');
                T.t(1) = T.t(1) + 0.1
                %                 T.t(1)
                val=0;
            case 30 %up
                disp('increase in y');
                T.t(2) = T.t(2) + 0.1
                %                 T.t(2)
                val=0;
            case 31 %down
                disp('decrease in y');
                T.t(2) = T.t(2) - 0.1
                %                 T.t(2)
                val=0;
            case 98
                disp('moving to next location');
                handles.theta3 = (45/180)*pi;
                handles.path = recordMovement(handles.path,handles.theta1/pi,handles.theta2/pi,handles.theta3/pi);
                pause(1);
                if(shift == 1)
                    disp('box 1'); 
                    handles.theta1 = (-10.5/180)*pi; %box 1
                    handles.theta2 = (33/180)*pi;
                    shift = shift+1;
                    
                elseif(shift == 2)
                    disp('box 2');
                    handles.theta1 = (-14/180)*pi; %box 2
                    handles.theta2 = (0.5/180)*pi;
                    shift = shift+1;
                    
                elseif(shift == 3)
                    disp('box 3');
                    handles.theta1 = (-33/180)*pi; %box 3
                    handles.theta2 = (97/180)*pi;
                    shift = shift+1;
                    
                elseif(shift == 4)
                    disp('Middle Box');
                    handles.theta1 = (-29/180)*pi; %Middle Box
                    handles.theta2 = (60.5/180)*pi;
                    shift = shift+1;
                    
                elseif(shift == 5)
                    disp('box 4');
                    handles.theta1 = (-69.5/180)*pi; %box 4
                    handles.theta2 = (86/180)*pi;
                    shift = shift+1;
                end
                
                handles.path = recordMovement(handles.path,handles.theta1/pi,handles.theta2/pi,handles.theta3/pi);
                pause(1);
                handles.theta3 = 0;
                handles.path = recordMovement(handles.path,handles.theta1/pi,handles.theta2/pi,handles.theta3/pi);
                
                T = handles.robot.fkine ([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
                pause(1);
                
            otherwise
                disp('wrong option');
                val=0;
        end
        hold on;
        plot3(T.t(1), T.t(2), T.t(3),'-bs');
        
        % perform inverse kinemetics to get the joint angles
        q = handles.robot.ikcon(T, [handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
        handles.theta1 = q(1);
        handles.theta2 = q(2);
        handles.theta3 = q(3);
        
        %convert the theta values from radians to degress
        theta1_deg= handles.theta1*180/pi;
        theta2_deg= handles.theta2*180/pi;
        theta3_deg= handles.theta3*180/pi;
        
        % update edit boxes
        set(handles.edit1, 'String',theta1_deg);
        set(handles.edit2, 'String',theta2_deg);
        set(handles.edit3, 'String',theta3_deg);
        
        set(handles.edit4, 'String', T.t(1));
        set(handles.edit5, 'String', T.t(2));
        set(handles.edit6, 'String', T.t(3));
        
        % Update handles structure
        guidata(hObject, handles);
        
        % record the joint angles into the file
        handles.path = recordMovement(handles.path,handles.theta1/pi,handles.theta2/pi,handles.theta3/pi);
        fid = fopen('shapesinfo.txt','a');
        fid2 = fopen('position.txt', 'a');
        
        fprintf(fid, "%f\t%f\n",handles.theta1/pi, handles.theta2/pi, handles.theta3/pi);
        fprintf(fid2, "%f\t%f\n", T.t(1), T.t(2));
        
        % Plot the points on GUI
        handles.robot.plot([handles.theta1, handles.theta2, handles.theta3, handles.theta4]);
        handles.theta3 = 0;
        handles.path = recordMovement(handles.path,handles.theta1/pi,handles.theta2/pi,handles.theta3/pi);
        fclose(fid);
        fclose(fid2);
    end
end

% Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    contents = cellstr(get(hObject,'string'));
    selected_method = contents(get(hObject, 'Value'));
    
    if(strcmp(selected_method, 'D Star'))
        handles.algo = 'D_Star';
        
    elseif(strcmp(selected_method, 'Probabilistic Road Map'))
        handles.algo = 'PRM';
        
    elseif(strcmp(selected_method, 'Distance Transform'))
        handles.algo = 'DXForm';
        
    else
        handles.algo = 'D Star';
        msg = 'Error while choosing option, defaulting to D Star.';
        warning(msg)    
    end
    disp(handles.algo);
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in mazeSolver.
function mazeSolver_Callback(hObject, eventdata, handles)
% hObject    handle to mazeSolver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    import pkg.*
    handles.rob = pathFinderRobot();
    handles.algo;
    handles.rob = mazeSolver(handles.rob, handles.algo);
    disp(handles.rob.filename);
    

% --------------------------------------------------------------------
function StartingPosition_Callback(hObject, eventdata, handles)
% hObject    handle to StartingPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Box1_Callback(hObject, eventdata, handles)
% hObject    handle to Box1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%box1Center = mymap(3,10);


% --------------------------------------------------------------------
function Box2_Callback(hObject, eventdata, handles)
% hObject    handle to Box2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%box2Center = mymap(12,10);

% --------------------------------------------------------------------
function Box3_Callback(hObject, eventdata, handles)
% hObject    handle to Box3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Box4_Callback(hObject, eventdata, handles)
% hObject    handle to Box4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GoalPosition_Callback(hObject, eventdata, handles)
% hObject    handle to GoalPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CenterBox_Callback(hObject, eventdata, handles)
% hObject    handle to CenterBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
