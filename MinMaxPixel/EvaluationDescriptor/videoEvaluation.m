clear
%原始视频
fileName1 = 'F:/video_seq/dtneu_nebel.avi'; 
obj1 = VideoReader(fileName1);
numFrames1 = obj1.NumberOfFrames;% 帧的总数
%% 
% 恢复视频
fileName2 = 'F:/video_seq/nebel_back.avi'; 
obj2 = VideoReader(fileName2);
numFrames2 = obj2.NumberOfFrames;% 帧的总数
%%
t1=clock;
frame1 = read(obj1,1);
sz1=size(frame1);
frame2 = read(obj2,1);
sz2=size(frame2);

% if((sz1==sz2) && (numFrames1==numFrames2))
w=sz1(1);  %列
h=sz1(2);  %行
d=sz1(3);

for k=1:50
    disp(k);
    % 输出：可见边缘比，过饱和像素点数目比，平均梯度比，原图可见边，恢复图可见边
    % 输入：原图，恢复图
    % function [e1,ns1,r1,Crri,Crr1]=Evaluation(NameOri,NameResto)
    [e1(k),ns1(k),r1(k),Crri(:,:,k),Crr1(:,:,k)]=Evaluation(read(obj1,k),read(obj2,k));
%     f(:,:,:,k)=read(obj1,k);


end
% end