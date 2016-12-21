%% 形态学测试


orig=double(imread('C:/Users/振巍/Desktop/毕业论文figure/videodehaze/0697_back.png'))/255.0;

sv=floor(max(size(orig))/80);
sz=size(orig);
Nsum=sz(1)*sz(2);
se=strel('square',sv);
L=L_func(orig,1);
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

s=(232-99)*(456-377);
imtool([L,f,h]);

% a=reshape(L(100:232,378:456),[1 s]);
% b=reshape(f(100:232,378:456),[1 s]);
% c=reshape(h(100:232,378:456),[1 s]);
% a=sort(a);
% b=sort(b);
% c=sort(c);
% L=L_func(e,1);
% TVF()
% imtool(L);
u=TVF(h);
imtool(u);
% imtool(u,[]);
