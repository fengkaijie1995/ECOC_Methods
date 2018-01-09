%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functon is to draw the complexdity level in the preocess of coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
learners={'svm'};
fs_method = {'roc','ttest','wilcoxon'};
titles = {'Roc','T-test','Wilcoxon'};
datanames={'Breast','Cancers','DLBCL','Leukemia2','Leukemia3','Lung1'};
legend_names  = {'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
genpath = 'E:\×ÀÃæ\ecoc\ecoc-2.26\ICDC-ECOC\data';
ylabels = {'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
fontsize =8;

clf;%Çå¿Õfigure
figure
for fs_option = 1:3 % feature selection method 
    clf;
    for dnum = 8 %DC_OPTION
        subplot(3,1,dnum-7);
        title(ylabels{dnum},'FontSize',fontsize);
        
        picrespapth = [genpath,'\pic\ÆÚ¿¯\new_N3_F3\cplx'];
        mkdir(picrespapth);
        
        for fs_size = 100 % feature size
            
            filepath = [genpath,'\data_fs_10--150_pair_newN3_newF3\data_fs_',num2str(fs_size),'\',fs_method{fs_option},'\dcplx'];
            tdcplx = create_dtcplx(filepath,learners{1},datanames);
            draw_cplx(tdcplx,picrespapth,fs_size,dnum,fs_method{fs_option});
            
        end
    end
    legend(legend_names,'location','best','FontSize',fontsize);    
    saveas(gca ,[picrespapth,'\',ylabels{dnum},'_',fs_method{fs_option},'_',num2str(fs_size)],'fig');
    disp([picrespapth,'\',ylabels{dnum},'_',fs_method{fs_option},'_',num2str(fs_size)]);
    saveas(gca ,[picrespapth,'\',ylabels{dnum},'_',fs_method{fs_option},'_',num2str(fs_size)],'tiff');    
end
