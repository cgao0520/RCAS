%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
%Reduct construction based on Addition-Deletion Strategy
%Arguments:
%   X: information table
%Return values:
%   R: reduct
%   p: partition based on AT
function [R,P] = RCADS(X)
%tic
R = [];
I = freq(X,'descend');
P = GetPartition(X);
%[r,c] = size(X);
use_att = [];

%%%%%%%%%%%%%%%%%%%%%%%
%Addition Phase
for i=1:length(I)
    use_att = [use_att,I(i)];
    XX = [];
    for j=1:length(use_att)
        XX=[XX,X(:,use_att(j))];
    end
    PX = GetPartition(XX);
    if ComparePartition(P,PX) == 1 %equal
        break;
    end
end
%toc

%%%%%%%%%%%%%%%%%%%%%%%
%Deletion Phase
[RR,PP] = RCDS(XX);
for i=1:length(RR)
    R(i) = use_att(RR(i));
end

