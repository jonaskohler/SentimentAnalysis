function imdb = setupData(path)
% path: path to training/testdata 
% e.g.: <path>\test\car\
%path='C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data';

imagesClass1Train = dir(fullfile(path,'/train/positive/*.jpg'));
imagesClass2Train = dir(fullfile(path,'/train/negative/*.jpg'));
imagesClass1Test = dir(fullfile(path,'/test/positive/*.jpg'));
imagesClass2Test = dir(fullfile(path,'/test/negative/*.jpg'));

total_images = length(imagesClass2Test)+length(imagesClass1Test)...
    +length(imagesClass2Train)+length(imagesClass1Train);

% Images get resized to image_size
image_size = [224 224];

imdb.images.data = zeros(image_size(1),image_size(2),3,total_images,'single');
imdb.images.labels = zeros(1,total_images,'single');
imdb.images.set = zeros(1,total_images,'uint8');
image_counter = 1;

% Categories/sets have to be same name as your folders
categories = {'positive','negative'};
sets  = {'train','test'};


fprintf('Loading %d positive train and %d negative train images...\n',...
    length(imagesClass1Train),length(imagesClass2Train));
fprintf('Loading %d positive test and %d negative test images...\n',...
    length(imagesClass1Test),length(imagesClass2Test));
fprintf('Each image will be resized to %d by %d\n', image_size(1),image_size(2));

for set = 1:length(sets)
    for category = 1:length(categories)
        
        cur_path=fullfile(path,sets{set},categories{category});
        cur_images = dir(fullfile(cur_path,'*.jpg'));
        num_images = length(cur_images);
        % take n images out of folder (needs to be smaller then num_images)
        
        n = num_images; % Take all images from Folder
        if n > num_images
            error('too many images selected...');
        else
            fprintf('Taking %d images from %s\n',n,cur_path);
            cur_images = cur_images(1:n);
        end
    for i = 1:length(cur_images)
        disp(cur_images(i).name)
        cur_image = imread(fullfile(cur_path, cur_images(i).name));
        cur_image = single(cur_image);
        cur_image = imresize(cur_image,image_size);

             if(size(cur_image,3) < 3)
               cur_image = cat(3,cur_image,cur_image,cur_image);	%converting to RGB image
             end  
        imdb.images.data(:,:,:,image_counter) = cur_image;
        imdb.images.labels(1,image_counter) = category;
        imdb.images.set(1,image_counter) = set;
        image_counter = image_counter+1;
        
        
    end


    end
end


end