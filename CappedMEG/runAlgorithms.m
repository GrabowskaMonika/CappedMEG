function [ ] = runAlgorithms(A, k, n, tit, C1, C2, isOnline)

    sizeA = size(A);
    Anew = A./repmat(sqrt(sum(A'.^2)),sizeA(2),1)';     %data normalization
    
    if isOnline
        AnewTE = Anew(floor(sizeA(1)/10)+1:end, :);          %test set in online experiment
    else
        AnewTE = Anew(1:floor(floor(sizeA(1)/3)*2/10), :);      %test set in batch experimnet
    end
    sizeTE = size(AnewTE);
    
    D =  svd(Anew).^2 / sizeA(1);
    batchLossPerIteration = sum(D(k+1:length(D)));

    lossIncremental = zeros(sizeTE(1),n);
    lossOja = zeros(sizeTE(1),n);
    lossMSG = zeros(sizeTE(1),n);
    lossMEG = zeros(sizeTE(1),n);
    
    capIncremental = 0;
    capMSG = 0;
    capMEG = 0;
    
     if tit == "Artifficial"
        lossIncremental = zeros(sizeA(1),n);
        lossOja = zeros(sizeA(1),n);
        lossMSG = zeros(sizeA(1),n);
        lossMEG = zeros(sizeA(1),n);
        a = C2(1:2);
        c = C2(3:4);
        e = C2(5:6);
        b = 1;
        d = 1;
        f = 1;
     end

    for ii = 1:n
        ii
        if tit == "Artifficial"
            AnewTE = mnrnd(1,((1.1).^((-1)*1:32))./sum((1.1).^((-1)*1:32)),sizeA(1));
        else
            
            Anew = Anew(randperm(sizeA(1)), :);     %mixing tuples

            if isOnline
                size(Anew);
                AnewTR = Anew(1:floor(sizeA(1)/10), :);     %training set
                AnewTE = Anew(floor(sizeA(1)/10)+1:end, :); %test set
                size(AnewTR);
            else 
                AnewTR = Anew(1:floor(sizeA(1)/3)*2, :);    %training set
                AnewTE = Anew;                              %test set
            end

            %training learning rate
            for i1 = 1:length(C1)
                for i2 = 1:length(C2)
                    lRate = [C1(i1), C2(i2)];        
                    [lossOjaLR(i1,i2), timeOjalR] = oja(AnewTR, k, lRate, 0, 1, isOnline);
                    [lossOjaLRSqrt(i1,i2), timeOjaLR] = oja(AnewTR, k, lRate, 1, 1, isOnline);
                    [lossMEGLR(i1,i2), timeMEGLR, capMEGLR] = MEG(AnewTR, k, lRate, 1, 0, 1, 1, isOnline);
                    [lossMEGLRSqrt(i1,i2), timeMEGLR, capMEGLR] = MEG(AnewTR, k, lRate, 1, 1, 1, 1, isOnline);
                    [lossMSGLR(i1,i2), timeMSGLR, capMSGLR] = MEG(AnewTR, k, lRate, 0, 0, 1, 1, isOnline);
                    [lossMSGLRSqrt(i1,i2), timeMSGLR, capMSGLR] = MEG(AnewTR, k, lRate, 0, 1, 1, 1, isOnline);
                end
            end

            [a, b] = minLRate(lossOjaLR, lossOjaLRSqrt); 
            [c, d] = minLRate(lossMEGLR, lossMEGLRSqrt);  
            [e, f] = minLRate(lossMSGLR, lossMSGLRSqrt);
        
        end
        
        %MEG(Anew, k, lRate, isMEG, isSqrt, isCapped, isTraining, isOnline)
        %isMEG == 0 - MSG, %isMEG == 1 - MEG, %isMEG == 2 - IPCA, 
        [lossIncremental(:,ii) , timeIncremental(ii),  capIncremental(ii) ] = MEG(AnewTE, k, [0, 0], 2, 2, 0, 0, isOnline);
        [lossOja(:,ii) , timeOja(ii)] = oja(AnewTE, k, [C1(a(1)), C2(a(2))], b, 0, isOnline);
        [lossMEG(:,ii) , timeMEG(ii),  capMEGsqrt(ii) ] = MEG(AnewTE, k, [C1(c(1)), C2(c(2))], 1, d, 1, 0, isOnline);
        [lossMSG(:,ii) , timeMSG(ii),  capMSGsqrt(ii) ] = MEG(AnewTE, k, [C1(e(1)), C2(e(2))], 0, f, 1, 0, isOnline);

    end

    timeIncrementalAVG = mean(timeIncremental);
    timeOjaAVG = mean(timeOja);
    timeMSGAVG = mean(timeMSG);
    timeMEGAVG = mean(timeMEG);

    capMSGsqrtAvg = mean(capMSGsqrt);
    capMSGAvg = mean(capMSG);
    capMEGsqrtAvg = mean(capMEGsqrt);
    capMEGAvg = mean(capMEG);
    
    %drawing chart
    figure
    hold on;
    
    if isOnline        
        plotFigureOnline(lossIncremental, batchLossPerIteration, 'k', 2);
        plotFigureOnline(lossOja, batchLossPerIteration, 'r', 2);
        plotFigureOnline(lossMSG, batchLossPerIteration, 'b', 2);
        plotFigureOnline(lossMEG, batchLossPerIteration, 'g', 2);
        ylabel('regret per trial')
    else
        plotFigure(lossIncremental, batchLossPerIteration, 'k', 2);
        plotFigure(lossOja, batchLossPerIteration, 'r', 2);
        plotFigure(lossMSG, batchLossPerIteration, 'b', 2);
        plotFigure(lossMEG, batchLossPerIteration, 'g', 2);
        ylabel('excess compression loss');        
    end
    
    hold off;
    set(gcf, 'units','points','position',[200,200,400,200]);
    legend('IPCA', 'Oja', 'MSG', 'MEG');
    xlabel('# iterations')
    title(strcat(tit, ' (k = ', int2str(k), ')'));
    drawnow;
    frame = getframe(1);
    
    %saving results
    if isOnline
        folder = 'ResultOnline';
    else
        folder = 'ResultBatch';
    end
    print(strcat(folder, '/Figure/', tit, int2str(k)),'-depsc');
         
    save(strcat(folder, '/', tit, '/', tit, 'Figure', int2str(k)), 'lossOja', 'lossMSG', 'lossMEG', 'lossIncremental', 'batchLossPerIteration', ...
        'capMEGsqrtAvg', 'capMEGAvg', 'capMSGsqrtAvg', 'capMSGAvg', 'timeOjaAVG', 'timeMEGAVG', 'timeMSGAVG', 'timeIncrementalAVG');
    
end