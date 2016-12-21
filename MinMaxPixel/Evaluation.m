% 1/12/2016
% IFSTTAR copyright
%
% The approach is described in details in 
%
% "Blind Contrast Restoration Assessment by Gradient Ratioing at Visible Edges",
% by N. Hautiere, J.-P. Tarel, D. Aubert and E. Dumont,
% in proceedings of International Congress for Stereology (ICS'07), 
% Saint Etienne, France, August 30-September 7, 2007.
% http://perso.lcpc.fr/tarel.jean-philippe/publis/ics07.html
%

%%%% Cleaning
% clc
% clear 
% close all

%%%% Images reading: the input 2 images must be grayscale

% NameOri='C:\Users\振巍\Desktop\color-line截距直方图\stadium_1.jpg';
% NameResto='C:\Users\振巍\Desktop\快速去雾实验图片\对比图\stadium_He.png';
% 输出：可见边缘比，过饱和像素点数目比，平均梯度比，原图可见边，恢复图可见边
% 输入：原图，恢复图
function [e1,ns1,r1,Crri,Crr1]=Evaluation(NameOri,NameResto)

% I1=imread(NameOri);
I1=double(NameOri);
% if the input image is a color image, use following line
 I1=double(rgb2gray(uint8(I1)));

[nl,nc]=size(I1);

% R1=imread(NameResto);
R1=double(NameResto);
% if the input image is a color image, use following line
R1=double(rgb2gray(uint8(R1)));

%%%% Figure 1
    % figure(1)
    % colormap gray
    % subplot(1,2,1)
    % imagesc(I1)
    % axis image
    % title('Original')
    % subplot(1,2,2)
    % imagesc(R1)
    % axis image
    % title('Restored')

%%%% Sobel Gradient
Sy = double([1 2 1;0 0 0;-1 -2 -1]);
GIy = imfilter(I1,Sy,'symmetric');
GRy1 = imfilter(R1,Sy,'symmetric');

Sx = double([1 0 -1; 2 0 -2; 1 0 -1]);
GIx = imfilter(I1,Sx,'symmetric');
GRx1 = imfilter(R1,Sx,'symmetric');

GI=sqrt((GIx.^2)+(GIy.^2));
GR1=sqrt((GRx1.^2)+(GRy1.^2));

minGI=min(GI(:));
maxGI=max(GI(:));

%%%% Figure 2
    % figure(2)
    % colormap gray
    % subplot(1,2,1)
    % imagesc(GI,[minGI maxGI]);
    % title(['Gradients of the original image']); 
    % axis image
    % colorbar
    % subplot(1,2,2)
    % imagesc(GR1,[minGI maxGI]);
    % title(['Gradients of the restored image']); 
    % axis image
    % colorbar

%%%% Contrast Computation at 5%
tic
[C1 Crr1]=functionContrastAt5PerCent(R1);
[Ci Crri]=functionContrastAt5PerCent(I1);
toc

    minCrri=min(Crri(:));
    maxCrri=max(Crri(:));

%%%% Figure 3
    % figure(3)
    % colormap gray
    % subplot(1,2,1)
    % imagesc(Crri,[minCrri  maxCrri]);
    % axis image
    % title(['Visible edge in the original image']);
    % colorbar
    % subplot(1,2,2)
    % imagesc(Crr1,[minCrri  maxCrri]);
    % axis image
    % title(['Visible edge in the restored image']);
    % colorbar

%%%% Visible Gradients Ratio
Cratio1=zeros(nl,nc);
Cratio1(Crr1>0)=GR1(Crr1>0)./GI(Crr1>0);
    
    rmin=1;
    rmax=10;

%%%% Figure 4
    % figure(4)
    % imagesc(Cratio1,[rmin rmax]);
    % axis image
    % title(['Visible gradients ratio between ',num2str(rmin), ' and ',num2str(rmax)]); 
    % colormap jet
    % colorbar

%%%% Descriptor computation

% Rate of new visible edges
whitePixels1=sum(C1(:));
whitePixelsi=sum(Ci(:));
e1=(whitePixels1-whitePixelsi)/whitePixelsi;

% Number of saturated pixels after restoration
ns1=sum(R1(:)==256 |R1(:)==0);
ns1=ns1/(nl*nc);

% Restoration quality (geometric mean ratios of visibility level)
XX=log(Cratio1);
r1=exp((1/(whitePixels1))*nansum(XX(isfinite(XX))));
end
