%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function will get the each data complexity of each column of one coding matrix 
% input parameters are coding matrix, dc option, traindata and trainlabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ECOC_cplx = get_ecoc_cplx(ECOC,DC_OPTION,TTD,TTL)
ECOC_cplx = [];
if strcmp(DC_OPTIONS{i},'CF') == 1
    return;
end
for i = 1:size(ECOC,2)
    c1 = find(ECOC(:,i) == 1)
    c2 = find(ECOC(:,i) == -1)
    cplx = get_complexity_option(c1,c2,TTD,TTL,DC_OPTION);
    ECOC_cplx = [ECOC_cplx cplx];
end
end
