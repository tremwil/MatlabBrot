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

% Last Modified by GUIDE v2.5 05-Dec-2019 23:36:25

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mandelPlotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mandelPlotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtBoxPower_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxPower as text
%        str2double(get(hObject,'String')) returns contents of txtBoxPower as a double


% --- Executes during object creation, after setting all properties.
function txtBoxPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxEsc_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxEsc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxEsc as text
%        str2double(get(hObject,'String')) returns contents of txtBoxEsc as a double


% --- Executes during object creation, after setting all properties.
function txtBoxEsc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxEsc (see GCBO)
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



function txtBoxItCnt_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxItCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxItCnt as text
%        str2double(get(hObject,'String')) returns contents of txtBoxItCnt as a double


% --- Executes during object creation, after setting all properties.
function txtBoxItCnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxItCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxPoly_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxPoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxPoly as text
%        str2double(get(hObject,'String')) returns contents of txtBoxPoly as a double


% --- Executes during object creation, after setting all properties.
function txtBoxPoly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxPoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtBoxCurrAlg_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxCurrAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxCurrAlg as text
%        str2double(get(hObject,'String')) returns contents of txtBoxCurrAlg as a double


% --- Executes during object creation, after setting all properties.
function txtBoxCurrAlg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxCurrAlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dropDownAlgo.
function dropDownAlgo_Callback(hObject, eventdata, handles)
% hObject    handle to dropDownAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dropDownAlgo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropDownAlgo


% --- Executes during object creation, after setting all properties.
function dropDownAlgo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropDownAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbBulbCheck.
function cbBulbCheck_Callback(hObject, eventdata, handles)
% hObject    handle to cbBulbCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbBulbCheck


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


% --- Executes on button press in cbRenderMendel.
function cbRenderMendel_Callback(hObject, eventdata, handles)
% hObject    handle to cbRenderMendel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbRenderMendel


% --- Executes on button press in cbRenderJulia.
function cbRenderJulia_Callback(hObject, eventdata, handles)
% hObject    handle to cbRenderJulia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbRenderJulia


% --- Executes on button press in cbAutoRender.
function cbAutoRender_Callback(hObject, eventdata, handles)
% hObject    handle to cbAutoRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAutoRender


% --- Executes on button press in btnScreencap.
function btnScreencap_Callback(hObject, eventdata, handles)
% hObject    handle to btnScreencap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtBoxJuliaCy_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxJuliaCy as text
%        str2double(get(hObject,'String')) returns contents of txtBoxJuliaCy as a double


% --- Executes during object creation, after setting all properties.
function txtBoxJuliaCy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxJuliaCx_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxJuliaCx as text
%        str2double(get(hObject,'String')) returns contents of txtBoxJuliaCx as a double


% --- Executes during object creation, after setting all properties.
function txtBoxJuliaCx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxJuliaZoom_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxJuliaZoom as text
%        str2double(get(hObject,'String')) returns contents of txtBoxJuliaZoom as a double


% --- Executes during object creation, after setting all properties.
function txtBoxJuliaZoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxJuliaRe_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaRe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxJuliaRe as text
%        str2double(get(hObject,'String')) returns contents of txtBoxJuliaRe as a double


% --- Executes during object creation, after setting all properties.
function txtBoxJuliaRe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaRe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxJuliaIm_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxJuliaIm as text
%        str2double(get(hObject,'String')) returns contents of txtBoxJuliaIm as a double


% --- Executes during object creation, after setting all properties.
function txtBoxJuliaIm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxJuliaIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxResX_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxResX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxResX as text
%        str2double(get(hObject,'String')) returns contents of txtBoxResX as a double


% --- Executes during object creation, after setting all properties.
function txtBoxResX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxResX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxResY_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxResY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxResY as text
%        str2double(get(hObject,'String')) returns contents of txtBoxResY as a double


% --- Executes during object creation, after setting all properties.
function txtBoxResY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxResY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on selection change in dropDownCmap.
function dropDownCmap_Callback(hObject, eventdata, handles)
% hObject    handle to dropDownCmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dropDownCmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropDownCmap


% --- Executes during object creation, after setting all properties.
function dropDownCmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropDownCmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dropDownColor.
function dropDownColor_Callback(hObject, eventdata, handles)
% hObject    handle to dropDownColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dropDownColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dropDownColor


% --- Executes during object creation, after setting all properties.
function dropDownColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropDownColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxCMult_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxCMult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxCMult as text
%        str2double(get(hObject,'String')) returns contents of txtBoxCMult as a double


% --- Executes during object creation, after setting all properties.
function txtBoxCMult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxCMult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxSmoothR_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxSmoothR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxSmoothR as text
%        str2double(get(hObject,'String')) returns contents of txtBoxSmoothR as a double


% --- Executes during object creation, after setting all properties.
function txtBoxSmoothR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxSmoothR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxMandelZ_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxMandelZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxMandelZ as text
%        str2double(get(hObject,'String')) returns contents of txtBoxMandelZ as a double


% --- Executes during object creation, after setting all properties.
function txtBoxMandelZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxMandelZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxMandelCx_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxMandelCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxMandelCx as text
%        str2double(get(hObject,'String')) returns contents of txtBoxMandelCx as a double


% --- Executes during object creation, after setting all properties.
function txtBoxMandelCx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxMandelCx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtBoxMandelCy_Callback(hObject, eventdata, handles)
% hObject    handle to txtBoxMandelCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtBoxMandelCy as text
%        str2double(get(hObject,'String')) returns contents of txtBoxMandelCy as a double


% --- Executes during object creation, after setting all properties.
function txtBoxMandelCy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtBoxMandelCy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
