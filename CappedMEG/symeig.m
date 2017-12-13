function [ U, V ] = symeig(C)

    [ U, V ] = eig((C + C') / 2);
end
