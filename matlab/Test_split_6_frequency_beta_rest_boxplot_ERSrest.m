clear; clc; warning off
tit={'C3','Cz','C4'};
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
median_ref={};
med_ref_load = importdata('median_ref.mat');
for iz=1 %subject
    day=days{iz};
    idname=name_list{iz};

for qq=1 %days
    path =['D:\ZLegendZ\06_PROJECT_BME8\test_BME8\DATA\'];
    med_ref = med_ref_load{iz}{qq};
    load([path,idname(1:4),day{qq},'.mat'])
    ERDS={};
    delta_ERDSmax={};
    test=[];
    jz=0;
    Pt={};
    clf
    for c=1:N_class
        for c1=1:Nc(c)
            for step=0:2
                sec =[step,step+1];
                if ~isempty(class_eeg{c1,c})
                    split = class_eeg{c1,c}(sec(1)*fs+1:sec(2)*fs,:);
                    [f,P]=fourier_transform_n(split,fs);
                    ERDS{c1,c}{step+1} =P;
                end
                jz=jz+1;
                for chan=1:3
                    a=find(f>=13); b=find(f<=35);
                    hold on
                    Pt{chan}(:,jz)=zeros(23,1);
                    Pt{chan}(:,jz)=Pt{chan}(:,jz)+P(a(1):b(end),chan);
                end
            end
            
        end
    end
    for chan=1:3
        %median_ref{iz}{qq}(:,chan)=median(Pt{chan},2);
        figure(chan)
        set(gcf,'WindowState','maximized');
        boxplot(Pt{chan}',[13:35])
        title([idname,'         ',replace(day{qq},'_','-'),'         Channel ',tit{chan}])
        ylim([0 2500])
        temp_up_adj = cell2mat(get(findobj(gcf, 'tag', 'Upper Adjacent Value'),'YData')); 
        up_adj{chan} = flip(temp_up_adj(:,1)) ; %Upper Adjencent 23value 13-35hz
        
        P_rest{chan} = Pt{1,chan}';
        num_rest_choose=[];
        sumsum=[];
        for n=1:size(P_rest{chan},1) %405x23
%             if ~isempty(find(P_rest{chan}(n,:)'-up_adj{chan}>0)) % Threshold condition
%                 continue;
%             else
                num_rest_choose =[num_rest_choose n];
                ERS_rest(:,chan) = (P_rest{chan}(n,:)' - med_ref(:,chan))./med_ref(:,chan) ;
                figure(50);
                subplot(3,1,chan);hold on
                %plot(ERS_rest(:,chan),'*')
                title([idname,'         ',replace(day{qq},'_','-'),'         Channel ',tit{chan}])
                
                ERS_rest_sum=[];
                for freq=1:23
                    ERS_rest_sum = [ERS_rest_sum ERS_rest(freq,chan)'];
                    %maxmax(freq)= max(ERS_rest_sum{freq});
                end
                sumsum=[sumsum ; ERS_rest_sum];
                 
%             end
        end

 
%         figure(50);
%         subplot(3,1,chan);hold on
%         boxplot(sumsum,[13:35]);
%         ylim([0 30])
%         
        
        
        
    end 
    

    
end
end

