% 计算具有时域相关性的大气光幕
% 输入：帧（frame RGB），帧序列（nframe） 
function L=Slow_L_video(frame,frame_pre,L_pre,nframe,A)
    pnImageY=double(frame(:,:,1)*0.3+frame(:,:,2)*0.59+frame(:,:,3)*0.11)/255.0;
    pnImageYP=double(frame_pre(:,:,1)*0.3+frame_pre(:,:,2)*0.59+frame_pre(:,:,3)*0.11)/255.0;
    tao=TemporalEstimation(pnImageY, pnImageYP, nframe,A);
%     L=L_pre*tao;

    L=max(A-tao.*(double(A-L_pre)),0);
end