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
test=[];
jz=0;

figure(50);clf
for iz=1
    day=days{iz};
    idname=name_list{iz};

for qq=1%1:length(day)
    clear Pt P
    Pt=zeros(23,3);
    path =['C:\Users\Admin\Desktop\test_BME8\DATA\'];

    load([path,idname(1:4),day{qq},'.mat'])
    ERDS={};
    delta_ERDSmax={};
    
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
                    figure(chan);
                    set(gcf,'WindowState','maximized');
                    a=find(f>=13); b=find(f<=35);
                    hold on
                    if logic_test(P(a(1):b(end),chan)>=1500)==0
                        Pt(:,chan)=Pt(:,chan)+P(a(1):b(end),chan);
                        plot([13:35],P(a(1):b(end),chan),'.')
                        test(jz,chan)=1;
                    else
                        test(jz,chan)=0;
                    end
                    ylim([0 1500])
                    
                end
            end
        end
    end

    for chan=1:3
        figure(chan)
        hold on
        z{qq}=plot([13:35],Pt(:,chan)/sum(test(:,chan)),'-*');
%         title([idname,'        ',num2str(sum(test(:,chan))*100/size(test(:,chan),1)),' %'])

        legend([z{qq}],day{qq})
%         saveas(figure(chan),['C:\Users\Admin\Desktop\test_BME8\result\',idname(1:4),day{qq},'_',tit{chan},'.fig']);
%         close(figure(chan));
    end
    
end

end



