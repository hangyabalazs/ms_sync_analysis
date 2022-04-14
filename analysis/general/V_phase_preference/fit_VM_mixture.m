function fit_VM_mixture(angs,kMax)
%FIT_VM_MIXTURE fits a mixture of KMAX Von Mises (VM) distribution to 
%circular phase data ANGS.
%   Implemented based on VMCOMPONENTS_EM!!!
%   Parameters:
%   ANGS: nCellx1 vector, mean phases of some cells relative to some global
%   rhythmic signal (e.g.: theta oscillation).
%   KMAX: maximal number of fitted VM distributions.
%
%   See also WATSONKFIT_EM, VMCOMPONENTS_EM, ANTIPHASE_CCG_PAIRS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 17/02/2022

global RESULTDIR

nCells = numel(angs); % nzumber of cells

mu = NaN(kMax);
kappa = NaN(kMax);
p = NaN(kMax);
AIC = zeros(1,kMax);
BIC = zeros(1,kMax);
for k = 1:kMax
    % Fit k VM distributions with expectation maximalization:
    if k == 1
        [ftm, mu(1,1), mvl] = mvlmn(angs,'rad');
        kappa(1,1) = A1inv(mvl);
%         p = [];
    else
        [param,err,Q_tot,e_tot] = watsonkfit_EM(angs.',k);
        mu(k,1:k) = param{1};
        kappa(k,1:k) = param{2};
        p(k,1:k-1) = param{3};
    end
    
    % Model goodness (information criterias)
    p(k,k) = 1 - sum(p(k,1:k-1));
    F = cell(1,k); % mixed von Mises cdf
    cF = zeros(1,nCells);
    for t = 1:k
        F{t} = vmcdf(angs',mu(k,t),kappa(k,t),'rad');
        cF = cF + p(k,t) * F{t};
    end
    L = 0;  % log-likelihood function
    for j = 1:k
        L = L + p(k,j)/(2*pi*besseli(0,kappa(k,j)))*exp(kappa(k,j)*cos(angs-mu(k,j)));
    end
    Q = sum(log(L));
    AIC(k) = 2 * (3 * k - 1) - 2 * Q; % Akaike Information Criteria
    BIC(k) = - 2 * Q + (3 * k - 1) * log(nCells); % Bayesian Information Criteria
end
end