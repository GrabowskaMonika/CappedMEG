function [ eigenValues ] = projectionMSG(k, values)

    n = length(values);
    values = values(length(values):-1:1);
    i = 0; 
    j = 0;
    si = 0; 
    sj = 0;
    Epsilon = 10^(-6);
    stop = true;

    while (i < n && stop)
        if(i < j)
            S = (k - (sj - si) - (n - j)) / (j - i);           
            if(i <= 0 || values(i) + S <= 0) && ...
                (values(i + 1) + S >= 0 && values(j) + S <= 1) && ...
                (j >= n || values(j + 1) + S >= 1 )
                eigenValues = values(i + 1:n) + S;
                eigenValues = eigenValues(eigenValues >= Epsilon);
                eigenValues(eigenValues > 1) = 1;
                stop = false;
                eigenValues = eigenValues(length(eigenValues):-1:1);
            end
        elseif(i == j && n - j == k)
            eigenValues = values(i + 1:n);
            stop = false;
            eigenValues = eigenValues(eigenValues >= Epsilon);
            eigenValues(eigenValues > 1) = 1;
            eigenValues = eigenValues(length(eigenValues):-1:1);
        end
    
        if(j < n && values(j + 1) - values(i + 1) <= 1)
            sj = sj + values(j + 1);
            j = j + 1;
            while j < n && values(j + 1) == values(j)
                sj = sj + values(j + 1);
                j = j + 1;
            end
        else
            si = si + values(i + 1);
            i = i + 1;
            while (i < n) && (values(i + 1) == values(i))
                si = si + values(i + 1);
                i = i + 1;
            end 
        end 
    end
end
