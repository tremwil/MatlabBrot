function varargout = mandelPlotter(varargin)
% MANDELPLOTTER MATLAB code for mandelPlotter.fig
%      MANDELPLOTTER, by itself, creates a new MANDELPLOTTER or raises the existing
%      singleton*.
%
%      H = MANDELPLOTTER returns the handle to a new MANDELPLOTTER or the handle to
%      the existing singleton*.
%
%      MANDELPLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANDELPLOTTER.M with the given input arguments.
%
%      MANDELPLOTTER('Property','Value',...) creates a new MANDELPLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mandelPlotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mandelPlotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mandelPlotter

% Last Modified by GUIDE v2.5 12-Dec-2019 20:38:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mandelPlotter_OpeningFcn, ...
                   'gui_OutputFcn',  @mandelPlotter_OutputFcn, ...
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


% --- Executes just before mandelPlotter is made visible.
function mandelPlotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mandelPlotter (see VARARGIN)

% Choose default command line output for mandelPlotter
handles.output = hObject;

% Set default axis limits
btnResetView_Callback(hObject, eventdata, handles);
% Store default position of axis objects, aslo add titles
handles.origMandelPos = handles.axMandel.Position;
handles.origJuliaPos = handles.axJulia.Position;
title(handles.axMandel, 'Mandelbrot Set');
title(handles.axJulia, 'Julia Set');
% Pre-create a field for Julia and Mandelbrot image objects
handles.mandelImg = 0;
handles.juliaImg = 0;
% Assign renderSub function to handles so it can be called from
% outside of this file
handles.renderSub = @renderSub;
% Init images that will display the sets
handles.mandelImg = image(handles.axMandel, 'CData', 0,...
    'XData', handles.axMandel.XLim, 'YData', handles.axMandel.YLim);
handles.juliaImg = image(handles.axJulia, 'CData', 0,...
    'XData', handles.axJulia.XLim, 'YData', handles.axJulia.YLim);
% Store the iteration data inside the UserData of the images
handles.mandelImg.UserData = [];
handles.juliaImg.UserData = [];
% Assign button down to image so Quick Julia still works
handles.mandelImg.ButtonDownFcn = @(s,e) axMandel_ButtonDownFcn(s, e, handles);
% Handle interactive axes
hObject.WindowButtonMotionFcn = @(s,e) interactiveAxis(s,e, handles);
hObject.WindowButtonDownFcn = @(s,e) interactiveAxis(s,e, handles);
hObject.WindowButtonUpFcn = @(s,e) interactiveAxis(s,e, handles);
hObject.WindowScrollWheelFcn = @(s,e) interactiveAxis(s,e, handles);
% Handle color sliders
addlistener(handles.colorOffset,'Value','PreSet',...
    @(src,evt) recomputeCmap(handles));
addlistener(handles.colorBias,'Value','PreSet',...
    @(src,evt) recomputeCmap(handles));
% Create initial colormap data
recomputeCmap(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mandelPlotter wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);


% --- Outputs from this function are returned to the command line.
function varargout = mandelPlotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function zPower_Callback(hObject, eventdata, handles)
% hObject    handle to zPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zPower as text
%        str2double(get(hObject,'String')) returns contents of zPower as a double
if updateTextBox(hObject, 1, Inf, @(p)deal(str2double(p),...
        str2double(p) == floor(str2double(p))))
    updateAlgoSettings(0, handles);
end

% --- Executes during object creation, after setting all properties.
function zPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function escVal_Callback(hObject, eventdata, handles)
% hObject    handle to escVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of escVal as text
%        str2double(get(hObject,'String')) returns contents of escVal as a double
updateTextBox(hObject, 0, Inf);
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% --- Executes during object creation, after setting all properties.
function escVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to escVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function itCnt_Callback(hObject, eventdata, handles)
% hObject    handle to itCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itCnt as text
%        str2double(get(hObject,'String')) returns contents of itCnt as a double
updateTextBox(hObject, 1, Inf, @(it)deal(str2double(it),...
    str2double(it) == floor(str2double(it))));

checkAutoRender(handles);

if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% --- Executes during object creation, after setting all properties.
function itCnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function customPoly_Callback(hObject, eventdata, handles)
% hObject    handle to customPoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of customPoly as text
%        str2double(get(hObject,'String')) returns contents of customPoly as a double
if updateTextBox(hObject, -Inf, Inf, @parsePolynomial)
    updateAlgoSettings(1, handles);
end

% --- Executes during object creation, after setting all properties.
function customPoly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to customPoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function currAlgo_Callback(hObject, eventdata, handles)
% hObject    handle to currAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currAlgo as text
%        str2double(get(hObject,'String')) returns contents of currAlgo as a double
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% --- Executes during object creation, after setting all properties.
function currAlgo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in algoType.
function algoType_Callback(hObject, eventdata, handles)
% hObject    handle to algoType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns algoType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from algoType
updateAlgoSettings(0, handles);

% --- Executes during object creation, after setting all properties.
function algoType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algoType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bulbCheck.
function bulbCheck_Callback(hObject, eventdata, handles)
% hObject    handle to bulbCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bulbCheck
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% --- Executes on button press in btnRender.
function btnRender_Callback(hObject, eventdata, handles)
% hObject    handle to btnRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
renderSub(1, 1, handles);

% --- Executes on button press in renderMandel.
function renderMandel_Callback(hObject, eventdata, handles)
% hObject    handle to renderMandel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of renderMandel
resizeAxes(handles);
if handles.autoRender.Value
    renderSub(1, 1, handles)
end

% --- Executes on button press in renderJulia.
function renderJulia_Callback(hObject, eventdata, handles)
% hObject    handle to renderJulia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of renderJulia
resizeAxes(handles);
if handles.autoRender.Value
    renderSub(1, 1, handles) 
end

% --- Executes on button press in autoRender.
function autoRender_Callback(hObject, eventdata, handles)
% hObject    handle to autoRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoRender
if hObject.Value
    renderSub(1, 1, handles) 
end

% --- Executes on button press in btnScreencap.
function btnScreencap_Callback(hObject, eventdata, handles)
% hObject    handle to btnScreencap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.renderMandel.Value
    [file,path] = uiputfile('*.png','Save Mandelbrot Set', 'mandelbrot.png');
    if file
        imwrite(handles.mandelImg.CData, [path file]); 
    end
end
if handles.renderJulia.Value
    [file,path] = uiputfile('*.png','Save Julia Set', 'julia.png');
    if file
        imwrite(handles.juliaImg.CData, [path file]); 
    end
end


function juliaCy_Callback(hObject, eventdata, handles)
% hObject    handle to juliaCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of juliaCy as text
%        str2double(get(hObject,'String')) returns contents of juliaCy as a double
updateTextBox(hObject, -Inf, Inf);
if handles.autoRender.Value
    renderSub(0, 1, handles)
end

% --- Executes during object creation, after setting all properties.
function juliaCy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to juliaCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function juliaCx_Callback(hObject, eventdata, handles)
% hObject    handle to juliaCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of juliaCx as text
%        str2double(get(hObject,'String')) returns contents of juliaCx as a double
updateTextBox(hObject, -Inf, Inf);
if handles.autoRender.Value
    renderSub(0, 1, handles)
end

% --- Executes during object creation, after setting all properties.
function juliaCx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to juliaCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function juliaZoom_Callback(hObject, eventdata, handles)
% hObject    handle to juliaZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of juliaZoom as text
%        str2double(get(hObject,'String')) returns contents of juliaZoom as a double
updateTextBox(hObject, 0.001, 1e13);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
if handles.autoRender.Value
    renderSub(0, 1, handles);  
end
% --- Executes during object creation, after setting all properties.
function juliaZoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to juliaZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function juliaRe_Callback(hObject, eventdata, handles)
% hObject    handle to juliaRe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of juliaRe as text
%        str2double(get(hObject,'String')) returns contents of juliaRe as a double
updateTextBox(hObject, -Inf, Inf);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
if handles.autoRender.Value
    renderSub(0, 1, handles);  
end

% --- Executes during object creation, after setting all properties.
function juliaRe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to juliaRe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function juliaIm_Callback(hObject, eventdata, handles)
% hObject    handle to juliaIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of juliaIm as text
%        str2double(get(hObject,'String')) returns contents of juliaIm as a double
updateTextBox(hObject, -Inf, Inf);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
if handles.autoRender.Value
    renderSub(0, 1, handles);  
end

% --- Executes during object creation, after setting all properties.
function juliaIm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to juliaIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resX_Callback(hObject, eventdata, handles)
% hObject    handle to resX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resX as text
%        str2double(get(hObject,'String')) returns contents of resX as a double
updateTextBox(hObject, 0,0, @checkRes, 1);
checkAutoRender(handles);
if handles.autoRender.Value
    renderSub(1, 1, handles);  
end

function [c,v] = checkRes(r)
r = deblank(r);
if endsWith(r,'max')
    c = -1;
    if length(r) > 3
        c = -str2double(deblank(r(1:end-3)));
    end
    v = ~isnan(c);
else
    c = str2double(r);
    v = ~isnan(c) && c == floor(c) && c >= 1;
end


% --- Executes during object creation, after setting all properties.
function resX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resY_Callback(hObject, eventdata, handles)
% hObject    handle to resY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resY as text
%        str2double(get(hObject,'String')) returns contents of resY as a double
updateTextBox(hObject, 0, 0, @checkRes, 1);
checkAutoRender(handles);
if handles.autoRender.Value
    renderSub(1, 1, handles);  
end

% --- Executes during object creation, after setting all properties.
function resY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dynamicZoom.
function dynamicZoom_Callback(hObject, eventdata, handles)
% hObject    handle to dynamicZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dynamicZoom


% --- Executes on button press in quickJulia.
function quickJulia_Callback(hObject, eventdata, handles)
% hObject    handle to quickJulia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quickJulia


% --- Executes on selection change in cMap.
function cMap_Callback(hObject, eventdata, handles)
% hObject    handle to cMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cMap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cMap
recomputeCmap(handles);

% --- Executes during object creation, after setting all properties.
function cMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorMethod.
function colorMethod_Callback(hObject, eventdata, handles)
% hObject    handle to colorMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colorMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorMethod
recomputeCmap(handles);

% --- Executes during object creation, after setting all properties.
function colorMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function colorMult_Callback(hObject, eventdata, handles)
% hObject    handle to colorMult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colorMult as text
%        str2double(get(hObject,'String')) returns contents of colorMult as a double
updateTextBox(hObject, 0.1, Inf);
recomputeCmap(handles);

% --- Executes during object creation, after setting all properties.
function colorMult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorMult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function colorRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mandelZoom_Callback(hObject, eventdata, handles)
% hObject    handle to mandelZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mandelZoom as text
%        str2double(get(hObject,'String')) returns contents of mandelZoom as a double
updateTextBox(hObject, 0.001, 1e13);
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);
if handles.autoRender.Value
    renderSub(1, 0, handles);  
end

% --- Executes during object creation, after setting all properties.
function mandelZoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mandelZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mandelCx_Callback(hObject, eventdata, handles)
% hObject    handle to mandelCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mandelCx as text
%        str2double(get(hObject,'String')) returns contents of mandelCx as a double
updateTextBox(hObject, -Inf, Inf);
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);
if handles.autoRender.Value
    renderSub(1, 0, handles);  
end

% --- Executes during object creation, after setting all properties.
function mandelCx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mandelCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mandelCy_Callback(hObject, eventdata, handles)
% hObject    handle to mandelCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mandelCy as text
%        str2double(get(hObject,'String')) returns contents of mandelCy as a double
updateTextBox(hObject, -Inf, Inf);
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);
if handles.autoRender.Value
    renderSub(1, 0, handles);  
end

% --- Executes during object creation, after setting all properties.
function mandelCy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mandelCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showAxes.
function showAxes_Callback(hObject, eventdata, handles)
% hObject    handle to showAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showAxes
if hObject.Value
    handles.axMandel.XTickMode = 'auto';
    handles.axMandel.YTickMode = 'auto';
    handles.axJulia.XTickMode = 'auto';
    handles.axJulia.YTickMode = 'auto';
else
    handles.axMandel.XTick = [];
    handles.axMandel.YTick = [];
    handles.axJulia.XTick = [];
    handles.axJulia.YTick = [];
end

% --- Executes on button press in btnResetView.
function btnResetView_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tbToReset = {handles.mandelCx, handles.mandelCy, handles.mandelZoom
             handles.juliaCx,  handles.juliaCy,  handles.juliaZoom};
for i=1:numel(tbToReset)
    tb = tbToReset{i};
    setSmartTb(tb, tb.UserData{3}, tb.UserData{2});
end

calculateAxis(handles.axMandel,handles.mandelCx.Value,...
    handles.mandelCy.Value,handles.mandelZoom.Value);
calculateAxis(handles.axJulia,handles.juliaCx.Value,...
    handles.juliaCy.Value,handles.juliaZoom.Value);

if handles.autoRender.Value
    renderSub(1, 1, handles); 
end

% --- Executes on button press in btnHelp.
function btnHelp_Callback(hObject, eventdata, handles)
% hObject    handle to btnHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnResetAll.
function btnResetAll_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mandelImg.CData = [];
handles.juliaImg.CData = [];

elems = struct2cell(handles);
for i=1:numel(elems)
    child = elems{i};
    if ~isequal(size(child), [1 1])
        continue; 
    end
    if isgraphics(child,'uicontrol') && ~strcmp(child.Enable, 'inactive')
        switch child.Style
            case 'edit'
                setSmartTb(child, child.UserData{3}, child.UserData{2});
            case {'checkbox', 'slider'}
                child.Value = child.UserData;
            case 'popupmenu'
                child.Value = 1;
        end
    end
end

title(handles.axMandel, 'Mandelbrot Set');
title(handles.axJulia, 'Julia Set');

handles.mandelImg.XData = [1e10 1e10+1];
handles.mandelImg.YData = [1e10 1e10+1];
handles.juliaImg.XData = [1e10 1e10+1];
handles.juliaImg.YData = [1e10 1e10+1];

handles.btnRender.UserData = 1;
updateAlgoSettings(0, handles);
recomputeCmap(handles);
resizeAxes(handles);

% --- Executes on mouse press over axes background.
function axMandel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axMandel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.quickJulia.Value && eventdata.Button == 3
    cpt = handles.axMandel.CurrentPoint(1,1:2);
    setSmartTb(handles.juliaRe, cpt(1));
    setSmartTb(handles.juliaIm, cpt(2));
    renderSub(0, 1, handles);
end

% --- Executes on slider movement.
function colorOffset_Callback(hObject, eventdata, handles)
% hObject    handle to colorOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
recomputeCmap(handles);

% --- Executes during object creation, after setting all properties.
function colorOffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function colorBias_Callback(hObject, eventdata, handles)
% hObject    handle to colorBias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
recomputeCmap(handles);

% --- Executes during object creation, after setting all properties.
function colorBias_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorBias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Set the value of a smart textbox
function setSmartTb(tb, value, valueStr)
    if nargin < 3
        valueStr = num2str(value); 
    end
    tb.Value = value;
    tb.String = valueStr;
    tb.UserData{1} = tb.String;

function updateAlgoSettings(forcePoly, handles)
% Polynomial is not of the "one power" form with degree larger than 0
if forcePoly
    if nnz(handles.customPoly.Value) ~= 1 ...
            || handles.customPoly.Value(end) ~= 1 ...
            || handles.customPoly.Value(1) ~= 0
        handles.currAlgo.String = 'SC any poly';
        handles.algoType.Value = 1;
        setSmartTb(handles.zPower, length(handles.customPoly.Value)-1);
        checkAutoRender(handles);
        return
    end
    setSmartTb(handles.zPower, length(handles.customPoly.Value)-1);
end
% Reset polynomial field
handles.customPoly.String = ['z^' handles.zPower.String];
updateTextBox(handles.customPoly, -Inf, Inf, @parsePolynomial);
% Choose algorithm tpye
algoType = {'SC ', 'RR '};
handles.currAlgo.String = algoType{handles.algoType.Value};
% Choose algorithm implementation
if handles.zPower.Value == 2
    handles.currAlgo.String = [handles.currAlgo.String 'optimized'];
else
    handles.currAlgo.String = [handles.currAlgo.String 'any power'];
end
checkAutoRender(handles);
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

function checkAutoRender(handles)
% Disables auto-render to protect the user from his foolishness if
% necessary.

% Number of visible plots
nVis = strcmp(handles.axMandel.Visible, 'on') + ...
        strcmp(handles.axJulia.Visible, 'on');
% get pixel size of largest axis
pxPos = max(getpixelposition(handles.axMandel),...
            getpixelposition(handles.axJulia));
res = [handles.resX.Value, handles.resY.Value];
% Handle 'max' res syntax
res = res.*((res > 0) - (res < 0).*pxPos(3:4));
% Total pixel count
pxCnt = nVis * prod(res);
% Max allowed auto render = 200 iterations at power 2 and 1 megapixel with
% combined zoom of 4000
zoomPenalty = log(handles.mandelZoom.Value + handles.juliaZoom.Value);
powerPenalty = 1 + 4*(handles.zPower > 2); % Min 5X overhead for unoptimized
if handles.itCnt.Value * pxCnt * powerPenalty * zoomPenalty > 2e9
    handles.autoRender.Value = 0;
    handles.autoRender.Enable = 'off';
else
     handles.autoRender.Enable = 'on';
end

function resizeAxes(handles)
if handles.renderMandel.Value && handles.renderJulia.Value
    handles.renderMandel.Enable = 'on';
    handles.renderJulia.Enable = 'on';
    
    handles.axMandel.Position = handles.origMandelPos;
    handles.axJulia.Position = handles.origJuliaPos;
    
    handles.axMandel.Visible = 1;
    handles.axJulia.Visible = 1;
    handles.mandelImg.Visible = 1;
    handles.juliaImg.Visible = 1;
elseif handles.renderMandel.Value
    handles.renderMandel.Enable = 'off';
    
    w = sum(handles.origJuliaPos([1,3])) - handles.origMandelPos(1);
    h = sum(handles.origJuliaPos([2,4])) - handles.origMandelPos(2);
    handles.axMandel.Position = [handles.origMandelPos(1:2) w h];
    
    handles.axMandel.Visible = 1;
    handles.axJulia.Visible = 0;
    handles.mandelImg.Visible = 1;
    handles.juliaImg.Visible = 0;
elseif handles.renderJulia.Value
    handles.renderJulia.Enable = 'off';
    
    w = sum(handles.origJuliaPos([1,3])) - handles.origMandelPos(1);
    h = sum(handles.origJuliaPos([2,4])) - handles.origMandelPos(2);
    handles.axJulia.Position = [handles.origMandelPos(1:2) w h];
    
    handles.axMandel.Visible = 0;
    handles.axJulia.Visible = 1;
    handles.mandelImg.Visible = 0;
    handles.juliaImg.Visible = 1;
end
checkAutoRender(handles);
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);

function renderSub(renderM, renderJ, handles)
if handles.autoRender.Value == 0
    handles.btnRender.Enable = 'off';
    drawnow();
end

resSettings = [handles.resX.Value, handles.resY.Value];
descToAlgo = containers.Map(...
{'SC optimized', 'SC any power', 'SC any poly', 'RR optimized', 'RR any power'}, ...
{'EscapeValue2', 'EscapeValue', 'EscapeValuePoly', 'QuadtreeFill2', 'QuadtreeFill'});

% Save iteration count of last render. The reason we put it there is so
% that it is part of a reference object so that if the handles object is
% outdated, it is still possible to obtain the current value.
if handles.btnRender.UserData ~= handles.itCnt.Value
    handles.btnRender.UserData = handles.itCnt.Value;
    recomputeCmap(handles);
end

% Mandelbrot render
if renderM && strcmp(handles.axMandel.Visible, 'on')
    mSpace = [handles.axMandel.XLim handles.axMandel.YLim];
    pxPos = getpixelposition(handles.axMandel);
    res = resSettings;
    for i=1:2
        if res(i) < 0; res(i) = round(-res(i) * pxPos(2+i)); end
    end
    tic();
    handles.mandelImg.UserData = mandelbrot(...
        handles.itCnt.Value, res, mSpace, ...
        'Algorithm', descToAlgo(handles.currAlgo.String), ...
        'SmoothRadius', 2, ...
        'Poly', handles.customPoly.Value, ...
        'BulbCheck', handles.bulbCheck.Value, ...
        'Exponent', handles.zPower.Value, ...
        'EscapeValue', handles.escVal.Value);
    renderTime = num2str(toc()); 
    title(handles.axMandel, ['Mandelbrot Set (T = ' renderTime ' sec)']);
    displaySets(1, 0, handles);
    handles.mandelImg.XData = handles.axMandel.XLim;
    handles.mandelImg.YData = handles.axMandel.YLim;
end
% Julia render
if renderJ && strcmp(handles.axJulia.Visible, 'on')
    mSpace = [handles.axJulia.XLim handles.axJulia.YLim];
    pxPos = getpixelposition(handles.axJulia);
    res = resSettings;
    for i=1:2
        if res(i) < 0; res(i) = round(-res(i) * pxPos(2+i)); end
    end
    juliaAlgo = ['SC ' handles.currAlgo.String(4:end)];
    juliaPt = handles.juliaRe.Value + 1i*handles.juliaIm.Value;
    tic();
    handles.juliaImg.UserData = julia(...
        juliaPt, handles.itCnt.Value, res, mSpace, ...
        'Algorithm', descToAlgo(juliaAlgo), ...
        'SmoothRadius', 2, ...
        'Poly', handles.customPoly.Value, ...
        'Exponent', handles.zPower.Value, ...
        'EscapeValue', handles.escVal.Value);
    renderTime = num2str(toc()); 
    title(handles.axJulia, ['Julia Set (T = ' renderTime ' sec)']);
    displaySets(0, 1, handles);
    handles.juliaImg.XData = handles.axJulia.XLim;
    handles.juliaImg.YData = handles.axJulia.YLim;
end

handles.btnRender.Enable = 'on';
drawnow();

function recomputeCmap(handles)
cname = handles.cMap.String{handles.cMap.Value};
fname = str2func(cname);
% Colormap size - Clamped between 512 (total 1024) and 8192 (total 16384)
% colors.
cCnt = min(max(handles.btnRender.UserData+1, 512), 8192);
% hsv color map is already periodic, so just create it larger
if strcmp(cname,'hsv')
    cData = fname(2*cCnt);
    nLoop = 2*cCnt - 1;
else
    cData = fname(cCnt+1);
    nLoop = cCnt;
end
% Maximum power bias, edge case -> binary image
if handles.colorBias.Value <= 0 || handles.colorBias.Value >= 1
    col = cData(nLoop * handles.colorBias.Value + 1,:);
    handles.cMap.UserData = repmat(col, 2*cCnt, 1);
else
    % Power adjust equation: x in [0 1] -> x^((1 - r)/r), r correction
    % factor
    power_adjust = (1 - handles.colorBias.Value)/handles.colorBias.Value;
    idxBias = floor(((0:nLoop)/nLoop) .^ power_adjust * nLoop) + 1; 
    cData = cData(idxBias,:);
    % Loop matrix around if not HSV for continuity
    if ~strcmp(cname, 'hsv')
        cData = [cData; cData(end-1:-1:2,:)]; 
    end
    % Perform mult + offset
    offset = handles.colorOffset.Value * nLoop;
    prePhase = (0:nLoop-1) * handles.colorMult.Value + offset;
    idxPhase = rem(floor(prePhase), 2*cCnt) + 1;
    % Assign phase + frequency transform
    handles.cMap.UserData = cData(idxPhase,:);
end
% Force re-render
displaySets(1,1,handles);

function displaySets(showM, showJ, handles)
dispCtrl = [showM showJ];
imObjs = {handles.mandelImg handles.juliaImg};
axObjs = {handles.axMandel handles.axJulia};
cMap = handles.cMap.UserData;
lenCMap = size(cMap,1);
itCnt = handles.btnRender.UserData;

% Measure time to color
ltime = tic();

for i=1:2
    im = imObjs{i};
    ax = axObjs{i};
    if ~dispCtrl(i) || strcmp(ax.Visible, 'off')
        continue;
    end
    
    % Compute integer and fractional parts of itData
    iPart = floor(im.UserData+1);
    fPart = im.UserData+1 - iPart;
    % Compute new mapped colors
    if handles.colorMethod.Value == 2
        % Histogram mode
        itArea = zeros(1,itCnt+1);
        for j=1:numel(iPart)
            itArea(iPart(j)) = itArea(iPart(j)) + 1;
        end
        itMap = zeros(1,itCnt);
        acc = 0;
        for j=1:itCnt
            itMap(j) = acc;
            acc = acc + itArea(j); 
        end
        itMap = itMap / acc;
    else
        % Linear mode
         itMap = (0:itCnt) / itCnt;
    end
    % Create a new map linear map from iterations to color map
    nMap = cMap(floor(itMap*(lenCMap - 1))+1,:); 
    % Using the calculated color map, convert iterations to RGB values
    imData = ind2rgb(iPart, nMap);
    % Presence of fractional iterations in image, interpolate
    if any(fPart(:))
        imData = (1 - fPart).*imData + fPart.*ind2rgb(iPart+1, nMap);
    end
    % Set the body of the Mandelbrot set to black
    imData(repmat(im.UserData,1,1,3) == itCnt) = 0;
    im.CData = imData; % Display the image data
end
