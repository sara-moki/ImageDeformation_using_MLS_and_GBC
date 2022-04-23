function phi = MeanValue2D(v,x)
n = size(v,1);
w = zeros(n,1);
r = zeros(n,1);
d = zeros(n,2);
t =  zeros(n,1);
for i = 1:n
d(i,:) = v(i,:) - x;
r(i) = norm(d(i,:));
end
for i = 1:n
ip1 = mod(i,n)+1;% i+1
a = d(i,1)*d(ip1,2)-d(i,2)*d(ip1,1);
b =(r(i)*r(ip1))+(dot(d(i,:),d(ip1,:)));
t(i) = a./b;
end
for i = 1:n
    im1 = mod(i-2,n) + 1;% i-1
    w(i) = (t(im1)+t(i))/r(i);
end   
wsum = sum(w);
phi = w./wsum;