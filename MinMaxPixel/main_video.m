clear
fileName = 'F:/video_seq/dtneu_nebel.avi'; 
obj = VideoReader(fileName);
numFrames = obj.NumberOfFrames;% 帧的总数
%% 
% kenlRatio = .01;
myObj0 = VideoWriter('F:\video_seq\nebel_back.avi');%初始化一个avi文件
 writerObj.FrameRate = 24;
open(myObj0)
%% 
% % kenlRatio = .01;
% myObj1 = VideoWriter('F:\video_seq\ZOE_1.avi');%初始化一个avi文件
%  writerObj.FrameRate = 24;
% open(myObj1)
%%
t1=clock;
frame = read(obj,1);
sz=size(frame);
A=0.98;
w=sz(1);  %列
h=sz(2);  %行
d=sz(3);

% 直接读入大气光幕图
% 背景RGB
orig=imread('C:/Users/振巍/Desktop/毕业论文figure/videodehaze/nebel_back.png');

%开闭运算
sv=floor(max(size(orig))/80);
sz=size(orig);
Nsum=sz(1)*sz(2);
se=strel('square',sv);
L=L_func(orig,1);
imtool(L);
        %% 开
        %腐蚀
        e=imerode(L,se);
        %膨胀
        f=imdilate(e,se);
        %% 闭
        %灰度膨胀
        g=imdilate(f,se);
        %灰度腐蚀
        h=imerode(g,se);

%TVF
L_uniform=TVF(h);  %输入double型h
% dehazed=zeros(h,w,d,numFrames);
% dc = zeros(h,w);%构成像素矩阵
%% 
% G = fspecial('motion');  %生成高斯滤波器

%% 
 for k = 2 :numFrames% 读取数据
      disp( k);
      frame = read(obj,k);
%       I=frame;
%       Q=I;
%    if mod(k,20)==0  
%% 帧处理
% function [T1, dehaze ,L,A]=MinMax_func(Image,L_uniform,k,A1)
            [J_video,dehaze,L,A]=MinMax_func(frame,L_uniform,k,A);
%            if(k==2)
% %                L_uniform=TVF(L);
%                imtool(L_uniform);
%            end
%                J_video_hsl =colorspace('hsl<-', J_video);
%                J_video_l= J_video_hsl(:,:,3);
% 
%                light1(k)=mean(mean(J_video(:,:,1)*0.299+J_video(:,:,2)*0.587+J_video(:,:,3)*0.114));
%             J_d=LaplacianGuided(frame,k);
%                J_d_hsl =colorspace('hsl<-', J_d);
%                J_d_l= J_d_hsl(:,:,3);
%                light2(k)=mean(mean( J_d(:,:,1)*0.299+J_d(:,:,2)*0.587+J_d(:,:,3)*0.114));
             
            % ICCV'2009 paper result (NBPC)
%             sv=2*floor(max(size(frame))/50)+1;
%             frame=double(frame)/255.0;
%             J_Tarel=nbpc(frame,sv,0.95,0.5,1,1.3);

%             light3(k)=mean(mean(frame(:,:,1)*0.299+frame(:,:,2)*0.587+frame(:,:,3)*0.114))/255.0;
             dehazed(:,:,:,k)=dehaze(:,:,:);
             if(k==30)
%              figure,imshow(J_d);
              figure,imshow([dehaze,frame]);
%               figure,imshow([L,L_uniform]);
             end
%              imtool( dehazed(:,:,:,3))
%                title('递推');
%                 figure,imshow(frame);
%                title('原图');
%              end
%            [Y,U,V]=RGB2YUV(frame);
%             Q=Y;%亮度分量Y
%             t = 255 - 0.95*Q;
%             t_d=double(t)/255;
%             A=230;
%             img_d = double(frame);
%             J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
%             J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
%             J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%             J_d=J/255;
% %       for x=1:h
% %           for y=1:w    
% %               
%               
% %             Q(x,y)=I(x,y)*1.2  
% %          if I(x,y)<80        
% %            Q(x,y)=I(x,y)*0.25;       
% %          if(I(x,y)>=80)&&(I(x,y)<180)       
% %            Q(x,y)=I(x,y)*2.2-156; 
% %          end
% %         else       
% %          Q(x,y)=I(x,y)*0.2+204;
% %          end
% %         end
% %       end
% %      end
%     
%  
% %      Q = rgb2gray(frame);
% %      Ig = imfilter(frame,G);
% %      figure,imshow(frame);%显示帧
% %      for y=1:h
% %          for x=1:w
% %          dc(y,x) = min(frame(y,x,:));
% %          end
% %      end
%write to video
%         I=double2img(J_video);
       writeVideo(myObj0,dehaze);
%        writeVideo(myObj1,J_d);
 end
 disp(['总耗时=',num2str(etime(clock,t1))])
%  figure,plot(light1,'r')  %video
%  hold on
%  plot(light2,'g')
%  hold on
%  plot(light3,'b')
%  figure,imshow(Q);
 close(myObj0);
%  close(myObj1);

