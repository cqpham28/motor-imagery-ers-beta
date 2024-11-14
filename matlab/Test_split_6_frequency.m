clear all; clc; warning off; clear day

day={'10_08','10_09','10_10','10_12','10_13'}; idname ='[01]' ;
% day={'10_11','10_12','10_13','10_14','10_15'}; idname ='[02]' ;
% day={'10_13','10_17','10_18','10_19'}; idname ='[03]' ;
% day={'10_21','10_27','10_28','10_30','10_31'}; idname ='[04]' ;
% day={'11_01','11_02','11_03','11_05','11_13'}; idname ='[05]' ;
% day={'11_02','11_03','11_07','11_08'}; idname ='[06]' ;
% day={'10_29','11_06','11_09','11_12','11_16'}; idname ='[07]' ;
% day={'11_06','11_07','11_09','11_14','11_15'}; idname ='[08]' ;
% day={'11_11','11_13','11_17','11_19','11_20'}; idname ='[09]' ;
% day={'11_12','11_21','11_22'}; idname ='[10]' ;
% day={'11_14','11_15','11_20','11_26','11_27'}; idname ='[11]' ;
% day={'11_15','11_18','11_23'}; idname ='[12]' ;
% day={'11_19','11_22','11_23','11_24','11_25'}; idname ='[13]' ;


frequency = [13 35];
chan_name={'C3','Cz','C4'}; class_name={'LH','RH','F'};
figure(200); clf; set(gcf,'WindowState','maximized');
yvalue_5days = cell(3,3);
for qq=1:length(day)
    path =['C:\Users\Admin\Desktop\test_BME8\DATA\'];

    load([path,idname(1:4),day{qq},'.mat'])

    start=1;
    for step=1:7
        freq =[start+step,start+step+1];
        for c=1:N_class
            %figure(); clf; set(gcf,'WindowState','maximized');
            temp_spec=zeros(length([freq(1)*fs:freq(2)*fs]),3);
            kn=0;
            for c1=1:Nc(c)
                if ~isempty(class_eeg{c1,c})
                    split = class_eeg{c1,c}(freq(1)*fs:freq(2)*fs,:);
                    [f,P]=fourier_transform_n(split,fs);
                    temp_spec=temp_spec+P;
                    kn=kn+1;
                end
            end
            temp_spec=temp_spec/kn;   
            temp{step,c} =temp_spec;
        end
        
    end
    a=find(f>=frequency(1)); b=find(f<=frequency(2)); 
    range=[a(1):b(end)];
    
   
    for class=1:3
        for chan=1:3
            sumkk=zeros(length(range),3);
%             figure();clf; 
            for i=1:6
                kk=temp{i+1,class}-temp{1,class};  
%                 subplot(3,2,i);
%                 plot(f(range),kk(range,chan),'-*');
%                 title([num2str(i-1),'-',num2str(i)]);
                sumkk = sumkk + kk(range,:) ;
            end
%             figure(qq);
%             subplot(3,3,class+3*chan-3);
%             plot(f(range),sumkk(:,chan),'-*');
%             title([class_name{class},' - ',chan_name{chan}]);
%             v=axis;axis([v(1) v(2) -2000 2000]);
            
            figure(200);
            subplot(3,3,class+3*chan-3); hold on
            xvalue = f(find(sumkk(:,chan)>0)+range(1))' ;
            yvalue = sumkk(find(sumkk(:,chan)>0),chan) ;
            plot(xvalue,yvalue,'*')
            yvalue_5days{chan,class} = [yvalue_5days{chan,class} length(yvalue)];
            title([class_name{class},' - ',chan_name{chan},...
                '  [',num2str(round(100*sum(yvalue_5days{chan,class})/(length(day)*length(sumkk)),1)),'%]']);
            v=axis;axis([frequency(1) frequency(2) 0 1500]);
%             v=axis;axis([frequency(1) frequency(2) -3000 0]);
        end
    end
%     close(figure(qq));
% saveas(figure(qq),['C:\Users\Admin\Desktop\test_BME8\',idname,'-',day{qq},'.png']);

end

data_fig=[get(findobj(gcf,'Type','line'),'Xdata') get(findobj(gcf,'Type','line'),'Ydata')]  ;
check_lost=[];
for class=1:3
    for chan=1:3
        check_lost =[check_lost; yvalue_5days{chan,class}'];
    end
end


if ~isempty(find(check_lost==0))
    data_fig_v2={};
    temp_lost = [0 find(check_lost==0)'];
    for i=1:length(temp_lost)-1
        temp_lost_fix(i,1)=temp_lost(i)+1;
        temp_lost_fix(i,2)=temp_lost(i+1)-1;
    end
    temp_lost_fix = [temp_lost_fix; temp_lost(end)+1 9*length(day)];

    for i=1:size(temp_lost_fix,1)
        data_fig_v2=[data_fig_v2; [{data_fig{temp_lost_fix(i,1)-i+1:temp_lost_fix(i,2)-i+1,1}}' {data_fig{temp_lost_fix(i,1)-i+1:temp_lost_fix(i,2)-i+1,2}}']];
        data_fig_v2=[data_fig_v2; [{0} {0}]];
    end        
else
    data_fig_v2 = data_fig;
end

clear check data_check
for i=1:9
    check{i,1} = data_fig_v2(length(day)*(i-1)+1:length(day)*i,:) ;
    data_check{i,1}=[];
    for m=1:length(day)
        z1=check{i,1}(m,1); z1=z1{1}' ;
        z2=check{i,1}(m,2); z2=z2{1}' ;
        data_check{i,1} = [data_check{i,1}; z1 z2] ;
    end
end

ketqua=[];
for i=1:9
    f_start=frequency(1) ; 
    f_step = 4;
    k=-1; 
    total_temp=[];
    while f_start+k+f_step<=frequency(2)
       k=k+1;
       f_check =[f_start + k , f_start + k + f_step]; 

       idx_temp = find(data_check{i,1}(:,1)>=f_check(1) & ...
           data_check{i,1}(:,1)<=f_check(2));
       total_temp = [total_temp; k sum(data_check{i,1}(idx_temp,2))];
    end
    [~,id]=max(total_temp(:,2));
    ketqua=[ketqua; i f_start+total_temp(id,1) f_start+f_step+total_temp(id,1) ...
        total_temp(id,2)];
end

figure(200);
for i=1:9
    subplot(3,3,i); hold on; v=axis;
    plot([ketqua(i,2) ketqua(i,2)],[1500 0],'k-');
    plot([ketqua(i,3) ketqua(i,3)],[1500 0],'k-');
    axis([frequency(1) frequency(2) 0 1500]);
%     v=axis;axis([frequency(1) frequency(2) -3000 0]);
    text(ketqua(i,3)+1,1000,[num2str(ketqua(i,2)),'-',num2str(ketqua(i,3)),' Hz'],'FontSize',15);
end

saveas(figure(200),['C:\Users\Admin\Desktop\test_BME8\results_beta_frequency\',idname,'_positive.png']);
close(figure(200));