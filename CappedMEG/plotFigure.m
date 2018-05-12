function [ ] = plotFigure(Loss, batchLossPerIteration, color, lineWidth)

    LossAVG = mean(Loss(2:end, :)');
    [m, nn] = size(LossAVG);
    Regret = LossAVG - batchLossPerIteration; 
    v1= 1:1:nn;
    v1 = v1 * 10;
    plot(v1(2:end), Regret(2:end), color,  'LineWidth', lineWidth)
end
