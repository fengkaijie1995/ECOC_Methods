%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function wil get the each right rates of each classifier 
% input parameters are coding matrix, classifier predicted labels and true test labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function classifier_right = get_classifier_right(ECOC,predicted_Y,TTL)
classifier_right = zeros(1,size(ECOC,2));
for i = 1:size(TTL,1)
    true_binary_y = ECOC(TTL(i),:);
    predicted_y = predicted_Y(i,:);
    classifier_right = classifier_right + (true_binary_y == predicted_y);
end
classifier_right = classifier_right/size(TTL,1);
end

