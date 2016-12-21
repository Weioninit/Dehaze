function m=Min_mean(img)
I=im2double(img);
w = size(I,2);
h = size(I,1);%ÐÐ
d = size(I,3);
min_p=zeros(h,w);
if(d==1)
    min_p=img;
end
if(d==3)
for j = 1:w
        for i = 1:h          
            % find min and max value of each pixel
             min_p(i,j) = min(I(i,j,:)); % find min across all channels          
        end
end
end

 m=mean(mean(min_p));