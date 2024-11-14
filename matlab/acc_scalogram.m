function [f_range, F_scal, tf_matrix, tf_bin, tf_bin_thresh] = acc_scalogram(g_acc, fs_acc, scale, thresh_binary, close_pixel)

%range_scale = 1:25; 
%thresh_binary = 0.8;
%close_pixel = 25;

[cfs,frq] = cwt(g_acc,scale,'cgau4',fs_acc);
F_scal = scal2frq(scale,'cgau4',1/fs_acc);
tf_matrix = 10*log10(abs(cfs));

f_range=[num2str(F_scal(end)),'-->',num2str(F_scal(1))];


tf_gray = mat2gray(tf_matrix); %grayscale
level = graythresh(tf_gray) ;
tf_bin = imbinarize(tf_gray,level)*255;


tf_gray = mat2gray(tf_matrix); %grayscale
level = graythresh(tf_gray) ;
tf_bin = imbinarize(tf_gray,level)*255;


tf_bin_thresh = tf_bin ;
for i=1:size(tf_bin,2)
   if length(find(tf_bin(:,i)==0))/length(tf_bin(:,i)) <= 1-thresh_binary   
       tf_bin_thresh(:,i)=1;
   else
       tf_bin_thresh(:,i)=0;
   end 
end

tf_bin_thresh = imclose(tf_bin_thresh,strel('disk',close_pixel)); %disk-shaped structuring element (25pixels radius)






