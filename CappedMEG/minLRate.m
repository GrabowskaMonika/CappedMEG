function [vector s] = minLRate (A, Asqrt)

    [ i j ] = find(A == min(A(A > 0)));
    [ k l ] = find(Asqrt == min(Asqrt(Asqrt > 0)));

    if A(i(1), j(1)) < Asqrt(k(1), l(1))
        vector(1) = i(1);
        vector(2) = j(1);
        s = 0;
    else
        vector(1) = k(1);
        vector(2) = l(1);
        s = 1;
    end
end
