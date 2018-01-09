%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function is main function for ECOC
% function need correspoding data file including original dataset and selected features
% all results are save as xls file in the data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GDS = {'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','SRBCT'};
GDS_Name = {'Breast','Cancers','DLBCL','GCM','Leukemia1','Leukemia2','Lung','SRBCT'};
GLearners={'discriminant','naivebayes','svm','tree','NMC','ADA'};  
GFS = {'bhattacharyya','entropy','LaplacianScore','roc','Su','ttest','wilcoxon'};

%%filepath
addpath(genpath(pwd));
path = 'E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC';

feature_size = 100:5:150;
FS = GFS([5,6,7]);
DS = GDS([1]);
Learners = GLearners([3]);

for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for dataset_option = 1: size(DS,2) %dataset
            
            for lindex = 1: size(Learners,2) %base learner%
                
                %load original datasets
                disp(['加载原始数据：',[path,'/data/data_original/'],DS{dataset_option}]);
                [TD,TL,TTD,TTL] = load_data([path,'/data/data_original/'],DS{dataset_option});
                
                %get inportance orders
                [FS_TD,FS_TTD] = get_fsdata([path,'/data/data_fs/',DS{dataset_option},'/',DS{dataset_option},'_',FS{fs_option},'.mat'],TD,TTD,feature_option);
                disp(['加载数据：',genpath,'/data/data_original/',DS{dataset_option}]);
    
                %ecoc train and test
                disp('strat ecoc....');
                results = ecoc_process(DS{dataset_option},FS_TD,TL,FS_TTD,TTL,Learners{lindex});
                
                respath = [pwd,'/data/results/',num2str(feature_option),'/',FS{fs_option},'/'];
                mkdir(respath);
                save([respath,num2str(feature_option),'_',FS{fs_option},'_',Learners{lindex},'_',DS{dataset_option},'.mat'],'results');
                
            end %end of learners
            %
        end%end of datanames
        
    end%end of fs_method
    
end %end of fs_size