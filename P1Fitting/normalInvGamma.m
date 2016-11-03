function res = normalInvGamma( alpha, beta, delta, gammaVar, sigma, mu )
% Compute the probability that a given normal was generated using this
% normal inverse gamma funcion.

term1 = sqrt(gammaVar) / (sigma * sqrt(2*pi));
term2 = beta^alpha / gammaVar(alpha);
term3 = (1/sigma^2)^(alpha+1);
power_num = -(2*beta + gammaVar*(delta-mu)^2);
power_denom = 2 * sigma^2;

res = term1*term2*term3*exp(power_num/power_denom);

% TODO fill out this function
res = 0;
        
