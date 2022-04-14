function [allCorr,peakLags,sumacrs,cycT] = all_ccg(cellPairs,toI,maxlag,cgbins,maxFr)
%ALL_CCG calculates the ccgs of all CELLPAIRS during a given interval or 
%during theta or delta. Ccgs' rhthmicity offset is defined as the closest
%   to zero peak's lag. Relative phase can be computed by dividing the 
%   offset lag with the rhthmicity cycle length (= distance between the 
%   first two different-side peak lags).
%   Parameters:
%   CELLPAIRS: nCellPairsx8 array, containing cell ID pairs (e.g.: 
%   {20100728,2,4,5,2010728,2,4,6;20100728,3,4,5,2010728,3,4,9; etc.}).
%   TOI: time of interest to compute ccgs. Can be 'theta', 'delta' or a
%   numerical vector containing timepoints (in NSR) of interest.
%   MAXLAG: maximum shift in sampling rate (use default: CGWINDOW*NSR).
%   CGBINS: bin size for smoothing in sampling rate (use default: CGBINS).
%   MAXFR: maximum frequency of ccgs, used to calculate peak phase.
%
%   See also PLOT_CCG_NETWORK, CREATE_CCGMATRIX, CREATE_CCGMATRIXIDS, 
%   ALIGN_CCG_PEAKS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/16/2022

global NSR
global RESULTDIR

allCorr = zeros(size(cellPairs,1),maxlag*2+1);
peakLags = zeros(size(cellPairs,1),1);
sumacrs = zeros(size(cellPairs,1),1);
cycT = zeros(size(cellPairs,1),1);
for it1 = 1:size(cellPairs,1)
        TS1 = loadTS(cellPairs{it1,1},cellPairs{it1,2},cellPairs{it1,3},cellPairs{it1,4});
        TS2 = loadTS(cellPairs{it1,5},cellPairs{it1,6},cellPairs{it1,7},cellPairs{it1,8});
        if isequal(toI,'theta')
            % Load state detection results:
            load(fullfile(RESULTDIR,'theta_detection','theta_segments',[cellPairs{it1,1},cellPairs{it1,2}]),'theta');
            [normLrCor,sumacr,lags] = correlation(TS1(theta(TS1)==1),TS2(theta(TS2)==1),...
            false,[1,1,1],maxlag,cgbins,'integrating');
        elseif isequal(toI,'delta')
            % Load state detection results:
            load(fullfile(RESULTDIR,'theta_detection','theta_segments',[cellPairs{it1,1},cellPairs{it1,2}]),'delta');
            [normLrCor,sumacr,lags] = correlation(TS1(delta(TS1)==1),TS2(delta(TS2)==1),...
            false,[1,1,1],maxlag,cgbins,'integrating');
        else
%             [normLrCor,sumacr,lags] = correlation(TS1(TS1>toI(1) & TS1<toI(2)),TS2(TS2>toI(1) & TS2<toI(2)),...
%             false,[1,1,1],maxlag,cgbins,'integrating');
            [normLrCor,sumacr,lags] = correlation(intersect(toI,TS1),intersect(toI,TS2),...
            false,[1,1,1],maxlag,cgbins,'integrating');
        end
        if any(normLrCor) %??????????????????????????????????
            % Peak lag:
            [~,locs] = findpeaks(normLrCor,lags,'MinPeakDistance',NSR/maxFr);
            [~,pkId] = min(abs(locs));
            peakLags(it1) = locs(pkId);
            sumacrs(it1) = sumacr;
            allCorr(it1,:) = normLrCor;
            
            cycT(it1) = sum(mink(abs(locs),2)); % phase = peakLag\cycT*2*pi
        end
end
end