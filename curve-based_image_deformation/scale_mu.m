function  mu_r=scale_mu(InputCurves,OutputCurves,GivenPoint,alpha,xG,wG,AC,QAC,method)
M=length(InputCurves);
res1=0;
res2=0;
switch method
    case 'Similar'
       for j=1:M
           p_hat= ppval(InputCurves{j},xG)-AC';
           ww = wG'.*omega_function(InputCurves{j},GivenPoint,alpha,xG);
           res1 = res1+ sum(sum((repmat(ww,2,1).*p_hat).*p_hat));
       end   
       mu_r = res1;
    case 'Rigid'    
        for j=1:M
              p_hat= ppval(InputCurves{j},xG)-AC';
              q_hat = ppval(OutputCurves{j},xG)-QAC';
              orth_p_hat=flip(p_hat);
              orth_p_hat(1,:)=-orth_p_hat(1,:);
              ww = wG'.*omega_function(InputCurves{j},GivenPoint,alpha,xG);
              res1 = res1+ sum(sum((repmat(ww,2,1).*p_hat).*q_hat));
              res2 = res2+ sum(sum((repmat(ww,2,1).*orth_p_hat).*q_hat));
        end
        mu_r=sqrt(((res1)^2)+((res2)^2));        
end   