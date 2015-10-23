function [PosBoundary, VelBoundary, Rho_RhoHalf_dRhoBoundary]  = initBoundaries(boxWidth, boxHeight, h, enableBottomWall, enableSideWalls, enableTopWall, rho0 )
%initBoundaries 

minX = -2*h;
maxX = boxWidth + 2*h;

numParticlesPerColumn = size(minX:h:maxX,2); % From -2*h:h:boxWidth+2*h
numParticlesPerRow = size(h:h:boxHeight-h,2); % From h:h:(boxHeight-h)
totalNumBoundaryParticles = 0;



if(enableBottomWall)
   totalNumBoundaryParticles = totalNumBoundaryParticles + 3*numParticlesPerColumn;
end
if(enableSideWalls)
   totalNumBoundaryParticles = totalNumBoundaryParticles + 6*numParticlesPerRow;
end
if(enableTopWall)
    totalNumBoundaryParticles = totalNumBoundaryParticles + 3*numParticlesPerColumn;
end

PosBoundary = zeros(2, totalNumBoundaryParticles);
VelBoundary = zeros(2, totalNumBoundaryParticles);
Rho_RhoHalf_dRhoBoundary = zeros(3, totalNumBoundaryParticles);
Rho_RhoHalf_dRhoBoundary(1:2,:) = rho0;

counter = 1;
if(enableBottomWall)
    for x = minX:h:maxX
        PosBoundary(1,counter) = x;
        PosBoundary(2,counter) = 0;
        counter = counter + 1;
        
        PosBoundary(1,counter) = x;
        PosBoundary(2,counter) = -h;
        counter = counter + 1;
        
        PosBoundary(1,counter) = x;
        PosBoundary(2,counter) = -2*h;
        counter = counter + 1;
    end
end

if(enableSideWalls)
    for y = h:h:boxHeight-h
        PosBoundary(1,counter) = minX;
        PosBoundary(2,counter) = y;
        counter = counter + 1; 
        
        PosBoundary(1,counter) = minX+h;
        PosBoundary(2,counter) = y;
        counter = counter + 1;
        
        PosBoundary(1,counter) = 0;
        PosBoundary(2,counter) = y;
        counter = counter + 1;
        
        PosBoundary(1,counter) = boxWidth;
        PosBoundary(2,counter) = y;
        counter = counter + 1;
        
        PosBoundary(1,counter) = boxWidth+h;
        PosBoundary(2,counter) = y;
        counter = counter + 1;
        
        PosBoundary(1,counter) = maxX;
        PosBoundary(2,counter) = y;
        counter = counter + 1;
    end
end

if(enableTopWall)
    for x = minX:h:maxX
        PosBoundary(1,counter) = x;
        PosBoundary(2,counter) = boxHeight;
        counter = counter + 1;
        
        PosBoundary(1,counter) = x;
        PosBoundary(2,counter) = boxHeight+h;
        counter = counter + 1;
        
        PosBoundary(1,counter) = x;
        PosBoundary(2,counter) = boxHeight+2*h;
        counter = counter + 1;
    end   
end

end

