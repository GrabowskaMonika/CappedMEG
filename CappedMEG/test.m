clc;    
clear;

C1 = 2.^((-5):(4));
C2 = 0;
n = 20;

isOnline = [1,0];
k = [1,2,4,8];
dataSets = ["MNIST", "Musk", "OptDigits", "Scene", "Segmentation", "Spambase"];
for is = 1:length(isOnline)
    for i = 1:length(dataSets)
        disp(strcat(dataSets(i), '.mat'))
        A = importdata(strcat(dataSets(i), '.mat'));
        for j = 1:length(k)     
            runAlgorithms( A, k(j), n, dataSets(i), C1, C2, isOnline(is));
        end
    end
end

if isOnline(1)
    A = mnrnd(1,((1.1).^((-1)*1:32))./sum((1.1).^((-1)*1:32)),11000);
    runAlgorithms( A, 1, n, 'Artifficial', C1, [10,1, 8,1, 7,1], isOnline(1));
    runAlgorithms( A, 4, n, 'Artifficial', C1, [9,1, 8,1, 5,1], isOnline(1));
end
