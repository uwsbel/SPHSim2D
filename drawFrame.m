function [] = drawFrame(Pos, PosBoundary, boxWidth, boxHeight)
%drawFrame Plot particles at a specific time step
    clf;
    close all;
    totalParticles = size(Pos, 2);
    hold on;
    axis([-0.2 1.5*boxWidth -0.2 1.5*boxHeight]);
    numFluidParticles = size(Pos,2);
    numBoundaryParticles = size(PosBoundary,2);
  
    for i = 1:numFluidParticles
       x = Pos(1,i);
       y = Pos(2,i);
       scatter(x,y,'MarkerEdgeColor',[0 .5 .5],...
                   'MarkerFaceColor',[0 .7 .7],...
                   'LineWidth',1.5);
    end
    
    for i = 1:numBoundaryParticles
       x = PosBoundary(1,i);
       y = PosBoundary(2,i);
       scatter(x,y,'MarkerEdgeColor',[0 0 0],...
                   'MarkerFaceColor',[0 0 0],...
                   'LineWidth',1.5);
    end
    
    hold off;
    

end

