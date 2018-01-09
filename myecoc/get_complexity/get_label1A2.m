%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functon is to the traindata of group1, group2
% parameters are group1, group2, traindata and trainlabel
% return most traindata of group1 and group2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [l1,l2]=get_label1A2(c1,c2,train,label)
    l1=[];
    for i=1:size(c1)
        l1=[l1;label(find(label==c1(i)),:)];
    end
    l2=[];
    for i=1:size(c2)
        l2=[l2;label(find(label==c2(i)),:)];
    end    
end
