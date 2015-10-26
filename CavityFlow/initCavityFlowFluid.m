function [ Pos, Vel, VelHalf, Acc, Rho_RhoHalf_hho ] = initCavityFlowFluid( numFluidParticles, boxWidth, boxHeight, h, rho0 )
%initFluid Summary of this function goes here
%   Detailed explanation goes here

disp('Initializing Fluid Particle System');

Pos = zeros(2, numFluidParticles);
Vel = zeros(2, numFluidParticles);
VelHalf = zeros(2, numFluidParticles);
Acc = zeros(2, numFluidParticles);
Rho_RhoHalf_hho = zeros(3, numFluidParticles);
Rho_RhoHalf_hho(1:2,:) = rho0;


counter = 1;

% Place Fluid Particles
for x =  h:h:(boxWidth-h)  
    for y =  h:h:(boxHeight-h)
        Pos(1,counter) = x;
        Pos(2,counter) = y;
        counter = counter + 1; 
    end
end

end

