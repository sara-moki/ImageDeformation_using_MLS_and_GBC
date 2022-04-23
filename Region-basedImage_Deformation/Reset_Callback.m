function Reset_Callback(hObject, ~, handles)
cla
handles.output = hObject;
% Update handles structure
hold on;
axis auto;
guidata(hObject, handles);
ud.alpha = str2double(get(handles.alpha,'string'));
ud.figure = handles.figure1;
ud.hdeformation = [];
ud.index=0;%%%%
ud.method='Affine';
ud.animation = 'Translation';
ud.xG_number = str2double(get(handles.Leg_points,'string'));
ud.yG_number = ud.xG_number;
[ud.xG,ud.w1G]=lgwt(ud.xG_number,0,1);
[ud.yG,ud.w2G]=lgwt(ud.xG_number,0,1);
[ud.a,ud.b] = meshgrid(ud.xG,ud.yG);
h=10^-4;
% sq2cir = ((sqrt((2.*ud.a-1+10.^-4).^2 + (2.*ud.b-1+10.^-4).^2 ...
%                         - ((2.*ud.a-1+10.^-4).^2).*((2.*ud.b-1+10.^-4).^2)))./sqrt((2.*ud.a-1+10.^(-4)).^2 + (2.*ud.b-1+10.^(-4)).^2));
% sq2cirHa = ((sqrt((2.*ud.a-1+10.^-4+h).^2 + (2.*ud.b-1+10.^-4).^2 ...
%                         - ((2.*ud.a-1+10.^-4+h).^2).*((2.*ud.b-1+10.^-4).^2)))./sqrt((2.*ud.a-1+10.^(-4)+h).^2 + (2.*ud.b-1+10.^(-4)).^2));
% sq2cirHb = ((sqrt((2.*ud.a-1+10.^-4).^2 + (2.*ud.b-1+10.^-4+h).^2 ...
%                         - ((2.*ud.a-1+10.^-4).^2).*((2.*ud.b-1+10.^-4+h).^2)))./sqrt((2.*ud.a-1+10.^(-4)).^2 + (2.*ud.b-1+10.^(-4)+h).^2));
% uxG = (2.*ud.a-1+10.^-4).*sq2cir;
% uxGHa = (2.*ud.a-1+10.^-4+h).*sq2cirHa;
% uxGHb = (2.*ud.a-1+10.^-4).*sq2cirHb;
% 
% vyG =  (2.*ud.b-1+10.^-4).*sq2cir;
% vyGHa =  (2.*ud.b-1+10.^-4).*sq2cirHa;
% vyGHb =  (2.*ud.b-1+10.^-4+h).*sq2cirHb;
% 
% ud.Leg_theta = atan2(vyG,uxG);
% ud.Leg_r = (uxG.^2+vyG.^2);
% 
% ud.Leg_theta_xu = atan2(vyG,uxGHa);
% ud.Leg_theta_xv = atan2(vyGHa,uxG);
% ud.Leg_theta_yu = atan2(vyG,uxGHb);
% ud.Leg_theta_yv = atan2(vyGHb,uxG);
% 
% ud.Leg_rxu = (uxGHa.^2+vyG.^2);
% ud.Leg_rxv = (uxG.^2+vyGHa.^2);
% ud.Leg_ryu = (uxGHb.^2+vyG.^2);
% ud.Leg_ryv = (uxG.^2+vyGHb.^2);
% ud.Jac_P =[];

%%%%%%%%%%%%%%%%%%%%Another Parametrization
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