%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
%Reduct construction based on Deletion Strategy
%Arguments:
%   X: information table
%Return values:
%   R: reduct
%   p: partition based on AT
function [R,P] = RCDS(X)
%tic
[r,c] = size(X);
R=1:1:c;
P = GetPartition(X); % partition based on AT (all attributes)
I = freq(X,'ascend');

flag = 1;
red_att = [];
RR = []; % the set of reduced attributes
while flag
    
    for i=1:length(I)
        red_att = RR;
        red_att = [red_att, I(i)];
        XX = GetReducedX(X,red_att);
        
        PX = GetPartition(XX);
        if ComparePartition(P,PX) == 1
            RR = red_att;
            I(i)=[];
            break;
        end
    end
    if size(RR,2) ~= size(red_att,2)
        flag = 0;
    end
end

R = [];
for i=1:c
    flag = 1;
    for j=1:length(RR)
        if i==RR(j)
            flag = 0;
            break;
        end
    end
    if flag == 1
        R = [R,i];
    end
end
    
%toc


%Get a new set of objects with reduced attributes
%Arguments:
%   X: information table
%   red_att: attributes need to be reduced
%Return values:
%   XX: a new set of objects
function XX = GetReducedX(X,red_att)
[r,c] = size(X);
XX = [];
for i=1:c
    flag = 1;
    for j=1:length(red_att)
        if i==red_att(j)
            flag = 0;
            break;
        end
    end
    if flag == 1
        XX=[XX,X(:,i)];
    end
end


    
