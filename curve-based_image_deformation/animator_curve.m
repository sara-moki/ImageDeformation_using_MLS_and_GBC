function animator_curve(action,isAnimation)
if nargin<2, isAnimation=true; end
get(gcf,'userdata');
axis manual
switch(action) 
%cases START and MOVE are the default to animate a point.
      case 'start'
          ud = get(gcf,'userdata');
          seltype = get(gcf,'SelectionType');
          if strcmpi(seltype,'normal') %'left mouse button pressed
             currPt = get(gca,'CurrentPoint');
             ncurrPt(1) = currPt(1,1);
             ncurrPt(2) = currPt(1,2);
             ud.OutputPoints(ud.indexFound,1) = currPt(1,1);
             ud.OutputPoints(ud.indexFound,2) = currPt(1,2);
             ud.indexFound=findClosestControl(ncurrPt,ud.A);% which point we are click on from the sum of all points
             L=length(ud.InputSplinePoints{1});
             if rem(ud.indexFound/L,1)==0  
                  ud.index=ud.indexFound/L;
             else 
                  ud.index=floor(ud.indexFound/(L+1))+1 ;
             end       
             set(ud.hmarker{ud.indexFound},'xdata',ncurrPt(1),'ydata',ncurrPt(2));
             set(ud.figure,'WindowButtonMotionFcn','animator_curve move');
             set(ud.figure,'WindowButtonUpFcn','animator_curve stop');
         elseif strcmpi(seltype,'open') %right mouse button pressed
             set(ud.figure,'WindowButtonMotionFcn','');
             set(ud.figure,'windowButtonUpFcn','');
             set(ud.figure,'windowButtonDownFcn','');
         end
     set(gcf,'userdata',ud);
     case 'move'
         ud = get(gcf,'userdata');
         delete(findobj('color',[0 1/ud.index 1/ud.index]));
         delete(findobj(ud.pp2{ud.index}));
         currPt = get(gca,'CurrentPoint');
         set(ud.hmarker{ud.indexFound},'xdata',currPt(1,1),'ydata',currPt(1,2));
         L=length(ud.InputSplinePoints{1});
         if rem(ud.indexFound/L,1)==0   
             ud.index=ud.indexFound/L;
         else 
               ud.index=floor(ud.indexFound/L)+1 ;
         end 
         Newindex= (ud.indexFound - ((ud.index-1)*L));
         ud.OutputSplinePoints{ud.index}(Newindex,1) = currPt(1,1);
         ud.OutputSplinePoints{ud.index}(Newindex,2) = currPt(1,2);  
         hold on 
         xs=linspace(0,1,100);
         xs1=linspace(0,1,length(ud.InputSplinePoints{ud.index}));              
         ud.qq{ud.index}=spline(xs1,[0 ud.OutputSplinePoints{ud.index}(:,1)' 0; 0 ud.OutputSplinePoints{ud.index}(:,2)' 0]);
         x1=ppval(ud.qq{ud.index},xs');
         ud.OutputPoints_based{ud.index}=ppval(ud.qq{ud.index},ud.xG');
         hold on;
         ud.pp1{ud.index}= plot(x1(1,:),x1(2,:),'color',[0 1/ud.index 1/ud.index],'LineWidth',3); 
%          ud.tStart = cputime;
         if strcmp(ud.deformation,'Curve-based')
             Deformed_output = zeros(length(ud.xx),2);
             for i=1:length(ud.xx)
              Deformed_output(i,:) = Single_Curve_Deformation(ud.pp,ud.qq,[ud.xx(i);ud.yy(i)],...
                                         ud.alpha,ud.xG,ud.wG,ud.method);
             end
         elseif strcmp(ud.deformation,'Point-based')
              ud.InputPointsG=(cell2mat(ud.InputPoints))';
              ud.OutputPoints_basedG=(cell2mat(ud.OutputPoints_based))';
              diff_valueG = (cell2mat(ud.diff_value))';
              ud.wGG = repmat(ud.wG,ud.indexG,1);
              Deformed_output = Point_based_Deformation(ud.InputPointsG,ud.OutputPoints_basedG,...
                                   diff_valueG,[ud.xx;ud.yy],ud.alpha,ud.wGG,ud.method);
         end     
         Vr = reshape(Deformed_output,[size(ud.xcoarse),2]);  
         Vx = interp2(ud.xcoarse,ud.ycoarse,Vr(:,:,1),ud.xfine,ud.yfine,'linear');
         Vy = interp2(ud.xcoarse,ud.ycoarse,Vr(:,:,2),ud.xfine,ud.yfine,'linear');
         set(ud.hpatch,'xdata',Vx,'ydata',Vy);
         set(gcf,'userdata',ud);
    case'stop'
% Button unpressed so end animation and set everything back to normal.
        ud = get(gcf,'userdata');
%         tEnd = cputime - ud.tStart;
        set(ud.figure,'WindowButtonMotionFcn','');
        set(ud.figure,'windowButtonUpFcn','');
        set(ud.figure,'windowButtonDownFcn','animator_curve start');
        set(gcf,'userdata',ud);       
end
