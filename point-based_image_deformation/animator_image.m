function animator_image(action,isAnimation)
if nargin<2, isAnimation=true; end
ud = get(gcf,'userdata');
% set(gcf,'doublebuffer','off');
axis manual
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
             set(ud.figure,'WindowButtonMotionFcn','animator_image move')
             set(ud.figure,'WindowButtonUpFcn','animator_image stop');
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
           set(ud.hmarker{ud.indexFound},'xdata',currPt(1,1),'ydata',currPt(1,2));  
%          plot(currPt(1,1),currPt(1,2),'o','MarkerSize',8,'MarkerFaceColor','y');
           ud.tStart = cputime;
           Deformed_output = Image_Deformation(ud.InputPoints,ud.OutputPoints,[ud.xx;ud.yy],ud.alpha,ud.method);
           if ishandle(ud.hdeformation)
              delete(ud.hdeformation);
           end
           Vr = reshape(Deformed_output,[size(ud.xcoarse),2]);  
           Vx = interp2(ud.xcoarse,ud.ycoarse,Vr(:,:,1),ud.xfine,ud.yfine,'linear');
           Vy = interp2(ud.xcoarse,ud.ycoarse,Vr(:,:,2),ud.xfine,ud.yfine,'linear');
           set(ud.hpatch,'xdata',Vx,'ydata',Vy);
           set(gcf,'userdata',ud);
       case'stop'
        % Button unpressed so end animation and set everything back to normal.
           ud = get(gcf,'userdata');
           tEnd = cputime - ud.tStart
           set(ud.figure,'WindowButtonMotionFcn','');
           set(ud.figure,'windowButtonUpFcn','');
           set(ud.figure,'windowButtonDownFcn','animator_image start');
           set(gcf,'userdata',ud);      
end