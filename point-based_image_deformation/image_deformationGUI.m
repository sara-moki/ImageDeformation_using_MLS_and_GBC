function varargout = image_deformationGUI(varargin)
% IMAGE_DEFORMATIONGUI MATLAB code for image_deformationGUI.fig
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_deformationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @image_deformationGUI_OutputFcn, ...
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

% --- Executes just before image_deformationGUI is made visible.
function image_deformationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
hold on; 
axis equal;
ud.figure = handles.figure1;
ud.hdeformation = [];
ud.method='Affine';
ud.InputPoints = [];
ud.OutputPoints = [];
ud.alpha = str2double(get(handles.slider_value,'string'));
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Line.
function Line_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
xx=ones(1,20);
yy=(1:1:20);
hold on; 
axis equal;
axis equal; plot(xx,yy);
ud.xx = xx; ud.yy = yy;
ud.anim_mode='curve';
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Circle.
function Circle_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
xx = cos((0:0.01:2*pi));
yy = sin((0:0.01:2*pi));
hold on; 
axis equal;
axis equal; plot(xx,yy);
ud.xx = xx; ud.yy = yy;
ud.anim_mode='curve';
set(handles.figure1,'userdata',ud);


% --- Outputs from this function are returned to the command line.
function varargout = image_deformationGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in affine_button.
function affine_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Similar_button,'value',0);
set(handles.affine_button,'value',1);
set(handles.Rigid_button,'value',0);
ud.method='Affine';
set(handles.figure1,'userdata',ud);


% --- Executes on button press in Similar_button.
function Similar_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Similar_button,'value',1);
set(handles.affine_button,'value',0);
set(handles.Rigid_button,'value',0);
ud.method='Similar';
set(handles.figure1,'userdata',ud);



% --- Executes on button press in Rigid_button.
function Rigid_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Similar_button,'value',0);
set(handles.affine_button,'value',0);
set(handles.Rigid_button,'value',1);
ud.method='Rigid';
set(handles.figure1,'userdata',ud);


% --- Executes on button press in select_markers_button.
function select_markers_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
seltype = get(gcf,'SelectionType');
count = max(length(ud.InputPoints),0);
while strcmpi(seltype,'normal')
   waitforbuttonpress;
   seltype = get(gcf,'SelectionType');
   if strcmpi(seltype,'normal')
      currPt = get(handles.image_axis,'CurrentPoint');
      count=count+1;
      hold on;
      ud.InputPoints =[ud.InputPoints;[currPt(1,1),currPt(1,2)]];
      hold on;
      ud.hmarker{count}=plot(currPt(1,1),currPt(1,2),'o','MarkerSize',11,'MarkerFaceColor','g');
   end
end
ud.OutputPoints = ud.InputPoints;
for i=1:length(ud.InputPoints)
   ud.animated_curve{i} = [];
   ud.indexFoundSize(i) = Inf;
end
set(handles.figure1,'userdata',ud);

% --- Executes on button press in spline_button.
function spline_button_Callback(hObject, eventdata, handles)
cla %clear the axis
ud = get(handles.figure1,'userdata');
ud.anim_mode='curve';
axis manual
seltype = get(gcf,'SelectionType');
xy = [];
while strcmpi(seltype,'normal')
waitforbuttonpress;
seltype = get(gcf,'SelectionType');
if strcmpi(seltype,'normal')
currPt = get(handles.image_axis,'CurrentPoint');
xy = [xy;[currPt(1,1),currPt(1,2)]];
hold on; plot(currPt(1,1),currPt(1,2),'o','MarkerSize',8,'MarkerFaceColor','y');
end
end
rr = fnplt(cscvn(xy'),'k',2);
fnplt(cscvn(xy'),'k',1);
delete(findobj('MarkerFaceColor','y'));
ud.xx = rr(1,:); ud.yy = rr(2,:);

ud.anim_mode='curve';
set(handles.figure1,'userdata',ud);


% --- Executes on button press in Freehand_Draw_button.
function Freehand_Draw_button_Callback(hObject, eventdata, handles)
cla
ud = get(handles.figure1,'userdata');
ud.anim_mode='curve';
axis manual
M= drawrectangle('InteractionsAllowed','none','FaceAlpha',0,'FaceSelectable',1);
ud.xx=M.Position(:,1)';
ud.yy=M.Position(:,2)';
set(handles.figure1,'userdata',ud);

% --- Executes on button press in interactive_button.
function interactive_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
switch(ud.anim_mode)
    case 'curve'
        waitforbuttonpress;
        currPt = get(gca,'CurrentPoint');
        ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2);
        ud.indexFound=findClosestControl(ncurrPt,ud.InputPoints);
        set(ud.figure,'WindowButtonMotionFcn','animator move')
        set(ud.figure,'WindowButtonUpFcn','animator stop');
    case 'grid' 
        waitforbuttonpress;
        currPt = get(gca,'CurrentPoint');
        ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2);
        ud.indexFound=findClosestControl(ncurrPt,ud.InputPoints);
        set(ud.figure,'WindowButtonMotionFcn','animator_grid move')
        set(ud.figure,'WindowButtonUpFcn','animator_grid stop');
    case 'image'
        waitforbuttonpress;
        currPt = get(gca,'CurrentPoint');
        ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2);
        ud.indexFound=findClosestControl(ncurrPt,ud.InputPoints);
        set(ud.figure,'WindowButtonMotionFcn','animator_image move')
        set(ud.figure,'WindowButtonUpFcn','animator_image stop');
    case 'ROI'
        waitforbuttonpress;
        currPt = get(gca,'CurrentPoint');
        ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2);
        ud.indexFound=findClosestControl(ncurrPt,ud.InputPoints);
        set(ud.figure,'WindowButtonMotionFcn','animator_ROI move')
        set(ud.figure,'WindowButtonUpFcn','animator_ROI stop');
end    
set(handles.figure1,'userdata',ud);

% --- Executes on slider movement.
function alpha_slider_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.alpha = get(handles.alpha_slider,'value');
set(handles.slider_value,'string',num2str(ud.alpha));
set(handles.figure1,'userdata',ud);




% --- Executes during object creation, after setting all properties.
function alpha_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider_value_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
slider_value = get(handles.aplha_slider,'value');
set(handles.figure1,'userdata',ud);


% --- Executes during object creation, after setting all properties.
function slider_value_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-----------------------------------------------
function [indexFound]=findClosestControl(hnewPoint,pointsXY)
nPoints=size(pointsXY,1);
normpoints = zeros(1,nPoints);
for i=1:nPoints
    normpoints(i) = norm(pointsXY(i,:)-hnewPoint);
end
[C,indexFound] = min(normpoints);


% --- Executes on button press in Grid.
function Grid_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.anim_mode='grid';
ud.grid_r=str2double(get(handles.grid_r,'string'));
ud.grid_c=str2double(get(handles.grid_c,'string'));
ud.subgrid_column = str2double(get(handles.subgrid_column,'string'));
ud.subgrid_row = str2double(get(handles.subgrid_row,'string'));
grid_c_divid=((ud.grid_c)/ud.subgrid_column);
grid_r_divid=((ud.grid_r)/ud.subgrid_row);
isaninteger = @(x) mod(x, 1) == 0;   
if 0==isaninteger(grid_r_divid) && 0==isaninteger(grid_c_divid) 
   ud.grid_r = ud.grid_r+(ud.subgrid_row - mod(ud.grid_r,ud.subgrid_row)) ;
   ud.grid_c = ud.grid_c+(ud.subgrid_column - mod(ud.grid_c,ud.subgrid_column)) ;           
end 
[ud.xfine,ud.yfine] = meshgrid(1:1:ud.grid_r+1,1:1:ud.grid_c+1);
[ud.xcoarse,ud.ycoarse] = meshgrid(1:grid_r_divid:ud.grid_r+1,1:grid_c_divid:ud.grid_c+1);
hgrid = mesh(ud.xfine,ud.yfine);
delete(hgrid);
Z = zeros(ud.grid_r+1,ud.grid_c+1);
ud.hpatch = surf(ud.xfine,ud.yfine,Z, ... % Plot surface 
 'EdgeColor', 'k','linewidth',1.5);
ud.xx = ud.xcoarse(:)';
ud.yy = ud.ycoarse(:)';
hold on; 
% plot(ud.xx,ud.yy,'ro');
set(ud.hpatch,'Facealpha',0);
set(handles.figure1,'userdata',ud);


 
% --- Executes on button press in ROI.
function ROI_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
ud.anim_mode='ROI';
ud.resol_row = str2double(get(handles.resolution_r,'string'));
ud.resol_column = str2double(get(handles.resolution_c,'string'));
[filename,pathname]=uigetfile('*.*');
A = imread(filename);
Im = imresize(A,[ud.resol_row+1,ud.resol_column+1]);
[ud.xfine,ud.yfine] = meshgrid(1:1:ud.resol_row+1,1:1:ud.resol_column+1);
Z = zeros(size(Im,2),size(Im,1));
im1=flipud(imshow(Im));
roi=drawassisted(im1,'InteractionsAllowed','none');
x=roi.Position(:,1);
y=roi.Position(:,2);
BW = poly2mask(x,y,size(Im,1),size(Im,2));
Z(~BW)=NaN;
hold on;
ud.hpatch = mesh(ud.xfine,ud.yfine,Z,Im, ... % Plot surface
'FaceColor', 'texturemap', ...
'EdgeColor','none');
ind=find(BW==1);
[row,col] = ind2sub(size(Im),ind);
ud.xx = col(1:100:end)'; ud.yy = row(1:100:end)';
delete(findobj('type','image'));
delete(roi);
delete(im1);
set(handles.figure1,'userdata',ud);

function Image_Callback(hObject, eventdata, handles)
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
[filename,pathname]=uigetfile('*.*');
Im = flipud(imresize(imread(filename),[ud.resol_row+1,ud.resol_column+1]));
[ud.xfine,ud.yfine] = meshgrid(1:1:ud.resol_row+1,1:1:ud.resol_column+1);
[ud.xcoarse,ud.ycoarse] = meshgrid(1:resol_r_divid:ud.resol_row+1,1:resol_c_divid:ud.resol_column+1);
Z = zeros(size(Im,2),size(Im,1));
ud.hpatch = mesh(ud.xfine,ud.yfine,Z,Im, ... % Plot surface%%%%%%%%%%%%%%%%%%%%%%%
'FaceColor', 'texturemap', ...
'EdgeColor', 'none');
ud.xx = ud.xcoarse(:)';
ud.yy = ud.ycoarse(:)';
hold on; 
set(ud.hpatch,'linestyle','none');
set(gca,'XTick',[],'YTick',[],'xlim',[-20,800],'ylim',[-20,700]);
set(handles.figure1,'userdata',ud);


% --- Executes during object creation, after setting all properties.
function Image_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grid_c_Callback(hObject, eventdata, handles)

function grid_c_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grid_r_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function grid_r_CreateFcn(hObject, eventdata, handles)
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


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
cla;
ud = get(handles.figure1,'userdata');
handles.output = hObject;
guidata(hObject, handles);
hold on;
axis auto;
ud.alpha = str2double(get(handles.slider_value,'string'));
ud.figure = handles.figure1;
ud.InputPoints=[];
ud.OutputPoints=[];
% ud.figure=[];
ud.hdeformation = [];
set(handles.figure1,'userdata',ud);
set(handles.figure1,'userdata',ud);


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



function subgrid_row_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function subgrid_row_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subgrid_column_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function subgrid_column_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
get(handles.figure1,'userdata');
ax = gcf;
filter = {'*.jpg';'*.png';'*.tif';'*.pdf';'*.eps'};
[filename,filepath] = uiputfile(filter);
if ischar(filename)
    exportgraphics(ax,[filepath filename]);
end

% --- Executes on button press in anime_button.
function anime_button_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
currPt = get(gca,'CurrentPoint');
ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2); 
ud.indexFound=findClosestControl(ncurrPt,ud.InputPoints);
seltype = get(gcf,'SelectionType');
count = max(length(ud.InputPoints),0);
xy = [];
while strcmpi(seltype,'normal')
      w = waitforbuttonpress;
      seltype = get(gcf,'SelectionType');
      if strcmpi(seltype,'normal');
         currPt = get(handles.image_axis,'CurrentPoint');
         xy = [xy;[currPt(1,1),currPt(1,2)]];
         count=count+1;
         hold on;
         xy = [xy;[currPt(1,1),currPt(1,2)]];
         hold on; plot(currPt(1,1),currPt(1,2),'o','MarkerSize',8,'MarkerFaceColor','y');
     end
end
ud.animated_curve{ud.indexFound} = fnplt(cscvn(xy'),'y',2);
ud.animated_index = ud.indexFound;
ud.indexFoundSize(ud.indexFound) = length(ud.animated_curve{ud.indexFound});
fnplt(cscvn(xy'),'y',1);
set(handles.figure1,'userdata',ud);

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
ud =  get(handles.figure1,'userdata');
mysize = min(ud.indexFoundSize);
delete(findobj('color','y'));
delete(findobj('marker','o'))
for i=1:mysize
     for j=1:length(ud.InputPoints)
         if ~isempty(ud.animated_curve{j})
          ud.OutputPoints(j,:) = ud.animated_curve{j}(:,i)';
         end
     end
         Deformed_output = Image_Deformation(ud.InputPoints,ud.OutputPoints,[ud.xx;ud.yy],ud.alpha,ud.method);
         Vx = griddata(ud.xx,ud.yy,Deformed_output(:,1),ud.xfine,ud.yfine);
         Vy = griddata(ud.xx,ud.yy,Deformed_output(:,2),ud.xfine,ud.yfine);
         set(ud.hpatch,'xdata',Vx,'ydata',Vy);
         F(i) = getframe(gca);
end
figure; hold on;
movie(F,1,24);
set(handles.figure1,'userdata',ud);
