image_name =  'C:/Users/��Ρ\Desktop/color-line�ؾ�ֱ��ͼ/mountain_input.png';
img=imread(image_name);
I=im2double(img);
image_name1 =  'C:/Users/��Ρ\Desktop/color-line�ؾ�ֱ��ͼ/train_input.png';
img1=imread(image_name1);
I1=im2double(img1);
image_name2 =  'C:/Users/��Ρ\Desktop/color-line�ؾ�ֱ��ͼ/hongkong_input.png';
img2=imread(image_name2);
I2=im2double(img2);
[lamda,mean,pro,L_test]=cal_lamda(I);
[lamda1,mean1,pro1,L_test1]=cal_lamda(I1);
[lamda2,mean2,pro2,L_test2]=cal_lamda(I2);
mean_f=50*(1.6*mean-0.14);
mean_p=50*(1.6*mean1-0.14);
mean_g=50*(1.6*mean2-0.14);
figure
plot(lamda,'red');
hold on
plot(lamda1,'blue');
hold on

plot(lamda2,'green');
hold on
% plot([0,50],[pro,pro],'red');
plot([mean_f,mean_f],[0,1],'red');



hold on
plot([mean_p,mean_p],[0,1],'blue');

hold on

plot([mean_g,mean_g],[0,1],'green');



figure
imshow(L_test);
imwrite(L_test,'C:\Users\��Ρ\Desktop\����ȥ��ʵ��ͼƬ\mountain-L_mark.jpg');
figure
imshow(L_test1);
imwrite(L_test1,'C:\Users\��Ρ\Desktop\����ȥ��ʵ��ͼƬ\train-L_mark.jpg');
figure
imshow(L_test2);
imwrite(L_test2,'C:\Users\��Ρ\Desktop\����ȥ��ʵ��ͼƬ\hongkong-L_mark.jpg');
