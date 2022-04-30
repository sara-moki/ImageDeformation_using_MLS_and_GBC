function OutputGiven = Single_Curve_Deformation(InputCurves,OutputCurves,GivenPoint,alpha,xG,wG,method) 
ww = Curves_weights(InputCurves,GivenPoint,alpha,wG,xG);
AC=AveragedCurve(InputCurves,xG,ww);
QAC=AveragedCurve(OutputCurves,xG,ww);
switch method 
    case ('Affine')
        L = length(InputCurves);
        B = zeros(2);
        A = zeros(2);
        for k=1:L 
                 InputCurve_Hat=ppval(InputCurves{k},xG)-AC'; %phat(u,v)
                 OutputCurve_Hat=ppval(OutputCurves{k},xG)-QAC';%qhat(u,v)
                 a = (repmat(ww(k,:),2,1).*OutputCurve_Hat)*InputCurve_Hat';
                 b = (repmat(ww(k,:),2,1).*InputCurve_Hat)*InputCurve_Hat';
                 B = B + a; 
                 A = A+ b;
        end
        M = B/A;
    case('Similar')
        mu_r = scale_mu(InputCurves,OutputCurves,GivenPoint,alpha,xG,wG,AC,QAC,method); 
        L=length(InputCurves);
        B = zeros(2);
        for k=1:L
                    InputCurve_Hat=ppval(InputCurves{k},xG)-AC'; %phat(u,v)
                    OutputCurves_Hat=ppval(OutputCurves{k},xG)-QAC';%qhat(u,v)
                    Per_P_hat=flip(InputCurve_Hat);
                    Per_P_hat(1,:)=-Per_P_hat(1,:);
                    Per_Q_hat=flip(OutputCurves_Hat);
                    Per_Q_hat(1,:)=-Per_Q_hat(1,:);
                    a = (sum(InputCurve_Hat.*OutputCurves_Hat));
                    b = (sum((InputCurve_Hat).*Per_Q_hat));
                    c =(sum((Per_P_hat).*OutputCurves_Hat));
                    d = (sum((Per_P_hat).*Per_Q_hat));
                    B = B + [sum(ww(k,:).*a), sum(ww(k,:).*b); sum(ww(k,:).*c), sum(ww(k,:).*d)];             
        end
        M = (1/mu_r).*B ;

    case 'Rigid'
        mu_r = scale_mu(InputCurves,OutputCurves,GivenPoint,alpha,xG,wG,AC,QAC,method); 
        L=length(InputCurves);
        B = zeros(2);
        for k=1:L      
                    InputCurve_Hat=ppval(InputCurves{k},xG)-AC'; %phat(u,v)
                    OutputCurves_Hat=ppval(OutputCurves{k},xG)-QAC';%qhat(u,v)
                    Per_P_hat=flip(InputCurve_Hat);
                    Per_P_hat(1,:)=-Per_P_hat(1,:);
                    Per_Q_hat=flip(OutputCurves_Hat);
                    Per_Q_hat(1,:)=-Per_Q_hat(1,:);
                    a = (sum(InputCurve_Hat.*OutputCurves_Hat));
                    b = (sum((InputCurve_Hat).*Per_Q_hat));
                    c =(sum((Per_P_hat).*OutputCurves_Hat));
                    d = (sum((Per_P_hat).*Per_Q_hat));
                    B = B + [sum(ww(k,:).*a), sum(ww(k,:).*b); sum(ww(k,:).*c), sum(ww(k,:).*d)];
        end
 M = (1/mu_r).*B ; 
end 
 OutputGiven =(M*(GivenPoint-AC')) + QAC';
 
function AC=AveragedCurve(Curves,xG,ww)%AC is p(t) star/q(t) star
M=length(Curves);
result1=zeros(2,M);
result2=zeros(1,M);
for j=1:M
     result1(:,j) = result1(:,j)+ sum(ww(j,:).*ppval(Curves{j},xG),2);%vector
     result2(j) = result2(j)+ sum(ww(j,:),2);%number
end
 AC = sum(result1,2)./sum(result2);
 AC=AC';
