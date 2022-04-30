function ww = Curves_weights(InputCurves,GivenPoint,alpha,wG,xG)
M = length(InputCurves);
ww = zeros(M,length(xG));
for j=1:M
    ww(j,:) = wG'.*omega_function(InputCurves{j},GivenPoint,alpha,xG);
end
