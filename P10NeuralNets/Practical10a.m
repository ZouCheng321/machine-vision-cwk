% Machine Vision Neural Network tutorial---Part 1
% Author: Daniyar Turmukhambetov, 13 Dec 2026
%
% You are going to train a small multilayer perceptron
% (MLP) to classify some toy data points in a 2D-space. 
% 
% The multilayer perceptron is implemented in "mlp.m" file.
% TODO 0: Please read the code of "mlp.m" before proceeding.

% Certain methods (functions) are not implemented: 
%     layers/relu.m
%     layers/affine_layer.m
%     layeres/cross_entropy_softmax_layer.m
% Your task is to complete the missing code.
% Below, the functions are tested to ensure that the 
% implementation is correct.

% Make layer files callable.
clear
clear 'functions'
addpath('layers')
% Fix random seed
rng(1337)

% TODO 1: Implement ReLU layer. You need to go into 
% "layers/relu_layer.m" and fill in the blanks.
% See "layers/sigmoid_layer.m" as a reference.
clear;
relu = relu_layer();

% TODO 1.1: Implement forward pass of ReLU layer
test_x = [-0.1, 0.1; 0.1, -0.1];
[y, relu] = relu.forward(test_x);
test_y = [0.0, 0.1; 0.1, 0.0];
if numel(y)~=numel(test_y) || any(abs(y(:)-test_y(:))>1.0e-6)
    error('TODO 1.1 ReLU forward pass test failed.')
else
    disp('ReLU forward pass test correct.')
end

% TODO 1.2: Implement backward pass of ReLU layer
test_dldy = [0.1, 0.2; 0.3, 0.4];
[dldx, relu] = relu.backward(test_dldy);
test_dldx = [0.0, 0.2; 0.3, 0.0];
if numel(dldx)~=numel(test_dldx) || any(abs(dldx(:)-test_dldx(:))>1.0e-6)
    error('TODO 1.2 ReLU backward pass test failed.')
else
    disp('ReLU backward pass test correct.')
end

% TODO 2: Implement affine layer in "layers/affine_layer.m" file.
clear;
affine = affine_layer(3, 2);

% TODO 2.1: Implement forward pass of affine layer
test_x = [-0.1, 0.2, 0.3; 0.1, -0.2, -0.3];
[y, affine] = affine.forward(test_x);
test_y = [-0.15007770, -0.021137288; 0.17007770, 0.041137288];
if numel(y)~=numel(test_y) || any(abs(y(:)-test_y(:))>1.0e-6)
    error('TODO 2.1 Affine forward pass test failed.')
else
    disp('Affine forward pass test correct.')
end

% TODO 2.2: Implement backward pass of affine layer
test_dldy = [-0.1, -0.2; 0.3, 0.4];
[dldx, affine] = affine.backward(test_dldy);
test_dldx = [0.05000650, 0.08486181, 0.03421172; -0.14523331, -0.21020669, -0.10986740];

if numel(dldx)~=numel(test_dldx) || any(abs(dldx(:)-test_dldx(:))>1.0e-6)
    error('TODO 2.2 Affine backward pass test failed.')
else
    disp('Affine backward pass test correct.')
end

% TODO 3: Implement cross-entropy softmax layer in "layers/cross_entropy_softmax_layer.m" file.
clear;
crossentropy_softmax = crossentropy_softmax_layer();

% TODO 3.1: Implement "softmax" function of cross-entropy softmax layer 
test_x = [-0.1, 0.2, 0.3];
test_target = [0.0, 1.0, 0.0];
[y, crossentropy_softmax] = crossentropy_softmax.forward(test_x, test_target);
test_softmax_output = [0.26030254, 0.35137168, 0.38832576];
softmax_output = crossentropy_softmax.softmax_output;

if numel(softmax_output)~=numel(test_softmax_output) || any(abs(softmax_output(:)-test_softmax_output(:))>1.0e-6)
    error('TODO 3.1 Cross-entropy softmax layer''s softmax output test failed.')
else
    disp('Cross-entropy softmax layer''s softmax output test correct.')
end

% TODO 3.2: Implement crossentropy computation of 
% the forward pass of cross-entropy softmax layer 
test_y = 1.04591068;
if numel(y)~=numel(test_y) || any(abs(y(:)-test_y(:))>1.0e-6)
    error('TODO 3.2 Cross-entropy softmax forward pass test failed.')
else
    disp('Cross-entropy softmax forward pass test correct.')
end

% TODO 3.3: Implement backward pass of cross entropy softmax layer 
test_dldy = -0.1;
[dldx, crossentropy_softmax] = crossentropy_softmax.backward(test_dldy);
test_dldx = [-0.02603025, 0.06486283, -0.03883257];

if numel(dldx)~=numel(test_dldx) || any(abs(dldx(:)-test_dldx(:))>1.0e-6)
    error('TODO 3.3 Cross-entropy softmax backward pass test failed.')
else
    disp('Cross-entropy softmax backward pass test correct.')
end

% TODO 4: Implement "apply_gradient_descent_step" function (backpropagation) 
% of the multilayer perceptron training.
clear;
mlp = mlp();
mlp = mlp.run(5);
test_mlp = load('test_net.mat');

if any(cell2mat(cellfun(@(x,y) isprop(x, 'W') && numel(x.W)~=numel(y.W), test_mlp.net, mlp.net, 'UniformOutput', false))) || ...
        any(cell2mat(cellfun(@(x,y) isprop(x, 'W') && any(x.W(:)-y.W(:)>1.0e-6), mlp.net, test_mlp.net, 'UniformOutput', false)))
    error('TODO 4 MLP apply_gradient_descent_step test failed.')
else
    disp('MLP apply_gradient_descent_steptest correct.')
end


% Finally, you can train your multilayer perceptron
clear;
mlp = mlp();
mlp = mlp.run();
