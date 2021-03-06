function r=practical5b
%The goal of this part of the practical is to use the dynamic programming
%routine that you developed in the first part to solve the dense stero
%problem.  Use the template below, filling in parts marked "TO DO".

%close any previous figures;
close all;

%load in images and ground truth
load('StereoData.mat','im1','im2','gt');

%ground truth disparity is originally expressed in 16'ths of pixels but we 
%will only consider whole-pixel shifts
gtDisp = round(gt/16);

%display image
figure; set(gcf,'Color',[1 1 1]);
subplot(1,2,1); imagesc(im1); axis off; axis image; colormap(gray);
subplot(1,2,2); imagesc(im2); axis off; axis image; colormap(gray);

%figure out size of image
[imY imX] = size(im1);

%define maximum disparity 
maxDisp = 10;

%set up pairwiseCosts - we will define a fixed cost of alpha for changing
%disparity or zero cost for staying the same
alpha = 1;
pairwiseCosts = alpha*ones(maxDisp,maxDisp)-alpha*eye(maxDisp,maxDisp);

%initialize the disparity map that we will estimate
estDisp = zeros(imY,imX-maxDisp);


%define standard deviation of noise
noiseSD = 6;

%display ground truth and estimated disparity
figure; set(gcf,'Color',[1 1 1]);
subplot(1,2,1); imagesc(gtDisp,[0 11]); axis off; axis image; colormap(gray); colorbar;
title('Ground Truth');

%run through each line of image
for (cY = 1:imY)
    fprintf('Procesing scanline %d\n',cY);
    %define unary costs - we will not use the last few columns of the
    %image as the disparity might map the pixel outside the valid area of
    %the second image
    unaryCosts = zeros(maxDisp,imX-maxDisp);
    for(cDisp = 1:maxDisp)
        for (cX = 1:imX-maxDisp)
            %TO DO - calculate cost for this disparity. This is the 
            %negative log likelihood, where the likelihood is a Gaussian
            %with a mean of the value (i.e. intensity) at the offset pixel 
            %in image2 and a standard deviation of "noiseSD".
            % Jim:
            % This is a grid with k as the rows and x as the cols.
            im1_pix = im1(cY,cX);
            im2_disp_pix = im2(cY,cX+cDisp);
            pdf_val = normpdf(im1_pix, im2_disp_pix, noiseSD);
            neg_llike = -log(pdf_val);
            unaryCosts(cDisp,cX) = neg_llike;
        end;
    end;
    
    %TO DO call the routine that you wrote in the previous section (copy it
    %below into the bottom of this file)
    estDisp(cY,:) = dynamicProgram(unaryCosts,pairwiseCosts);
    
    %display solution so far
    subplot(1,2,2); imagesc(estDisp,[0 11]); axis off; axis image; colormap(gray); colorbar;
    title('Estimated Disparity');
    drawnow;
end;


%TO DO - investigate how different values of alpha and noiseSD affect the results

%TO DO (optional) - you should be able to rewrite this with fewer loops once you have
%the general idea so that it runs faster

%TO DO (optional)- adapt the algorithm so that it makes use of colour
%information


 function bestPath = dynamicProgram(unaryCosts, pairwiseCosts)


%count number of positions (i.e. pixels in the scanline), and nodes at each
%position (i.e. the number of distinct possible disparities at each position)
[nNodesPerPosition nPosition] = size(unaryCosts);

%define minimum cost matrix - each element will eventually contain
%the minimum cost to reach this node from the left hand side.
%We will update it as we move from left to right
minimumCost = zeros(nNodesPerPosition, nPosition);

%define parent matrix - each element will contain the (vertical) index of
%the node that preceded it on the path.  Since the first column has no
%parents, we will leave it set to zeros.
parents = zeros(nNodesPerPosition, nPosition);

%FORWARD PASS

%TO DO:  fill in first column of minimum cost matrix
minimumCost(:,1) = unaryCosts(:,1);


%Now run through each position (column) (i.e: pixel -jim)
for (cPosition = 2:nPosition)
    %run through each node (element of column)
    for (cNode = 1:nNodesPerPosition)
        %now we find the costs of all paths from the previous column to this node
        possPathCosts = zeros(nNodesPerPosition,1);
        for (cPrevNode = 1:nNodesPerPosition)
            %TO DO  - fill in elements of possPathCosts
            this_pairwise = pairwiseCosts(cPrevNode,cNode);
            previous_cost = minimumCost(cPrevNode,cPosition-1);
            possPathCosts(cPrevNode) = this_pairwise + previous_cost;
        end;
        %TO DO - find the minimum of the possible paths 
        [this_minimum min_index] = min(possPathCosts);
        %TO DO - store the minimum cost in the minimumCost matrix
        minimumCost(cNode,cPosition) = this_minimum + ...
            unaryCosts(cNode,cPosition);
        %TO DO - store the parent index in the parents matrix
        parents(cNode,cPosition) = min_index;
    end;
end;


%BACKWARD PASS

%we will now fill in the bestPath vector
bestPath = zeros(1,nPosition);

%TO DO  - find the index of the overall minimum cost from the last column and put this
%into the last entry of best path
[last_mincost last_mincost_index] = min(minimumCost(:,nPosition));
bestPath(nPosition) = last_mincost_index;

%TO DO - find the parent of the node you just found
this_parent = parents(last_mincost_index, nPosition);

%run backwards through the cost matrix tracing the best path
for (cPosition = nPosition-1:-1:1)
    %TO DO - work through matrix backwards, updating bestPath by tracing
    %parents.
    bestPath(cPosition) = this_parent;
    this_parent = parents(this_parent,cPosition);
    
end





 