%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mandelPlotter.m          %
% AUTHOR: William Tremblay %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% Last Modified by GUIDE v2.5 14-Dec-2019 12:23:27

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
% Init images that will display the sets very off screeen
handles.mandelImg = image(handles.axMandel, 'CData', 0,...
    'XData', [1e10 1e10+1], 'YData', [1e10 1e10+1]);
handles.juliaImg = image(handles.axJulia, 'CData', 0,...
    'XData', [1e10 1e10+1], 'YData', [1e10 1e10+1]);
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
% Fix multiline tooltips
elems = struct2cell(handles);
for i=1:numel(elems)
    child = elems{i};
    if ~isequal(size(child), [1 1])
        continue; % Child is not a UI element
    end
    if isprop(child, 'Tooltip') && iscell(child.Tooltip)
        % Join tooltip strings into one with line breaks
        child.TooltipString = strjoin(child.Tooltip, '\n');
    end
end

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
% Update text box with a custom check for a positive integer
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
% Update text box with a custom check for a positive integer
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
% Update text box with a custom check for a positive integer
updateTextBox(hObject, 1, Inf, @(it)deal(str2double(it),...
    str2double(it) == floor(str2double(it))));
% Check if auto should be disabled automatically
checkAutoRender(handles);
% If no, perform the render
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
% Update text box with a custom check for a polynomial
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
% Force re-render if autorender on
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
% Update algorithm settings
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
% Re-render if autorender on
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% --- Executes on button press in btnRender.
function btnRender_Callback(hObject, eventdata, handles)
% Render upton clicking render button
renderSub(1, 1, handles);

% --- Executes on button press in renderMandel.
function renderMandel_Callback(hObject, eventdata, handles)
% Resize axes and re-render automatically if needed
resizeAxes(handles);

% --- Executes on button press in renderJulia.
function renderJulia_Callback(hObject, eventdata, handles)
% Resize axes and re-render automatically if needed
resizeAxes(handles);

% --- Executes on button press in autoRender.
function autoRender_Callback(hObject, eventdata, handles)
% If autoRender turned on, render
if hObject.Value
    renderSub(1, 1, handles) 
end

% --- Executes on button press in btnScreencap.
function btnScreencap_Callback(hObject, eventdata, handles)
% Check if Mandelbrot set is being rendered
if handles.renderMandel.Value
    % Query user save path
    [file,path] = uiputfile('*.png','Save Mandelbrot Set', 'mandelbrot.png');
    if file % If gave a valid path, save image color data with imwrite
        imwrite(handles.mandelImg.CData, [path file]); 
    end
end
% Check if Julia set is being rendered
if handles.renderJulia.Value
    % Query user save path
    [file,path] = uiputfile('*.png','Save Julia Set', 'julia.png');
    if file % If gave a valid path, save image color data with imwrite
        imwrite(handles.juliaImg.CData, [path file]); 
    end
end

function juliaCy_Callback(hObject, eventdata, handles)
% Update text box
% Recalculate axis
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
if handles.autoRender.Value % auto render if enabled
    renderSub(0, 1, handles);  
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
% Update text box
updateTextBox(hObject, -Inf, Inf);
% Recalculate axis
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
if handles.autoRender.Value % auto render if enabled
    renderSub(0, 1, handles);  
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
% Update text box
updateTextBox(hObject, 0.001, 1e13);
% Recalculate axis
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
if handles.autoRender.Value % auto render if enabled
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
% Update text box and render if needed
updateTextBox(hObject, -Inf, Inf);
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
% Update text box and render if needed
updateTextBox(hObject, -Inf, Inf);
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
% Update text box with custom check and render if needed
updateTextBox(hObject, 0,0, @checkRes, 1);
checkAutoRender(handles); % Disable auto-render if res to high
if handles.autoRender.Value
    renderSub(1, 1, handles);  
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
% Update text box with custom check and render if needed
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
% Unused callback


% --- Executes on button press in quickJulia.
function quickJulia_Callback(hObject, eventdata, handles)
% Unused callback

% --- Executes on selection change in cMap.
function cMap_Callback(hObject, eventdata, handles)
% Recompute color map
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
% Recompute color map
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
% Update text box and recompute color map
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
% Update zoom TB, recalculate axis and autorender if enabled
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
% Update Cx TB, recalculate axis and autorender if enabled
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
% Update Cy TB, recalculate axis and autorender if enabled
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
if hObject.Value % Axes enabled, set TickMode to auto
    handles.axMandel.XTickMode = 'auto';
    handles.axMandel.YTickMode = 'auto';
    handles.axJulia.XTickMode = 'auto';
    handles.axJulia.YTickMode = 'auto';
else % Axes disabled, remove tick marks
    handles.axMandel.XTick = [];
    handles.axMandel.YTick = [];
    handles.axJulia.XTick = [];
    handles.axJulia.YTick = [];
end

% --- Executes on button press in btnResetView.
function btnResetView_Callback(hObject, eventdata, handles)
% Cell array containing all fields to be reset
tbToReset = {handles.mandelCx, handles.mandelCy, handles.mandelZoom
             handles.juliaCx,  handles.juliaCy,  handles.juliaZoom};
for i=1:numel(tbToReset) % Iterate through each and reset to default value
    tb = tbToReset{i};
    % Reset smart TB with default string and numeric value
    setSmartTb(tb, tb.UserData{3}, tb.UserData{2});
end
% Recalcualte both axes
calculateAxis(handles.axMandel,handles.mandelCx.Value,...
    handles.mandelCy.Value,handles.mandelZoom.Value);
calculateAxis(handles.axJulia,handles.juliaCx.Value,...
    handles.juliaCy.Value,handles.juliaZoom.Value);
% Auto-render if enabled
if handles.autoRender.Value
    renderSub(1, 1, handles); 
end

% --- Executes on button press in btnHelp.
function btnHelp_Callback(hObject, eventdata, handles)
helpMenu();

% --- Executes on button press in btnResetAll.
function btnResetAll_Callback(hObject, eventdata, handles)
% Transform handles element to cell array
elems = struct2cell(handles);
for i=1:numel(elems) % For each element of handles struct
    child = elems{i};
    if ~isequal(size(child), [1 1]) % Check if single element
        continue; 
    end % Check if UI element and is not inactive
    if isgraphics(child,'uicontrol') && ~strcmp(child.Enable, 'inactive')
        switch child.Style
            case 'edit' % Smart edit box, reset to default value/string
                setSmartTb(child, child.UserData{3}, child.UserData{2});
            case {'checkbox', 'slider'}
                % For these default was stored in UserData
                child.Value = child.UserData;
            case 'popupmenu' % Popupmenu defaults is just the first elem.
                child.Value = 1;
        end
    end
end
% Reset titles
title(handles.axMandel, 'Mandelbrot Set');
title(handles.axJulia, 'Julia Set');
% Clear image CDATA for both sets
handles.mandelImg.CData = [];
handles.juliaImg.CData = [];
% Get images off the screen
handles.mandelImg.XData = [1e10 1e10+1];
handles.mandelImg.YData = [1e10 1e10+1];
handles.juliaImg.XData = [1e10 1e10+1];
handles.juliaImg.YData = [1e10 1e10+1];
% Reset last reender iteration count (stored in btnRender userData)
handles.btnRender.UserData = 1;
updateAlgoSettings(0, handles); % Re-check algo settings
recomputeCmap(handles);         % Recalculate color map
resizeAxes(handles);            % Resize axis objects back

% --- Executes on mouse press over axes background.
function axMandel_ButtonDownFcn(hObject, eventdata, handles)
% Check if quick Julia feature is enabled and right click is pressed
if handles.quickJulia.Value && eventdata.Button == 3
    cpt = handles.axMandel.CurrentPoint(1,1:2); % Current mouse pos in axis
    setSmartTb(handles.juliaRe, cpt(1));        % Set Julia re part to X
    setSmartTb(handles.juliaIm, cpt(2));        % Set Julia im part to Y
    renderSub(0, 1, handles);                   % Re-render Julia set
end

% --- Executes on slider movement.
function colorOffset_Callback(hObject, eventdata, handles)
% Force color map recalculation
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
% Force color map recalculation
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

%%%%%%%%%%%% END OF AUTOMATICALLY GENERATED CALLBACKS %%%%%%%%%%%%%
%%%%%%%%%%%% SUBROUTINES BELOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Small helper function to check resolution user input
function [c,v] = checkRes(r)
r = strtrim(r); % Remove spaces
if endsWith(r,'max') % max syntax
    c = -1;
    if length(r) > 3 % Number before
        c = -str2double(deblank(r(1:end-3)));
    end % valid only if c is not NaN or 0
    v = ~isnan(c) && c ~= 0;
else % Else just parse number normally, check if at least 1 px
    c = str2double(r);
    v = ~isnan(c) && c == floor(c) && c >= 1;
end

% Set the value of a smart textbox. Smart textboxes are update using the
% external updateTextBox function and are able to verify if user input is
% correct before accepting it. See updateTextBox.m for more info.
function setSmartTb(tb, value, valueStr)
    if nargin < 3  % Set string value to direct converstion from numeric
        valueStr = num2str(value); 
    end
    tb.Value = value;           % Set textbox value (curr. num. value)
    tb.String = valueStr;       % Set textbox string (curr. str. value)
    tb.UserData{1} = tb.String; % Set textbox last valid string

% Fix contradictions in algo settings (between power and custom poly)
% and choose the best specific algorithm for the situation.
function updateAlgoSettings(forcePoly, handles)
% Polynomial is not of the "one power" form with degree larger than 0
if forcePoly
    % Check if polynomial is not a perfect power, i.e. z^n
    if nnz(handles.customPoly.Value) ~= 1 ...
            || handles.customPoly.Value(end) ~= 1 ...
            || handles.customPoly.Value(1) ~= 0
        % Set algo to smooth color any polynomial
        handles.currAlgo.String = 'SC any poly';
        handles.algoType.Value = 1; % Force smooth color
        % Update value of Z power field to degree of polynomial
        setSmartTb(handles.zPower, length(handles.customPoly.Value)-1);
        checkAutoRender(handles); % Disable auto render if necessary
        return
    end % Just update Z power to degree
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
end % Disable auto render if necessary, otherwise auto-render
checkAutoRender(handles);
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% Disables auto-render to protect the user from his foolishness if
% necessary. This prevents the app from freezing for minutes if a very
% smart individual tries to pan a 8K 20000 iterations render with auto
% render.
function checkAutoRender(handles)
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
% Either iteraitons >= 5000, image has more than 2MP or power change
if handles.itCnt.Value >= 5000 || pxCnt > 2e6 || handles.zPower.Value > 2
    handles.autoRender.Value = 0;
end

% Resize axes to have a correct size depending on what is rendered
function resizeAxes(handles)
% Both Mandel and Julia are rendered
if handles.renderMandel.Value && handles.renderJulia.Value
    % Allow to disable any plot
    handles.renderMandel.Enable = 'on';
    handles.renderJulia.Enable = 'on';
    % Set graph positions to the original one
    handles.axMandel.Position = handles.origMandelPos;
    handles.axJulia.Position = handles.origJuliaPos;
    % Set all axes and images visible
    handles.axMandel.Visible = 1;
    handles.axJulia.Visible = 1;
    handles.mandelImg.Visible = 1;
    handles.juliaImg.Visible = 1;
% Only Mandel is on
elseif handles.renderMandel.Value
    % Prevent user from disabling all graphs
    handles.renderMandel.Enable = 'off';
    % Compute fullscreen width and height
    w = sum(handles.origJuliaPos([1,3])) - handles.origMandelPos(1);
    h = sum(handles.origJuliaPos([2,4])) - handles.origMandelPos(2);
    handles.axMandel.Position = [handles.origMandelPos(1:2) w h];
    % Set Julia stuff to invisible
    handles.axJulia.Visible = 0;
    handles.juliaImg.Visible = 0;
% Only Julia is on
elseif handles.renderJulia.Value
    % Prevent user from disabling all graphs
    handles.renderJulia.Enable = 'off';
    % Compute fullscreen width and height
    w = sum(handles.origJuliaPos([1,3])) - handles.origMandelPos(1);
    h = sum(handles.origJuliaPos([2,4])) - handles.origMandelPos(2);
    handles.axJulia.Position = [handles.origMandelPos(1:2) w h];
    % Set Mandel stuff to invisible
    handles.axMandel.Visible = 0;
    handles.mandelImg.Visible = 0;
end
% Verify if auto-render should be left on
checkAutoRender(handles);
% Recalculate axis numberings
calculateAxis(handles.axMandel, handles.mandelCx.Value, ...
    handles.mandelCy.Value, handles.mandelZoom.Value);
calculateAxis(handles.axJulia, handles.juliaCx.Value, ...
    handles.juliaCy.Value, handles.juliaZoom.Value);
% Auto render if necessary 
if handles.autoRender.Value
    renderSub(1, 1, handles);
end

% Render subroutine. Will render sets it was told to with the two bool
% arguments.
function renderSub(renderM, renderJ, handles)
% If auto render is off, disable btnRender until render is done
% drawnow() called to update the GUI so it shows the btn was disabled
if handles.autoRender.Value == 0
    handles.btnRender.Enable = 'off';
    drawnow();
end
% Store resolution settings and map to convert UI algo names to true names
resSettings = [handles.resX.Value, handles.resY.Value];
descToAlgo = containers.Map(...
{'SC optimized', 'SC any power', 'SC any poly', 'RR optimized', 'RR any power'}, ...
{'EscapeValue2', 'EscapeValue', 'EscapeValuePoly', 'QuadtreeFill2', 'QuadtreeFill'});

% Save iteration count of last render. The reason we put it there is so
% that it is part of a reference object so that if the handles object is
% outdated, it is still possible to obtain the current value.
if handles.btnRender.UserData ~= handles.itCnt.Value
    handles.btnRender.UserData = handles.itCnt.Value;
     % Recompute color map so coloring is accurate
    recomputeCmap(handles, 1); % 1 for no auto re-coloring
end

% Mandelbrot render
if renderM && strcmp(handles.axMandel.Visible, 'on')
    % Compute algorithm parameters
    mSpace = [handles.axMandel.XLim handles.axMandel.YLim];
    pxPos = getpixelposition(handles.axMandel);
    res = resSettings;
    for i=1:2 % Handle 'max' notation, stored as neg. number
        if res(i) < 0; res(i) = round(-res(i) * pxPos(2+i)); end
    end
    % Start time measuring and call render method, storing iteration
    % counts if mandelImg's UserData. This allows to change coloring
    % withouy re-render.
    tic();
    handles.mandelImg.UserData = mandelbrot(...
        handles.itCnt.Value, res, mSpace, ...
        'Algorithm', descToAlgo(handles.currAlgo.String), ...
        'SmoothRadius', 2, ...
        'Poly', handles.customPoly.Value, ...
        'BulbCheck', handles.bulbCheck.Value, ...
        'Exponent', handles.zPower.Value, ...
        'EscapeValue', handles.escVal.Value);
    renderTime = num2str(toc()); % Display render time in title of graph
    title(handles.axMandel, ['Mandelbrot Set (T = ' renderTime ' sec)']);
    displaySets(1, 0, handles); % Perform coloring and image displaying
    % Change position of render to new one
    handles.mandelImg.XData = handles.axMandel.XLim;
    handles.mandelImg.YData = handles.axMandel.YLim;
end
% Julia render
if renderJ && strcmp(handles.axJulia.Visible, 'on')
    % Compute algorithm parameters
    mSpace = [handles.axJulia.XLim handles.axJulia.YLim];
    pxPos = getpixelposition(handles.axJulia);
    res = resSettings;
    for i=1:2 % Handle 'max' notation, stored as neg. number
        if res(i) < 0; res(i) = round(-res(i) * pxPos(2+i)); end
    end
    juliaAlgo = ['SC ' handles.currAlgo.String(4:end)];
    juliaPt = handles.juliaRe.Value + 1i*handles.juliaIm.Value;
    tic(); % Time + store it. mat. Julia to juliaImg.UserData
    handles.juliaImg.UserData = julia(...
        juliaPt, handles.itCnt.Value, res, mSpace, ...
        'Algorithm', descToAlgo(juliaAlgo), ...
        'SmoothRadius', 2, ...
        'Poly', handles.customPoly.Value, ...
        'Exponent', handles.zPower.Value, ...
        'EscapeValue', handles.escVal.Value);
    renderTime = num2str(toc()); % Display render time in title of graph
    title(handles.axJulia, ['Julia Set (T = ' renderTime ' sec)']);
    displaySets(0, 1, handles); % Perform coloring and image displaying
    % Change position of render to new one
    handles.juliaImg.XData = handles.axJulia.XLim;
    handles.juliaImg.YData = handles.axJulia.YLim;
end
% Re-enable render button and drawnow to reload visuals
handles.btnRender.Enable = 'on';
drawnow();

% Recompute custom colormap based on user settings, and recalculate the
% color for the last iteration count matrix.
function recomputeCmap(handles, noReColor)
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
if nargin == 1 || ~noReColor % Force re-color unless specified
    displaySets(1,1,handles);
end

% Perform the coloring and displaying of the existing iteration data.
% Called real time after any color setting changes
function displaySets(showM, showJ, handles)
dispCtrl = [showM showJ];                       % Bool to color each set
imObjs = {handles.mandelImg handles.juliaImg};  % Mandel/Julia img objs
axObjs = {handles.axMandel handles.axJulia};    % mandel/Julia axis objs
cMap = handles.cMap.UserData;                   % current calc. colormap
lenCMap = size(cMap,1);                         % size of colormap
itCnt = handles.btnRender.UserData;             % iter. cnt. of last render
% For each set (Mandelbrot/Julia)
for i=1:2
    im = imObjs{i}; % Get img object
    ax = axObjs{i}; % Get axis object
    if ~dispCtrl(i) || strcmp(ax.Visible, 'off')
        continue; % Axis invisible or no coloring flag, continue
    end
    % Compute integer and fractional parts of itData
    iPart = floor(im.UserData+1);
    fPart = im.UserData+1 - iPart;
    % Compute new mapped colors
    if handles.colorMethod.Value == 2
        % Histogram mode
        itArea = zeros(1,itCnt+2);
        for j=1:numel(iPart) % Store number of px. to reach given it.cnt.
            itArea(iPart(j)) = itArea(iPart(j)) + 1;
        end
        itMap = zeros(1,itCnt); % Create map of itCnt->norm. color value
        acc = 0; % Accumulator fox pixels
        for j=1:itCnt
            itMap(j) = acc; % Store current position
            acc = acc + itArea(j); % Accumulate for next one
        end % Normalize based on total iterations for whole render
        itMap = itMap / acc;
    else % Linear color mode, so linear uniform map
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
