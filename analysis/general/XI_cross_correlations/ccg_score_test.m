function [pTh,pDe] = ccg_score_test(rhGroupPairs)
%CCG_SCORE_TEST compares rhthmicity group intra and inter group connection 
%types.
%   CCG_SCORE_TEST(RHGROUPPAIRS) calculates the ccgs of corecorded cell 
%   pairs, where the first cell is from RHGROUPPAIRS{e.g.: 1}{1} and the 
%   second is from RHGROUPPAIRS{e.g.: 1}{2}. Once all ccgs are calculated
%   for the given connection type (during delta and theta as well), it 
%   calculates the CCGSSCORES (rhythmicity measure of indvidual ccgs: 
%   squared integral of the group-mean-subtracted ccgs). Finally, when
%   CCGSSCORES are calculated for all connection types, it compares the
%   score distributions by ranksum test.
%   Parameters:
%   RHGROUPPAIRS: cell array, containing rhythmicity group ID (three letter
%   abbreviations) pairs to compare CCGSCORES between them (e.g.:
%   {{'CTB','CTB'},{'CTT','CTT'},{'DT_','DT_'},{'CTB','CTT'},{'CTB','DT_'},{'CTT','DT_'}})
%
%   See also ALL_CCG, PLOT_CCG_NETWORK, CREATE_CCGMATRIX, CREATE_CCGMATRIXIDS, 
%   ALIGN_CCG_PEAKS, FIND_CORECORDED_CELL_PAIRS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/16/2022

global RESULTDIR
global CGWINDOW
global NSR
global CGBINS

maxlag = CGWINDOW * NSR;
findMaxIn = -maxlag/2:maxlag/2; % lags
findMaxIn = findMaxIn + maxlag; % indices of lags
slideWindow = maxlag / 2;

ccgScores = zeros(2,20000); % store ccg scores during theta and delta
pairId = zeros(1,20000);
cntr = 1;
for it = 1:numel(rhGroupPairs) % iterate trough all connection types
    grp1 = rhGroupPairs{it}{1};
    grp2 = rhGroupPairs{it}{2};
    
    rowIds1 = get_rhGroup_indices_in_allCell(grp1);
    rowIds2 = get_rhGroup_indices_in_allCell(grp2);
    indPairs = find_corecorded_cell_pairs(rowIds1,rowIds2);
    cellPairs = [convert_IDs(indPairs(:,1)),convert_IDs(indPairs(:,2))];
    nPairs = size(indPairs,1);
    
    pairId(cntr:cntr+nPairs-1) = it;
    thCorrs = all_ccg(cellPairs,'theta',maxlag,CGBINS,6); % compute ccgs (during theta)
    thCorrsPA = align_ccg_peaks(thCorrs.',findMaxIn,slideWindow); % peak aligned correlograms
    ccgScores(1,cntr:cntr+nPairs-1) = sum((thCorrsPA-mean(thCorrsPA)).^2);
    deCorrs = all_ccg(cellPairs,'delta',maxlag,CGBINS,6); % compute ccgs (during delta)
    deCorrsPA = align_ccg_peaks(deCorrs.',findMaxIn,slideWindow); % peak aligned correlograms
    ccgScores(2,cntr:cntr+nPairs-1) = sum((deCorrsPA-mean(deCorrsPA)).^2);
    cntr = cntr + nPairs;
    
    % Plot
    [colors1{it},~,~,name1] = rhgroup_colors(grp1);
    [colors2{it},~,~,name2] = rhgroup_colors(grp2);
    connNames{it} = [name1,'-',name2];
end
ccgScores(:,cntr:end) = []; % remove excess
pairId(cntr:end) = []; % remove excess
% Plot
figure; 
boxplot(ccgScores(1,:),pairId,'labels',connNames,'Colors','k','symbol','');
title('ccg scores during theta')
figure;
boxplot(ccgScores(2,:),pairId,'labels',connNames,'Colors','k','symbol','');
title('ccg scores during delta')

% Statistics:
pTh = zeros(numel(rhGroupPairs));
pDe = zeros(numel(rhGroupPairs));
for it1 = 1:numel(rhGroupPairs)
    for it2 = 1:numel(rhGroupPairs)
            ccgScoresRows1 = pairId == it1;
            ccgScoresRow2 = pairId == it2;
            pTh(it1,it2) = ranksum(ccgScores(1,ccgScoresRows1),ccgScores(1,ccgScoresRow2));
            pDe(it1,it2) = ranksum(ccgScores(2,ccgScoresRows1),ccgScores(2,ccgScoresRow2));
    end
end

end