function [indexFound]=findClosestControl(hnewPoint,pointsXY)
nPoints=size(pointsXY,1);
normpoints = zeros(1,nPoints);
for i=1:nPoints
    normpoints(i) = norm(pointsXY(i,:)-hnewPoint);
end
[C,indexFound] = min(normpoints);
