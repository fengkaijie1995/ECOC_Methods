%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functon is to draw ensemble error and DC level changing with feature size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_error_cplx_fsize_ensemble(genpath,DS,FS,Learners,feature_size)

sz = 40;
colors =[[0,0,1]; [0,1,0]; [1,0,0]; [0,1,1]; [1,0.8,0]; [1,0,1]; [0,0,0]; [0.75,0.75,0.75]; [0,0.5,0.5]; [0.5,0.5,0.4]; [1,0.6,0]; [0.8,0.4,0.4];];
% colors = colormap('vga');

datanames={'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
DC = {'F1','F2','F3','N2','N3','C1'};
marker_size = 5;
 
feature_option_name = {'100','105','110','115','120','125','130','135','140','145','150'};

for fs_option = 1: size(FS,2) %feature selection
    
    for lindex = 1: size(Learners,2) %base learner%
        
        for dc_option = 1:size([1,2,3,4,5,8],2)
            
            clf;
            hold on;
            H_ensemble = [];
            for feature_option = feature_size %feature size
                
                feature_option_inx = find(feature_size == feature_option);
                now_color = colors(feature_option_inx + 1,:);
          
                data_ensemble_error = [];
                data_ensemble_cplxs = [];
                
                for dataset_option = 1: size(DS,2) %dataset
                    global GDS;
                    [~,inx] = ismember(DS{dataset_option},GDS);
                    
                    %加载dcplx数据
                    matname=['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\acc_dcplx_classifier\data_fs_',num2str(feature_option),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);                    
             
                    data_ensemble_error = [data_ensemble_error (1 - dcplx{inx,2}{1,dc_option}(1))*100];
                    data_ensemble_cplxs = [data_ensemble_cplxs mean(dcplx{inx,13}{1,dc_option})];
                end       
                
                H_ensemble(feature_option_inx) = plot(data_ensemble_cplxs,data_ensemble_error,'*','MarkerFaceColor',now_color,...
                    'MarkerEdgeColor',now_color,'MarkerSize',marker_size);
            end
       
            legend(feature_option_name,'location','best');
            
            xlabel(DC{dc_option}); %x轴
            ylabel('error-ratio'); %y轴
            
            filepath = [genpath,'/data/论文结果整理-期刊-pair\new_N3_F3\error_cplx_fssize_ensemble\',FS{fs_option}];
            mkdir(filepath);
            filename = [FS{fs_option},'_',Learners{lindex},'_',DC{dc_option}];
            disp([filepath,'\',filename]);
            
            saveas(gca ,[filepath,'\',filename],'fig');
            saveas(gca ,[filepath,'\',filename],'tiff');
        end
    end
end
end