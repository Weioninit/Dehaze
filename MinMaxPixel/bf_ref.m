% Bilateral filter
% Straight forward realization
%
% Dan Stefanov, 2013

% implemets staight forward algorithm 
function [filtered_image_fxp] = bf_ref (input_image_fxp, sigma, r)
    input_image = double (input_image_fxp);
    [extended_image, od] = extend_image (input_image, r);
    filter_mask = comp_filter_mask (sigma.d,r);
    filtered_image = zeros (size(extended_image));
     
    for x = od.a(2):od.b(2)
        for y = od.a(1):od.b(1)
            filtered_image(y,x) = ...
               filter_point(extended_image,[y x],sigma.r,filter_mask,r);
        end
    end

    filtered_image_crop = filtered_image(od.a(1):od.b(1),od.a(2):od.b(2));
    filtered_image_fxp = uint8(filtered_image_crop);            
end

% creates gaus mask
function [mask] = comp_filter_mask (sigma,r)
    line = -r:r;
    line_mask = exp (-0.5*(line / sigma).^2);
    mask = line_mask' * line_mask;
end

% computes single point
function [value] =  filter_point(in_im,p0,sigma,mask,radius)
    f_p0 = in_im (p0(1),p0(2));
    window = crop_radius (in_im,p0,radius);
    window_gaus = comp_gaus (window, f_p0, sigma);
    window_mask = window_gaus .* mask;
    value_h = sum(sum(window_mask .* window));
    value_k = sum(sum(window_mask));
    value = value_h / value_k;
end

% crop a squere window
function [crop_image] = crop_radius (in_im,p0,radius)
    side = (-radius):radius;
    crop_image = in_im (p0(1)+side,p0(2)+side);
end


function [gaus_im] = comp_gaus (window, f_p0, sigma)
    gaus_im = exp (-0.5*((window-f_p0)/sigma).^2);
end