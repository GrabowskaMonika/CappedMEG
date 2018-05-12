clc;    
clear;

C1 = 2.^((-5):(4));
C2 = 0;
n = 50;

isOnline = [0,1];
k = [1,2,4,8,16,20];
dataSets = ["Faces", "MNIST", "Musk", "OptDigits", "Spambase", "Scene"];
for is = 1:length(isOnline)
    for i = 1:length(dataSets)
        disp(strcat(dataSets(i), '.mat'))
        A = importdata(strcat(dataSets(i), '.mat'));
        for j = 1:length(k)     
            runAlgorithms( A, k(j), n, dataSets(i), C1, C2, isOnline(is));
        end
    end
end

A = mnrnd(1,((1.1).^((-1)*1:64))./sum((1.1).^((-1)*1:64)),11000);
for j = 1:length(k)     
    runAlgorithms( A, k(j), n, 'Artifficial', C1, [10,1, 8,1, 7,1], 1);
end

