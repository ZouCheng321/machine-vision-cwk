function res = logNormal( X, sigma, mu )
% Computes the likelihood that the data X have been generated using the
% given parameters of a one-dimensional normal, but in log space, so the 
% equation should be derived and implemented differently here than in
% normal().

% TODO fill out this function
nData = length(X);
constants = -nData/2 * (log(2*pi) + log(sigma^2));

summed = 0;
for i =1:nData
    summed = summed - (1/(2*sigma^2)) * (X(i) - mu)^2;
end

res = constants + summed;