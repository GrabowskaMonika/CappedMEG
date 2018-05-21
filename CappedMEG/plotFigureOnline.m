function [ ] = plotFigureOnline(Loss, batchLossPerIteration, color, lineWidth)    

    [m,nn] = size(Loss);
    LossAVG =  mean(Loss(10:m, :)');
    v1 = 10:m;
    LossAVG = LossAVG./(v1);
    Regret = LossAVG - batchLossPerIteration;
    plot(v1, Regret, color,  'LineWidth', lineWidth)
    
end