function tao=TemporalEstimation( pnImageY,pnImageYP, nframe,atm_y)
% global  atm_y 
patch_size=10;
tao=ones(size(pnImageY));

%% 对后续帧的t估计 
 %  The algorithm use exhaustive searching method and its step size is sampled to 0.1
 %	The previous frame information is used to estimate transmission.
 %  atm_y= 0.3*R + 0.59*G + 0.11*B

  fPreJ= pnImageYP-atm_y;
  dI=pnImageY-pnImageYP;
  fTao=(pnImageY-atm_y)./fPreJ;
  fWi=exp(-(dI.*dI)/10);% pixl based matrix
  
  fWsum=fTao.*fWi;
%   fnewTao = double(zeros(2*floor(patch_size/2),2*floor(patch_size/2)));
  [image_x image_y channels] = size(pnImageYP);
    fnewTao = zeros(image_x,image_y);
   fWsum = padarray(fWsum, [floor(patch_size/2) floor(patch_size/2)], 'symmetric');
   fWi = padarray(fWi, [floor(patch_size/2) floor(patch_size/2)], 'symmetric');
   for i = 1:patch_size:image_x
        minX = i;
        maxX = (i + 2*floor(patch_size/2));
        for j = 1:patch_size:image_y
            minY = j;
            maxY = (j + 2*floor(patch_size/2)); %patch
%             fnewTao(i,j)=sum(fWsum(minX:maxX, minY:maxY))/sum(fWi(minX:maxX, minY:maxY));
            
            % copy all color channels over
          fnewTao(minX:maxX,minY:maxY)=sum(fWsum(minX:maxX, minY:maxY))/sum(fWi(minX:maxX, minY:maxY));
        end
   end

    Wi=imfilter(fWi ,fspecial('average',[patch_size patch_size]),'symmetric');
    Wi_small=Wi(1:image_x,1:image_y);
    tao= fnewTao(1:image_x,1:image_y).*Wi_small;
    
  end
