% load the pre-trained CNN
run ('C:\Users\Challenge Accepted\Documents\MATLAB\matconvnet-master/matlab/vl_setupnn')
run ('C:\Users\Challenge Accepted\Documents\MATLAB\practical-cnn-2015a\vlfeat/toolbox/vl_setup')
net = load('C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data/final net 4096 4096 2 w dropout/net-epoch-15.mat') ;
net = vl_simplenn_tidy(net.net) ; %takes the NET object and upgrades it to the current version of MatConvNet
net.meta.classes.description{1,1}='positive';
net.meta.classes.description{1,2}='negative';

%softmaxloss needs the ground truth in net.layers{end}.class which is passed as the second parameter in vl_simplenn to vl_nnsoftmaxloss.
%when you want to obtain only class prop only change last layer to  softmax
net.layers{end}.type = 'softmax';

% load and preprocess an images
path='C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data\tobelabeled\pics_final';
imagesClassify = dir(fullfile(path,'/*.jpg'));
total_images= length(imagesClassify);
image_size(1)=net.meta.normalization.imageSize(1);
image_size(2)=net.meta.normalization.imageSize(2);
imdb.images.data = zeros(image_size(1),image_size(2),3,total_images,'single');
imdb.images.labels = zeros(1,total_images,'single');
image_counter = 1;
categories = {'positive','negative'};


            
    for i = 1:length(imagesClassify)
        cur_image = imread(fullfile(path, imagesClassify(i).name));
        cur_image = single(cur_image);
        cur_image = imresize(cur_image,net.meta.normalization.imageSize(1:2)); %do I need to resize images for classification? yes net expects one specific size
        cur_image= bsxfun(@minus, cur_image, net.meta.normalization.averageImage) ; %what happens here?    
        if(size(cur_image,3) < 3)
               cur_image = cat(3,cur_image,cur_image,cur_image);	%converting to RGB image
        end  
        imdb.images.data(:,:,:,image_counter) = cur_image;
        image_counter = image_counter+1;        
    end
    
image_counter=image_counter-1;
classifications=zeros(image_counter,1);
confidence=zeros(image_counter,2);
correctness=zeros(image_counter,1);
truePositives=[];
falsePositives=[];

for i=1:image_counter
% run the CNN
res = vl_simplenn(net,imdb.images.data(:,:,:,i));
% show the classification result
scores = squeeze(gather(res(end).x)) ;
confidence(i,1)=scores(1,1);
confidence(i,2)=scores(2,1);
end
correctness;
%Summary:

%works quite well :)  but for some reasons classifications vary slightly for
%the same picture with each run 0_0?!