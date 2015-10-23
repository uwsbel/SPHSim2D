function [Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho] = ParallelStep(Pos, Vel, VelHalf, Acc, Rho_RhoHalf_dRho, params, stepTerm)
%ParallelStep 
%   Performs leap-frog numerical integration

    % Assign parameters
    numFluidParticles = params.numFluidParticles;
    dt = params.dt;
    dtHalf = 0.5*dt;
    totalNumParticles = size(Pos,2);
    rho0 = params.rho0;
    g = params.g;
    mu = params.mu;
    h = params.h;
    h2 = h*h;
    epsilon = params.epsilon;
    particleMass = params.particleMass;
    

    NeighborList = GetNeighborList(Pos, params.h, params.maxX, params.maxY, params.numFluidParticles);
   

    % Update velocity and rho at t using acceleration at t-dt and 
    % vel and rho at t-0.5*dt.
    % This is not supposed to happend in the first step, however all of the
    % values are 0 at that point so it does not really matter if we run
    % thiis part of the code. An if statement would be an overkill because
    % it would be evaluated at every integration step.
    for i = 1:numFluidParticles
        Vel(:,i) = VelHalf(:,i) + dtHalf*Acc(:,i);
        Rho_RhoHalf_dRho(1,i) = Rho_RhoHalf_dRho(2,i) + dtHalf*Rho_RhoHalf_dRho(3,i); 
    end
    
    % Create temporary arrays for position and density vector. There is no
    % need to do this for Vel or Acc vector because, the Acc vector is not
    % used in the step loop and VelHalf is the vector that is being update
    % in the step loop and the Vel vector is the one used
    PosNext = Pos;
    Rho_RhoHalf_dRhoNext = Rho_RhoHalf_dRho;
    
    Pressures = zeros(1, totalNumParticles);
    for i = 1:numFluidParticles
        rho_i = Rho_RhoHalf_dRho(1,i);
        Pressures(1, i) = calcPressure(rho_i, rho0);
    end

    RhoHalf = zeros(3, totalNumParticles);
    RhoHalf(2,:) = Rho_RhoHalf_dRho(2,:);
    %Loops through all of the fluid particles
    parfor i = 1:numFluidParticles
        xAcc_i = 0; % Reset values for every particle
        yAcc_i = 0;
        rho_i = Rho_RhoHalf_dRho(1,i);
        drho_i = 0;
        p_i = Pressures(1, i);
        r_i = Pos(:,i);
        v_i = Vel(:,i);
   
        Neighbor = NeighborList{i,1};
        [numNeighbors, dummy] = size(Neighbor);
        for k = 2:numNeighbors
            j = Neighbor(k);
            r_j = Pos(:,j);     

            dr = r_i - r_j;

            norm_dr = norm(dr);
            q = norm_dr/h;
                
            rho_j = Rho_RhoHalf_dRho(1,j);
            p_j = Pressures(1, j);  
            v_j = Vel(:,j);
            dv = v_i - v_j;


            dw_ij = dW(q, h); 
            grad_a_wab = (dw_ij/(h2*q)) * dr;       
            rho_bar = (rho_i+rho_j)/2;
            % Everything is a scalar except unit_dr
            pressureTerm = (particleMass*((p_i/(rho_i*rho_i)) + (p_j/(rho_j*rho_j))))...
                            .* grad_a_wab;                
            muNumerator = particleMass * 2*mu .* (dr' * grad_a_wab) .* dv;
            muDenominator = (rho_bar*rho_bar)*(norm_dr*norm_dr + h2*epsilon);
            muTerm = (muNumerator./muDenominator);
            
            xAcc_i = xAcc_i - pressureTerm(1) + muTerm(1);
            yAcc_i = yAcc_i - pressureTerm(2) + muTerm(2);       
            drho_i = drho_i + (rho_i/rho_j)*particleMass*dv'*grad_a_wab;

        end
        % Leap frog stuff: 
        % stepTerm = 0.5 for first step. Otherwise stepTerm==1. 
        Acc(:,i) = [xAcc_i;...
                    yAcc_i + g];

        % Velocity at t+0.5*dt
        VelHalf(:,i) = VelHalf(:,i) + stepTerm*dt*Acc(:,i);
        
        % rho at t+0.5*dt
        
        Rho_RhoHalf_dRhoNext(:,i) = RhoHalf(:,i) + [0; stepTerm*dt*drho_i; drho_i];
        
        % Temporary Position
        PosNext(:,i) = Pos(:,i) + dt * VelHalf(:,i);

    end
    


    Pos = PosNext;
    Rho_RhoHalf_dRho = Rho_RhoHalf_dRhoNext;
end

