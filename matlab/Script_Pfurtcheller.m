clear all; clc;


channel={'C3','Cz','C4'};
task={'LH','RH','F'};
load erdscolormap;
colormap(erdcolormap);

S= importdata('ERS23_datasave.mat');
G = importdata('ERStest_new.mat');
% {13sb} {5days} {trials x tasks} {3channel} 12 x 23

path =['C:\Users\Admin\Desktop\test_BME8\DATA\'];
%txtfile=fopen([path,'chonloc_trial.txt'],'wt');
for iz=1:length(S) %13subject
    day=days{iz};
    idname=name_list{iz}; 
    for qq=1:length(day)
        path =['C:\Users\Admin\Desktop\test_BME8\DATA\'];
        load([path,idname(1:4),day{qq},'.mat'])    
        S1 = S{iz}{qq};
        G1 = G{iz}{qq};
        for c=1:3 %3task/class
            choose_fail{c}=[];
            for c1=1:Nc(c)
                count=0; count2=0;
                
                for chan=1:3 %channel 
                    condition = G1{c1,c}(:,chan);
                    if ~isempty(find(condition(1+3:end-3)==1))
                        count=count+1;
                    end
                    
                    
                    
%                     figure(50); clf; set(gcf,'WindowState','maximized');
%                     [Xq,Yq] = meshgrid(0:0.1:13,13:0.1:35);
%                     ERS_trial = S1{c1,c}{chan}';
%                     Vq = interp2(0:13,13:35,[zeros(23,1) ERS_trial zeros(23,1)],Xq,Yq,'cubic');
%                     subplot(3,1,chan); hold on
%                     [Ct,Line]=contourf(0:0.1:13,13:0.1:35,Vq);
%                     Line.LineStyle='none';
%                     colormap(jet)
%                     C=colorbar;
%                     C.Label.String = 'ERS';
%                     xlabel('\Deltat (s)') ; ylabel('f (Hz)')
%                     xticks([0.5:1:12.5,12.7])
%                     xticks([0.5:1:12.5])
%                         xticklabels({'-3 s','-2 s','-1 s','0 s',...
%                         '1 s','2 s','3 s','4 s','5 s','6 s','7 s','8 s','9 s'})
                    
                    
%                     if ~isempty(find(condition==1))
%                         temp = find(condition==1) ; nguong =[];
%                        for i=1:length(temp)
%                           %plot([temp(i) temp(i)],[13 35],'y--','LineWidth',1.5);
%                           [~,z]=max(ERS_trial(:,temp(i))) ;
%                           plot(temp(i),12+z,'yo','LineWidth',3.5,'MarkerSize',20);
%                           nguong =[nguong max(ERS_trial(:,temp(i)))];
%                        end
%                     end

                    %caxis([0 mean(nguong)/4]);
                    
                    date_string=string(datetime(2019,str2num(day{qq}(1:2)),str2num(day{qq}(4:5))));
                        title(strcat('Name :  ',idname(5:end),'          Task :  ',task{c},'          Date :  ',date_string...
                        ,'          Trial :  ',num2str(c1),'          Channel :  ',channel{chan}));
%                     
                
                end
%                 saveas(figure(50),['C:\Users\Admin\Desktop\test_BME8\WORK\dataCuong_Minh\',idname,'\',day{qq},'\'...
%                     ,'ERS_Contourf-',idname,'_',task{c},'-day',day{qq},'-trial',num2str(c1),'.png'])

                condition2 = G1{c1,c}(4:9,1:3);
                for j=1:6
                    if sum(condition2(j,:))>=2
                        count2=count2+1;
                    end
                end
             
                if count2==0
                    choose_fail{c}=[choose_fail{c} c1]; 
                end
            end
        end
    text=[idname,'-',day{qq},' => Trial get: ',num2str(sum(Nc)-length(cell2mat(choose_fail))),' / ',num2str(sum(Nc)),' => ',...
        num2str(100-100*length(cell2mat(choose_fail))/sum(Nc)),' %'];
    disp(text);
    %fprintf(txtfile,'%s\n',text);
    end
    

end
close(figure(1));
% fclose('all');

