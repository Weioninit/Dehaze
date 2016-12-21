image_name =  'H:/桌面/color-line截距直方图/buildings_input.png';
%  function T=MinMax(Image)
img=imread(image_name);
%  img=Image;
I=im2double(img);
w = size(I,2);
h = size(I,1);%行
d= size(I,3);
Nsum=w*h;

min_p=zeros(h,w);
max_p=zeros(h,w);


 for j = 1:w
        for i = 1:h          
            % find min and max value of each pixel
             min_p(i,j) = min(I(i,j,:)); % find min across all channels
             max_p(i,j) = max(I(i,j,:));
%              m_sum=m_sum+min_p(i,j);
             y(i,j)=I(i,j,1)*0.3+I(i,j,2)*0.59+I(i,j,3)*0.11;
        end
 end

 r=floor(max(w,h)/80);
 G=fspecial('average',[r r]);
 M_min=imfilter(min_p,G);
 M_max=imfilter(max_p,G);
 
 %% 分别根据最大值和最小值各自的平均值计算约束的透射率
 A=0.9;
 omega=1;
 t=omega*max((A-M_max)/A,(M_min-A)/(1-A));
 
 t1=(M_max-A)/(-A);
 figure 
 imshow(t);
 figure
 imshow(drawcolor(t));
 title('t')

 
 %% output
 I_out=zeros(h,w,3);
 I_out(:,:,1)=(I(:,:,1)-A+A*t)./t;
 I_out(:,:,2)=(I(:,:,2)-A+A*t)./t;
 I_out(:,:,3)=(I(:,:,3)-A+A*t)./t;
 
 
 figure
 imshow(I_out);