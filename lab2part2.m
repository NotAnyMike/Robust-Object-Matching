%% part 2 Interset Point Description & Matching
% Create two images by translating one image.
clc;clear;
img_raw1 = imread('picture/ka.jpg');
img_raw2 = imread('picture/ka.jpg');
z = 255*ones(size(img_raw1));
img_raw1 = [img_raw1,z;z,z];
img_raw2 = [z,z;z,img_raw2];

%% 
img1 = rgb2gray(img_raw1);
key_point1 = corner(img1);

img2 = rgb2gray(img_raw2);
key_point2 = corner(img2);

mini = min(key_point1(:,1)); maxi = max(key_point1(:,1));
minj = min(key_point1(:,2)); maxj = max(key_point1(:,2));
key_point1 = key_point1(key_point1(:,1)>mini & key_point1(:,1)<maxi,:);
key_point1 = key_point1(key_point1(:,2)>minj & key_point1(:,2)<maxj,:);
mini = min(key_point2(:,1)); maxi = max(key_point2(:,1));
minj = min(key_point2(:,2)); maxj = max(key_point2(:,2));
key_point2 = key_point2(key_point2(:,1)>mini & key_point2(:,1)<maxi,:);
key_point2 = key_point2(key_point2(:,2)>minj & key_point2(:,2)<maxj,:);

figure(1); imshow(img_raw1); hold on;
plot(key_point1(:,1),key_point1(:,2),'*r');

figure(2); imshow(img_raw2); hold on;
plot(key_point2(:,1),key_point2(:,2),'*r'); 

%% simple descriptor
colour_h1 = extractDescrAppearance(img1,key_point1);
gradient_h1 = extractDescrGradient(img1,key_point1);% a gradient based descriptor
 
colour_h2 = extractDescrAppearance(img2,key_point2);
gradient_h2 = extractDescrGradient(img2,key_point2);

%% Match descriptors
colour_h2(1:30,:)=randn(size(colour_h2(1:30,:))); %Kill the first fraction of matches to sanity check.
D = pdist2(colour_h1,colour_h2); figure(5); clf; imagesc(D);
matchlist = matchDescrs(colour_h1,colour_h2);

%% Color descriptor matching
figure(3);imshow(img_raw1); hold on; 
figure(4);imshow(img_raw2); hold on; 
clist='rgbcmykrgbcmykrgbcmyk'; %Illustrate matches with the first 21 points
k=1;i=1;
while(i<numel(matchlist)&&k<21)
    if(matchlist(i)<1), i=i+1; continue; end
    figure(3); plot(key_point1(i,1),key_point1(matchlist(i),2),[clist(k),'*']);
    figure(4); plot(key_point2(i,1),key_point2(matchlist(i),2),[clist(k),'*']); 
    k=k+1;i=i+1;
end


