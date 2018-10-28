%% interest point Detection
img_raw = imread('picture/part1.jpg');

%% write a Harris detector
% computer the Ix,Iy,Iy
img = rgb2gray(img_raw);
img= imgaussfilt(img,0.1);%apple gaussian filter to the image

Ix=conv2(img,[1,0,-1],'same');
Iy=conv2(img,[1;0;-1],'same');              
IxIy=Ix.*Iy;
sigma = 0.3;
Ix= imgaussfilt(Ix,sigma);Iy= imgaussfilt(Iy,sigma);IxIy= imgaussfilt(IxIy,sigma); %apply gaussian filter for three new images
%computer the Harris score for each points in the picture
alpha = 0.06; %according to the original paper
[x,y]=size(img);
R=ones(x,y);
harris_img = zeros(x,y);
for i = 1:x
    for j = 1:y
        h=[Ix(i,j).^2,IxIy(i,j).^2;IxIy(i,j).^2,Iy(i,j).^2];
        % no g here,since we have already imgaussian on Ix Iy IxIy
        harris_img(i,j)=det(h)-alpha*((trace(h))^2);
        R(i,j)=harris_img(i,j);
    end
end 

%% Plot 
%R = 40;% set the threshold here
[ip_x,ip_y] = find(harris_img>40);
figure(1);imshow(img_raw);
hold on; plot(ip_x,ip_y,'r*');


