clear all; clc; close all; warning off

                   %% Init
    [days, name_folder, name_list, task_name] = subject_information ;
    ERS23= importdata('ERS23_datasave.mat'); % {13sb} {5days} {trials x tasks} {3channel} 12 x 23 (ERS value)
    ERStest = importdata('ERStest.mat'); % {13sb} {5days} {trials x tasks} {3channel} 12points (1 & 0)
    ERS_freq = importdata('ERStest_freq_value.mat');  % {13sb} {5days} {trials x tasks} {3channel} 12points (freq corresponding to 1)
    
    load erdscolormap;
    colormap(erdcolormap);

path =['C:\Users\Admin\Desktop\test_BME8\DATA\'];
%txtfile=fopen([path,'chonloc_trial.txt'],'wt');

% count_rest=zeros(length(S),3); count_rest_sum=zeros(length(S),3);
% count_imagine=zeros(length(S),3); count_imagine_sum=zeros(length(S),3);

 trials_failed = zeros(13,3); trials_get = zeros(13,3);    
for sb=1:length(ERS23) % 13 subject
    day=days{sb};
    idname=name_folder{sb}; 
    
        count_imagine{sb}=zeros(3,3) ;
        count_imagine_sum{sb}=zeros(3,3) ;
        count_pre{sb}=zeros(3,3) ;
        count_pre_sum{sb}=zeros(3,3) ;
        count_post{sb}=zeros(3,3) ;
        count_post_sum{sb}=zeros(3,3) ;
        
        count_freq_pre{sb}=cell(3,3); count_freq_on{sb}=cell(3,3); count_freq_post{sb}=cell(3,3);
        
        count_1_all{sb,1}=zeros(12,3) ; count_1_all{sb,2}=zeros(12,3) ; count_1_all{sb,3}=zeros(12,3) ;

        
    for qq= 1:length(day)
        path ='C:\Users\Admin\Desktop\newfolder\test_BME8\DATA\';
        load([path,idname(1:4),day{qq},'.mat']) % load DATA 
        S1 = ERS23{sb}{qq};
        G1 = ERStest{sb}{qq};
        N1 = ERS_freq{sb}{qq};
            
       
        for c=1:3 %3task/class
  
            for c1=1:Nc(c)
                if isempty(find(unique(G1{c1,c}(4:12,:))==1))
                    trials_failed(sb,c)=trials_failed(sb,c)+1;
                    continue;
                end
                trials_get(sb,c)=trials_get(sb,c)+1;
                
                count_1_all{sb,c} = count_1_all{sb,c} + G1{c1,c}; 

 
                for chan=1:3 %channel 
                    condition = G1{c1,c}(:,chan);
                   

                    count_pre{sb}(c,chan) = count_pre{sb}(c,chan) + sum(condition(1:3)) ;
                    count_pre_sum{sb}(c,chan) = count_pre_sum{sb}(c,chan) + 3;
                    count_imagine{sb}(c,chan) = count_imagine{sb}(c,chan) + sum(condition(4:9)) ;
                    count_imagine_sum{sb}(c,chan) = count_imagine_sum{sb}(c,chan) + 6;
                    count_post{sb}(c,chan) = count_post{sb}(c,chan) + sum(condition(10:12)) ;
                    count_post_sum{sb}(c,chan) = count_post_sum{sb}(c,chan) + 3;
                    
                   
                    condition_freq = N1{c1,c}(:,chan); 
                    freq1=condition_freq(1:3); freq2=condition_freq(4:9); freq3=condition_freq(10:12); 
                    count_freq_pre{sb}{c,chan} = [count_freq_pre{sb}{c,chan} freq1(find(freq1~=0))'];
                    count_freq_on{sb}{c,chan} = [count_freq_on{sb}{c,chan} freq2(find(freq2~=0))'];
                    count_freq_post{sb}{c,chan} = [count_freq_post{sb}{c,chan} freq3(find(freq3~=0))'];
                    

                end
            end
        end
%     text=[idname,'-',day{qq},' => get: ',num2str(sum(Nc)-length(cell2mat(choose_fail))),' / ',num2str(sum(Nc)),' => ',...
%         num2str(100-100*length(cell2mat(choose_fail))/sum(Nc)),' %'];
%     disp(text);
    %fprintf(txtfile,'%s\n',text);
    end
    

    disp(sb);
    temp_ima = (100*count_imagine{sb}./count_imagine_sum{sb});
    count_result_ima(sb,:) = [temp_ima(1,:) temp_ima(2,:) temp_ima(3,:)];
    
    temp_pre = (100*count_pre{sb}./count_pre_sum{sb});
    count_result_pre(sb,:) = [temp_pre(1,:) temp_pre(2,:) temp_pre(3,:)];
    
    temp_post = (100*count_post{sb}./count_post_sum{sb});
    count_result_post(sb,:) = [temp_post(1,:) temp_post(2,:) temp_post(3,:)];
    
    
    j=0;
    for m=1:3
        for n=1:3
            j=j+1;
            count_result_pre_freq(sb,j) = mode(count_freq_pre{sb}{m,n});
            count_result_on_freq(sb,j) = mode(count_freq_on{sb}{m,n});
            count_result_post_freq(sb,j) = mode(count_freq_post{sb}{m,n});
        end
    end   
end




