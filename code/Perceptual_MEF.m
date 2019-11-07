function result = Perceptual_MEF(images_rgb)

[H, W, ~, N] = size(images_rgb);
%% calculate adaptive well-exposedness weight maps, namesly weight_maps_1
% compute luminance
images_luminance = zeros(H, W, N); % initialize
for i = 1 : N
    images_ycbcr = rgb2ycbcr(images_rgb(:, :, :, i));
    images_luminance(:, :, i) = images_ycbcr(:, :, 1);
end
% compute mean value of luminance
mean_value = mean(mean(images_luminance));
mean_value = reshape(mean_value, N, 1);
% set the sigma value
sigma = 0.20;
% compute adaptive well-exposedness weight maps denoted as weight_maps_1
weight_maps_1 = zeros(H, W, N); % initialize
for j = 1 : N
    weight_maps_1(:, :, j) = exp(-0.5 * (images_luminance(:, :, j) - (1 - mean_value(j))).^2 / sigma /sigma);
end

%% calculate 3-D color gradient, namely weight_maps_2
% compute 3-D color gradient
weight_maps_2 = zeros(H, W, N);
for k = 1 : N
    [weight_maps_2(:, :, k), ~, ~] = color_gradient(images_rgb(:, :, :, k));
end
% given the weight for above two weight_maps
w1 = 1;w2 = 2.2;
weight_maps = (weight_maps_1.^w1) .* (weight_maps_2.^w2);
% refine weight maps
weight_refine = zeros(H, W, N);% initialize
for m = 1 : N
    weight_refine(:, :, m) = imgaussfilt(weight_maps(:, :, m), 3); % 3 is the well
end
% Determine the number of decomposition layers
if N > 3
    level = 7;
else
    level = 8;
end
%% pyramid fusion
result = fusion_pyramid(images_rgb, weight_refine, level);
result = uint8(255*result);
end

    
