function [ ] = plotFigureOnline(Regret, batchLossPerIteration, color, lineWidth)    

    [m,nn] = size(Regret);
    Graph =  mean(Regret(10:m, :)');
    v1 = 10:m;
    Graph = Graph./(v1);
    Graph = Graph - batchLossPerIteration;
    plot(v1(40:end), Graph(40:end), color,  'LineWidth', lineWidth)
    
end