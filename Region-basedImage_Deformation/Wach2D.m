function phi = Wach2D(v,x)
n = size(v,1);
w = zeros(n,1);
A=zeros(n,1);
C=zeros(n,1);
for i = 1:n
  j = mod(i-2,n) + 1;%i-1
  k= mod(i,n)+1;%i+1
  A(i) = AreaTri(v,x,i,n);
  A(j)= AreaTri(v,x,j,n);
   C(i) = 0.5*det([ones(1,3);...
      v(j,2),v(i,2),v(k,2);v(j,1),v(i,1),v(k,1)]);
  w(i) = C(i)./(A(i)*A(j));
end
  wsum = sum(w);
  phi= w./wsum;
end    

function Area = AreaTri(v,x,i,n)
ii = mod(i,n)+1;
Area = 0.5*det([ones(1,3);x(1,1),v(ii,1),v(i,1);...
                    x(1,2),v(ii,2),v(i,2)]);
end 


