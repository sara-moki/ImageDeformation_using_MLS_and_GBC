function interactive_button_Callback(~, ~, handles)
ud = get(handles.figure1,'userdata'); 
ud.tf = zeros(size(ud.xx,1),ud.index);
for i=1:ud.index
  ud.tf(:,i) = inROI(ud.polyg{i},ud.xx,ud.yy);
end
%find the interiors w.r.t. all polygon
ud.tff=zeros(length(ud.xx),1);
for i=1:ud.index
       ud.tff= ud.tff + ud.tf(:,i);
end
ud.A = zeros(ud.index,1);
ud.deformPol = ud.polyg;
for i=1:ud.index    
    ud.deformPol{i}.InteractionsAllowed = 'all'; 
end
waitforbuttonpress;
for i = 1: ud.index
    ud.A(i,1)= ud.deformPol{i}.Selected;
end
ud.indexFoundP = find(ud.A==1);
ud.xx2 = ud.xx;
ud.yy2=ud.yy;
ud.uu = cell2mat(ud.uxG);
ud.vv = cell2mat(ud.vyG);
ud.InputPoints = [ud.uu(:), ud.vv(:)];
ud.OutputPoints=ud.InputPoints;
WG_prod = repmat(ud.w1G,1,length(ud.w2G)).*ud.w2G;
L= length(ud.Jac_P(:))/length(WG_prod(:));
ud.affine_Mat =[];
ud.omega =[];
for i = 1:size(ud.tff,1)    
       if ud.tff(i,1)==0 
             ud.omega = [ud.omega;
                      sum(repmat(WG_prod(:),L,1).*(ud.Jac_P(:))./((vecnorm(ud.InputPoints'- [ud.xx(i);ud.yy(i)])).^(2*ud.alpha)),1)];
             ud.affine_Mat = [ud.affine_Mat ; affine_Mat(ud.InputPoints,[ud.xx(i);ud.yy(i)],...
                                                          ud.alpha,ud.w1G,ud.w2G,ud.Jac_P(:))];
       end
end       
set(ud.figure,'WindowButtonMotionFcn','animator_area move')
set(ud.figure,'WindowButtonUpFcn','animator_area stop');
set(handles.figure1,'userdata',ud);

function affine_Mat = affine_Mat(InputPoints,GivenPoint,alpha,w1G,w2G,jacobian)
N = length(InputPoints); 
WG_prod = repmat(w1G,1,length(w2G)).*w2G;
L= length(jacobian)/length(WG_prod(:));
omega = sum(repmat(WG_prod(:),L,1).*(jacobian)./((vecnorm(InputPoints'- GivenPoint)).^(2*alpha)),1);
AveragedPoint = [omega*InputPoints(:,1),omega*InputPoints(:,2)]./sum(omega); %psar
ModifiedInputPoints = InputPoints-AveragedPoint; %phat
B = [0 0; 0 0];
    for j=1:N
       B = B + (omega(j)*(ModifiedInputPoints(j,:)')*ModifiedInputPoints(j,:));
    end     
affine_Mat = (GivenPoint' - AveragedPoint)/(B); 