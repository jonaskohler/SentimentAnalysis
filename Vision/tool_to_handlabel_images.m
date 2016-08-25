function labelimages()
%get path of current file
file = mfilename('fullpath'); 
path = fileparts(file); 
path= 'C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data\tobelabeled\';
%find all images in current folder
imagesToLabelJPG = dir(fullfile(path,'/*.jpg'));
imagesToLabelPNG = dir(fullfile(path,'/*.png'));
imagesToLabel = [imagesToLabelJPG ; imagesToLabelPNG];

tweets=fopen('C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data\tobelabeled\100Tweets\Clinton\Clinton_100Images_labeled_clean.txt')
lines=textscan(tweets,'%s %s %s')
lines{1,3}(1,1)
for i = 1:length(imagesToLabel)
image= imread(fullfile(path,imagesToLabel(i).name));
h_fig= figure(1);
imshow(image);
drawnow;
mfilename('fullpath')
w = waitforbuttonpress;
set(h_fig,'KeyPressFcn',@(h_obj,evt) disp(evt.Key));
a = double(get(h_fig,'CurrentCharacter'));
%waitfor(h_fig,'CurrentCharacter');
if a==28
   disp('leftarrow -> positive')
   movefile(fullfile(fullfile(path,imagesToLabel(i).name)),fullfile(path,'positive')); 
elseif a==29   
   disp('rightarrow -> negative')
   movefile(fullfile(fullfile(path,imagesToLabel(i).name)),fullfile(path,'negative')); 
elseif a==30
    disp('uparrow -> neutral')
   movefile(fullfile(fullfile(path,imagesToLabel(i).name)),fullfile(path,'neutral')); 
end    
% 
% w = waitforbuttonpress;
% if w == 0
%    movefile(fullfile(fullfile(path,imagesToLabel(i).name)),fullfile(path,'positive')); 
% else
%     disp('PRESS BUTTON -> negative')
%     movefile(fullfile(fullfile(path,imagesToLabel(i).name)),fullfile(path,'negative'));
% end
end
close all

end
