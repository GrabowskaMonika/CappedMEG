function [ compLoss ] = compressionLoss(AnewW, EigVectors, k, sumLength)
    
    sumLengthAlg = sum(sum((AnewW*EigVectors(:,1:k)) .^ 2));
    compLoss = sumLength - sumLengthAlg;
    sizeW = size(AnewW);
    compLoss = compLoss/sizeW(1);

end