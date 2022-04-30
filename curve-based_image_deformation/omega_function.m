function omega = omega_function(InputCurve,GivenPoint,alpha,t)
diff_InputCurve=fnder(InputCurve,1);  
diff_value=ppval(diff_InputCurve,t);
Input_value=ppval(InputCurve,t);
omega = vecnorm(diff_value)./((vecnorm(Input_value- GivenPoint)).^(2*alpha));