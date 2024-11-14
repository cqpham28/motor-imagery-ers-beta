clear all ; clc; warning off ; close('all')
days={{'10_08','10_09','10_10','10_12','10_13'},...
    {'10_11','10_12','10_13','10_14','10_15'},...
    {'10_13','10_17','10_18','10_19'},...
    {'10_21','10_27','10_28','10_30','10_31'},...
    {'11_01','11_02','11_03','11_05','11_13'},...
    {'11_02','11_03','11_07','11_08'},...
    {'10_29','11_06','11_09','11_12','11_16'},...
    {'11_06','11_07','11_09','11_14','11_15'},...
    {'11_11','11_13','11_17','11_19','11_20'},...
    {'11_12','11_21','11_22'},...
    {'11_14','11_15','11_20','11_26','11_27'},...
    {'11_15','11_18','11_23'},...
    {'11_19','11_22','11_23','11_24','11_25'}};
name_list = {'[01]' , '[02]','[03]',...
            '[04]','[05]','[06]',...
            '[07]','[08]','[09]',...
            '[10]','[11]','[12]','[13]'};

tit={'C3','Cz','C4'};
cls_name={'left hand','right hand','feet'};
load median_ref.mat
% load ERS_Outer_Fence.mat
load ERS_datasave.mat
load ERS23_datasave.mat

for p=1%:length(ERS23_datasave)
    day=days{p};
    idname=name_list{p};
    for d=1%:length(ERS23_datasave{p})
        [m,n]=size(ERS23_datasave{p}{d});
        for task=1%:n
            for trial=1%:m
                if ~isempty(ERS23_datasave{p}{d}{trial,task})
                    
                    for channel=1:length(ERS23_datasave{p}{d}{trial,task})
                        subplot(3,1,channel)
                        set(gcf,'WindowState','maximized')
                        %OuterFence=ERS_Outer_Fence{p}{d}(:,channel);
                        [delT,freq]=size(ERS23_datasave{p}{d}{trial,task}{channel});
                        
                        ERS=ERS23_datasave{p}{d}{trial,task}{channel};
                        [Xq,Yq] = meshgrid(1:0.1:12,13:0.1:35);
                        Vq = interp2(1:12,13:35,ERS',Xq,Yq,'cubic');
                        [Ct,Line]=contourf(1:0.1:12,13:0.1:35,Vq);
                        Line.LineStyle='none';
                        colormap(jet)
                        C=colorbar;
                        C.Label.String = 'ERS';
                        
                        xlabel('\Deltat (s)')
                        ylabel('f (Hz)')
                        date_string=string(datetime(2019,str2num(day{d}(1:2)),str2num(day{d}(4:5))));
                        title(strcat('Name :  ',idname(5:end),'          Task :  ',cls_name{task},'          Date :  ',date_string...
                        ,'          Trial :  ',num2str(trial),'          Channel :  ',tit{channel}));
                        
                        
                        
                        xticks([1:12,12.7])
                        xticklabels({'[-3 s : -2 s]','[-2 s : -1 s]','[-1 s : 0 s]','[0 s : 1 s]',...
                        '[1 s : 2 s]','[2 s : 3 s]','[3 s : 4 s]',...
                        '[4 s : 5 s]','[5 s : 6 s]','[6 s : 7 s]',...
                        '[7 s : 8 s]','[8 s : 9 s]','\Deltat'})

                    end
                    
                    %saveas(gcf,['D:\Working\My work\EEG\Cuong_Minh\2020\Data\',idname,'\',day{d},'\'...
                    %    ,'1ERDS-',idname,'_',cls_name{task},'-day',day{d},'-trial',num2str(trial),'.png'])
                end
            end
        end
    end
end





