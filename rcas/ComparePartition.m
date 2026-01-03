%Author: Vincent(Cong) Gao
%Create Date: October 2014
%URL: http://www2.cs.uregina.ca/~gao266
%Compare two partitions
%Arguments:
%   two partitions
%Return values:
%   val: 1 if they are equal, 0 otherwise
function val = ComparePartition(p1,p2)
s1 = size(p1,2);
s2 = size(p2,2);
if s1 ~= s2
    val=0;
    return;
end

b = zeros(1,s1);
for i=1:s1
    bi = cell2mat(p1(i));
    si = size(bi,2);
    for j=1:s2
        bj = cell2mat(p2(j));
        sj = size(bj,2);
        if si ~= sj
            continue;
        else
            bii = sort(bi);
            bjj = sort(bj);
            count = 0;
            for k=1:si
                if bii(k) ~= bjj
                    break;
                else
                    count = count + 1;
                end
            end
            if count == si
                b(i) = 1;
                break;
            end
        end
    end
end

if size(find(b==0),2) ~= 0
    val = 0;
else
    val = 1;
end