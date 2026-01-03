%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
%Do examination 2
%Arguments:
%   x: information table
%Return values:
%   t: time used for computing (Addition, Deletion, Addition-deletion)
%   num: number of attributes in the computed reduct (Addition, Deletion, Addition-deletion)
%   R: the set of reduct (Addition, Deletion, Addition-deletion)
%Example:
%   [t,num,R]=exam2(x); x is an information table (data set)

%try: glass
function [t,num,R] = exam2(x)
tic;
[RD,PD]=RCDS(x);
td = toc;
tic;
[RAD,PAD]=RCADS(x);
tad = toc;
tic;
[RA,M,Mc]=RCAAS(x);
ta = toc;

t = [ta,td,tad];
R{1} = RA;
R{2} = RD;
R{3} = RAD;

num=[size(RA,2),size(RD,2),size(RAD,2)];

