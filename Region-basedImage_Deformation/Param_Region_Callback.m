function Param_Region_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
axis manual
% xlim([-20,600]);
%  ylim([-20,600]);
% xlim([-10,60]);
% ylim([-10,60]);
ud.index=ud.index+1; 
ud.contents = cellstr(get(hObject,'String'));
ud.polyg_planar = ud.contents(get(hObject,'Value'));
% if strcmp(ud.polyg_planar,'Polygon')
    ud.polyg{ud.index} = drawpolygon('Color',ud.Handle_Color,'InteractionsAllowed','all','LineWidth',1.3);
% end     
%%%%%%%%%Using Polar coordinates for Legendre points parametrization in region-handle
ud.polyg{ud.index}.UserData = ud.polyg{ud.index}.Position;
polyg=polyshape(ud.polyg{ud.index}.UserData);
[xpole,ypole] = centroid(polyg);
%  plot(xpole,ypole,'Marker','diamond','MarkerSize',15,'Color','r');
%%refinement of the polygon's edges 
pt=interparc(rand(10000,1),[ud.polyg{ud.index}.Position(:,1);ud.polyg{ud.index}.Position(1,1)],...
                          [ud.polyg{ud.index}.Position(:,2);ud.polyg{ud.index}.Position(1,2)],'linear');
pt_theta = atan2(pt(:,2)-ypole,pt(:,1)-xpole);
rad_pt = sqrt((pt(:,1)-xpole).^2+(pt(:,2)-ypole).^2);
hold on
ud.Leg_theta12 = ud.Leg_theta(:);
angle = [];
Leg_rp =[];
k=0;
for j= 1:length(ud.Leg_theta12)
        for i = 1:length(pt_theta)
             if i~=k
               if abs(round(ud.Leg_theta12(j),2) - round(pt_theta(i),2)) <0.05
%                  if round(rho(j),3)==round(pt_theta(i),3)
                  angle = [ angle ; pt_theta(i)];
                  Leg_rp = [Leg_rp;rad_pt(i)];
                  k=i;
                  break;
                end
             end 
        end
end
ud.uxG{ud.index} = xpole+ud.Leg_r(:).*Leg_rp.*cos(angle);
ud.vyG{ud.index} = ypole+ud.Leg_r(:).*Leg_rp.*sin(angle);
u = ud.uxG{ud.index};
v=  ud.vyG{ud.index};
u=u(:);
v=v(:);
% plot(u,v,'*r','MarkerSize',15)
hold on
%%%%Computing jacobian of P(u,v)
%%for p1(u+h,v)
h=10^-4;
angle = [];
Leg_rp =[];
k=0;
ud.Leg_theta12 = ud.Leg_theta_xu(:);
for j= 1:length(ud.Leg_theta12)
        for i = 1:length(pt_theta)
             if i~=k
               if abs(round(ud.Leg_theta12(j),2) - round(pt_theta(i),2)) <0.05
                  angle = [ angle ; pt_theta(i)];
                  Leg_rp = [Leg_rp;rad_pt(i)];
                  k=i;
                  break;
                end
             end 
        end
end
uxGxu{ud.index} = xpole+ud.Leg_rxu(:).*Leg_rp.*cos(angle);
xuH = uxGxu{ud.index};
xuH = xuH(:);
ud.P1u = (xuH-u)./h;
hold on
%%for p1(u,v+h)
angle = [];
Leg_rp =[];
k=0;
ud.Leg_theta12 = ud.Leg_theta_xv(:);
for j= 1:length(ud.Leg_theta12)
        for i = 1:length(pt_theta)
             if i~=k
               if abs(round(ud.Leg_theta12(j),2) - round(pt_theta(i),2)) <0.05
                  angle = [ angle ; pt_theta(i)];
                  Leg_rp = [Leg_rp;rad_pt(i)];
                  k=i;
                  break;
                end
             end 
        end
end
ud.xvG{ud.index} = ypole+ud.Leg_rxv(:).*Leg_rp.*sin(angle);
xvH = ud.xvG{ud.index};
xvH = xvH(:);
ud.P1v = (xvH-v)./h;
hold on
%%for p2(u+h,v)
angle = [];
Leg_rp =[];
k=0;
ud.Leg_theta12 = ud.Leg_theta_yu(:);
for j= 1:length(ud.Leg_theta12)
        for i = 1:length(pt_theta)
             if i~=k
               if abs(round(ud.Leg_theta12(j),2) - round(pt_theta(i),2)) <0.05
                  angle = [ angle ; pt_theta(i)];
                  Leg_rp = [Leg_rp;rad_pt(i)];
                  k=i;
                  break;
                end
             end 
        end
end
ud.yuG{ud.index} = xpole+ud.Leg_ryu(:).*Leg_rp.*cos(angle);
yuH = ud.yuG{ud.index};
yuH = yuH(:);
ud.P2u = (yuH-u)./h;
hold on
%%for p2(u,v+h)
angle = [];
Leg_rp =[];
k=0;
ud.Leg_theta12 = ud.Leg_theta_yv(:);
for j= 1:length(ud.Leg_theta12)
        for i = 1:length(pt_theta)
             if i~=k
               if abs(round(ud.Leg_theta12(j),2) - round(pt_theta(i),2)) <0.05
                  angle = [ angle ; pt_theta(i)];
                  Leg_rp = [Leg_rp;rad_pt(i)];
                  k=i;
                  break;
                end
             end 
        end
end
ud.vyG{ud.index} = ypole+ud.Leg_ryv(:).*Leg_rp.*sin(angle);
yvH = ud.vyG{ud.index};
yvH = yvH(:);
ud.P2v = (yvH-v)./h;
ud.Jac_P =[ ud.Jac_P;  Jacobian_P(ud.P1u,ud.P1v,ud.P2u,ud.P2v)];


%%%%%computing GBC for interior points%%%%%%%
ud.s = inROI(ud.polyg{ud.index},ud.xx,ud.yy );%%%
x = find(ud.s==1);%%%%%
ud.x_in = [ud.xx(x),ud.yy(x)];
phi=zeros(size(ud.polyg{ud.index}.Position,1),size(ud.x_in,1));
Leg_phi=zeros(size(ud.polyg{ud.index}.Position,1),size(ud.uxG{ud.index},1));
for i =1:size(ud.x_in,1)
      switch(ud.GBC)
           case('Wachspress')
                phi(:,i) = Wach2D(ud.polyg{ud.index}.Position,ud.x_in(i,:));
           case('MVC')    
               phi(:,i) = MeanValue2D(ud.polyg{ud.index}.Position,ud.x_in(i,:));                     
      end    
end
%%%%%computing GBC for first parametrization  %%%%%%%%%%%%%%
for i=1:length(u)
      switch(ud.GBC)
           case('Wachspress')
                Leg_phi(:,i) = Wach2D(ud.polyg{ud.index}.Position,[u(i),v(i)]);
           case('MVC')     
                 Leg_phi(:,i) = MeanValue2D(ud.polyg{ud.index}.Position,[u(i),v(i)]);
      end            
end 
ud.BC{ud.index} = phi;
ud.Leg_GBC{ud.index} =Leg_phi;
set(handles.figure1,'userdata',ud);
