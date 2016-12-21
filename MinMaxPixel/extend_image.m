% Bilateral filter
% Utility subfunction for use in optimized end reference algorithms
%
% Dan Stefanov, 2013


% exteds image borders with flipt copy to radius pixes
function [res_im, orig_dim] = extend_image (in_im, radius)
    im_size = size (in_im);
    ext_h = extend_image_h (in_im, radius);
    ext_v = extend_image_h (ext_h', radius)';
    res_im = ext_v;
    orig_dim.a = [1 1] + radius;
    orig_dim.b = im_size + radius;
end

function [res_im] = extend_image_h (in_im, radius)
    ext_left = in_im (:,1:radius);
    ext_right = in_im (:,(end+1-radius):end);
    res_im = [fliplr(ext_left),in_im,fliplr(ext_right)];
end