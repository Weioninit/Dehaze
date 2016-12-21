
clear
clc
 image_name =  'C:\Users\振巍\Desktop\毕业论文figure\平台运行速度\img2.jpg';
img=imread(image_name);

I=im2double(img);
w = size(I,2);
h = size(I,1);%行
d= size(I,3);
Nsum=w*h;
t0=clock;
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

 r=floor(max(w,h)/80);
%  r=15;
 G=fspecial('average',[r r]);
  %% 增加NBPC约束
 




 M_min=imfilter(min_p,G,'symmetric');
 M_max=imfilter(max_p,G,'symmetric');
 
%   sw=abs(M_min-min_p);
%  b=M_min-sw;
%  M_nbpc=imfilter(b,G,'symmetric');
 
%  M_nbpc=medfilt2(b, [sv, sv], 'symmetric');

 
%  count=0;
%   for j = 1:w
%         for i = 1:h          
%             if M_max(i,j)>0.75
%                 count = count+1;
%              end
%            
%         end
%  end
%    pro= count/Nsum;
%   figure
%  imshow(M_min)
%  title('M_min')
%  imwrite(M_min,'C:\Users\振巍\Desktop\快速去雾实验图片\hongkong-M_minGao.jpg');
%  figure
%  imshow(M_max)
%  title('M_max')
%  imwrite(M_max,'C:\Users\振巍\Desktop\快速去雾实验图片\hongkong-M_maxGao.jpg');
%  m1=min_p(x,y);
%  m2=max_p(x,y);
%  s=min_p(x,y)/(1-max_p(x,y));
 
 %cal mean_value of M_min
%    figure
%  imshow(M_min)
   mean_value=mean(mean(M_min));
   mean_p=mean(mean(min_p));
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
        A1=0.75;
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
 
 %最大值滤波后加入调整系数 alpha
    %  c=ones(size(M_min));
    %  vh=130;
    %  rcalib=2000;
    %  minvd=200;
    % %  n=max(w,h)/8;
    % for v=1:h
    % 	ci=1-exp((log(0.05)*rcalib)/(minvd*max(v-vh,0)));
    % 	c(v,:)=c(v,:)*ci;
    % end

%% 多个rcalib
% q=ones(size(M_min));
%  rcalib=1000;
% 
% for v=1:h
% 	qi=1-exp((log(0.05)*rcalib)/(minvd*max(v-vh,0)));
% 	q(v,:)=q(v,:)*qi;
% end
% e=ones(size(M_min));
%  rcalib=200;
% 
% for v=1:h
% 	ei=1-exp((log(0.05)*rcalib)/(minvd*max(v-vh,0)));
% 	e(v,:)=e(v,:)*ei;
% end
% 
% 
% figure;
% % p1=plot(c(1:v,:),'r');
% 
% % p2=plot(q(1:v,:),'g');
% x=1:h;
% plot(x,c(x,1),'r',x,q(x,1),'g',x,e(x,1),'b');
% 
% legend('lamda=4000','lamda=1000','lamda=200');

%%


alpha=1;

%  L_minmax1=min(M_min(:,:),M_nbpc);
%% 直接读取大气光幕图
%  L_minmax=double(imread('C:/Users/振巍/Desktop/毕业论文figure/videodehaze/cross_529_TVF_1000.png'))/255.0;
 
% setup sigma
sigma.d = 3;
sigma.r = 0.1;
radius = 10;

  L_minmax=min(M_min(:,:),alpha*A1*(1-M_max(:,:))/(1-A1));
     imtool(L_minmax);
%   L_minmax= bilateralGrayscale(L_minmax,sigma.d,sigma.r,radius);
%    L_minmax=im2double(L_minmax)/255.0;
%    imtool(L_minmax);
%  L_minmax=M_min(:,:);
%  L_minmax=min(L_minmax,c);
  
%    imtool(L_minmax);
   
   %restore the airlight
   sv=20;
% s_m=medfilt2(L_minmax(vh-n:vh+2*n,:), [sv, sv], 'symmetric');
% P = fspecial('gaussian', [r r]);
% s_m=imfilter(L_minmax(vh-n:vh+n,:),G,'symmetric');
% L_minmax(vh-n:vh+2*n,:)=s_m;
%  lamda=zeros(1,19);
%  imtool(L_minmax);
 
%  T=0;
%  将L=M_min的元素标记出来
% for A1=0.05:0.05:0.95
%      t=0;
%  T= T+1;
%  L_minmax=min(M_min(:,:),A1*(1-M_max(:,:))/(1-A1));
%  L_test=L_minmax;

%% 测试约束范围
% L_test=zeros(h,w);
%  for j = 1:w
%         for i = 1:h 
%             if(L_minmax(i,j)==M_min(i,j))
%             L_test(i,j)=1;
% %             t= t+1;
%             end
%         end
%  end
%  figure
%  imshow(L_test);
 
%   figure
%  imshow([M_min alpha*A1*(1-M_max(:,:))/(1-A1) L_minmax L_test]);
%  title('Min AMax');
%  figure
%  imshow(drawcolor(1-L_minmax/A1));
%  title('airlight');
 
%  lamda(T)=(Nsum-t)/Nsum;
%  
%  
%  
% end
%  plot(lamda);
% hold on
% plot([0,T],[pro,pro]);

% imwrite(L_minmax,'C:\Users\振巍\Desktop\快速去雾实验图片\hongkong-L_minmaxGao.jpg');

%  figure
%  imshow(L_test)
 %cal outputimage 1
%  I1=I(:,:,1);
%  I2=I(:,:,2);
%  I3=I(:,:,3);
%  p=ones(h,w);


 %cal L using MaxMin
%   L_minmax1=(min(1.6*mean_value,0.93))*L_minmax1;
% %    L_minmax1=s*L_minmax1;
%   I_out1 =(I1-L_minmax1)./(p-L_minmax1/A1);
%   I_out2 =(I2-L_minmax1)./(p-L_minmax1/A1);
%   I_out3 =(I3-L_minmax1)./(p-L_minmax1/A1);
%   I_out=zeros(h,w,3);
%   I_out(:,:,1)=I_out1;
%   I_out(:,:,2)=I_out2;
%   I_out(:,:,3)=I_out3;
%   T1=I_out;

  
   %cal outputimage 2

 p=ones(h,w);


 %cal L using MaxMin
  L_minmax=(min(1.3*mean_value,0.87))*L_minmax;
%   L_minmax=s*L_minmax;
  if(d==1)
      T1=zeros(size(I));
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
  T2=I_out;
  end
  
   H_img=H(uint8(T2*255));
   m_img=Min_mean(uint8(T2*255));
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
dehazehsl = colorspace('hsl<-',T2);%gama修正
% dehazeligmean = mean(mean(dehazehsl(:,:,3)));
gama = 0.8;  % dehazing07,46,47,71 0.618  dehazing12,22  0.7 
    dehazehsl(:,:,3) = real(dehazehsl(:,:,3).^gama);
    dehaze=colorspace('rgb<-hsl',dehazehsl);
end
%   toc


   imtool([I dehaze]);
%    figure 
%    imshow(dehaze);
%    figure
%    imshow(L_minmax1)
%   title('I_out');
disp(['程序总运行时间：',num2str(etime(clock,t0))]);
%   imwrite(L_test,'C:\Users\振巍\Desktop\快速去雾实验图片\ny17-I_lamdaAauto.jpg');
%    imwrite(I_out,'C:\Users\振巍\Desktop\快速去雾实验图片\snow-I_outGao2.jpg');
%    figure
%   imshow(Imin_out);
%   title('Imin_out');
%    imwrite(Imin_out,'C:\Users\振巍\Desktop\快速去雾实验图片\hongkong-I_outLiu.jpg');
%    
 
 
 
 