function [Pos] = DamBreak(numFluidParticlesPerRow, numFluidParticlesPerColumn, h)
%DamBreakSimulation 
%   Performs a 2D dam break simulation

    numFluidParticles = numFluidParticlesPerRow*numFluidParticlesPerColumn; %Filename
    boxWidth = 2 * numFluidParticlesPerRow * h; 
    boxHeight = 2 * numFluidParticlesPerColumn * h; 
    
    numSteps = 2000; % Number of frames
    currStep = 0;
    
    params.numFluidParticles = numFluidParticles;
    params.maxX = boxWidth; %+ 2*h;
    params.maxY = boxHeight;% + 2*h;
    params.rho0 = 1000; % Reference density
    params.dt = 1e-4; % Time step
    params.h = h; % Interaction radius
    params.particleMass = (h^2) * params.rho0;
    params.pressureConstant = 0.5;
    params.mu = 0.001;
    params.g = -9.81; % Gravity AccFluideleration
    params.epsilon = 1e-2;

    enableSideWalls = 1;
    enableBottomWall = 1;
    enableTopWall = 0;
    [PosBoundary, VelBoundary, Rho_RhoHalf_dRhoBoundary]  = initBoundaries(boxWidth, boxHeight, h, enableBottomWall, enableSideWalls, enableTopWall, params.rho0 );
    [PosFluid, VelFluid, VelHalfFluid, AccFluid, Rho_RhoHalf_dRhoFluid] = initDamBreakFluid( numFluidParticlesPerRow, numFluidParticlesPerColumn, h, params.rho0 );
    
    % drawFrame(PosFluid, PosBoundary, boxWidth, boxHeight);
    
    Pos = [PosFluid, PosBoundary];
    Vel = [VelFluid, VelBoundary];
    VelHalf = [VelHalfFluid, VelBoundary]; % Vel Boundary is always zeros so we dont care
    Acc = [AccFluid, VelBoundary];
    Rho_RhoHalf_dRho = [Rho_RhoHalf_dRhoFluid, Rho_RhoHalf_dRhoBoundary];
    
    writeFrame(Pos, Vel, Rho_RhoHalf_dRho, numFluidParticles, currStep);

    t = tic;
    [Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho] = Step(Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho, params, 0.5);
    currStep = currStep + 1;
    
    for i = currStep:numSteps
        fprintf(strcat('Curr Step = ', num2str(i), '\n'));
        [Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho] = Step(Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho, params, 1);
        if(mod(i,10) == 0)
            writeFrame(Pos, Vel, Rho_RhoHalf_dRho, numFluidParticles, i);
        end
    end

    t = toc(t)

end

