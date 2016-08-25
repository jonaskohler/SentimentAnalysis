function exercise4x(varargin)
% EXERCISE4   Part 4 of the VGG CNN practical
%%%%%%NEXT UP try running the script the way it is and see if it always
%%%%%%classifies positive (~36.92%)
% try the same net backpropagating only the last two layers!




run ('C:\Users\Challenge Accepted\Documents\MATLAB\matconvnet-master/matlab/vl_setupnn')
%run ('C:\Users\Challenge Accepted\Documents\MATLAB\matconvnet-1.0-beta20/matlab/vl_setupnn')
run ('C:\Users\Challenge Accepted\Documents\MATLAB\practical-cnn-2015a\vlfeat/toolbox/vl_setup')

% -------------------------------------------------------------------------
%% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = setupData('C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data') ;
%imdb = load('data/charsdb.mat') ;


%% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net= load('imagenet-vgg-f.mat') ;
vl_simplenn_display(net); 
%%
%%
f=1/100; 
net.layers{20} = net.layers{19}; %relu
net.layers{19} = net.layers{18}; %conv
net.layers{18} = struct('type','dropout',...		%adding the dropout layer between fc6 and fc7
                            'rate',0.5);    
net.layers{21} = struct('type','dropout',...		%adding the dropout layer between fc7 and fc8 (wheel of emotion)
                            'rate',0.5);             
net.layers{22} = struct('type', 'conv', ... 
                           'weights', {{f*0.1*randn(1,1,4096,2, 'single'), zeros(1, 2, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'fc8') ;
net.layers{23} = struct('type', 'softmaxloss') ;
vl_simplenn_display(net); 

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 256 ;
trainOpts.numEpochs = 10 ;
trainOpts.continue = true ;
trainOpts.useGpu = false ;
trainOpts.learningRate = 0.001 ;
trainOpts.expDir = 'C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data' ;
trainOpts = vl_argparse(trainOpts, varargin);

 % Take the average image out
% 
imageMean = mean(imdb.images.data(:)) ;
imdb.images.data = imdb.images.data - imageMean ;

% Convert to a GPU array if needed
if trainOpts.useGpu
  imdb.images.data = gpuArray(imdb.images.data) ;
end

% Call training function in MatConvNet
[net,info] =  cnn_train(net, imdb, @getBatch, trainOpts) ;

% Move the CNN back to the CPU if it was trained on the GPU
if trainOpts.useGpu
  net = vl_simplenn_move(net, 'cpu') ;
end

% Save the result for later use
%net.layers(end) = [] ;
%net.imageMean = imageMean ;
%save('data/chars-experiment/charscnn.mat', '-struct', 'net') ;

% -------------------------------------------------------------------------
% Part 4.4: visualize the learned filters
% -------------------------------------------------------------------------

figure(2) ; clf ; colormap gray ;
vl_imarraysc(squeeze(net.layers{1}.weights{1}),'spacing',2)
axis equal ; title('filters in the first layer') ;
% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
%im = 256 * reshape(im, 32, 32, 3, []) ;
labels = imdb.images.labels(1,batch) ;

% --------------------------------------------------------------------
function [im, labels] = getBatchWithJitter(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

n = numel(batch) ;
train = find(imdb.images.set == 1) ;

sel = randperm(numel(train), n) ;
im1 = imdb.images.data(:,:,sel) ;

sel = randperm(numel(train), n) ;
im2 = imdb.images.data(:,:,sel) ;

ctx = [im1 im2] ;
ctx(:,17:48,:) = min(ctx(:,17:48,:), im) ;

dx = randi(11) - 6 ;
im = ctx(:,(17:48)+dx,:) ;
sx = (17:48) + dx ;

dy = randi(5) - 2 ;
sy = max(1, min(32, (1:32) + dy)) ;

im = ctx(sy,sx,:) ;

% Visualize the batch:
% figure(100) ; clf ;
% vl_imarraysc(im) ;

im = 256 * reshape(im, 32, 32, 1, []) ;



