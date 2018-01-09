%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function focus on get F1 values betwen group c1 and c2
% input parameters are groups c1 and c2, traindata and trainlabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cplx = get_complexityF1(c1,c2,train,label)
     disp('compute the F1 cplx value');
    [data1,data2]=get_data1A2(c1,c2,train,label);
    for p=1:size(train,2)
        fp(p)=(mean(data1(:,p)-mean(data2(:,p)))^2/(var(data1(:,p))+var(data2(:,p))));
    end
       %clpx=max(fp);
       cplx = get_mode(fp);
end

function mode = get_mode(m)
    numbers = unique(m);
    fre = [];
    for i=1:size(numbers,2)
       fre(i) = sum(m == numbers(i));
    end
    maxfre = find(fre == max(fre));
    mode = numbers(maxfre(1));
end