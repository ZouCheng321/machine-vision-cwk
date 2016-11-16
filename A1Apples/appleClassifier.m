function r=appleClassifier

% LoadApplesScript.m
% This optional script may help you get started with loading of photos and masks.
%
% Note that there are more elegant ways to organize your (photo, mask)
% pairs, and for sorting through many files in a directory. We don't use
% them here because we only have a small number of files, but consider
% useful functions like fileparts(). For simplicity, this example code just
% makes a few cell-arrays to hold the hard-coded filenames.

if( ~exist('apples', 'dir') || ~exist('testApples', 'dir') )
    display('Please change current directory to the parent folder of both apples/ and testApples/');
end

% Note that cells are accessed using curly-brackets {} instead of parentheses ().
Iapples = cell(3,1);
Iapples{1} = 'apples/Apples_by_kightp_Pat_Knight_flickr.jpg';
Iapples{2} = 'apples/ApplesAndPears_by_srqpix_ClydeRobinson.jpg';
Iapples{3} = 'apples/bobbing-for-apples.jpg';

IapplesMasks = cell(3,1);
IapplesMasks{1} = 'apples/Apples_by_kightp_Pat_Knight_flickr.png';
IapplesMasks{2} = 'apples/ApplesAndPears_by_srqpix_ClydeRobinson.png';
IapplesMasks{3} = 'apples/bobbing-for-apples.png';

for iImage = 1:3
    curI = double(imread(  Iapples{iImage}   )) / 255;
    % curI is now a double-precision 3D matrix of size (width x height x 3). 
    % Each of the 3 color channels is now in the range [0.0, 1.0].
    % (because of the division by 255) -jim
    figure;
    imagesc(curI)

    curImask = imread(  IapplesMasks{iImage}   );
    % These mask-images are often 3-channel, and contain grayscale values. We
    % would prefer 1-channel and just binary:
    curImask = curImask(:,:,2) > 128;  % Picked green-channel arbitrarily.
    figure;
    imshow(curImask)


    %load in test image and ground truth.  Your goal is to segment this image
    %to recover the ground truth
    im = imread('bob_small.jpeg');
    load('bob_GroundTruth_small.mat','gt');

    %display test image and ground truth;
    close all;
    figure; set(gcf,'Color',[1 1 1]);
    subplot(1,3,1); imagesc(im); axis off; axis image;
    subplot(1,3,2); imagesc(gt); colormap(gray); axis off; axis image;
    drawnow;

    %load in training data - contains two variables each of size 3 x 10000
    %Each column contains RGB values from one pixel in training data
    load('RGBSkinNonSkin','RGBSkin','RGBNonSkin');


    %fit Gaussian model for skin data
    %TO DO - fill in this routine (it's below, at the bottom of this file)
    %COMPLETE
    [meanSkin covSkin] = fitGaussianModel(RGBSkin);

    %fit Gaussian model for non-skin data
    %TO DO - fill in this routine (below)
    [meanNonSkin covNonSkin] = fitGaussianModel(RGBNonSkin);

    %let's define priors for whether the pixel is skin or non skin
    priorSkin = 0.3;
    priorNonSkin = 0.7;

    %now run through the pixels in the image and classify them as being skin or
    %non skin - we will fill in the posterior
    [imY imX imZ] = size(im);

    posteriorSkin = zeros(imY,imX);
    for (cY = 1:imY); 
        fprintf('Processing Row %d\n',cY);     
        for (cX = 1:imX);          
            %extract this pixel data
            thisPixelData = squeeze(double(im(cY,cX,:)));
            %calculate likelihood of this data given skin model
            %TO DO - fill in this routine (below)
            likeSkin = calcGaussianProb(thisPixelData,meanSkin,covSkin);
            %calculate likelihood of this data given non skin model
            likeNonSkin = calcGaussianProb(thisPixelData,meanNonSkin,covNonSkin);
            %TO DO (c):  calculate posterior probability from likelihoods and 
            %priors using BAYES rule. Replace this: 
            posteriorSkin(cY,cX) = (likeSkin * priorSkin) / ...
                (likeSkin * priorSkin + likeNonSkin * priorNonSkin);
        end;
    end;

    %draw skin posterior
    clims = [0, 1];
    subplot(1,3,3); imagesc(posteriorSkin, clims); colormap(gray); axis off; axis image;
    % set(gca, 'clim', [0, 1]);

end


    %==========================================================================
    %==========================================================================

    %the goal of this routine is to evaluate a Gaussian likleihood
    function like = calcGaussianProb(data,gaussMean,gaussCov)

    [nDim nData] = size(data);

    %TO DO (b) - fill in this routine
    %replace this
    constant = 1 / ( (2*pi)^(nDim/2) * sqrt(det(gaussCov)));

    % Likelihood incrementer. 1 is the product identity.
    like = 1;

    for n = 1:nData
        meandiffs = (data(:,n) - gaussMean);
        power = -0.5 * meandiffs' * inv(gaussCov) * meandiffs;
        exponent = exp(power);

        % Update likelihood
        like = like * constant * exponent;
    end
    



%==========================================================================
%==========================================================================

%the goal of this routine is to return the mean and covariance of a set of
%multidimensaional data.  It is assumed that each column of the 2D array
%data contains a single data point.  The mean vector should be a 3x1 vector
%with the mean RGB value.  The covariance should be a 3x3 covariance
%matrix. See the note at the top, which explains that using mean() is ok,
%but please compute the covariance yourself.
function [meanData covData] = fitGaussianModel(data);

% Looks like this is how one assigns two variables.
[nDim nData] = size(data);

%TO DO (a): replace this

%calculate mean of data.  You can do this using the MATLAB command 'mean'
meanData = mean(data,2);

%calculate covariance of data.  You should do this yourself to ensure you
%understand how.  Check you have the right answer by comparing with the
%matlab command 'cov'.
covData = zeros(nDim,nDim);
for m = 1:nDim
    m_data = data(m,:);
    for n = 1:3
        n_data = data(n,:);
        exy = mean(m_data .* n_data);
        exey = mean(m_data) * mean(n_data);
        mn_cov = exy - exey;
        covData(m,n) = mn_cov;
    end
end

