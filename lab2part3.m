%% part3
clc;clear;close all;
img1_raw = imread('picture/part3_1.jpg');
img2_raw = imread('picture/part3_2.jpg');

img1 = rgb2gray(img1_raw);
img2 = rgb2gray(img2_raw);

key_point1 = detectHarrisFeatures(img1);
key_point2 = detectHarrisFeatures(img2);

[features1, valid_points1] = extractFeatures(img1,key_point1);
[features2, valid_points2] = extractFeatures(img2,key_point2);

indexPairs = matchFeatures(features1,features2);

match_point1 = valid_points1(indexPairs(:,1));
match_point2 = valid_points2(indexPairs(:,2));
figure; ax = axes;
showMatchedFeatures(img1,img2,match_point1,match_point2,'montage','Parent',ax)

% RANSAC loop
% write a ransac_loop which can computer the transformation between two images
loc_match_point1 = match_point1.Location; %load the variable in struct
loc_match_point2 = match_point2.Location;

%% Add noise. (This image is too easy. Add some noise to make work for RANSAC)
noise1 = rand(1,1000)*683;
noise2 = rand(1,1000)*1024;

k = 5;
noise1 = randsample(noise1,k)';
noise2 = randsample(noise2,k)';
noise = [noise1,noise2];

[num,~] = size(loc_match_point1);
index_rand = randsample(1:num,k*8);
loc_match_point1 = loc_match_point1(index_rand,:);
loc_match_point2 = loc_match_point2(index_rand,:);

loc_match_point1 = [loc_match_point1;noise];
loc_match_point2 = [loc_match_point2;noise];

%% Least Squares Alignent: This is not robust enough
A = [loc_match_point1,ones(size(loc_match_point1,1),1)];
transform_matrix = A \ loc_match_point2;
        
%% RANSAC : Implement me.
%Your RANSAC function should return a matrix which is the affine tranformation of image1 to match image 2.
transform_matrix = ransac_loop_affine(loc_match_point1,loc_match_point2,100); %Img1 points, Img2 points, Number of RANSAC iterations.

%% 
trans_model = affine2d(transform_matrix);
img1_affine = imwarp(img1,trans_model);

figure;
subplot(1,3,1);
imshow(img1);
title('image1');
hold on;

subplot(1,3,2);
imshow(img1_affine);
title('affined image1');
hold on;

subplot(1,3,3);
imshow(img2);
title('image2');
%as bonus you can try to implement another RANSAC for homography to
%project one image to another, which can build a panorama stitch 








