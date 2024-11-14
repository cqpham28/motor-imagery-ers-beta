clear; clc; warning off
close('all')
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
load ERS_Outer_Fence.mat
load ERS_datasave.mat
load ERS23_datasave.mat
load ERStest

for p=1%:length(ERS23_datasave)
    day=days{p};
    idname=name_list{p};
    ERS_normalize=cell(1,3);
    
    for task=1:3
        figure(1)
        clf
        set(gcf,'WindowState','maximized')
        ERS_normalize{task}={zeros(12,23) zeros(12,23) zeros(12,23)};
        Ni=zeros(1,3);
        Nd=zeros(1,3);
        for d=1:length(ERS23_datasave{p})
            [m,n]=size(ERS23_datasave{p}{d});
            for trial=1:m
                if ~isempty(ERS23_datasave{p}{d}{trial,task})
                    maxf=max([max(ERS23_datasave{p}{d}{trial,task}{1}),...
                        max(ERS23_datasave{p}{d}{trial,task}{2}),...
                        max(ERS23_datasave{p}{d}{trial,task}{3})]);
                    for channel=1:length(ERS_normalize{task})
                        if logic_test(ERStest{p}{d}{trial,task}(:,channel))
                            %OuterFence=ERS_Outer_Fence{p}{d}(:,channel);
                            %[delT,freq]=size(ERS23_datasave{p}{d}{trial,task}{channel});
                        
                            ERS=ERS23_datasave{p}{d}{trial,task}{channel}/maxf;
                            ERS_normalize{task}{channel}=ERS_normalize{task}{channel}+ERS;
                            Ni(channel)=Ni(channel)+1;
                        end
                        Nd(channel)=Nd(channel)+1;
                    end
                end
            end
        end
    
        minERS=min([min(ERS_normalize{task}{1})/Ni(1),min(ERS_normalize{task}{2})/Ni(2),min(ERS_normalize{task}{3})/Ni(3)]);
        maxERS=max([max(ERS_normalize{task}{1})/Ni(1),max(ERS_normalize{task}{2})/Ni(2),max(ERS_normalize{task}{3})/Ni(3)]);
        for channel=1:length(ERS_normalize{task})
            ERS_normalize{task}{channel}=ERS_normalize{task}{channel}/Ni(channel);
            [Xq,Yq] = meshgrid(0:0.1:13,13:0.1:35);
            Vq = interp2(0:13,13:35,[zeros(23,1) ERS_normalize{task}{channel}' zeros(23,1)],Xq,Yq,'cubic');
            subplot(1,3,channel)
            [Ct,Line]=contourf(0:0.1:13,13:0.1:35,Vq);
            Line.LineStyle='none';
            colormap(jet)
            C=colorbar;
            %C.Label.String = 'ERS';
            caxis([minERS maxERS])
                        
            xlabel('t (s)')
            ylabel('f (Hz)')
            title(['\rm',tit{channel},'       Chosen trials: ',num2str(Ni(channel)),'/',num2str(Nd(channel))])
            xticks([0.5:1:12.5])
            xticklabels({'-3','-2','-1','0','1','2','3','4','5','6','7','8','9'})    
        end
        subplot(1,3,3)
        text(-18,36.7,['Name :  ',idname(5:end),'               Task :  ',cls_name{task}]);
        %saveas(gcf,['D:\Working\My work\EEG\Cuong_Minh\result\ThongKe-ChuanHoaChungCacNgay\',...
        %            'Kochuanhoa-mapERS-',idname,'_',cls_name{task},'.png'])
    end  
    
end





