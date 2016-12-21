
%输入：视频帧Image,和统一的大气光幕图L_uniform,输入帧序号k
%输出：去雾后的视频帧T1，gama调节后dehaze,估计的大气光幕L

function [T1, dehaze ,L_uniform_out,A]=MinMax_func(Image,L_uniform_in,k,A1)
%  img=Image;
I=im2double(Image);
w = size(I,2);
h = size(I,1);%行
d= size(I,3);
Nsum=w*h;
min_p=zeros(h,w);
max_p=zeros(h,w);
% if(~L_uniform)
if(k==1)

if(d==1)
min_p=I;
max_p=I;

end
% min and max value of I
% y_sum=0;
% m_sum=0;

if(d==3)
 for j = 1:w
        for i = 1:h          
            % find min and max value of each pixel
             min_p(i,j) = min(I(i,j,:)); % find min across all channels
             max_p(i,j) = max(I(i,j,:));
%              m_sum=m_sum+min_p(i,j);
             y(i,j)=I(i,j,1)*0.3+I(i,j,2)*0.59+I(i,j,3)*0.11;
        end
 end
end
 

 r=floor(max(w,h)/80);
%  r=15;
 G=fspecial('gaussian',[r r]);

 sv=2*floor(max(size(I))/50)+1;
  %% 增加NBPC约束
%   sv=5;

%  M_min=medfilt2(min_p, [sv, sv], 'symmetric');
%  M_max=medfilt2(max_p, [sv, sv], 'symmetric');



 M_min=imfilter(min_p,G,'symmetric');
 M_max=imfilter(max_p,G,'symmetric');
 
 %% 用块状
%  M_min=makeDarkChannel(I,r);
%  M_max=makeLightChannel(I,r);
 
 
%   sw=abs(M_min-min_p);
%  b=M_min-sw;
%  M_nbpc=imfilter(b,G,'symmetric');
 
%  M_nbpc=medfilt2(b, [sv, sv], 'symmetric');

 %cal mean_value of M_min
%    figure
%  imshow(M_min)
   mean_value=mean(mean(M_min));
%   mean_value=m_sum/Nsum;
  if(d==3) 
      mean_y=mean(mean(y));
  end
   if(d==1) 
       mean_y=mean_value;
   end
%    thed1=exp(-mean_value);
%    thed2=min(10*(mean_value-0.6)*(mean_value-0.6)+0.5,0.9);
 %cal Airlight
%    A0=0.5*(max(max(M_min))+max(max(max(I))));       %Min
%    A1=0.9*(max(max(M_min))+min(min(min(I))));       %MinMax
%       A1=max(1.6*mean_value-0.14,0.5); 
       A1=1.6*mean_y-0.14;
        A1=0.85;
 %cal Airlight using 0.1%
%   numpx = floor(Nsum/1000);
%   JDarkVec = reshape(M_min,Nsum,1);
%   ImVec = reshape(I,Nsum,3);
%   [JDarkVec, indices] = sort(JDarkVec);
%   indices = indices(Nsum-numpx+1:end);
%     atmSum = zeros(1,3);
%     for ind = 1:numpx
%         atmSum = atmSum + ImVec(indices(ind),:);
%     end
%     atmospheric = atmSum/numpx;
%     A2=atmospheric(1)*0.3+atmospheric(2)*0.59+atmospheric(3)*0.11;
%      A=0.7;
 %cal Atmospheric light also L
 
 %PAC cal
 c=ones(size(M_min));
 vh=130;
 rcalib=2000;
 minvd=200;
%  n=max(w,h)/8;
for v=1:h
	ci=1-exp((log(0.05)*rcalib)/(minvd*max(v-vh,0)));
	c(v,:)=c(v,:)*ci;
end


%%


alpha=1;

%  L_minmax1=min(M_min(:,:),M_nbpc);
%% 直接读取大气光幕图
%  L_minmax=double(imread('C:/Users/振巍/Desktop/毕业论文figure/videodehaze/cross_529_TVF_1000.png'))/255.0;
 
  L=max(min(M_min(:,:),alpha*A1*(1-M_max(:,:))/(1-A1)),0);
%   L=min(M_min(:,:),alpha*A1*(1-M_max(:,:))/(1-A1));
%   imtool(L);
%  L_minmax=M_min(:,:);
%  L_minmax=min(L_minmax,c);
  

  
   %cal outputimage 2

 


 %cal L using MaxMin
  L_minmax=(min(1.6*mean_value,0.93))*L;
  L_uniform_out=uint8(L_minmax*255);
  A=A1;
end
if(k>1)
    L_minmax=im2double(L_uniform_in);
    L_uniform_out=min(max(L_uniform_in,0),255);
    A=A1;
end
%   L_minmax=s*L_minmax;
p=ones(h,w);
  if(d==1)
%       T1=zeros(size(I));
      T1 =(I-L_minmax)./(p-L_minmax/A1);
  end
  

  if(d==3)
  I1=I(:,:,1);
  I2=I(:,:,2);
  I3=I(:,:,3);
  I_out1 =(I1-L_minmax)./(p-L_minmax/A1);
  I_out2 =(I2-L_minmax)./(p-L_minmax/A1);
  I_out3 =(I3-L_minmax)./(p-L_minmax/A1);
  I_out=zeros(h,w,3);
  I_out(:,:,1)=I_out1;
  I_out(:,:,2)=I_out2;
  I_out(:,:,3)=I_out3;
  T1=max(min(I_out,1),0);
  end
 
%     if(d==3)
%   I1=I(:,:,1);
%   I2=I(:,:,2);
%   I3=I(:,:,3);
%   I_out1 =(I1-L_minmax)./(p-L_minmax/atmospheric(1));
%   I_out2 =(I2-L_minmax)./(p-L_minmax/atmospheric(2));
%   I_out3 =(I3-L_minmax)./(p-L_minmax/atmospheric(3));
%   I_out=zeros(h,w,3);
%   I_out(:,:,1)=I_out1;
%   I_out(:,:,2)=I_out2;
%   I_out(:,:,3)=I_out3;
%   T1=I_out;
%   end
 %cal L using Min
%   Imin_out1 =(I1-L_min)./(p-L_min/A0);
%   Imin_out2 =(I2-L_min)./(p-L_min/A0);
%   Imin_out3 =(I3-L_min)./(p-L_min/A0);
%   Imin_out=zeros(h,w,3);
%   Imin_out(:,:,1)=Imin_out1;
%   Imin_out(:,:,2)=Imin_out2;
%   Imin_out(:,:,3)=Imin_out3;

%   gama修正 
if(d==3)
dehazehsl = colorspace('hsl<-',T1);%gama修正
% dehazeligmean = mean(mean(dehazehsl(:,:,3)));
gama = 0.8;  % dehazing07,46,47,71 0.618  dehazing12,22  0.7 
    dehazehsl(:,:,3) = real(dehazehsl(:,:,3).^gama);
    dehaze=colorspace('rgb<-hsl',dehazehsl);
end
%% 调整范围

T1=uint8(T1*255);
dehaze=uint8(dehaze*255);
end
 
 
 
 