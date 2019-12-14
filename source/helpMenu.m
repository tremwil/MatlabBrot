function varargout = helpMenu(varargin)
% HELPMENU MATLAB code for helpMenu.fig
%      HELPMENU, by itself, creates a new HELPMENU or raises the existing
%      singleton*.
%
%      H = HELPMENU returns the handle to a new HELPMENU or the handle to
%      the existing singleton*.
%
%      HELPMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELPMENU.M with the given input arguments.
%
%      HELPMENU('Property','Value',...) creates a new HELPMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before helpMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to helpMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help helpMenu

% Last Modified by GUIDE v2.5 13-Dec-2019 23:13:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @helpMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @helpMenu_OutputFcn, ...
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


% --- Executes just before helpMenu is made visible.
function helpMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to helpMenu (see VARARGIN)

% Choose default command line output for helpMenu
handles.output = hObject;
% Init image that will store CData of loaded stuff
handles.imgObj = image(handles.helpImgAx, 'CData', 0,...
    'XData', [1e10 1e10+1], 'YData', [1e10 1e10+1]);
handles.imgObj.UserData = 1;
handles.imgObj.ButtonDownFcn = @(s,e) helpImgAx_ButtonDownFcn(s,e,handles);
% Load image CData
handles.imData = {};
i = 1;
while isfile(['help_img/' num2str(i) '.PNG'])
    handles.imData{end+1} = imread(['help_img/' num2str(i) '.PNG']);
    i = i + 1;
end
handles.helpText = {};
currImg = struct();
% Load text strings
for i = 1:length(handles.helpTxtBox.String)
    line = handles.helpTxtBox.String{i};
    if ~isempty(line) && line(1) == '>'
        if ~isempty(fieldnames(currImg))
            handles.helpText{end+1} = currImg;
        end
        currImg.title = line(2:end);
        currImg.lines = {};
    else
        currImg.lines{end+1} = line;
    end
end
handles.helpText{end+1} = currImg;
loadSelectedImg(handles)

guidata(hObject, handles);

% UIWAIT makes helpMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = helpMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function helpImgAx_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to helpImgAx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if eventdata.Button == 1
    handles.imgObj.UserData = min(handles.imgObj.UserData + 1, ...
        length(handles.imData));
elseif eventdata.Button == 3
    handles.imgObj.UserData = max(handles.imgObj.UserData - 1, 1);
end
loadSelectedImg(handles)

% --- Executes on button press in btnPrev.
function btnPrev_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imgObj.UserData = max(handles.imgObj.UserData - 1, 1);
loadSelectedImg(handles)

% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
% hObject    handle to btnNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.imgObj.UserData = min(handles.imgObj.UserData + 1, length(handles.imData));
loadSelectedImg(handles)

% --- Executes during object creation, after setting all properties.
function helpTxtBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to helpTxtBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function loadSelectedImg(handles)
i = handles.imgObj.UserData;
% Get image & aspect ratio
img = handles.imData{i};
imR = size(img,2)/size(img,1);
% Get screen aspect ratio
pxPos = getpixelposition(handles.helpImgAx);
axR = pxPos(3)/pxPos(4);
% Will touch horizontally
if axR <= imR
    handles.imgObj.XData = [0 1];
    handles.imgObj.YData = [0.5 0.5] + [-0.5/imR, 0.5/imR]*axR;
% Will touch vertically
else
    handles.imgObj.XData = [0.5 0.5] + [-0.5*imR, 0.5*imR]/axR;
    handles.imgObj.YData = [0 1];
end
% Set image CData & supersample 3x to eliminate aliasing
handles.imgObj.CData = imresize(img, 3);
% Change current image indicator
handles.cImgTxt.String = ['Image ' num2str(i) '/' num2str(length(handles.imData))];
% Load help title & text
ht = handles.helpText{i};
title(handles.helpImgAx, ht.title);
handles.helpTxtBox.String = ht.lines;
