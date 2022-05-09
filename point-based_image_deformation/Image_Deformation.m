function [OutputGiven] = Image_Deformation(InputPoints,OutputPoints,GivenPoints,alpha,method)
for i=1:length(GivenPoints) 
    OutputGiven(i,:)=Single_Image_Deformation(InputPoints,OutputPoints,GivenPoints(:,i),alpha,method);   
end
function [OutputGiven] = Single_Image_Deformation(InputPoints,OutputPoints,GivenPoint,alpha,method)
N = size(InputPoints,1); 
%build the weights
omega = zeros(1,N);
for j=1:N
    omega(j) = 1./(norm(InputPoints(j,:)'- GivenPoint)).^(2*alpha);
end
%Averaged Point
AveragedPoint = [omega*InputPoints(:,1),omega*InputPoints(:,2)]./sum(omega); %psar
%Averaged Point
QAveragedPoint = [omega*OutputPoints(:,1),omega*OutputPoints(:,2)]./sum(omega); %qstar
%modified points
ModifiedInputPoints = InputPoints-AveragedPoint; %phat
%modified points
ModifiedOutputPoints = OutputPoints-QAveragedPoint; %qhat
switch method 
    case 'Affine'    
       B = [0 0; 0 0];
       for j=1:N
            B = B + (omega(j)*(ModifiedInputPoints(j,:)')*ModifiedInputPoints(j,:));
       end     
       S = (GivenPoint' - AveragedPoint)/(B); 
       C = [0 0];
       for j=1:N
            A = S*(omega(j)*(ModifiedInputPoints(j,:)'));
            C = C + A.*ModifiedOutputPoints(j,:);
       end
       OutputGiven =C + QAveragedPoint;
%--------------------------------------------
    case 'Similar'
       Per_ModifiedInputPoints=flip(ModifiedInputPoints,2);
       Per_ModifiedInputPoints(:,1)=-Per_ModifiedInputPoints(:,1) ; %phat perpindicular
       Per_GP_AP=flip(GivenPoint' - AveragedPoint,2);
       Per_GP_AP(:,1)=-Per_GP_AP(:,1); %(v-p*) perpindicular
       %%%%scaling constant 
       mu_s=0;
       for j=1:N
           mu_s = mu_s + (omega(j)*(ModifiedInputPoints(j,:))*ModifiedInputPoints(j,:)');
       end
       S= [(GivenPoint' - AveragedPoint)', -Per_GP_AP'];
       B = [0 0];
       for j=1:N
           A=omega(j)*[ModifiedInputPoints(j,:); -Per_ModifiedInputPoints(j,:)]*S;
           B= B+ (ModifiedOutputPoints(j,:)*(1/mu_s)*A);
       end
       OutputGiven = B + QAveragedPoint;
%--------------------------------------------
    case 'Rigid'
        Per_ModifiedInputPoints=flip(ModifiedInputPoints,2);
        Per_ModifiedInputPoints(:,1)=-Per_ModifiedInputPoints(:,1) ; %phat perpindicular
        Per_GP_AP=flip(GivenPoint' - AveragedPoint,2);
        Per_GP_AP(:,1)=-Per_GP_AP(:,1); %(v-p*) perpindicular
        G=(GivenPoint' - AveragedPoint);
        S= [G', -Per_GP_AP'];     
        B = [0 0];
        for j=1:N
            A=omega(j)*[ModifiedInputPoints(j,:); -Per_ModifiedInputPoints(j,:)]*S;
            B= B+ (ModifiedOutputPoints(j,:)*A);
        end
        OutputGiven =norm(G).*(B/norm(B)) + QAveragedPoint;
end