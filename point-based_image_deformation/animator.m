function animator(action,isAnimation)
if nargin<2, isAnimation=true; end
ud = get(gcf,'userdata');
switch(action)
%cases START and MOVE are the default to animate a point.
    case 'start'
       ud = get(gcf,'userdata');
       seltype = get(gcf,'SelectionType');
       if strcmpi(seltype,'normal') %'left mouse button pressed
          currPt = get(gca,'CurrentPoint');
          ncurrPt(1) = currPt(1,1); ncurrPt(2) = currPt(1,2);
          ud.indexFound=findClosestControl(ncurrPt,ud.InputPoints);
          ud.OutputPoints(ud.indexFound,1) = currPt(1,1);
          ud.OutputPoints(ud.indexFound,2) = currPt(1,2);
          set(ud.figure,'WindowButtonMotionFcn','animator move')
          set(ud.figure,'WindowButtonUpFcn','animator stop');
       elseif strcmpi(seltype,'open') %right mouse button pressed
          set(ud.figure,'WindowButtonMotionFcn','');
          set(ud.figure,'windowButtonUpFcn','');
          set(ud.figure,'windowButtonDownFcn','');

       end
          set(gcf,'userdata',ud);
    case 'move'
          ud = get(gcf,'userdata');
          ud.hhy = [];
          delete(findobj('MarkerFaceColor','y'));
          currPt = get(gca,'CurrentPoint');
          ud.OutputPoints(ud.indexFound,1) = currPt(1,1);
          ud.OutputPoints(ud.indexFound,2) = currPt(1,2);
          hold on;
          plot(currPt(1,1),currPt(1,2),'o','MarkerSize',8,'MarkerFaceColor','y');
          Deformed_output = Image_Deformation(ud.InputPoints,ud.OutputPoints,[ud.xx;ud.yy],ud.alpha,ud.method);
          if ishandle(ud.hdeformation)
             delete(ud.hdeformation);
          end
          ud.hdeformation = plot(Deformed_output(:,1),Deformed_output(:,2),'g', 'linewidth',3);
          set(gcf,'userdata',ud);
    case'stop'
    % Button unpressed so end animation and set everything back to normal.
          ud = get(gcf,'userdata');
          set(ud.figure,'WindowButtonMotionFcn','');
          set(ud.figure,'windowButtonUpFcn','');
          set(ud.figure,'windowButtonDownFcn','animator start');
          set(gcf,'userdata',ud);
end