%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function focus on the framework of ECOC 
% input parameters are dataname, traindata, trainlabel,testdata,testlabel,and clasifier 
% note that ECOC frameword include all ECOC algorithms, such as
% ovo,ova,dense random, sparse random, decoc, ecocone, forest ecoc
% and nine DC ECOC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function results = ecoc_process(dataname,TD,TL,TTD,TTL,classifier)
%%1.get all coding matrice
popular_M = {};
DC_M = {};
popular_M = get_popular_M(TD,TL,classifier);
DC_M = get_DC_M(TD,TL);
total_M = [popular_M DC_M];

%%2.train & test
results = train_test(TD,TL,TTD,TTL,total_M,classifier,size(popular_M,2));
results = [dataname results{1,1}];
end

function total_M = get_popular_M(TD,TL,classifier)
total_M = {};
global cds;
%%1.fitcecoc
ficecoc_codings={'onevsone','denserandom','onevsall','ordinal','sparserandom'};
for i = 1:size(ficecoc_codings,2)   
    cds = [];
    ecocmodel = fitcecoc(TD,TL,'Coding',ficecoc_codings{i},'learners',classifier);
    cds = ecocmodel.CodingMatrix;
    total_M = [total_M cds];
end

%%2.ecoc library coding
library_codings={'DECOC','ECOCONE','Forest'};
for i=1:size(library_codings,2)
    clear Parameters;
    Parameters.coding = library_codings{i};
    Parameters.decoding = 'HD';
    Parameters.base = 'MySVM';
    Parameters.base_test = 'MySVM_Test';
    [Classifiers,Parameters] = ECOCTrain(TD,TL,Parameters,[]);
    cds = Parameters.ECOC;
    total_M = [total_M cds];
end
end

function total_M = get_DC_M(TD,TL)
total_M = {};
%%1.DC coding matrices
[total_M,tcplx]=get_all_cds(size(unique(TL),1),TD,TL,'N4');

%%2.fuse the F1,F2 and F3 coding matrices
ensemble_cds = (unique([total_M{1},total_M{2},total_M{3}]','rows'))';
total_M{size(total_M,2)+1} = ensemble_cds;%fuse F1-F3

end

function restuls = train_test(TD,TL,TTD,TTL,total_M,classifier,boundary_pos)

%%1.init
total_predicted_label = {};
total_classifier_prediced_label = {};
total_score = {};
total_time = [];
total_confmusion = {};
total_classifier_error = {};
total_classifier_right = {};
total_ecoc_cplx = {};

%%2.train&test
DC_OPTIONS = {'F1','F2','F3','N2','N3','N4','L3','Cluster','CF'};
for i=1:size(total_M,2)%复杂度的个数
    
    %%2.1.train&predict
    global cds;
    cds = total_M{i};
    tstart = tic;%strat time
    ecocmodel = fitcecoc(TD,TL,'learners',classifier);%train
    predicted_label = predict(ecocmodel,TTD);%predice
    
    %%2.2.calculate the results
    time = toc(tstart);%end of time
    [confusion,~] = confusionmat(TTL,predicted_label);
    classifier_prediced_label = get_classifier_prediced_label(ecocmodel.BinaryLearners,TTD);
    score = get_score(TTL,predicted_label);
    classifier_error = get_classifier_error(cds, classifier_prediced_label,TTL);
    classifier_right = get_classifier_right(cds, classifier_prediced_label,TTL);
    
    ecoc_cplx = {};
    if i > boundary_pos
        ecoc_cplx = get_ecoc_cplx(cds,DC_OPTIONS{i-boundary_pos},TTD,TTL);
    end
    
    %%2.3.record results
    total_time = [total_time time];%训练和预测时间
    total_confmusion = [total_confmusion confusion];%混淆矩阵
    total_score = [total_score  score];%准确率
    total_predicted_label= [total_predicted_label  predicted_label];%test预测label
    total_classifier_prediced_label = [total_classifier_prediced_label classifier_prediced_label];
    
    total_classifier_error = [total_classifier_error classifier_error];
    total_classifier_right = [total_classifier_right classifier_right];
    total_ecoc_cplx = [total_ecoc_cplx ecoc_cplx];
end

%%3.return results
    restuls = [total_score,total_predicted_label,...
    total_classifier_prediced_label,total_classifier_error,...
    total_classifier_right,total_ecoc_cplx,total_confmusion,total_time];
end


function X = get_classifier_prediced_label(classifiers,data)
X = [];
for i=1:size(classifiers,1)
    x = predict(classifiers{i},data);
    X = [X x];
end
end

function ECOC_cplx = get_ecoc_cplx(ECOC,DC_OPTION,TTD,TTL)
ECOC_cplx = [];
if strcmp(DC_OPTION,'CF') == 1
    return;
end
for i = 1:size(ECOC,2)
    c1 = find(ECOC(:,i) == 1)
    c2 = find(ECOC(:,i) == -1)
    funstr = ['get_complexity',DC_OPTION];
    fh = str2func(funstr);
    cplx = fh(c1,c2,TTD,TTL);
    ECOC_cplx = [ECOC_cplx cplx];
end
end


