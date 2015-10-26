function [VelBoundary] = AddTopWallVelocity(PosBoundary,VelBoundary, boxHeight, velocityValue)
%AddTopWallVelocity Summary of this function goes here
%   Detailed explanation goes here

indeces = find(PosBoundary(2,:) >= boxHeight);

for i = 1:size(indeces,2)
    currIndex = indeces(1,i);
    VelBoundary(1, currIndex) = velocityValue;
end

end

