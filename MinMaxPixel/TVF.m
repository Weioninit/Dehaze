%im为double类型  u为uint8
function u=TVF(im)             %定义test函数
% im=imread('C:/Users/振巍/Desktop/毕业论文figure/videodehaze/0697_back_L.png');     %读取一幅tif格式的water图像，命名为im

im=double(im)/255.0;                %生成矩阵im
% figure(1),imshow(im)     %创建图像1，用来显示刚才读取的im图像

[nx,ny]=size(im);            %读取矩阵的大小，Nx是矩阵im的行，Ny是矩阵的列

% rand('state',0);      
% %为了能和作者产生相同的结果，在这里选择0，意思是在指定状态下，产生相同的随机结果
% rdn=randn(nx,ny);         %随机的噪声是一个和输入图像的尺寸一样大的噪声，命名为rdn
% sigma1=20;                  %赋值令西格玛等于20
% noise=sigma1.*rdn;        %噪声等于20倍的rdn
% imy=im+noise;              %新生成的imy图像是原图像加上噪声的图像，即imy是含噪声图像
% figure(2),imshow(imy,[]),title(num2str(sigma1)); 
% %建立图像2，用来显示带噪声的图像imy，标提是西格玛1的值
iteration=500;                                    %迭代终止的值




u_old=im;                                         %进行初始化
tau=0.02;                                          %系数
for n=1:iteration                                %迭代开始，是从1到500，步长为1，也就是迭代500次
u=u_old+tau .*(BackwardX( ForwardX(u_old))+BackwardY(ForwardY(u_old)));                  %对图像求二阶偏导，公式为 
    u_old=u;                                              %将计算后得到的图像u重新命名为u-old
    
end                                                        %结束
% imtool([im,e,u]);
% imtool(e);
u=uint8(u*255);
% figure(3),imshow(u),title(num2str(n))       %建立图像3，用来显示图像u，标题为迭代次数
% imtool(u)
end                                                        %结束
 
function [dx]=BackwardX(u)                           %定义BackwardX(u)函数
[Ny,Nx] = size(u);   
%读取矩阵u的大小,因为对行求差的时候只需要列坐标变动，所以这里行列的名字颠倒一下，这样更方便
dx = u;                                          %令dx和u一样
dx(2:Ny-1,2:Nx-1)=( u(2:Ny-1,2:Nx-1)-u(2:Ny-1,1:Nx-2)); 
%  对矩阵中列求一阶偏导，即 保留竖直方向上的差值
% 
dx(:,Nx) = -u(:,Nx-1);
%dx中Nx列所有元素的值都等于-u矩阵中Nx-1列的
end                                                           %结束
 
function [dy]=BackwardY(u)                             %定义BackwardY(u)函数
[Ny,Nx] = size(u);                                         %读取图像U的大小
dy = u;                                                      %令dx和u一样
dy(2:Ny-1,2:Nx-1)=( u(2:Ny-1,2:Nx-1) - u(1:Ny-2,2:Nx-1) );
% , 
dy(Ny,:) = -u(Ny-1,:);                              %dy中的Ny行的所有元素的值都等于-u矩阵中Ny-1行的
end                                                     %结束
 
function [dx]=ForwardX(u)                         %定义函数ForwardX(u)
[Ny,Nx] = size(u);                                   %读取图像u的大小
dx = zeros(Ny,Nx);                                   %创建一个Ny行，Nx列的零矩阵dx
dx(1:Ny-1,1:Nx-1)=( u(1:Ny-1,2:Nx) - u(1:Ny-1,1:Nx-1) ); 
% 由于dx之前是零矩阵，所以里面的最后一列应该为零
% 
end                                                      %结束
 
function [dy]=ForwardY(u)                          %定义函数ForwardY(u)
 
[Ny,Nx] = size(u);                                    %读取图像U的大小
dy = zeros(Ny,Nx);                                    %创建一个Ny行，Nx列的零矩阵dx
dy(1:Ny-1,1:Nx-1)=( u(2:Ny,1:Nx-1) - u(1:Ny-1,1:Nx-1) ); 
% 由于初始值全为零，则dy矩阵中的最后一行全为零
% 
end                                                      %结束







