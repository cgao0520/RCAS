%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
%Do examination
%Arguments:
%   X: information table
%   s: the number of objects in each step of loop
%   n: the number of loops
%Return values:
%   t: time used for computing (Addition, Deletion, Addition-deletion)
%   num: number of attributes in the computed reduct (Addition, Deletion, Addition-deletion)
%   R: the set of reduct (Addition, Deletion, Addition-deletion)
%Example:
%   [t,num,R]=exam(X,20); X is an information table (data set)
%   the result is:
%           t = 2.0385    3.6588    2.5599  
%           n = 7     8     8
%           R = [1x7 double]    [1x8 double]    [1x8 double]
%try: glass
function [t,num,R] = exam(X,s,n)
barMat = [];
timeMat = [];
for i=s:s:s*n
t=[];
RA=[];
RD=[];
RAD=[];
x=X(1:i,:);
tic;
[RA,M,Mc]=RCAAS(x);
ta = toc;
tic;
[RD,p]=RCDS(x);
td = toc;
tic;
[RAD,p]=RCADS(x);
tad = toc;

t = [ta,td,tad];
num = [size(RA,2),size(RD,2),size(RAD,2)];
R{1} = RA;
R{2} = RD;
R{3} = RAD;

timeMat = [timeMat; t];
barMat = [barMat; num];
end

hold off;
subplot(1,2,1);
    bar(barMat);
hold on;
subplot(1,2,2);
    plot(s:s:s*n, timeMat(:,1),'b*-'); hold on;
    plot(s:s:s*n, timeMat(:,2),'k^-'); hold on;
    plot(s:s:s*n, timeMat(:,3),'go-');
hold off;

legend('Addition','Deletion','Addition-deletion');
