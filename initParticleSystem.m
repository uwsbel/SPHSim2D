function [Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho] = initParticleSystem(params)
%initParticleSystem 
%   This function initialize an array of particles.

disp('Initializing Particle System');


numFluidParticles = params.numFluidParticles;
numFluidParticlesPerRow = params.numFluidParticlesPerRow;
numFluidParticlesPerColumn = params.numFluidParticlesPerColumn;

dr = params.initialSeparation;
boxWidth = params.boxWidth;
boxHeight = params.boxHeight;

numFluidParticlesSideBound = 0;
numFluidParticlesUpperBound = 0;
numFluidParticlesLowBound = 0;

if(enableSideBoundaries)
    numFluidParticlesSideBound = (boxHeight/dr) + 1;
end
if(enableLowerBoundary)
    numFluidParticlesLowBound = (boxWidth/dr) + 7;
end
if(enableUpperBoundary)
    numFluidParticlesUpperBound = (boxWidth/dr);
end



numSideBoundaryParticles = 6*numFluidParticlesSideBound;
numLowerBoundaryParticles = 3*numFluidParticlesLowBound;
numUpperBoundaryParticles = 3*numFluidParticlesUpperBound;

totalSPHMarkers = numFluidParticles + numLowerBoundaryParticles + numSideBoundaryParticles + numUpperBoundaryParticles;

Pos = zeros(2, totalSPHMarkers);
Vel = zeros(2, totalSPHMarkers);
VelHalf = zeros(2, totalSPHMarkers);
Acc = zeros(2, totalSPHMarkers);
Rho_RhoHalf_dRho = zeros(3, totalSPHMarkers);
Rho_RhoHalf_dRho(1:2,:) = params.rho0;


counter = 1;

% Place Fluid Particles
for x = dr: dr : dr*(numFluidParticlesPerColumn)  
    for y = dr: dr : dr*(numFluidParticlesPerRow)
        Pos(1,counter) = x;
        Pos(2,counter) = y;
        counter = counter + 1; 
    end
end


if(enableLowerBoundary)
    % Place Lower boundary layers
    for x = (-2*dr):dr:(boxWidth+2*dr)
        % Place Lower boundary first layer
        Pos(1,counter) = x;
        Pos(2,counter) = 0;
        counter = counter + 1;
        % Place Lower boundary second layer
        Pos(1,counter) = x;
        Pos(2,counter) = -dr;
        counter = counter + 1;
        % Place Lower boundary third layer
        Pos(1,counter) = x;
        Pos(2,counter) = -2*dr;
        counter = counter + 1;
    end
end

if(enableUpperBoundary)
    for x = dr: dr : dr*(boxWidth)  
        Pos(1,counter) = x;
        Pos(2,counter) = boxHeight;
        counter = counter + 1; 

        Pos(1,counter) = x;
        Pos(2,counter) = boxHeight + dr;
        counter = counter + 1;  
        
        Pos(1,counter) = x;
        Pos(2,counter) = boxHeight + 2*dr;
        counter = counter + 1;  
    end
end

if(enableSideBoundaries)
    %Place side boundary layers
    for y = dr:dr:(boxHeight+2*dr)
        % Place left-most boundary layer (first)
        Pos(1,counter) = -2*dr;
        Pos(2,counter) = y;
        counter = counter + 1;
    
        % Place second boundary layer (second)
        Pos(1,counter) = -dr;
        Pos(2,counter) = y;
        counter = counter + 1;
    
        % Place third boundary layer 
        Pos(1,counter) = 0;
        Pos(2,counter) = y;
        counter = counter + 1;
    
        % Place fourht boundary layer 
        Pos(1,counter) = boxWidth;
        Pos(2,counter) = y;
        counter = counter + 1;
    
        % Place fifth boundary layer 
        Pos(1,counter) = boxWidth + dr;
        Pos(2,counter) = y;
        counter = counter + 1;

        % Place right-most boundary layer (sixth)
        Pos(1,counter) = boxWidth + 2*dr;
        Pos(2,counter) = y;
        counter = counter + 1;
    end
end

