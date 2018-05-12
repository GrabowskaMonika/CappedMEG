function [ S, l, capping ] = capMEG(S, k, l, capping, d)
    
kmax = k+3;
    if(l > kmax)
%         disp('dziwne')
        rho = 1/(d-kmax);
        S = S - rho*S(kmax);
        S = S(1:kmax);
        l = kmax;
        capping = capping + 1;
    end
end
