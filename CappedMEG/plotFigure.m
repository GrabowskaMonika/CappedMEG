function [ ] = plotFigure(Regret, batchLossPerIteration, color, lineWidth)

    Graph = mean(Regret(2:end, :)');
    [ m, nn ] = size(Graph);
    Graph = Graph - batchLossPerIteration; 
    v1= 1:1:nn;
    v1 = v1 * 10;
    plot(v1(5:end), Graph(5:end), color,  'LineWidth', lineWidth)
    
end
