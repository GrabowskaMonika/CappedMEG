function [ ] = plotFigureOnline(Loss, batchLossPerIteration, color, lineWidth)    

    [m,nn] = size(Loss);
    LossAVG =  mean(Loss(10:m, :)');
    v1 = 10:m;
    LossAVG = LossAVG./(v1);
    Regret = LossAVG - batchLossPerIteration;
    plot(v1(20:end), Regret(20:end), color,  'LineWidth', lineWidth)
    
end