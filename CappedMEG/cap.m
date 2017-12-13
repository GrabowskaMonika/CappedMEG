function [ S, l, capping ] = cap(S, k, l, capping)

    if(l > k + 3)
        S = S(1:k + 3);
        l = k + 3;
        capping = capping + 1;
    end
end
