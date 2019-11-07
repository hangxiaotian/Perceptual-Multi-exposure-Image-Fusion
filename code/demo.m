clear all;close all;clc;
warning off;
addpath(genpath(pwd));

%%
folders_path = '..\Dataset\dataset5\';
files = dir(folders_path);
length_file = length(files);
%dataset_Q = zeros(length_file - 2,1);
%%
for k = 3 : length_file
    images_path = [folders_path, files(k).name];
    imgs = load_images(images_path,1);
    images_rgb = imgs/255.0;
    %tic;
    mg_result = Perceptual_MEF(images_rgb);
    %toc;
    %figure, imshow(mg_result);
%% Save the results       
    save_result = 1; % not_save_result = 0;
    if save_result
        imwrite(mg_result, ['result\',files(k).name,'Perceptual_MEF.tif']);
    end
%% evalutate MEF-SSIM
%     imgSeqColor = uint8(load_images(images_path,1));
%     [s1, s2, s3, s4] = size(imgSeqColor);
%     imgSeq = zeros(s1, s2, s4);
%     for n = 1:s4
%         imgSeq(:, :, n) =  rgb2gray( squeeze( imgSeqColor(:,:,:,n) ) );
%     end
%     fI1 = imread(['result\',files(k).name,'Perceptual_MEF.tif']);
%     fI1 = double(rgb2gray(fI1));
%     [dataset_Q(k-2,1), Qs1, QMap1] = mef_ms_ssim(imgSeq, fI1); 
end
% Average_MEF_SSIM = sum(dataset_Q)/length(dataset_Q)
% save dataset_Q.mat
