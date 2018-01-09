%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function focus on loading selected features 
% input parameters are file path, traindata, testdata and feature size 
% note that the data be preselected by correponding algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fstd,fsttd] = get_fsdata(path,td,ttd,feature_size)
load(path);
selected_feature = importance_order(1:feature_size);
fstd = td(:,selected_feature);
fsttd = ttd(:,selected_feature);
end