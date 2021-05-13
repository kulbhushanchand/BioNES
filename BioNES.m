function varargout = BioNES(varargin)
% BIONES MATLAB code for BioNES.fig
%      BIONES, by itself, creates a new BIONES or raises the existing
%      singleton*.
%
%      H = BIONES returns the handle to a new BIONES or the handle to
%      the existing singleton*.
%
%      BIONES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIONES.M with the given input arguments.
%
%      BIONES('Property','Value',...) creates a new BIONES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BioNES_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BioNES_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BioNES

% Last Modified by GUIDE v2.5 11-Mar-2021 13:59:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BioNES_OpeningFcn, ...
    'gui_OutputFcn',  @BioNES_OutputFcn, ...
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


% --- Executes just before BioNES is made visible.
function BioNES_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BioNES (see VARARGIN)

% Choose default command line output for BioNES
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
evalin('base','clear');
clc
format;

setappdata(handles.figure1,'data_logSysData',{});
logSys(handles, "Session Started");


InitializeVariables(handles);
GuiStates(handles,'initialize');
connectArduino(handles,'initialize');




% UIWAIT makes BioNES wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BioNES_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_connectGame.
function pushbutton_connectGame_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connectGame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.pushbutton_connectGame, 'String', 'Wait...');
set(handles.pushbutton_connectGame,'Enable','off');
string = 'Connecting with Game. Wait....';
SetParam(handles.text_statusMsg, string, 'info', 'text');
drawnow
connectGame(handles);


% --- Executes on selection change in listbox_serialPorts.
function listbox_serialPorts_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_serialPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_serialPorts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_serialPorts
listContents = cellstr(get(hObject,'String'));
portSelected = listContents{get(hObject,'Value')};

setappdata(handles.figure1,'settings_serialPort',portSelected);



% --- Executes during object creation, after setting all properties.
function listbox_serialPorts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_serialPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_connectArduino.
function pushbutton_connectArduino_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connectArduino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_connectArduino, 'String', 'Wait...');
set(handles.pushbutton_connectArduino,'Enable','off');
string = 'Connecting with Arduino. Wait....';
SetParam(handles.text_statusMsg, string, 'info', 'text');
drawnow
connectArduino(handles,'connect');

% --- Executes on button press in checkbox_biofeedback.
function checkbox_biofeedback_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_biofeedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_biofeedback
value = get(hObject,'Value');
if (value)
    setappdata(handles.figure1,'flags_isBiofeedback',true);
else
    setappdata(handles.figure1,'flags_isBiofeedback',false);
end


function edit_customId_Callback(hObject, eventdata, handles)
% hObject    handle to edit_customId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_customId as text
%        str2double(get(hObject,'String')) returns contents of edit_customId as a double


% --- Executes during object creation, after setting all properties.
function edit_customId_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_customId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_samplingRate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_samplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_samplingRate as text
%        str2double(get(hObject,'String')) returns contents of edit_samplingRate as a double


% --- Executes during object creation, after setting all properties.
function edit_samplingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_samplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_plotWidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plotWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plotWidth as text
%        str2double(get(hObject,'String')) returns contents of edit_plotWidth as a double


% --- Executes during object creation, after setting all properties.
function edit_plotWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plotWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_startStop.
function togglebutton_startStop_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_startStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_startStop
toggleButtonState = get(hObject,'Value');
if toggleButtonState == get(hObject,'Max')
    
    InitializeVariables(handles);
    ard = getappdata(handles.figure1,'settings_ard');
    fceux = getappdata(handles.figure1,'settings_fceux');
    %---------- initializing some of the variables to be used in the loop ----------
    samplingRate = getappdata(handles.figure1,'settings_samplingRate');
    timeInterval = getappdata(handles.figure1,'settings_samplingTimeInterval');
    sessionDuration = getappdata(handles.figure1,'settings_sessionDuration');
    numberOfSamples = getappdata(handles.figure1,'settings_numberOfSamples');
    isBiofeedback = getappdata(handles.figure1,'flags_isBiofeedback');
    isGameConnected = getappdata(handles.figure1,'flags_isGameConnected');
    relaxedHrv = getappdata(handles.figure1,'data_relaxedHrv');
    stressedHrv = getappdata(handles.figure1,'data_stressedHrv');
   
    
    
    count = 0;
    nBeat = 30;
    ibiS = 0;
    hrvS = 0;
    hrAvgS = 0;
    hrvAvgS = 0;
    hrArr = nan(1, nBeat);
    hrvArr = nan(1, nBeat);
    hrvTh = 2000;
    
    ibi = nan(1, numberOfSamples);
    beat = nan(1, numberOfSamples);
    hrAvg = nan(1, numberOfSamples);
    hrvAvg = nan(1, numberOfSamples);
    dataRel = nan(1, numberOfSamples);
    playerState = nan(1, numberOfSamples);
    isMainScreen = nan(1, numberOfSamples);
    gameMode = nan(1, numberOfSamples);
    positionInLevel = nan(1, numberOfSamples);
    score = nan(1, numberOfSamples);    
    isArrFull = 0;
    lastBeatTime = 0;
    bar = 0;
       
    plotWidth = getappdata(handles.figure1,'setting_plotWidth');
    rightOffset = getappdata(handles.figure1,'settings_rightOffset');
       
    cla(handles.axes1);
    animatedlineHandle1 = animatedline(handles.axes1,'LineWidth',1.5,'Color',[0.5 0 0]);
    animatedlineHandle2 = animatedline(handles.axes1,'LineWidth',1.5,'Color',[0 0.5 0]);
        
    GuiStates(handles,'started');
    
    set(handles.axes1,'ylim',[0 100]);
    
    % timer_buttonUpdate = tic;
    
    timeIntervalUs = timeInterval * 10^6;
    timeJitterUs = 0;
    tic;
    timeSample = toc*10^6;
    warnTime = timeSample;

    
    while(toggleButtonState && (toc <= sessionDuration) )
        
        while( ((toc*10^6) - timeSample) < (timeIntervalUs - timeJitterUs) )
            % disp('wasting time')
            % drawnow limitrate
            pause(0);
        end
        
        timeSample = toc*10^6;
        count = count + 1;
                
        %---------- Acquire data from arduino ----------
        fwrite(ard,160);
        rec_MSB = double(fread(ard,1));
        rec_LSB = double(fread(ard,1));
        beat(count) = bitshift(rec_MSB,-7);
        rec_MSB = bitand(rec_MSB,7);
        ibiS = bitor(bitshift(rec_MSB,8), rec_LSB);
        ibi(count) = ibiS;      
        
        %----- Feature extraction --------
        if(beat(count) && count > 1)
            lastBeatTime = timeSample;
            hrvS = abs(ibiS - ibiPrev);
            if(hrvS > hrvTh)
                hrvArr = nan(1, nBeat);
                isArrFull = 0;
            end
                        
            hrvArr = circshift(hrvArr,-1);
            hrvArr(nBeat) = hrvS;
            ibiPrev = ibiS;
            
            if(sum(isnan(hrvArr)))
                isArrFull = 0;
                hrAvgS = 0;
                hrvAvgS = 0;
            else
                isArrFull = 1;
            end
         
           
             if(isArrFull)
                % Calculate features only if array is full
                ibiAvgS = sum(ibi(count-nBeat+1:count))/nBeat;
                hrAvgS = 60000/ibiAvgS;
                hrvAvgS = round(median(hrvArr));
             end 
                      
        else
            ibiPrev = ibiS;
        end
        
        
      %----- Updating vars -----        
       hrAvg(count) = hrAvgS;
       hrvAvg(count) = hrvAvgS;
        
       if(timeSample - lastBeatTime > 2*10^6)
           hrvArr = nan(1, nBeat);
           isArrFull = 0;
       end
       
       if(isArrFull)
           dataRel(count) = 1;
       else
           dataRel(count) = 0;
         %  fprintf('Data corr. - %d\n',count)
       end
        
  
       %----- Calculating deviation -----
       currentHrv = hrvAvg(count);
       perHrvDeviation = round(min(-1,max(-100, (currentHrv - relaxedHrv)/(relaxedHrv - stressedHrv)*100)));
        
       %----- Get game stats -----
       if(isGameConnected)
           fwrite(fceux, 11);
           pause(0.05)
           if(fceux.BytesAvailable >0)
               a = char(fread(fceux, fceux.BytesAvailable))';
           end
           dataPacket = strsplit(a,',');
           playerState(count) = str2double(dataPacket{1});
           isMainScreen(count) = ~logical(str2double(dataPacket{2}));
           gameMode(count) = str2double(dataPacket{3});
           positionInLevel(count) = str2double(dataPacket{4});
           scoreSample = double(unicode2native(dataPacket{5}));
           score(count) = sum(scoreSample.*10.^[length(scoreSample)-1:-1:0]);
           
       %   sprintf("State = %d     Screen = %d    Game mode = %d   Position = %d   Score = %d\n", playerState(count), isMainScreen(count), gameMode(count), positionInLevel(count), score(count))
         
         %  sprintf("HRV = %d     Dev = %d    Bar = %d", currentHrv, perHrvDeviation, bar)
          
       end
      
       
        %---------- Biofeedback Controller  ----------
        
        if(isBiofeedback && isGameConnected)
            % Display HR and HRV
            bar = floor((100-abs(perHrvDeviation))/10);
         %   bar = round(mod(timeSample/10^6, 10));
                       
            switch bar
                case 0
                    fwrite(fceux, 0)
                case 1
                    fwrite(fceux, 1)
                case 2
                    fwrite(fceux, 2)
                case 3
                    fwrite(fceux, 3)
                case 4
                    fwrite(fceux, 4)
                case 5
                    fwrite(fceux, 5)
                case 6
                    fwrite(fceux, 6)
                case 7
                    fwrite(fceux, 7)
                case 8
                    fwrite(fceux, 8)
                case 9
                    fwrite(fceux, 8)
                otherwise
                    disp('fceux command not set')
            end
            
            if((playerState(count) == 8) && isMainScreen(count) && gameMode(count))
                if(bar == 0)
                    if((timeSample - warnTime) > 10*10^6)
                        sprintf("mario dies at %d", timeSample)
                        fwrite(fceux, 12)
                        warnTime = timeSample;
                    end
                    % show warning
                    fwrite(fceux, 13)
                else
                    warnTime = timeSample;
                end
            else
                warnTime = timeSample;
            end
       
        end
        
    %   sprintf("perDev = %d      bar = %d\n", perHrvDeviation, bar )
         
               

                     
        
        
        %---------- Calculating graph variables ----------
        timeSampleSec = timeSample/(10^6);
        % setting plot axes property
        if(timeSampleSec > plotWidth)
            
            xMin = timeSampleSec-plotWidth;
            xMax = timeSampleSec+rightOffset;
        else
            % timeSampleSec <= scrollPlotWidth
            xMin = 0;
            xMax = plotWidth+rightOffset;
        end
        
        %---------- Plotting data ----------
        set(handles.axes1,'xlim',[xMin xMax]);
        addpoints(animatedlineHandle1, timeSampleSec,beat(count)*10);
        addpoints(animatedlineHandle2, timeSampleSec,hrvAvg(count));

        %   time_buttonUpdate = toc(timer_buttonUpdate); % check timer
        %   if (time_buttonUpdate > 1)
       
        %---------- Jitter calculation and GUI update ----------
        toggleButtonState = get(hObject,'Value');
        drawnow limitrate
        %       timer_buttonUpdate = tic; % reset timer after updating
        %   end
  
        
        timeJitterUs = timeSample - (timeIntervalUs*(count));
        %  TJ_Work(count) = toc(tWork)*1000;
        
    end
    
    
    %---------- Saving data in the application data handle ----------
    recordedNumberOfSamples = count;
    
    sampleNumber = 1:1:recordedNumberOfSamples;
    [timeStampsMsec, ~] = getpoints(animatedlineHandle1);
    timeStampsMsec = round(timeStampsMsec*1000,0);
    
    setappdata(handles.figure1,'data_sampleNumber',sampleNumber);
    setappdata(handles.figure1,'data_timeStampsMsec',timeStampsMsec);
    setappdata(handles.figure1,'data_ibi',ibi);
    setappdata(handles.figure1,'data_beat',beat);
    setappdata(handles.figure1,'data_dataRel',dataRel);
    setappdata(handles.figure1,'data_hrAvg',hrAvg);
    setappdata(handles.figure1,'data_hrvAvg',hrvAvg);
    setappdata(handles.figure1,'data_playerState',playerState);
    setappdata(handles.figure1,'data_isMainScreen',isMainScreen);
    setappdata(handles.figure1,'data_gameMode',gameMode);
    setappdata(handles.figure1,'data_positionInLevel',positionInLevel);
    setappdata(handles.figure1,'data_score',score);
    setappdata(handles.figure1,'data_recordedNumberOfSamples',recordedNumberOfSamples);
    
    %---------- Saving data in base workspace ----------
    assignin('base','sampleNumber',sampleNumber);
    assignin('base','timeStampsMsec',timeStampsMsec);
    assignin('base','ibi',ibi(1:recordedNumberOfSamples));
    assignin('base','beat',beat(1:recordedNumberOfSamples));
    assignin('base','dataRel',dataRel(1:recordedNumberOfSamples));
    assignin('base','hrAvg',hrAvg(1:recordedNumberOfSamples));
    assignin('base','hrvAvg',hrvAvg(1:recordedNumberOfSamples));
    assignin('base','playerState',playerState(1:recordedNumberOfSamples));
    assignin('base','isMainScreen',isMainScreen(1:recordedNumberOfSamples));
    assignin('base','gameMode',gameMode(1:recordedNumberOfSamples));
    assignin('base','positionInLevel',positionInLevel(1:recordedNumberOfSamples));
    assignin('base','score',score(1:recordedNumberOfSamples));
    
    mainData = [sampleNumber(1:recordedNumberOfSamples);
                timeStampsMsec(1:recordedNumberOfSamples);
                ibi(1:recordedNumberOfSamples);
                beat(1:recordedNumberOfSamples);
                dataRel(1:recordedNumberOfSamples);
                hrAvg(1:recordedNumberOfSamples);
                hrvAvg(1:recordedNumberOfSamples);
                playerState(1:recordedNumberOfSamples);
                isMainScreen(1:recordedNumberOfSamples);
                gameMode(1:recordedNumberOfSamples);
                positionInLevel(1:recordedNumberOfSamples);
                score(1:recordedNumberOfSamples)]';
    assignin('base','mainData',mainData);
    
    GuiStates(handles,'stopped');
    CalculateResults(handles)
     
end


% --- Executes on button press in pushbutton_snapshot.
function pushbutton_snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
string = 'Snapshot - in process...';
color = [0.94 0 0];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);
drawnow

set(handles.output, 'PaperPositionMode', 'auto');
set(handles.output,'InvertHardcopy','off');

print -dmeta %-pdf

string = 'Snapshot - copied to clipboard';
color = [0 0.38 0.11];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);

% --- Executes on button press in pushbutton_log.
function pushbutton_log_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logSysData = getappdata(handles.figure1,'data_logSysData');
sessionId = getappdata(handles.figure1,'settings_sessionId');

fid=fopen(sprintf('data/%s_Log.txt',sessionId),'wt');
fprintf(fid,'%s -> %s\n', logSysData',logSysData');
fclose(fid);

FileName = sprintf('data/%s_Data',sessionId);
evalin('base', ['save(''', FileName ''')']);




% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','clear');
clc
delete(instrfindall);

[status,cmdout] =  system('taskkill -f -im fceux.exe');
if(~status)
    logSys(handles, "Already running instance of FCEUX has been terminated.")
else
    logSys(handles, "FCEUX is not running.")
end
    
logSys(handles, "GUI reseted.")
InitializeVariables(handles);
GuiStates(handles,'initialize');
connectArduino(handles,'initialize');
% ---------- Status Message ----------
SetParam(handles.text_statusMsg, 'GUI reseted and initialized...!!!', 'success', 'text');
drawnow

% --- Executes on button press in pushbutton_help.
function pushbutton_help_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Help

% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
logSys(handles, "Session Terminated");
clear global;
close all;
delete(instrfindall);
%clc;
%delete(instrfind);




function edit_sessionDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sessionDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sessionDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_sessionDuration as a double


% --- Executes during object creation, after setting all properties.
function edit_sessionDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sessionDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_debug.
function pushbutton_debug_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
string = 'Debug button pressed.';
SetParam(handles.text_statusMsg, string, 'info', 'text');
logSys(handles, "Debug button pressed.")
 % connectGame(handles)
% get(handles.text_recordedSamplingRate, 'String')

logSysData = getappdata(handles.figure1,'data_logSysData');
assignin('base','logSysData',logSysData);



%----------------------------------------------------
%-------------  CUSTOM FUNCTIONS --------------------
%----------------------------------------------------

function logSys(handles, logString)

% incomplete, in progress
logString = string(logString);
logDateTime = datetime('now');
logDateTime = datestr(logDateTime,'dd-mmmm-yyyy HH:MM:SS AM');

fprintf('%s %s\n', logDateTime,logString)

logSysData = getappdata(handles.figure1,'data_logSysData');
logString = [logDateTime logString];
logSysData = [logSysData ; logString];

setappdata(handles.figure1,'data_logSysData',logSysData);



function  InitializeVariables(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%------------------------------ initializing settings parameter variables
% do not set defaults here because this function is called each time at each start button press

% Daq Date and Time code
daqDateTime = datetime('now');
setappdata(handles.figure1,'settings_daqDateTime',daqDateTime);

% Session Date
sessionDate = datestr(daqDateTime,'dd-mmmm-yyyy');
setappdata(handles.figure1,'settings_sessionDate',sessionDate);

% Session Time
sessionTime = datestr(daqDateTime,'HH:MM:SS AM');
setappdata(handles.figure1,'settings_sessionTime',sessionTime);

% Custom ID
customId = get(handles.edit_customId,'String');
setappdata(handles.figure1,'settings_customId',customId);

% Session ID
yearValue = daqDateTime.Year;
yearValue  = num2str(yearValue);

monthValue = daqDateTime.Month;
if(monthValue<10)
    monthValue = sprintf('0%d',monthValue);
else
    monthValue  = num2str(monthValue);
end

dateValue = daqDateTime.Day;
if(dateValue<10)
    dateValue = sprintf('0%d',dateValue);
else
    dateValue  = num2str(dateValue);
end

hourValue = daqDateTime.Hour;
if(hourValue<10)
    hourValue = sprintf('0%d',hourValue);
else
    hourValue  = num2str(hourValue);
end


minuteValue = daqDateTime.Minute;
if(minuteValue<10)
    minuteValue = sprintf('0%d',minuteValue);
else
    minuteValue  = num2str(minuteValue);
end

secondValue = fix(daqDateTime.Second);
if(secondValue<10)
    secondValue = sprintf('0%d',secondValue);
else
    secondValue = num2str(secondValue);
end

sessionId  = sprintf('%s%s%s%s%s%s%s', yearValue, monthValue, dateValue, hourValue, minuteValue, secondValue,customId);
setappdata(handles.figure1,'settings_sessionId',sessionId);

% Session Duration
sessionDuration = ceil(str2double(get(handles.edit_sessionDuration,'String')) *60);
setappdata(handles.figure1,'settings_sessionDuration',sessionDuration);

% Sampling Rate
samplingRate= str2double(get(handles.edit_samplingRate,'String'));
setappdata(handles.figure1,'settings_samplingRate',samplingRate);

% Sampling Time Interval
setappdata(handles.figure1,'settings_samplingTimeInterval',1/samplingRate);

% Plot Width
plotWidth = str2double(get(handles.edit_plotWidth,'String'));
setappdata(handles.figure1,'setting_plotWidth',plotWidth);

% Right Offset
setappdata(handles.figure1,'settings_rightOffset',ceil(plotWidth/10));

% Number of samples to be recorded
numberOfSamples = samplingRate * sessionDuration ;
setappdata(handles.figure1,'settings_numberOfSamples',numberOfSamples);

% Flags
setappdata(handles.figure1,'flag_isAcquiring', false);
setappdata(handles.figure1,'flag_isTimeRef', false);

% Baseline values (from the settings panel)
relaxedHrv = str2double(get(handles.edit_relaxedHrv,'String'));
stressedHrv = str2double(get(handles.edit_stressedHrv,'String'));
setappdata(handles.figure1,'data_relaxedHrv',relaxedHrv);
setappdata(handles.figure1,'data_stressedHrv',stressedHrv);


%------------------------- initializing data parameter variables and populating with the blank

setappdata(handles.figure1,'data_sampleNumber',[]);
setappdata(handles.figure1,'data_timeStampsMsec',[]);
setappdata(handles.figure1,'data_ibi',[]);
setappdata(handles.figure1,'data_beat',[]);
setappdata(handles.figure1,'data_dataRel',[]);
setappdata(handles.figure1,'data_hrAvg',[]);
setappdata(handles.figure1,'data_hrvAvg',[]);
setappdata(handles.figure1,'data_playerState',[]);
setappdata(handles.figure1,'data_isMainScreen',[]);
setappdata(handles.figure1,'data_gameMode',[]);
setappdata(handles.figure1,'data_positionInLevel',[]);
setappdata(handles.figure1,'data_score',[]);
setappdata(handles.figure1,'data_recordedNumberOfSamples',[]);
setappdata(handles.figure1,'data_recordedSessionDuration',[]);
setappdata(handles.figure1,'data_recordedSamplingRate',[]);
setappdata(handles.figure1,'data_dataQuality',[]);

drawnow


function connectArduino(handles,string)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch string
    case 'connect'
        try
            GuiStates(handles, 'disable')
            delete(instrfindall);
            ard = serial(getappdata(handles.figure1,'settings_serialPort'));
            set(ard,'DataBits',8);
            set(ard,'StopBits',1);
            set(ard,'BaudRate',115200);
            set(ard,'Parity','none');
            fopen(ard);
            pause(1);
            % Flushing garbage values
            while(ard.BytesAvailable)
                uint8(fread(ard,1));
            end
            % sending pairing command
            fwrite(ard,32);
            rec_data = uint8(fread(ard,1));
            if(rec_data == 33)
                setappdata(handles.figure1,'flags_isArduinoConnected',true);
                setappdata(handles.figure1,'settings_ard',ard);
                GuiStates(handles, 'arduino-connected')
            elseif(rec_data == 34)
                GuiStates(handles, 'initialize')
                SetParam(handles.text_statusMsg, 'NACK received. Unable to connect to Arduino', 'error', 'text');
                drawnow
            else
                GuiStates(handles, 'initialize')
                SetParam(handles.text_statusMsg, 'No response. Unable to connect to Arduino', 'error', 'text');
                drawnow
            end
                 
        catch ME
            set(handles.pushbutton_reset,'Enable','on');
            drawnow
            switch ME.identifier
                case {'MATLAB:arduinoio:general:invalidAddressType', 'MATLAB:arduinoio:general:invalidAddressPCMac' , 'MATLAB:arduinoio:general:invalidPort'}
                    disp(ME.identifier)
                    disp('Select correct serial port');
                    % Displaying status message.
                    string = 'Select correct serial port';
                    SetParam(handles.text_statusMsg, string, 'error', 'text');
                    drawnow
                    
                case 'MATLAB:arduinoio:general:connectionExists'
                    disp(ME.identifier)
                    disp('Connection to arduino already exists in MATLAB')
                    % Displaying status message.
                    string = 'Connection to arduino already exists in MATLAB';
                    SetParam(handles.text_statusMsg, string, 'error', 'text');
                    drawnow
                    
                case 'MATLAB:serial:fopen:opfailed'
                    disp(ME.identifier)
                    disp('Failed to open a connection at serial port')
                    % Displaying status message.
                    string = 'Failed to open a connection at serial port. Possible reason is another application is connected to the port';
                    SetParam(handles.text_statusMsg, string, 'error', 'text');
                    drawnow
                    
                case 'MATLAB:serial:serial:invalidPORTempty'
                    disp(ME.identifier)
                    disp('Empty port. Connect arduino to begin with')
                    % Displaying status message.
                    string = 'Failed to open a connection at serial port. Possible reason is the port does not exist';
                    SetParam(handles.text_statusMsg, string, 'error', 'text');
                    drawnow
                    
                otherwise
                    disp(ME.identifier)
                    disp(ME)
                    disp('Unknown error !!!');
                    % Displaying status message.
                    string = 'Unknown error !!! Check command window for furthur details';
                    SetParam(handles.text_statusMsg, string, 'error', 'text');
                    drawnow
            end
        end
        
    case 'initialize'
        % Arduino object (This will be filled when user presses connect button)
        setappdata(handles.figure1,'settings_ard',[]);
        % Serial Port on which arduino is connected (User selected)
        setappdata(handles.figure1,'settings_serialPort',[]);
        
        % Find serial port and populate the list
        serialPorts = instrhwinfo('serial');
        %  nPorts = length(serialPorts.SerialPorts);
        set(handles.listbox_serialPorts, 'String', [serialPorts.SerialPorts]);
        %  set(handles.listbox_serialPorts, 'Value', 1);
        listContents = cellstr(get(handles.listbox_serialPorts,'String'));
        portSelected = listContents{get(handles.listbox_serialPorts,'Value')};
        setappdata(handles.figure1,'settings_serialPort',portSelected);
        if(isempty(portSelected))
            string = 'No serial port device detected. Connect arduino and press Reset button.';
            SetParam(handles.text_statusMsg, string, 'error', 'text');
        end
end




function connectGame(handles)

try
    [status,cmdout] =  system('taskkill -f -im fceux64.exe');
    if(~status)
        logSys(handles, "Already running instance of FCEUX has been terminated.")
    else
        logSys(handles, "FCEUX is not running.")
    end
     
    GuiStates(handles, 'disable')
    % Loading ROM and LUA-script path
    sp = ' ';
    br = '"';
    ROM_FullPath = [pwd,'\fceux64\ROMs\','Super Mario Bros. (World).zip'];
    LUA_FullPath = [pwd,'\fceux64\luaScripts\','BioNES.lua'];
    
    % Starting game
    FCEUX_cmd = ['fceux64\fceux64.exe',sp,'ntsc',sp,'-lua',sp,LUA_FullPath,sp,br,ROM_FullPath,br,sp,'&'];
    system(FCEUX_cmd);
    logSys(handles, "New instance of FCEUX is started and Game loaded.")
    
    % Starting TCP/IP server in MATLAB to communicate with game
    fceux = tcpip('127.0.0.1', 30000, 'NetworkRole', 'server');
    fopen(fceux);
    logSys(handles, "TCP/IP Server started.")
    logSys(handles, "MATLAB is connected to FCEUX.")
    
    setappdata(handles.figure1,'flags_isGameConnected',true);
    setappdata(handles.figure1,'settings_fceux',fceux);
    GuiStates(handles,'game-connected');  
    
catch ME
     set(handles.pushbutton_reset,'Enable','on');
     drawnow
     disp(ME.identifier)
     disp(ME) 
end




function  CalculateResults(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

recordedNumberOfSamples = getappdata(handles.figure1,'data_recordedNumberOfSamples');
timeStampsMsec = getappdata(handles.figure1,'data_timeStampsMsec');

lastTimeStamp = timeStampsMsec(1,recordedNumberOfSamples);
recordedSessionDuration = lastTimeStamp/1000;

recordedSamplingRate = recordedNumberOfSamples/recordedSessionDuration;

setappdata(handles.figure1,'data_recordedSessionDuration',recordedSessionDuration);
setappdata(handles.figure1,'data_recordedSamplingRate',recordedSamplingRate);

% Setting text for recorded session duration
string = sprintf('Recorded Session Duration (sec): %0.2f', recordedSessionDuration);
set(handles.text_recordedSessionDuration, 'String', string);

% Setting text for recorded sampling rate
string = sprintf('Recorded Sampling Rate (Hz): %0.2f', recordedSamplingRate);
set(handles.text_recordedSamplingRate, 'String', string);

% Setting text for samples recorded
string = sprintf('Recorded Number of Samples : %d', recordedNumberOfSamples);
set(handles.text_recordedNumberOfSamples, 'String', string);

% Setting text for data quality
samplingRate = str2double(get(handles.edit_samplingRate,'String'));
sessionDuration = str2double(get(handles.edit_sessionDuration,'String'));
string = sprintf('Data Quality (%%): %0.1f', (100 * recordedNumberOfSamples/round(recordedSessionDuration * samplingRate)));
set(handles.text_dataQuality, 'String', string);

% assignin('base','data_recordedSessionDuration',recordedSessionDuration);
% assignin('base','data_recordedSamplingFrequency',recordedSamplingFrequency);

drawnow


function SetParam(handleName, string, color, handleType)

switch color
    case 'info'
        color = [0 0 0];
    case 'highlight'
        color = [1 1 1];
    case 'normal'
        color = [0.94 0.94 0.94];
    case 'success'
        color = [0 0.38 0.11];
    case 'error'
        color = [0.94 0 0];
end

set(handleName, 'String', string);

switch handleType
    case 'text'
        set(handleName, 'ForegroundColor', color);
    case 'button'
        set(handleName, 'BackgroundColor', color);
end

drawnow



function GuiStates(handles, string)

switch string
    
    case 'disable'
        % ---------- Arduino Panel ----------
        set(findall(handles.uipanel_arduino, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Game Panel ----------
        set(findall(handles.uipanel_game, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Setting Panel ----------
        set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Control Panel ----------
        set(findall(handles.uipanel_control, '-property', 'Enable'), 'Enable', 'off');
        drawnow
        
    case 'initialize'
        % ---------- Arduino Panel ----------
        set(findall(handles.uipanel_arduino, '-property', 'Enable'), 'Enable', 'on');
        SetParam(handles.pushbutton_connectArduino, 'Connect', 'normal', 'button');
        % ---------- Game Panel ----------
        set(handles.checkbox_biofeedback,'Value',0);
        set(findall(handles.uipanel_game, '-property', 'Enable'), 'Enable', 'off');
        SetParam(handles.pushbutton_connectGame, 'Connect', 'normal', 'button');
        % ---------- Setting Panel ----------
        set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Control Panel ----------
        set(handles.togglebutton_startStop,'Enable','off');
        set(handles.pushbutton_snapshot,'Enable','on');
        set(handles.pushbutton_log,'Enable','off');
        set(handles.pushbutton_reset,'Enable','on');
        set(handles.pushbutton_help,'Enable','on');
        % ---------- Status Message ----------
        string = 'GUI Initialized...!!!';
        SetParam(handles.text_statusMsg, string, 'info', 'text');
        % ---------- Plot Panel ----------
        % This part is to intitialize the plot so as to have a correct layout in the opening of the GUI
        numberOfSamples = getappdata(handles.figure1,'settings_numberOfSamples');
        timeStamps = nan(1, numberOfSamples);
        rawData = nan(1, numberOfSamples);
        plot(handles.axes1,timeStamps,rawData,'LineWidth',0.25,'Color',[1 0 0]);
        % This part is common in opening and acquisition running formatting
        plotWidth = getappdata(handles.figure1,'setting_plotWidth');
        rightOffset = getappdata(handles.figure1,'settings_rightOffset');
        xMin = 0;
        xMax = plotWidth+rightOffset;
        yMin = 30;
        yMax = 100;
        setappdata(handles.figure1,'settings_xMin',xMin);
        setappdata(handles.figure1,'settings_xMax',xMax);
        setappdata(handles.figure1,'settings_yMin',yMin);
        setappdata(handles.figure1,'settings_yMax',yMax);
        set(handles.axes1,'XGrid','on');
        set(handles.axes1,'XMinorGrid','on');
        set(handles.axes1,'YGrid','on');
        set(handles.axes1,'YMinorGrid','on');
        %title(handles.axes1,'BioNES','interpreter','latex');
        xlabel(handles.axes1,'Time (sec)');
        ylabel(handles.axes1,'Data');
        set(handles.axes1,'XLimMode','manual','YLimMode','manual','FontSize',8);
        set(handles.axes1,'xlim',[xMin xMax],'ylim',[yMin yMax]);
        % ---------- Information Panel ----------
        % Setting text for session date
        sessionDate = getappdata(handles.figure1,'settings_sessionDate');
        string = sprintf('Session Date : %s', sessionDate);
        set(handles.text_sessionDate, 'String', string);
        % Setting text for session time
        sessionTime = getappdata(handles.figure1,'settings_sessionTime');
        string = sprintf('Session Time : %s', sessionTime);
        set(handles.text_sessionTime, 'String', string);
        % Setting text for session ID
        sessionId = getappdata(handles.figure1,'settings_sessionId');
        string = sprintf('Session ID : %s', sessionId);
        set(handles.text_sessionId, 'String', string);
        % Setting text for custom ID
        customId = getappdata(handles.figure1,'settings_customId');
        string = sprintf('Custom ID : %s', customId);
        set(handles.text_customId, 'String', string);
        % ---------- Results Panel ----------
        string = sprintf('Recorded Session Duration (sec) : %s', '.....');
        set(handles.text_recordedSessionDuration, 'String', string);
        string = sprintf('Recorded Sampling Rate (Hz) : %s', '.....');
        set(handles.text_recordedSamplingRate, 'String', string);
        string = sprintf('Recorded Number of Samples : %s', '.....');
        set(handles.text_recordedNumberOfSamples, 'String', string);
        string = sprintf('Data Quality (%%) : %s', '.....');
        set(handles.text_dataQuality, 'String', string);
        % ---------- Other Properties ----------
        cla(handles.axes1);
        %set(handles.output,'toolbar','figure');
        set(handles.output,'menubar','figure');
        set(handles.output, 'PaperPositionMode', 'auto');
        set(handles.output,'InvertHardcopy','off');
        % ---------- Variables ----------
        setappdata(handles.figure1,'flags_isDebug',false);
        setappdata(handles.figure1,'flags_isAcqRunning',false);
        setappdata(handles.figure1,'flags_isError',false);
        setappdata(handles.figure1,'flags_isArduinoConnected',false);
        setappdata(handles.figure1,'flags_isGameConnected',false);
        setappdata(handles.figure1,'flags_isBiofeedback',false);
        % setappdata(handles.figure1,'flags_isBenchmarkRunning',false);
        % ---------- Force GUI Update ----------
        logSys(handles, "GUI initialized.")
        drawnow
        
        
    case 'arduino-connected'
        % ---------- Arduino Panel ----------
        SetParam(handles.pushbutton_connectArduino, 'Connected', 'success', 'button');
        set(findall(handles.uipanel_arduino, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Game Panel ----------
        set(findall(handles.uipanel_game, '-property', 'Enable'), 'Enable', 'on');
        % ---------- Setting Panel ----------
        set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'on');
        % ---------- Control Panel ----------
        set(handles.togglebutton_startStop,'Enable','on');
        set(handles.pushbutton_snapshot,'Enable','on');
        set(handles.pushbutton_log,'Enable','off');
        set(handles.pushbutton_reset,'Enable','on');
        set(handles.pushbutton_help,'Enable','on');
        % ---------- Status Message ----------
        SetParam(handles.text_statusMsg, 'Arduino Connected...', 'success', 'text');
        
        % ---------- Plot Panel ----------
        
        % ---------- Information Panel ----------
        
        % ---------- Results Panel ----------
        
        % ---------- Other Properties ----------
        
        % ---------- Variables ----------
        
        % ---------- Force GUI Update ----------
        logSys(handles, "Arduino Connected.")
        drawnow
        
        
    case 'game-connected'
        % ---------- Arduino Panel ----------

        % ---------- Game Panel ----------
        SetParam(handles.pushbutton_connectGame, 'Started', 'success', 'button');
        set(findall(handles.uipanel_game, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Setting Panel ----------
        set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'on');
        % ---------- Control Panel ----------
        set(handles.togglebutton_startStop,'Enable','on');
        set(handles.pushbutton_snapshot,'Enable','on');
        set(handles.pushbutton_log,'Enable','off');
        set(handles.pushbutton_reset,'Enable','on');
        set(handles.pushbutton_help,'Enable','on');
        % ---------- Status Message ----------
        SetParam(handles.text_statusMsg, 'Game Connected...', 'success', 'text');
        % ---------- Plot Panel ----------
        
        % ---------- Information Panel ----------
        
        % ---------- Results Panel ----------
        
        % ---------- Other Properties ----------
        
        % ---------- Variables ----------
        
        % ---------- Force GUI Update ----------
        logSys(handles, "Game Connected.")
        drawnow

        
    case 'started'
        
        % ---------- Arduino Panel ----------
        
        % ---------- Game Panel ----------
        set(findall(handles.uipanel_game, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Setting Panel ----------
        set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'off');
        % ---------- Control Panel ----------
        SetParam(handles.togglebutton_startStop, 'Stop', 'success', 'button');
        set(handles.togglebutton_startStop,'Enable','on');
        set(handles.pushbutton_snapshot,'Enable','off');
        set(handles.pushbutton_log,'Enable','off');
        set(handles.pushbutton_reset,'Enable','off');
        set(handles.pushbutton_help,'Enable','off');
        % ---------- Status Message ----------
        SetParam(handles.text_statusMsg, 'Acquisition Running', 'success', 'text');
        % ---------- Plot Panel ----------
        % This part is common in initialize case and started case - we can
        % set defaults here
        plotWidth = getappdata(handles.figure1,'setting_plotWidth');
        rightOffset = getappdata(handles.figure1,'settings_rightOffset');
        xMin = 0;
        xMax = plotWidth+rightOffset;
        yMin = 30;
        yMax = 1000;
        setappdata(handles.figure1,'settings_xMin',xMin);
        setappdata(handles.figure1,'settings_xMax',xMax);
        setappdata(handles.figure1,'settings_yMin',yMin);
        set(handles.axes1,'XGrid','on');
        set(handles.axes1,'XMinorGrid','on');
        set(handles.axes1,'YGrid','on');
        set(handles.axes1,'YMinorGrid','on');
        %title(handles.axes1,'Arduino Serial Data Acquisition','interpreter','latex');
        xlabel(handles.axes1,'Time (sec)');
        ylabel(handles.axes1,'Data');
        set(handles.axes1,'XLimMode','manual','YLimMode','manual','FontSize',8);
        set(handles.axes1,'xlim',[xMin xMax],'ylim',[yMin yMax]);
        % ---------- Information Panel ----------
        % Setting text for session date
        sessionDate = getappdata(handles.figure1,'settings_sessionDate');
        string = sprintf('Session Date : %s', sessionDate);
        set(handles.text_sessionDate, 'String', string);
        % Setting text for session time
        sessionTime = getappdata(handles.figure1,'settings_sessionTime');
        string = sprintf('Session Time : %s', sessionTime);
        set(handles.text_sessionTime, 'String', string);
        % Setting text for session ID
        sessionId = getappdata(handles.figure1,'settings_sessionId');
        string = sprintf('Session ID : %s', sessionId);
        set(handles.text_sessionId, 'String', string);
        % Setting text for custom ID
        customId = getappdata(handles.figure1,'settings_customId');
        string = sprintf('Custom ID : %s', customId);
        set(handles.text_customId, 'String', string);
        % ---------- Results Panel ----------
        string = sprintf('Recorded Session Duration (sec) : %s', '.....');
        set(handles.text_recordedSessionDuration, 'String', string);
        string = sprintf('Recorded Sampling Rate (Hz) : %s', '.....');
        set(handles.text_recordedSamplingRate, 'String', string);
        string = sprintf('Recorded Number of Samples : %s', '.....');
        set(handles.text_recordedNumberOfSamples, 'String', string);
        string = sprintf('Data Quality (%%) : %s', '.....');
        set(handles.text_dataQuality, 'String', string);
        % ---------- Other Properties ----------
        
        % ---------- Variables ----------
        
        % ---------- Force GUI Update ----------
        logSys(handles, "Acquisition started.")
        drawnow
        
        
    case 'stopped'
        
        % ---------- Arduino Panel ----------
        
        % ---------- Game Panel ----------
        
        % ---------- Setting Panel ----------
        set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'on');
        % ---------- Control Panel ----------
        SetParam(handles.togglebutton_startStop, 'Start', 'normal', 'button');
        set(handles.togglebutton_startStop,'Enable','on');
        set(handles.pushbutton_snapshot,'Enable','on');
        set(handles.pushbutton_log,'Enable','on');
        set(handles.pushbutton_reset,'Enable','on');
        set(handles.pushbutton_help,'Enable','on');
        % ---------- Status Message ----------
        SetParam(handles.text_statusMsg, 'Acquisition Stopped', 'success', 'text');
        % ---------- Plot Panel ----------
        
        % ---------- Information Panel ----------
        
        % ---------- Results Panel ----------
        
        % ---------- Other Properties ----------
        set(handles.togglebutton_startStop,'Value',0);
        % ---------- Variables ----------
        
        % ---------- Force GUI Update ----------
        logSys(handles, "Acquisition stopped.")
        drawnow
        
        
end



function edit_relaxedHrv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_relaxedHrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_relaxedHrv as text
%        str2double(get(hObject,'String')) returns contents of edit_relaxedHrv as a double


% --- Executes during object creation, after setting all properties.
function edit_relaxedHrv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_relaxedHrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_stressedHrv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stressedHrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stressedHrv as text
%        str2double(get(hObject,'String')) returns contents of edit_stressedHrv as a double


% --- Executes during object creation, after setting all properties.
function edit_stressedHrv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stressedHrv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
