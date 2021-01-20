function samples = sample_normal_dist(mu, sigma, nCells1, nCells2)
%SAMPLE_NORMAL_DIST Samples normal distribution.
%   SAMPLES = SAMPLE_NORMAL_DIST(MUS,SIGMA,NCELLS1,NCELLS2) samples normal
%   distribution with given mean and variance, NCELLS1 x NCELLS2 (= output 
%   SAMPLES matrix dimensions) times.


pd = makedist('Normal','mu',mu,'sigma',abs(sigma));
samples = random(pd, nCells1, nCells2);
end