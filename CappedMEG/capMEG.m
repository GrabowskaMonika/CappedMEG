function [ S, l, capping ] = capMEG(S, k, l, capping, d)

%Capping procedure for MEG algorithm
    
    kmax = k+3;
    if(l > kmax)
        rho = 1/(d-kmax);
        S = S - rho*S(kmax);
        S = S(1:kmax);
        l = kmax;
        capping = capping + 1;
    end
end
