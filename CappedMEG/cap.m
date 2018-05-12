function [ S, l, capping ] = cap(S, k, l, capping)

    kmax = k+3;
    if(l > kmax)
        S = S(1:(kmax));
        l = kmax;
        capping = capping + 1;
    end
end
