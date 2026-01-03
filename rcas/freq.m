%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
%Heuristic function based on frequency
%Arguments:
%   X: information table
%   s: sort type (ascend / descend)
%Return values:
%   v: vector of attribute order
function I = freq(X,s)
[r,c]=size(X);
ind=[];
freq=[];
tmp=[];
for i=1:c
    x = X(:,i);
    tmp=[];
    for j=1:r
        val = x(j);
        b = 1;
        for k=1:length(tmp)
            if val == tmp(k)
                b = 0;
                break;
            end
        end
        
        if b == 1
            tmp=[tmp,val];
        end
    end
    freq(i) = length(tmp);
end
[Y,I]=sort(freq,s);