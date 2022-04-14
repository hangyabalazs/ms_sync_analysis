function p = std_permutation_test(X)
%STD_PERMUTATION_TEST
%   X: n x 2 matrix, storing (pairwise observations. 
%   std difference: std(2nd colum) -  std(1st column)!

nReps = 1e5; % number of permutations
stdDiffs = zeros(nReps,1); % allocate to store std differences
for it = 1:nReps
    replInx = randi(2,size(X,1),1)-1==0; % random index of pairs where labels are replaced
    swappedX = X;
    swappedX(replInx,:) = swappedX(replInx,[2,1]); % swap indexed rows
    stdDiffs(it) = diff(std(swappedX)); % std difference for this permutation
end
actDiff = diff(std(X)); % std difference in the actual data
p = sum(actDiff>stdDiffs)/nReps; % probability of even more negative difference
figure; histogram(stdDiffs), xline(actDiff,'LineWidth',2)
title({'Theta-delta fr std (Hz)',['P(theta-delta<', num2str(actDiff) ,') = ',num2str(p)]})

end