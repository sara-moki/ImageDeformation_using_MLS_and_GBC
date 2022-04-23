function varargout = Comb_Region_Image_DeformationGUI(varargin)
% Comb_Region_Image_DeformationGUI MATLAB code for Comb_Region_Image_DeformationGUI.fig
%      Comb_Region_Image_DeformationGUI, by itself, creates a new Comb_Region_Image_DeformationGUI or raises the existing
%      singleton*.
%
%      H = Comb_Region_Image_DeformationGUI returns the handle to a new Comb_Region_Image_DeformationGUI or the handle to
%      the existing singleton*.
%
%      Comb_Region_Image_DeformationGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Comb_Region_Image_DeformationGUI.M with the given input arguments.
%
%      Comb_Region_Image_DeformationGUI('Property','Value',...) creates a new Comb_Region_Image_DeformationGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Comb_Region_Image_DeformationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Region_Image_DeformationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Comb_Region_Image_DeformationGUI

% Last Modified by GUIDE v2.5 23-Apr-2022 16:36:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Comb_Region_Image_DeformationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Comb_Region_Image_DeformationGUI_OutputFcn, ...
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

function Comb_Region_Image_DeformationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Comb_Region_Image_DeformationGUI (see VARARGIN)

% Choose default command line output for Comb_Region_Image_DeformationGUI
handles.output = hObject;
% Update handles structure
hold on;
axis equal;
guidata(hObject, handles);
ud.alpha = str2double(get(handles.alpha,'string'));
ud.figure = handles.figure1;
ud.hdeformation = [];
ud.index=0;%%%%
ud.method='Affine';
ud.GBC = 'MVC';
ud.animation = 'Translation';
ud.xG_number = str2double(get(handles.Leg_points,'string'));
ud.yG_number = ud.xG_number;
[ud.xG,ud.w1G]=lgwt(ud.xG_number,0,1);
[ud.yG,ud.w2G]=lgwt(ud.xG_number,0,1);
[ud.a,ud.b] = meshgrid(ud.xG,ud.yG);
h=10^-4;
%%%%%%%%%%%% Parametrization
uxG = (2.*ud.a-1).*sqrt(1-(((2.*ud.b-1).^2)./2));
uxGHa = ((2.*ud.a-1)+h).*sqrt(1-(((2.*ud.b-1).^2)./2));
uxGHb =  (2.*ud.a-1).*sqrt(1-((((2.*ud.b-1)+h).^2)./2));
vyG = (2.*ud.b-1).*sqrt(1-(((2.*ud.a-1).^2)./2));
vyGHa = (2.*ud.b-1).*sqrt(1-((((2.*ud.a-1)+h).^2)./2));
vyGHb = ((2.*ud.b-1)+h).*sqrt(1-(((2.*ud.a-1).^2)./2));
ud.Leg_theta = atan2(vyG,uxG);
ud.Leg_r = (uxG.^2+vyG.^2);
ud.Leg_theta_xu = atan2(vyG,uxGHa);
ud.Leg_theta_xv = atan2(vyGHa,uxG);
ud.Leg_theta_yu = atan2(vyG,uxGHb);
ud.Leg_theta_yv = atan2(vyGHb,uxG);
ud.Leg_rxu = (uxGHa.^2+vyG.^2);
ud.Leg_rxv = (uxG.^2+vyGHa.^2);
ud.Leg_ryu = (uxGHb.^2+vyG.^2);
ud.Leg_ryv = (uxG.^2+vyGHb.^2);
ud.Jac_P =[];
set(handles.figure1,'userdata',ud);

function varargout = Comb_Region_Image_DeformationGUI_OutputFcn(hObject,eventdata, handles)
varargout{1} = handles.output;

function grid_Callback(hObject,eventdata, handles)
ud = get(handles.figure1,'userdata');
[ud.xx, ud.yy, ud.xfine,ud.yfine, ud.xcoarse, ud.ycoarse, ud.hpatch] = plot_grid(handles);
hold on; 
%  plot(ud.xx,ud.yy,'ro');
ud.xx2=ud.xx;ud.yy2=ud.yy;
set(ud.hpatch,'Facealpha',0);
set(handles.figure1,'userdata',ud);

function image_Callback(hObject,eventdata, handles)
 ud = get(handles.figure1,'userdata');
[ud.xx,ud.yy, ud.xfine,ud.yfine,ud.xcoarse,ud.ycoarse, ud.hpatch] = imTomesh(handles);
hold on; 
%  plot(ud.xx,ud.yy,'ro');
ud.xx2=ud.xx;ud.yy2=ud.yy;
set(ud.hpatch,'linestyle','none');
set(handles.figure1,'userdata',ud);


function resolution_r_CreateFcn(hObject,eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function resolution_r_Callback(hObject,eventdata, handles)


function resolution_c_CreateFcn(hObject,eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function resolution_c_Callback(hObject,eventdata, handles)


function sub_resol_r_CreateFcn(hObject,eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sub_resol_r_Callback(hObject,eventdata, handles)


function sub_resol_c_CreateFcn(hObject,eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sub_resol_c_Callback(~, ~, ~)


function affine_button_Callback(hObject,eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Similar_button,'value',0);
set(handles.affine_button,'value',1);
set(handles.Rigid_button,'value',0);
ud.method='Affine';
set(handles.figure1,'userdata',ud);

function Similar_button_Callback(hObject,eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Similar_button,'value',1);
set(handles.affine_button,'value',0);
set(handles.Rigid_button,'value',0);
ud.method='Similar';
set(handles.figure1,'userdata',ud);

function Rigid_button_Callback(hObject,eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Similar_button,'value',0);
set(handles.affine_button,'value',0);
set(handles.Rigid_button,'value',1);
ud.method='Rigid';
set(handles.figure1,'userdata',ud);

function alpha_slider_Callback(hObject,eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.alpha = get(handles.alpha_slider,'value');
set(handles.alpha,'string',num2str(ud.alpha));
set(handles.figure1,'userdata',ud);

function alpha_slider_CreateFcn(hObject,eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function alpha_Callback(~, ~, handles)
ud = get(handles.figure1,'userdata');
ud.alpha = get(handles.alpha,'string');
set(handles.figure1,'userdata',ud);

function alpha_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Param_Region_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');end

% --- Executes on button press in MVC_deform.
function MVC_deform_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.MVC_deform,'value',1);
set(handles.Translation,'value',0);
contents = cellstr(get(hObject,'String'));
ud.animation = contents(get(hObject,'Value'));
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Translation.
function Translation_Callback(hObject, eventdata, handles)
% hObject    handle to Translation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(handles.figure1,'userdata');
set(handles.MVC_deform,'value',0);
set(handles.Translation,'value',1);
contents = cellstr(get(hObject,'String'));
ud.animation = contents(get(hObject,'Value'));
set(handles.figure1,'userdata',ud);




function Leg_points_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Leg_points_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Wachspress.
function Wachspress_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Wachspress,'value',1);
set(handles.MVC,'value',0);
ud.GBC='Wachspress';
set(handles.figure1,'userdata',ud);

% --- Executes on button press in MVC.
function MVC_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Wachspress,'value',0);
set(handles.MVC,'value',1);
ud.GBC='MVC';
set(handles.figure1,'userdata',ud);


% --- Executes on selection change in Handle_Color.
function Handle_Color_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
contents = cellstr(get(hObject,'String'));% returns Handle_Color contents as cell array
ud.Handle_Color = contents{get(hObject,'Value')};
set(handles.figure1,'userdata',ud);% returns selected item from Handle_Color


% --- Executes during object creation, after setting all properties.
function Handle_Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
get(handles.figure1,'userdata');
ax = gcf;
filter = {'*.jpg';'*.png';'*.tif';'*.pdf';'*.eps'};
[filename,filepath] = uiputfile(filter);
if ischar(filename)
    exportgraphics(ax,[filepath filename]);
end

       
