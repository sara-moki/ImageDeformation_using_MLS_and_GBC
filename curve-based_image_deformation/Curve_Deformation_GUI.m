function varargout = Curve_Deformation_GUI(varargin)
% CURVE_DEFORMATION_GUI MATLAB code for Curve_Deformation_GUI.fig 
% Last Modified by GUIDE v2.5 02-Feb-2022 14:49:39
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Curve_Deformation_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Curve_Deformation_GUI_OutputFcn, ...
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


% --- Executes just before Curve_Deformation_GUI is made visible.
function Curve_Deformation_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
hold on;
axis equal;
guidata(hObject, handles);
ud.alpha = str2double(get(handles.alpha,'string'));
ud.xG_number = str2double(get(handles.Gaussian_Points,'string'));
[ud.xG,ud.wG]=lgwt(ud.xG_number,0,1);
ud.figure = handles.figure1;
ud.hdeformation = [];
ud.index=0;
ud.count=0;
set(handles.figure1,'userdata',ud);


% --- Outputs from this function are returned to the command line.
function varargout = Curve_Deformation_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in image.
function image_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.resol_row = str2double(get(handles.resolution_r,'string'));
ud.resol_column = str2double(get(handles.resolution_c,'string'));
ud.sub_resol_c = str2double(get(handles.sub_resol_c,'string'));
ud.sub_resol_r = str2double(get(handles.sub_resol_r,'string'));
resol_c_divid=(ud.resol_column)/ud.sub_resol_c;
resol_r_divid=(ud.resol_row)/ud.sub_resol_r;
isaninteger =@(x) mod(x, 1) == 0;   
    if  0 == isaninteger(resol_r_divid) && 0==isaninteger(resol_c_divid) 
        ud.resol_row = ud.resol_row+(ud.sub_resol_r - mod(ud.resol_row,ud.sub_resol_r)) ;
        ud.resol_column = ud.resol_column+(ud.sub_resol_c - mod(ud.resol_column,ud.sub_resol_c)) ;           
    end 
[filename,pathname]=uigetfile('*.*');
Im = flipud(imresize(imread(filename),[ud.resol_row+1,ud.resol_column+1]));
[ud.xfine,ud.yfine] = meshgrid(1:1:ud.resol_row+1,1:1:ud.resol_column+1);
[ud.xcoarse,ud.ycoarse] = meshgrid(1:resol_r_divid:ud.resol_row+1,1:resol_c_divid:ud.resol_column+1);
Z = zeros(size(Im,2),size(Im,1));
ud.hpatch = surf(ud.xfine,ud.yfine,Z,Im, ... % Plot surface
'FaceColor', 'texturemap', ...
'EdgeColor', 'none');
ud.xx = ud.xcoarse(:)';
ud.yy = ud.ycoarse(:)';
hold on; 
set(ud.hpatch,'linestyle','none');
set(gca,'XTick',[],'YTick',[])
% set(gca,'xlim',[-20,800],'ylim',[-20,700]);
set(handles.figure1,'userdata',ud);

% --- Executes on button press in grid.
function grid_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.anim_mode='image';
ud.resol_row = str2double(get(handles.resolution_r,'string'));
ud.resol_column = str2double(get(handles.resolution_c,'string'));
ud.sub_resol_c = str2double(get(handles.sub_resol_c,'string'));
ud.sub_resol_r = str2double(get(handles.sub_resol_r,'string'));
resol_c_divid=(ud.resol_column)/ud.sub_resol_c;
resol_r_divid=(ud.resol_row)/ud.sub_resol_r;
isaninteger =@(x) mod(x, 1) == 0;   
if  0 == isaninteger(resol_r_divid) && 0==isaninteger(resol_c_divid) 
        ud.resol_row = ud.resol_row+(ud.sub_resol_r - mod(ud.resol_row,ud.sub_resol_r)) ;
        ud.resol_column = ud.resol_column+(ud.sub_resol_c - mod(ud.resol_column,ud.sub_resol_c)) ;           
end 
[ud.xfine,ud.yfine] = meshgrid(1:1:ud.resol_row+1,1:1:ud.resol_column+1);
[ud.xcoarse,ud.ycoarse] = meshgrid(1:resol_r_divid:ud.resol_row+1,1:resol_c_divid:ud.resol_column+1);
hgrid = mesh(ud.xfine,ud.yfine);
delete(hgrid);
Z = zeros(ud.resol_row+1,ud.resol_column+1);
ud.hpatch = surf(ud.xfine,ud.yfine,Z, ... % Plot surface 
 'EdgeColor', 'k','linewidth',1);
ud.xx = ud.xcoarse(:)';
ud.yy = ud.ycoarse(:)';
hold on; 
%  plot(ud.xx,ud.yy,'ro');
set(ud.hpatch,'Facealpha',0);
set(handles.figure1,'userdata',ud);


% --- Executes on button press in spline.
function spline_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
axis manual
seltype = get(gcf,'SelectionType');
ud.index=ud.index+1;
ud.InputSplinePoints{ud.index}=[];%index of the spline curve
ud.count = max(length(ud.InputSplinePoints{1})*(ud.index-1),0);

while strcmpi(seltype,'normal')
      w = waitforbuttonpress;
      seltype = get(gcf,'SelectionType');
      if strcmpi(seltype,'normal')       
         currPt = get(handles.image_axis,'CurrentPoint');
         hold on;
         ud.InputSplinePoints{ud.index} =[ud.InputSplinePoints{ud.index};[currPt(1,1),currPt(1,2)]];
         hold on;
         ud.count=ud.count+1;
         ud.hmarker{ud.count}=plot(currPt(1,1),currPt(1,2),'o','MarkerSize',8,'MarkerFaceColor','b');         
      end
end
xs=linspace(0,1,100);
xs1=linspace(0,1,length(ud.InputSplinePoints{ud.index}));
ud.pp{ud.index}=spline(xs1,[ud.InputSplinePoints{ud.index}(:,1)';ud.InputSplinePoints{ud.index}(:,2)']);
x1=ppval(ud.pp{ud.index},xs');
ud.InputPoints{ud.index} = ppval(ud.pp{ud.index},ud.xG');
diff_InputCurve=fnder(ud.pp{ud.index},1);  
ud.diff_value{ud.index}=ppval(diff_InputCurve,ud.xG);
hold on;
ud.pp1{ud.index}=plot(x1(1,:),x1(2,:),'color',[0 1/ud.index 1/ud.index],'LineWidth',3);
ud.pp2{ud.index}= plot(ud.InputPoints{ud.index}(1,:),ud.InputPoints{ud.index}(2,:),'o','MarkerSize',1,'MarkerFaceColor','r');
ud.OutputSplinePoints=ud.InputSplinePoints;
ud.OutputPoints_based = ud.InputPoints ;
ud.qq=ud.pp;
ud.indexG=ud.index;
set(handles.figure1,'userdata',ud);




% --- Executes on button press in interactive_button.
function interactive_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
        waitforbuttonpress;
        currPt = get(gca,'CurrentPoint');
        ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2);     
        ud.InputSplinePointsG=cell2mat(ud.InputSplinePoints');% must choose the same number of points for each spline
        ud.A=ud.InputSplinePointsG;
        ud.B = (cell2mat(ud.InputPoints))';
        ud.indexFound=findClosestControl(ncurrPt,ud.A);
        ud.index=floor(ud.indexFound/(length(ud.InputSplinePoints{1})+1))+1;
        set(ud.figure,'WindowButtonMotionFcn','animator_curve move')
        set(ud.figure,'WindowButtonUpFcn','animator_curve stop');        
set(handles.figure1,'userdata',ud);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
cla;
handles.output = hObject;
hold on;
axis auto;
guidata(hObject, handles);
ud.alpha = str2double(get(handles.alpha,'string'));
ud.xG_number = str2double(get(handles.Gaussian_Points,'string'));
[ud.xG,ud.wG]=lgwt(ud.xG_number,0,1);
ud.figure = handles.figure1;
ud.hdeformation = [];
ud.index=0;
ud.count=0;
set(handles.figure1,'userdata',ud);
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Print.
function Print_Callback(hObject, eventdata, handles)
get(handles.figure1,'userdata');
ax = gcf;
filter = {'*.jpg';'*.png';'*.tif';'*.pdf';'*.eps'};
[filename,filepath] = uiputfile(filter);
if ischar(filename)
    exportgraphics(ax,[filepath filename]);
end


% --- Executes on slider movement.
function alpha_slider_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.alpha = get(handles.alpha_slider,'value');
set(handles.alpha,'string',num2str(ud.alpha));
set(handles.figure1,'userdata',ud);

% --- Executes during object creation, after setting all properties.
function alpha_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function alpha_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
slider_value = get(handles.aplha_slider,'value');
set(handles.figure1,'userdata',ud);

% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function resolution_r_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function resolution_r_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function resolution_c_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function resolution_c_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sub_resol_r_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sub_resol_r_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sub_resol_c_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function sub_resol_c_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [indexFound]=findClosestControl(hnewPoint,pointsXY)
nPoints=size(pointsXY,1);
normpoints = zeros(1,nPoints);
for i=1:nPoints
    normpoints(i) = norm(pointsXY(i,:)-hnewPoint);
end
[C,indexFound] = min(normpoints);



function Gaussian_Points_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.xG_number =  str2double(get(hObject,'String')) ;
[ud.xG,ud.wG]=lgwt(ud.xG_number,0,1);
set(handles.figure1,'userdata',ud);


% --- Executes during object creation, after setting all properties.
function Gaussian_Points_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Curve_based.
function Curve_based_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Point_based,'value',0);
set(handles.Curve_based,'value',1);
contents = cellstr(get(hObject,'String'));
ud.deformation = contents(get(hObject,'Value'));
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Point_based.
function Point_based_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Point_based,'value',1);
set(handles.Curve_based,'value',0);
contents = cellstr(get(hObject,'String'));
ud.deformation = contents(get(hObject,'Value'));
set(handles.figure1,'userdata',ud);


% --- Executes on selection change in Method.
function Method_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
contents = cellstr(get(hObject,'String'));
ud.method = contents(get(hObject,'Value'));
if strcmp(ud.method,'Affine')
   ud.method = 'Affine';
elseif  strcmp(ud.method,'Similar')
   ud.method = 'Similar';
elseif   strcmp(ud.method,'Rigid')
    ud.method = 'Rigid';
end 
set(handles.figure1,'userdata',ud);

% --- Executes during object creation, after setting all properties.
function Method_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
