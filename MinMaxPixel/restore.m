% 输入输出都为im  255

function T1=restore(Image,L,A)
I=im2double(Image);
L_minmax=im2double(L);
w = size(I,2);
h = size(I,1);%行
d= size(I,3);
p=ones(h,w);
A1=A/255.0;
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
 T1=uint8(T1*255);
end
% 
% %   gama修正 
% if(d==3)
% dehazehsl = colorspace('hsl<-',T1);%gama修正
% % dehazeligmean = mean(mean(dehazehsl(:,:,3)));
% gama = 0.8;  % dehazing07,46,47,71 0.618  dehazing12,22  0.7 
%     dehazehsl(:,:,3) = real(dehazehsl(:,:,3).^gama);
%     dehaze=colorspace('rgb<-hsl',dehazehsl);
% end