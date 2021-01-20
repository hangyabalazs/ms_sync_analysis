function shiftedMatrix = align_ccg_peaks(dataMatrix,findMaxIn,cutWindow)
%ALIGN_CCG_PEAKS Shifts input ccgs' maximums to the center.
%   SHIFTEDMATRIX = ALIGN_CCG_PEAKS(DATAMATRIX,FINDMAXIN,CUTWINDOW) align
%   (auto/cross) correlations at their peaks.
%   Parameters:
%   DATAMATRIX: (maxlag*2+1) x nPairs matrix, storing (cross-) correlations
%   of cell pairs.
%   FINDMAXIN: vector, specifying where to look for peaks.
%   CUTWINDOW: number, +/- window size to cut around peak.
%   SHIFTEDMATRIX: (CUTWINDOW*2+1) x nPairs matrix, returning shifted cross
%   correlations.
%
%   See also PLOT_CCG_NETWORK, CREATE_CCGMATRIX, CREATE_CCGMATRIXIDS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/05/2019

nCells = size(dataMatrix,2);
shiftedMatrix = zeros(cutWindow*2+1,nCells); % allocate
for it = 1:nCells
    [~,maxInd] = max(dataMatrix(findMaxIn,it));
    maxInd = maxInd + findMaxIn(1);
    shiftedMatrix(:,it) = dataMatrix(maxInd-cutWindow:maxInd+cutWindow,it);
end
end