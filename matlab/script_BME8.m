% pre_task = count_result_pre_freq;
% on_task =  count_result_on_freq;
% post_task = count_result_post_freq;

pre_task = count_result_pre;
on_task =  count_result_ima;
post_task = count_result_post;


%%
count=0; name_chan={'C3','Cz','C4'}; name_task={'LH','RH','F'};
figure(1);clf; hold on
for task=1:3
    for chan=1:3
        count=count+1;
        subplot(3,3,count); hold on
        zplot = [pre_task(:,count) on_task(:,count) post_task(:,count)]' ;
        plot(zplot,'-*','LineWidth',1.2)
        for type=1:3
            kq(type,count)= mean(zplot(type,:)); %on-stask
            sd(type,count)= std(zplot(type,:)); %on-stask
        end
        title(['Task: ',name_task{task},'   Channel: ',name_chan{chan}]);
        if count==1; ylabel('(%) beta response');end;
        v=axis; axis([0.5 3.5 0 70]);
        set(gca,'xtick',[1,2,3],'xticklabel',{'PRE-Task','ON-Task','POST-Task'})
        set(gca,'FontSize',15)
    end
end

%%
figure(2);clf;
kq1=kq'; sd1=sd';

hold on
color={'b','r','m'};

for i=1:3
%      errorbar([1:3],kq1(4:6,i),sd1(4:6,i),'-s','MarkerSize',13,'MarkerEdgeColor','blue',...
%     'MarkerFaceColor','blue','Color','blue','LineStyle','--','LineWidth',0.3);

a(i)=plot([1:3],kq1(1:3,i),'o-','Color',color{i},'MarkerSize',13,'LineWidth',1.7);
plot([4:6],kq1(4:6,i),'o-','Color',color{i},'MarkerSize',13,'LineWidth',1.7);
plot([7:9],kq1(7:9,i),'o-','Color',color{i},'MarkerSize',13,'LineWidth',1.7);
end

v=axis; axis([0.5 9.5 15 42]);
for k=[1 3 4 6 7 9] 
plot([k k],[15 42],'k--','LineWidth',1.4)
end
legend([a],{'PRE-Task','ON-Task','POST-Task'});
title('mean beta reponse of all subjects'); ylabel('%');
set(gca,'xtick',[1:9],'xticklabel',{'LH-C3','LH-Cz','LH-C4','RH-C3','RH-Cz','RH-C4','F-C3','F-Cz','F-C4'})
set(gca,'FontSize',17)


%%
count=0; name_chan={'C3','Cz','C4'}; name_task={'LH','RH','F'};
%figure(3);clf; hold on
[sb,c]=size(count_1_all);
for task=1:3 %task 1,2,3
    for chan=1:3
        count=count+1;
        zplot=[];
%         subplot(3,3,count); hold on
        for j=1:sb %13sb
            %plot(count_1_all{j,task}(:,chan),'-*','LineWidth',1.5)  
            zplot=[zplot count_1_all{j,task}(:,chan)./trials_get(j,task)] ;
        end
%         title(['Task: ',name_task{task},'   Channel: ',name_chan{chan}]);
%         v=axis; axis([0.5 6.5 0 40]); 
        
        for type=1:12
            kqq(type,count)= mean(zplot(type,:)); %on-stask
        end
             
    end
end

%%
kq2=100*kqq';


figure(4);clf;
hold on
linetype={'r-*','r--o','r:^','b-*','b--o','b:^','g-*','g--o','g:^'};
nameb ={'LH-C3','LH-Cz','LH-C4','RH-C3','RH-Cz','RH-C4','F-C3','F-Cz','F-C4'};
% linetype={'r*','ro','r^','b*','bo','b^','m*','mo','m^'};
for j=1:3
subplot(1,3,j);hold on
for i=1+3*(j-1):3+3*(j-1)
    b(i)=plot(kq2(i,:),linetype{i},'MarkerSize',9,'LineWidth',1.9);
end
v=axis; axis([0.5 12.5 15 45]);

plot([3.5 3.5],[15 45],'k--','LineWidth',1.2)
plot([9.5 9.5],[15 45],'k--','LineWidth',1.2)

if j==1; ylabel('occurrence rate (%)');end;
xlabel('time(s)')

% text(1.5,6,'PRE'); text(1.5,7,'PRE');   
set(gca,'FontSize',15);
set(gca,'xtick',[0.5:1:12.5],'xticklabels',{'-3','-2','-1','0',...
    '1','2','3','4','5','6','7','8','9'},'FontSize',20)
legend([b(1+3*(j-1):3+3*(j-1))],nameb{1+3*(j-1):3+3*(j-1)},'Location','northwest');
end


% h=suptitle('Mean beta response of all subjects in 3 continuous stages'); set(h,'FontSize',17,'FontWeight','bold')
    
    
%% frequency
for sb=5%1:13
    kq3 = count_freq_pre{sb}; %task x channel 
    kq4={};    linetype={'r-*','r--o','r-.^','b-*','b--o','b-.^','g-*','g--o','g-.^'};
    % linetype={'r*','ro','r^','b*','bo','b^','g*','go','g^'};
    nameb ={'LH-C3','LH-Cz','LH-C4','RH-C3','RH-Cz','RH-C4','F-C3','F-Cz','F-C4'};
    fcount = [13:35]'; count=0;
    figure();clf;hold on ;set(gcf,'WindowState','maximized');
    for task=1:3
        for chan=1:3
            count=count+1;
            for j=1:size(fcount,1)
               fcount(j,count+1)=length(find(kq3{task,chan}==fcount(j))) ; 
            end
            b(count)=plot([13:35],fcount(:,count+1),linetype{count},'MarkerSize',10,'LineWidth',1.4);
        end
    end
    v=axis; axis([12 36 v(3) v(4)]);
    legend([b],nameb,'Location','best'); 
    xlabel('Hz')
    set(gca,'FontSize',15);
    h=suptitle(['Frequency counted of subject ',name_folder{sb}(1:4),' during PRE-TASK']); 
    set(h,'FontSize',17,'FontWeight','bold') 
   %saveas(figure(sb),['C:\Users\Admin\Desktop\newfolder\test_BME8\1-WORK\bme8\FREQ_',name_folder{sb},'.png']);
    
   for j=1:9 % 9 lines.
       [z_max(1,j),z_id(1,j)] = max(fcount(:,j+1));
        freq_ratio(sb,j) = 100*z_max(1,j)/sum(fcount(:,j+1));
   end


end
close all;


