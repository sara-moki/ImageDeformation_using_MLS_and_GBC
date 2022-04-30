function animator_area(action,isAnimation)
if nargin<2, isAnimation=true; end
get(gcf,'userdata');
axis manual
switch(action) 
%cases START and MOVE are the default to animate a point.
      case 'start'
          ud = get(gcf,'userdata');
          seltype = get(gcf,'SelectionType');
          if strcmpi(seltype,'normal') %'left mouse button pressed    
             for i = 1: ud.index
               ud.A(i,1)= ud.deformPol{i}.Selected;
             end
             ud.indexFoundP = find(ud.A==1);           
             ud.deformPol{ud.indexFoundP}.Selected = 0;
             set(ud.figure,'WindowButtonMotionFcn','animator_area move')
             set(ud.figure,'WindowButtonUpFcn','animator_area stop');
             set(ud.figure,'userdata',ud);
         elseif strcmpi(seltype,'open') %right mouse button pressed
             set(ud.figure,'WindowButtonMotionFcn','');
             set(ud.figure,'windowButtonUpFcn','');
             set(ud.figure,'windowButtonDownFcn','');
          end
         set(gcf,'userdata',ud);
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     case 'move'         
           ud = get(gcf,'userdata');
           currPt = get(gca,'CurrentPoint');
           Deformed_output =  [ud.xx,ud.yy];%initiate the deformation
           Deformed_handles =[];
           for i = 1: ud.index
               ud.A(i,1)= ud.deformPol{i}.Selected;
           end           
           ud.indexFoundP = find(ud.A==1);
           %%%%%%%%%%%%%%%%Interior Points%%%%%%%%%%%%%%%%%%%%%
           s=find(ud.tf(:,ud.indexFoundP)==1);
           for i = 1:size(s,1)    
                  if strcmp(ud.animation,'Deformation')                    
                       if ud.tf(s(i),ud.indexFoundP)==1 
                             %for grid points
                             Deformed_output(s(i),:) = [sum(ud.BC{ud.indexFoundP}(:,i).*ud.deformPol{ud.indexFoundP}.Position(:,1)),...
                                                       sum(ud.BC{ud.indexFoundP}(:,i).*ud.deformPol{ud.indexFoundP}.Position(:,2))];
                             %for Legendre points (handles in point-based)
                             Deformed_handles = zeros(length(ud.Leg_GBC{ud.indexFoundP}),2);
                          for j =1: size(ud.Leg_GBC{ud.indexFoundP},2)
                               Deformed_handles(j,:)  = [sum(ud.Leg_GBC{ud.indexFoundP}(:,j).*ud.deformPol{ud.indexFoundP}.Position(:,1)),...
                                                   sum(ud.Leg_GBC{ud.indexFoundP}(:,j).*ud.deformPol{ud.indexFoundP}.Position(:,2))];
                          end 
                      end 

                  elseif strcmp(ud.animation,'Translation') 
                         
                      if ud.tf(s(i),ud.indexFoundP)==1 
                        poly=polyshape(ud.polyg{ud.indexFoundP}.UserData);
                        [cx,cy] = centroid(poly);
                        d= [currPt(1,1)-cx,currPt(1,2)-cy];
                        Deformed_output(s(i),:) = [ud.xx2(s(i)),ud.yy2(s(i))]+d;
                        D1 = ud.uxG{ud.indexFoundP};
                        D2 = ud.vyG{ud.indexFoundP};
                        Deformed_handles = [D1(:), D2(:)] +d;  
                      end  
                 end
          end 
         ss=find(ud.tff==1);
         ind1 = (ud.indexFoundP-1)*length(Deformed_handles)+1;
         ind2 = ind1+length(Deformed_handles)-1;
         ud.OutputPoints(ind1:ind2,:) = Deformed_handles;
         ud.xx(ss) = Deformed_output(ss,1);
         ud.yy(ss) = Deformed_output(ss,2);
          %%%%%%%%%%Deform exterior points%%%%%%%%%%%%
          tStart = tic; 
          T=zeros(size(ud.tff(:,1)==0,1 ),1);
          ind = find (ud.tff==0 );
           for i = 1:length(ind)    
                    tic   
                 Deformed_output(ind(i),:) = Image_Deformation(ud.InputPoints,ud.OutputPoints,[ud.xx(ind(i));ud.yy(ind(i))],...
                                                          ud.alpha,ud.method,ud.w1G,ud.w2G,ud.Jac_P(:),ud.omega(i,:),ud.affine_Mat(i,:));
                 T(i)= toc;
           end
          
         % *Interpolation:* 
         Deformed_outputG = Deformed_output;
        [ Vx, Vy ] = im2mesh_interp(Deformed_outputG,...
                             [ud.xcoarse,ud.ycoarse] , [ud.xfine,ud.yfine],'linear');
         tMul = sum(T); 
         set(ud.hpatch,'xdata',Vx,'ydata',Vy); 
         set(gcf,'userdata',ud);
         tEnd = toc(tStart) ;
    case'stop'
      % Button unpressed so end animation and set everything back to normal.
        ud = get(gcf,'userdata');
        set(ud.figure,'WindowButtonMotionFcn','');
        set(ud.figure,'windowButtonUpFcn','');
        set(ud.figure,'windowButtonDownFcn','animator_area start');
        set(gcf,'userdata',ud);
end
