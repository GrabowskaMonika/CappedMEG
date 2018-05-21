function [ eigenValues ] = projectionMEG(k, values)

    l = length(values);
    evalues = exp((-1) * values(1:l));
    
    if ((l - k) == 0 || (l - k) < sum(evalues))
        eigenValues = values;
    else
        lPrim = l;
        stop = false;
        Theta = log((lPrim - k) / sum(evalues(1:lPrim)) / exp(values(lPrim)));
        
        while stop == false
            if (Theta) <= 0 
                stop = true;
            else
                lPrim = lPrim - 1;
                
                if(lPrim - k == 0)
                    Theta = 0;
                else
                    Theta = log((lPrim - k) / sum(evalues(1:lPrim)) / exp(values(lPrim)));
                end
                
            end
        end
        
        eigenValues = values(1:lPrim) - Theta - values(lPrim);
    end
     
end
