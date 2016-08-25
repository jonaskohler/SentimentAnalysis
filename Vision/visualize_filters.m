
run ('C:\Users\Challenge Accepted\Documents\MATLAB\matconvnet-master/matlab/vl_setupnn')
run ('C:\Users\Challenge Accepted\Documents\MATLAB\practical-cnn-2015a\vlfeat/toolbox/vl_setup')
net = load('C:\Users\Challenge Accepted\Dropbox\KIT\SS16\KD Seminar\data/final net 4096 4096 2 w dropout/net-epoch-15.mat') ;
net = vl_simplenn_tidy(net.net) ; %takes the NET object and upgrades it to the current version of MatConvNet

vl_simplenn_display(net); 

myfilter= net.layers{13}.weights{1}(:,:,1:3,:)

figure(1) ; clf ; colormap gray ;
vl_imarraysc(squeeze(myfilter),'spacing',2)
axis equal ; title('filters in the last layer') ;