function res = normal( X, sigma, mu )
% Computes the likelihood that the data X have been generated from the given
% parameters (mu, sigma) of the one-dimensional normal distribution.
nData =length(X);
const = 1/sqrt(2*pi*sigma^2);
like = 1;

for (i = 1:nData)
    power = - (X(i,1) - mu)^2 / (2 * sigma^2);
    like = like * const * exp(power);
end

res = like;

% TODO fill out this function