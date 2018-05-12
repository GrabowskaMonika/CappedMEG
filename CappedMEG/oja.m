function [ loss, time ] = oja( Anew, k, lRate, isSqrt, isTraining, isOnline )

    ik = 0;
    sizeA = size(Anew);
    EigVectors = randn(sizeA(2),k); %normal distribution 
    loss = 0;
    time = 0;

    if ~isOnline
        if isTraining
            AnewTE = Anew(1:floor(sizeA(1)/10), :);       %training set
            Anew = Anew(floor(sizeA(1)/10)+1:end, :);     %test set
        else
            AnewTE = Anew(floor(sizeA(1)/3)*2+1:end, :);  %test set
            Anew = Anew(1:floor(sizeA(1)/3)*2, :);        %training set
            sizeA = size(Anew);
            loss = zeros(1,floor(sizeA(1)/3*2/10));
        end    
        sumLength = sum(sum(AnewTE.^2));
    else
        AnewTR = Anew(1:floor(sizeA(1)/10), :);         %traning set
        AnewTE = Anew(floor(sizeA(1)/10)+1:end, :);     %test set
        loss = zeros(1, sizeA(1));
    end
    sizeA = size(Anew);

    for i=1:sizeA(1)
        tic
        if isSqrt == 1
            lRatei = lRate(1)/sqrt(lRate(2) + i);
        elseif isSqrt == 0
            lRatei = lRate(1)/(lRate(2) + i);
        end
        
        [Q, R] = qr(EigVectors, 0);
        EigVectors = Q;
        
        time = time + toc;
        
        if isOnline
            if i == 1
                loss(1) = sum(Anew(i,:).^2) -  sum((Anew(i,:)*EigVectors).^2);
            else    
                loss(i) = loss(i-1) + (sum(Anew(i,:).^2) -  sum((Anew(i,:)*EigVectors).^2));        
            end
        else        
             if ~isTraining
             if mod(i,10) == 0
              sizeE = size(EigVectors);
              if sizeE(2) < k 
              ik = ik + 1;
               loss(ik) = 0;
             else
             ik = ik + 1;
             loss(ik) = compressionLoss(AnewTE, EigVectors, k, sumLength);
             end
             end
            end
        end
        
        tic
        EigVectors = EigVectors + lRatei * (Anew(i,:)'*((Anew(i,:)) * EigVectors));
        time = time + toc;
    end

     if isTraining
        if isOnline
            loss = loss(end);
        else
            loss = compressionLoss(AnewTE, EigVectors, k, sumLength);
        end
     end
end
