function HW2_TrackingAndHomographies


LLs = HW2_Practical9c( 'll' );
LRs = HW2_Practical9c( 'lr' );
ULs = HW2_Practical9c( 'ul' );
URs = HW2_Practical9c( 'ur' );

close all;

% Load frames from the whole video into Imgs{}.
% This is really wasteful of memory, but makes subsequent rendering faster.
LoadVideoFrames

% Coordinates of the known target object (a dark square on a plane) in 3D:
XCart = [-50 -50  50  50;...
          50 -50 -50  50;...
           0   0   0   0];

% These are some approximate intrinsics for this footage.
K = [640  0    320;...
     0    512  256;
     0    0    1];

% Define 3D points of wireframe object.
XWireFrameCart = [-50 -50  50  50 -50 -50  50  50;...
                   50 -50 -50  50  50 -50 -50  50;...
                    0   0   0   0 -100 -100 -100 -100];
 
hImg = figure;
       
% ================================================
for iFrame = 1:numFrames
    xImCart = [LLs(iFrame,:)' ULs(iFrame,:)' URs(iFrame,:)' LRs(iFrame,:)'];
    xImCart = circshift( xImCart, 1);

    % To get a frame from footage 
    im = Imgs{iFrame};

    % Draw image and 2d points
    set(0,'CurrentFigure',hImg);
    set(gcf,'Color',[1 1 1]);
    imshow(im); axis off; axis image; hold on;
    plot(xImCart(1,:),xImCart(2,:),'r.','MarkerSize',15);


    %TO DO Use your routine to calculate TEst the extrinsic matrix relating the
    %plane position to the camera position.
    T = estimatePlanePose(xImCart, XCart, K);



    %TO DO Draw a wire frame cube, by projecting the vertices of a 3D cube
    %through the projective camera, and drawing lines betweeen the 
    %resulting 2d image points
    hold on;
    
    % TO DO: Draw a wire frame cube using data XWireFrameCart. You need to
    % 1) project the vertices of a 3D cube through the projective camera;
    % 2) draw lines betweeen the resulting 2d image points.
    % Note: CONDUCT YOUR CODE FOR DRAWING XWireFrameCart HERE
    
    hold off;
    drawnow;
    
%     Optional code to save out figure
%     pngFileName = sprintf( '%s_%.5d.png', 'myOutput', iFrame );
%     print( gcf, '-dpng', '-r80', pngFileName ); % Gives 640x480 (small) figure

    
end % End of loop over all frames.
% ================================================

% TO DO: QUESTIONS TO THINK ABOUT...

% Q: Do the results look realistic?
% If not then what factors do you think might be causing this


% TO DO: your routines for computing a homography and extracting a 
% valid rotation and translation GO HERE. Tips:
%
% - you may define functions for T and H matrices respectively.
% - you may need to turn the points into homogeneous form before any other
% computation. 
% - you may need to solve a linear system in Ah = 0 form. Write your own
% routines or using the MATLAB builtin function 'svd'. 
% - you may apply the direct linear transform (DLT) algorithm to recover the
% best homography H.
% - you may explain what & why you did in the report.

