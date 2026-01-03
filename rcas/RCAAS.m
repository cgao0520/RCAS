%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
% reduct construction algorithm by addition strategy
% arguments:
%   S: is an information table
% return values:
%   R: reduct
%   M: Discernibility Matrix of S (matrix form)
%   Mc: Discernibility Matrix ( set form with count)

function [R,M,Mc] = RCAAS(S)
%tic
R=[];

[u,at]=size(S);
CA=1:at;
[M,Mc] = DiscernibilityMatrix(S);
Mcc=Mc;
while size(Mc,2)>0 && size(CA,2)>0
% (1) choose an attribute a from CA
    a = sigma_frequency(CA,Mc);
    g = Group(a,Mc);
    Mc=DeleteGroup(Mc,g);
    CA=DeleteAttr(CA,a);
% (2) test a
    if delta(a,g,Mc)~=3 % ~=unnecessary
        R=[R,a];
        % (2.1) test Ai
        %%{
        SortedGroup = xi_frequency(Mc,g);
        for i=1:size(SortedGroup,2)
            m=SortedGroup{i};
            found = 0;
            if JointSufficienct(CA,m,Mc)
                CA = DeleteAttrSet(CA,m);
                for j=1:size(Mc,2)
                    Mc{j}.m=DeleteAttrSet(Mc{j}.m,m);
                end
                found = 1;
                break;
            end
            if found==1
                break;
            end
        end
        %%}
    end
    %}    
    
end
Mc=Mcc;
%toc



% get the discernibility matrix of S
% arguments:
%   S: information table
% return values:
%   M: Discernibility Matrix (matrix form)
%   Mc: Discernibility Matrix (set form with count)
function [M,Mc]=DiscernibilityMatrix(S)
[r,c]=size(S);
Mc=[];
M=[];
n=1;
for i=1:r-1
    x=S(i,:);
    for j=i+1:r
        y=S(j,:);
        m=[];
        for k=1:c
            if x(k)~=y(k)
                m=[m,k];
            end
        end
        if size(m,2)~=0
            M{n}=m;
            n=n+1;
        end
        
    end
end

%%{
DM=M;
n=1;
c=size(M,2);
for i=1:c-1
    m1=M{i};M{i}=[];
    if size(m1,2)==0
        continue;
    end
    count = 1;
    for j=i+1:c
        m2=M{j};
        if size(m2,2)==0 % m = empty set
            continue;
        end

        if Equiv(m1,m2)
            count=count+1;
            M{j}=[];
        else
            continue;
        end
    end
    Mc{n}=struct('m',m1, 'count',count);
    n=n+1;
end

if c > 0
    m1=M{c};M{c}=[];
    if size(m1,2)~=0
        Mc{n}=struct('m',m1, 'count',1);
    end
end
M=DM;
%%}

% fitness function of sigma
% argument:
%   CA: Attributes set for computation
%   Mc: Discernibility Matrix (set form with count)
% return values:
%   a: the chosen attribute
function [a]=sigma_frequency(CA,Mc)
    c = size(CA,2);
    max_s = 0;
    max_a = 1;
    for i=1:c
        a = CA(i);
        s = GroupSize(a,Mc);
        if s > max_s
            max_s = s;
            max_a = a;
        end
    end
    a = max_a;
    

    
% function to compute the |Group(a)|
% argument:
%   a: denoted attribute
%   Mc: Discernibility Matrix (set form with count)
% return values:
%   s: cardinality of Group(a)
function [s]=GroupSize(a,Mc)
    s = 0;
    c = size(Mc,2);
    for i=1:c
        if size(find(Mc{i}.m == a),2)>0
            s = s+Mc{i}.count;
        end
    end
            
% function to get Group(a)
% argument:
%   a: denoted attribute
%   m: an element in Group(a)
%   Mc: Discernibility Matrix (set form with count)
% return values:
%   g: Group(a)
function [g]=Group(a,Mc)
    g = [];
    c = size(Mc,2);
    n=1;
    for i=1:c
        if size(find(Mc{i}.m == a),2)>0
            g{n} = Mc{i}.m;
            n = n+1;
        end
    end

    
% function help delta to test an attribute
% argument:
%   m: denoted attribute
%   Mc: Discernibility Matrix (set form with count)
% return values:
%   r: 1 or 0
function [r] = gamma(m,Mc)
    r=0;
    for i=1:size(Mc,2)
        m1=Mc{i}.m;
        
        a_c = 0;
        for j=1:size(m1,2)
            b = 0;
            for k=1:size(m,2)
                if m1(j)==m(k)
                    b=1;
                    break;
                end
            end
            if b==0 % m1 is not a subset of m
                break;
            else
                a_c = a_c+1;
            end
        end
        if a_c == size(m1,2)
            r=1;
            return;
        else
            continue;
        end
    end
            
% function to test an attribute
% argument:
%   a: denoted attribute
%   g: Group(a)
%   Mc: Discernibility Matrix (set form with count)
% return values:
%   r: test result 1 for core, 2 for necessary, 3 for unnecessary
function [r]=delta(a,g,Mc)
    %g = Group(a,Mc);
    c = size(g,2);
    sig = 0;
    for i=1:c
        m = g{i};
        sig = sig+gamma(m,Mc);
    end
    if sig == c || c==0
        r = 3;
    else
        r = 2;
    end
        
% function: delete Group(a) from M
% argument:
%   Mc: Discernibility Matrix (set form with count)
%   g: Group(a)
% return values:
%   M: M=Mc-Group(a)
function [M]=DeleteGroup(Mc,g)
    Mcc = Mc;
    c_g=size(g,2);
    c_m=size(Mcc,2);
    for i=1:c_g
        m=g{i};
        for j=1:size(Mcc,2)
            if Equiv(m,Mcc{j}.m)
                Mcc{j}.m=[];
                Mcc{j}.count=0;
                continue;
            end
        end 
    end
    n=1;
    M=[];
    for i=1:size(Mcc,2)
        if Mcc{i}.count==0
            continue;
        end
        M{n}=Mcc{i};
        n = n+1;
    end
        
% function: delete attribute a from CA
% argument:
%   CA: attribute set
%   a: attribute
% return values:
%   C: C=CA-{a}
function C=DeleteAttr(CA,a)
    n=1;
    C=[];
    for i=1:size(CA,2)
        if CA(i)~=a
            C(n)=CA(i);
            n = n+1;
        end
    end
      
    
% function: delete attribute set from another set
% argument:
%   CA: attribute set
%   m: attribute set
% return values:
%   C: C=CA-m   
function C=DeleteAttrSet(CA,m)
    C = CA;
    for i=1:size(m,2)
        C=DeleteAttr(C,m(i));
    end
    
% function: delete attribute a from CA
% argument:
%   CA: attribute set
%   a: attribute
% return values:
%   C: C=CA-{a}    
function [SortedGroup]=xi_frequency(Mc,g)
    fitness=[];
    m1=[];
    m2=[];
    for i=1:size(g,2)
        m1=g{i};
        count = 0;
        for j=1:size(Mc,2)
            m2=Mc{j}.m;
            if HasIntersec(m1,m2)
                count = count+1;
            end
        end
        fitness(i)=count;
    end
    [s_fitness,index]=sort(fitness,'descend');
    SortedGroup=g(index);
    
   
% function: intersection of two sets
% argument:
%   m1: attribute set
%   m2: attribute set
% return values:
%   r: 1 if the intersection of two sets is not empty, 0 for otherwise.
function r=HasIntersec(m1,m2)
    r=0;
    for i=1:size(m1,2)
        for j=1:size(m2,2)
            if m1(i) == m2(j)
                r=1;
                return;
            end
        end
    end
    
    
% function: intersection of two sets
% argument:
%   CA: attribute set
%   mi: an element of Group(a)
%   Mc: Discernibility Matrix (set form with count)
% return values:
%   r: 1 if the intersection of two sets is not empty, 0 for otherwise.    
function r=JointSufficienct(CA,mi,Mc)
    r=0;
    CAA=CA;
    CAA=DeleteAttrSet(CAA,mi);
    if size(CAA,2)==0
        r=0;
        return;
    end
    
    for i=1:size(Mc,2)
        if ~HasIntersec(CAA,Mc{i}.m)
            r=0;
            return;
        end
    end
    r=1;
        
        
% function: test two attributes whether they are equivalent or not
% argument:
%   m1: attribute set
%   m2: attribute set
% return values:
%   b: 1 for equvalent, 0 for not
function b=Equiv(m1,m2)
    if size(m1,2)~=size(m2,2)
        b=0;
    else
        if size(find((m1==m2)==1),2) == size(m1,2)
            b=1;
        else
            b=0;
        end
    end
            