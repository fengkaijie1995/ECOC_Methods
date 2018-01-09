%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function wil get the each prediced label of each classifier 
% input parameters are classifier, whole predicted labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function label = get_classifier_predicted_label(classifiers,data)
label = [];
for i=1:size(classifiers,1)
    x = predict(classifiers{i},data);
    label = [label x];
end
end

