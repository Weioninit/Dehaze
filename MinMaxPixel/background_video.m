clear
fileName = 'F:/video_seq/ZOE_480p.avi'; 
obj = VideoReader(fileName);
numFrames = obj.NumberOfFrames;% 帧的总数
%% 
% kenlRatio = .01;
% myObj0 = VideoWriter('F:\video_seq\cross~L.avi');%初始化一个avi文件
%  writerObj.FrameRate = 24;
% open(myObj0)

%%
t1=clock;
frame = read(obj,1);
sz=size(frame);
A=200;
w=sz(1);  %列
h=sz(2);  %行
d=sz(3);
f(:,:,:,1)=read(obj,1);
% f_double(:,:,:,1)=im2double(f(:,:,:,1))/255.0;
% L_process=zeros(w,h,numFrames);
% L_uniform=zeros(w,h);
%   L_pre=zeros(w,h);
  L_pre=L_func(f(:,:,:,1),0.65);
  nframes=50;
  % Create waitbar.  
h = waitbar(0,'Applying dehazing...');  
set(h,'Name','dehazing Progress');  
for k=2:nframes
    disp(k);
    f(:,:,:,k)=read(obj,k);
%     f_double(:,:,:,k)=im2double(f(:,:,:,k));
  %时间域上的大气光幕  
    L=Slow_L_video(f(:,:,:,k),f(:,:,:,k-1),L_pre,k,A);
  %空间域上的大气光幕
      %  bilateralGrayscale( inputImg,sigma_s,sigma_r,window_size)
%       imtool(L_func(f(:,:,:,k),0.9));
     L_ori=L_func(f(:,:,:,k),0.65);    %输出为double 255
%     L_space=bilateralGrayscale(L_ori,3,0.1,10);
%     imtool(L_space);
    %时空融合
    lamda=0.2;
%     L_optimal=min((lamda*L+L_space)./(1+lamda),255);
     L_optimal=L;
    %迭代
%     imtool([uint8(L) uint8(L_space) uint8(L_optimal)]);
     static(:,:,:,k)=restore(f(:,:,:,k),uint8(L_ori),A);
     dynamic(:,:,:,k)=restore(f(:,:,:,k),uint8(L_optimal),A);
     a(k)=std2(static(:,:,:,k));
     b(k)=std2(dynamic(:,:,:,k));
     c(k)=std2(f(:,:,:,k));
%     imtool(static(:,:,:,k));
%     imtool(dynamic(:,:,:,k));
    L_pre=L_optimal;
    
    waitbar(k/nframes);
   
end
figure(1);
plot(k,a(k),k,b(k),k,c(k));

close(h);
%% 
%          for k = 1 :24*3% 读取数据
%         %      function [T1, dehaze ,L_uniform_out,A]=MinMax_func(Image,L_uniform_in,k,A1)
%         %      获取前n帧的中值背景图
%             
%               disp( k);
%               frame = read(obj,k);
% %               if(k==1||k==30||k==50)
% %               imtool(frame);
% %               end
%               video_R(:,:,k)=frame(:,:,1);
%               video_G(:,:,k)=frame(:,:,2);
%               video_B(:,:,k)=frame(:,:,3);
%         %       L_process(:,:,k)=L_func(frame,1);
%               
%          end
%          %% 提取前n帧的中值作为背景大气光幕图
%          video_R=sort(video_R,3);
%          video_G=sort(video_G,3);
%          video_B=sort(video_B,3);
%          
%          back_median(:,:,1)=video_R(:,:,floor(k/2));
%          back_median(:,:,2)=video_G(:,:,floor(k/2));
%          back_median(:,:,3)=video_B(:,:,floor(k/2));
%            imtool(back_median);
%  L_order=sort(L_process(:,:,:),3);
%  L_median=L_order(:,:,floor(k/2));
%  imtool(L_median);
 