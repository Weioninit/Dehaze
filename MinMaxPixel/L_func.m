
%输入：视频帧Image,和统一的大气光幕图L_uniform,输入帧序号k
%输出：去雾后的视频帧T1，gama调节后dehaze,估计的大气光幕L

function [L_uniform_out]=L_func(Image,A)
%  img=Image;
I=im2double(Image);
w = size(I,2);
h = size(I,1);%行
d= size(I,3);
Nsum=w*h;
min_p=zeros(h,w);
max_p=zeros(h,w);


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
 

 r=2*floor(max(w,h)/50)+1;
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

       A1=1.6*mean_y-0.14;
       if(A>0)
         A1=A;
       end

 
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

end


 
 
 
 