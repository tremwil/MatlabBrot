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

% Last Modified by GUIDE v2.5 08-Dec-2019 23:06:24

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
% Handle interactive axes
hObject.WindowButtonMotionFcn = @interactiveAxis;
hObject.WindowButtonDownFcn = @interactiveAxis;
hObject.WindowButtonUpFcn = @interactiveAxis;
hObject.WindowScrollWheelFcn = @interactiveAxis;
% Store default position of axis objects, aslo add titles
handles.origMandelPos = handles.axMandel.Position;
handles.origJuliaPos = handles.axJulia.Position;
title(handles.axMandel, 'Mandelbrot Set');
title(handles.axJulia, 'Julia Set');
% Pre-create a field for Julia and Mandelbrot image objects
handles.mandelImg = 0;
handles.juliaImg = 0;

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
updateTextBox(hObject, 1, Inf, @(p)deal(str2double(p),...
    str2double(p) == floor(str2double(p))));
updateAlgoSettings(0, handles);

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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



function itCnt_Callback(hObject, eventdata, handles)
% hObject    handle to itCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itCnt as text
%        str2double(get(hObject,'String')) returns contents of itCnt as a double
updateTextBox(hObject, 1, Inf, @(it)deal(str2double(it),...
    str2double(it) == floor(str2double(it))));

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
updateTextBox(hObject, -Inf, Inf, @parsePolynomial);
updateAlgoSettings(1, handles);

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


% --------------------------------------------------------------------
function mainMenu_Callback(hObject, eventdata, handles)
% hObject    handle to mainMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function currAlgo_Callback(hObject, eventdata, handles)
% hObject    handle to currAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currAlgo as text
%        str2double(get(hObject,'String')) returns contents of currAlgo as a double


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


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in btnRender.
function btnRender_Callback(hObject, eventdata, handles)
% hObject    handle to btnRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resSettings = [handles.resX.Value, handles.resY.Value];
descToAlgo = containers.Map(...
{'SC optimized', 'SC any power', 'SC any poly', 'RR optimized', 'RR any power'}, ...
{'EscapeValue2', 'EscapeValue', 'EscapeValuePoly', 'QuadtreeFill2', 'QuadtreeFill'});

% Mandelbrot render
if strcmp(handles.axMandel.Visible, 'on')
    mSpace = [handles.axMandel.XLim handles.axMandel.YLim];
    pxPos = getpixelposition(handles.axMandel);
    res = resSettings;
    for i=1:2
        if res(i) == -1; res(i) = pxPos(2+i); end
    end
    tic();
    itData = mandelbrot(handles.itCnt.Value, res, mSpace, ...
        'Algorithm', descToAlgo(handles.currAlgo.String), ...
        'SmoothRadius', handles.colorRadius.Value, ...
        'Poly', handles.customPoly.Value, ...
        'BulbCheck', handles.bulbCheck.Value, ...
        'Exponent', handles.zPower.Value, ...
        'EscapeValue', handles.escVal.Value);
    renderTime = num2str(toc()); 
    title(handles.axMandel, ['Mandelbrot Set (t = ' renderTime ' )']);
    if handles.mandelImg == 0
        handles.mandelImg = imagesc(handles.axMandel, 'CData', itData,...
            'XData', handles.axMandel.XLim, 'YData', handles.axMandel.YLim);
        guidata(hObject, handles);
    else
        handles.mandelImg.CData = itData;
        handles.mandelImg.XData = handles.axMandel.XLim;
        handles.mandelImg.YData = handles.axMandel.YLim;
    end
end
% Julia render
if strcmp(handles.axJulia.Visible, 'on')
    mSpace = [handles.axJulia.XLim handles.axJulia.YLim];
    pxPos = getpixelposition(handles.axJulia);
    res = resSettings;
    for i=1:2
        if res(i) == -1; res(i) = pxPos(2+i); end
    end
    juliaAlgo = ['SC ' handles.currAlgo.String(4:end)];
    juliaPt = handles.juliaRe.Value + 1i*handles.juliaIm.Value;
    tic();
    itData = julia(juliaPt, handles.itCnt.Value, res, mSpace, ...
        'Algorithm', descToAlgo(juliaAlgo), ...
        'SmoothRadius', handles.colorRadius.Value, ...
        'Poly', handles.customPoly.Value, ...
        'Exponent', handles.zPower.Value, ...
        'EscapeValue', handles.escVal.Value);
    renderTime = num2str(toc()); 
    title(handles.axJulia, ['Julia Set (t = ' renderTime ' )']);
    if handles.juliaImg == 0
        handles.juliaImg = imagesc(handles.axJulia, 'CData', itData,...
            'XData', handles.axJulia.XLim, 'YData', handles.axJulia.YLim);
        guidata(hObject, handles);
    else
        handles.juliaImg.CData = itData;
        handles.juliaImg.XData = handles.axJulia.XLim;
        handles.juliaImg.YData = handles.axJulia.YLim;
    end
end

%drawnow();


% --- Executes on button press in renderMandel.
function renderMandel_Callback(hObject, eventdata, handles)
% hObject    handle to renderMandel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of renderMandel
resizeAxes(handles);

% --- Executes on button press in renderJulia.
function renderJulia_Callback(hObject, eventdata, handles)
% hObject    handle to renderJulia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of renderJulia
resizeAxes(handles);

% --- Executes on button press in autoRender.
function autoRender_Callback(hObject, eventdata, handles)
% hObject    handle to autoRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoRender


% --- Executes on button press in btnScreencap.
function btnScreencap_Callback(hObject, eventdata, handles)
% hObject    handle to btnScreencap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function juliaCy_Callback(hObject, eventdata, handles)
% hObject    handle to juliaCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of juliaCy as text
%        str2double(get(hObject,'String')) returns contents of juliaCy as a double
updateTextBox(hObject, -Inf, Inf);

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
updateTextBox(hObject, 0.001, Inf);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);

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

function [c,v] = checkRes(r)
if strcmp(r,'max')
    c = -1;
    v = 1;
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
updateTextBox(hObject, 1, Inf, @checkRes);

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



function colorRadius_Callback(hObject, eventdata, handles)
% hObject    handle to colorRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colorRadius as text
%        str2double(get(hObject,'String')) returns contents of colorRadius as a double
updateTextBox(hObject, 2, Inf);

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
updateTextBox(hObject, 0.001, Inf);
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);

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
elems = struct2cell(handles);
for i=1:numel(elems)
    child = elems{i};
    if ~isequal(size(child), [1 1])
        continue; 
    end
    if isgraphics(child,'uicontrol') && strcmp(child.Enable, 'on')
        switch child.Style
            case 'edit'
                setSmartTb(child, child.UserData{3}, child.UserData{2});
            case 'checkbox'
                child.Value = child.UserData;
            case 'popupmenu'
                child.Value = 1;
        end
    end
end
calculateAxis(handles.axMandel,handles.mandelCx.Value,...
    handles.mandelCy.Value,handles.mandelZoom.Value);
calculateAxis(handles.axJulia,handles.juliaCx.Value,...
    handles.juliaCy.Value,handles.juliaZoom.Value);


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
        if handles.autoRender.Value
            btnRender_Callback(0, 0, handles);
        end
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

if handles.autoRender.Value
    btnRender_Callback(0, 0, handles);
end

function resizeAxes(handles)
if handles.renderMandel.Value && handles.renderJulia.Value
    handles.renderMandel.Enable = 'on';
    handles.renderJulia.Enable = 'on';
    
    handles.axMandel.Position = handles.origMandelPos;
    handles.axJulia.Position = handles.origJuliaPos;
    
    handles.axMandel.Visible = 1;
    handles.axJulia.Visible = 1;
elseif handles.renderMandel.Value
    handles.renderMandel.Enable = 'off';
    
    w = sum(handles.origJuliaPos([1,3])) - handles.origMandelPos(1);
    h = sum(handles.origJuliaPos([2,4])) - handles.origMandelPos(2);
    handles.axMandel.Position = [handles.origMandelPos(1:2) w h];
    
    handles.axMandel.Visible = 1;
    handles.axJulia.Visible = 0;
elseif handles.renderJulia.Value
    handles.renderJulia.Enable = 'off';
    
    w = sum(handles.origJuliaPos([1,3])) - handles.origMandelPos(1);
    h = sum(handles.origJuliaPos([2,4])) - handles.origMandelPos(2);
    handles.axJulia.Position = [handles.origMandelPos(1:2) w h];
    
    handles.axMandel.Visible = 0;
    handles.axJulia.Visible = 1;
end
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);


% --- Executes on mouse press over axes background.
function axMandel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axMandel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.quickJulia.Value && eventdata.Button == 3
    cpt = hObject.CurrentPoint(1,1:2);
    setSmartTb(handles.juliaRe, cpt(1));
    setSmartTb(handles.juliaIm, cpt(2));
end
