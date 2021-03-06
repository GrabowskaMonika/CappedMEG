function [ loss, time, capping ] = MEG(Anew, k, lRate, isMEG, isSqrt, isCapped, isTraining, isOnline, valSetSize, teSetSize)

    time = 0;
    sizeA = size(Anew);
    l = 0;
    C = [];
    U = zeros(sizeA(2),0);
    S = [];  
    Un = [];
    Sn = [];
    Epsilon = 10^(-10);
    ik = 0;
    capping = 0;

    if ~isOnline
        if isTraining
            AnewTE = Anew(1:floor(sizeA(1)*valSetSize), :);    %validaton set in batch test
            Anew = Anew(floor(sizeA(1)*valSetSize)+1:end, :);   %appropriate training set
        else
            AnewTE = Anew(floor(sizeA(1)*(1-teSetSize))+1:end, :);  %test set in batch test
            Anew = Anew(1:floor(sizeA(1)*(1-teSetSize)), :);        %training set in batch set
            sizeA = size(Anew);
            loss = zeros(1,floor(sizeA(1)*(1-teSetSize)/10));
        end    
        sumLength = sum(sum(AnewTE.^2));
    else
        loss = zeros(1, sizeA(1));
    end
    sizeA = size(Anew);

    for i=1:sizeA(1)
        tic
        
        if isSqrt == 0
            lRatei = lRate(1)/(lRate(2) + i);
        elseif isSqrt == 1
            lRatei = lRate(1)/sqrt(lRate(2) + i);
        elseif isSqrt == 2
            lRatei = 1;
        end

        xt =  Anew(i,:)*U;
        xp = Anew(i,:) - xt*U';
        xpNorm = norm(xp);
        time = time + toc;
        
        if isOnline
            if i == 1        
                loss(1) = (sum(Anew(i,:).^2) - xpNorm^2*(k-l)/(sizeA(2) - l) - sum(xt.^2));
            elseif l<k
                loss(i) = loss(i-1) + (sum(Anew(i,:).^2) - xpNorm^2*(k-l)/(sizeA(2) - l) - sum(xt.^2));
            else        
                loss(i) = loss(i-1) + (sum(Anew(i,:).^2) -  sum(xt(1:k).^2));
            end
        else
            if ~isTraining
                if mod(i,10)==0 
                     sizeE = size(U);
                     if sizeE(2) < k 
                        ik = ik + 1;
                        loss(ik) = 0;
                     else
                        ik = ik + 1;
                        loss(ik) = compressionLoss(AnewTE, U, k, sumLength);
                     end
                end
            end
        end

        tic
        if xpNorm>Epsilon
            C = [diag(S) + lRatei*(xt'*xt), xpNorm*lRatei*xt'; xpNorm*lRatei*xt,  (xpNorm^2)*lRatei ];
            [Un,Sn] = symeig(C); 
            Sn=diag(Sn);
            Sn = Sn(length(Sn):-1:1);
            Un = Un(:, length(Un):-1:1);    
            U = [U, xp'/xpNorm]*Un;  
        else
            C = diag(S) + lRatei*(xt'*xt);
            [Un,Sn] = symeig(C);
            Sn=diag(Sn);
            Sn = Sn(length(Sn):-1:1);
            Un = Un(:, length(Un):-1:1);   
            U = U*Un;
        end

        S = Sn(Sn >= Epsilon);

        if(length(S)>=k)
            Sn = S;
        end
        
            l = length(Sn);
        
        if isCapped == 1
            if isMEG == 0
                [Sn, l, capping ] = cap( Sn, k, l, capping );
            elseif isMEG == 1
                [Sn, l, capping ] = capMEG( Sn, k, l, capping, sizeA(2));
            end
        end

        if(l>k)
            if isMEG == 0
                S = projectionMSG(k, Sn);
            elseif isMEG == 1            
                S = projectionMEG(k, Sn);               
            elseif isMEG == 2
                S = Sn(1:k);
            end   
        else
            S = Sn;
        end

        l = length(S);
        U = U(:,1:l);
        time = time + toc;
    end
    
    if isTraining
        if isOnline
            loss = loss(end);
        else
            loss = compressionLoss(AnewTE, U, k, sumLength);
        end
    end    
end
