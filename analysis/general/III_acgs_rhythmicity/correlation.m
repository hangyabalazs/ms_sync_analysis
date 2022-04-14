function [normLrCor,sumacr,lag] = correlation(timeseries1,timeseries2,isAcg,acgColour,maxlag,binsize,normMethod)
%CORRELATION Cross- or autocorrelation of timeseries.
%   [NORMLRCOR,SUMACR,LAG] = CORRELATION(TIMESERIES1,TIMESERIES2,ISACG,ACGCOLOUR,
%   MAXLAG,BINSIZE,NORMMETHOD,ISLPF) calculates crosscorrelation of timeseries1
%   and timeseries2, autocorrelation (if timeseries1 and timeseries2 are 
%   the same).
%   If TIMESERIES1 is not a logical vector (but a vector specifying AP timepoints)
%   than it converts them to a logical vector (sampled at NSR).
%   Other Parameters:
%   ISACG: logical, true if acg should be computed, false if ccg.
%   ACGCOLOUR: color of autcorrelograms (default: blue). Specify [0,0,0] to
%   avoid ploting.
%   MAXLAG: maximum shift in sampling rate (default: CGWINDOW*NSR).
%   BINSIZE: bin size for smoothing in sampling rate (default: CGBINS).
%   NORMMETHOD: string, normalization method, can be 'integrating' or 
%   'zscoring', (default: 'integrating').
%   NORMLRCOR: vector, normalized correlogram.
%   SUMACR: integral of smoothed correlogram.
%   LAG: lag vector.
%
%   See also CELL_RHYTHMICITY, THETAINDEX, DELTAINDEX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global NSR
global CGWINDOW
global CGBINS

% Input arguments
if nargin < 5    
    maxlag = CGWINDOW * NSR;
    binsize = CGBINS;
    normMethod = 'integrating';
    if nargin < 4
        acgColour = [0,0.4470,0.7410]; %blue
    end
end

if isempty(timeseries1) | isempty(timeseries2)
    disp('timeseries empty, so return')
    normLrCor = zeros(maxlag*2,1);
    sumacr = 0;
    lag = -maxlag:maxlag;
    lag(lag == 0) = [];
    return
end
    
if all(timeseries1) % convert to logical if AP timestamps are provided
    TS1 = timeseries1;
    TS2 = timeseries2;
    timeseries1 = zeros(max(TS1(end),TS2(end)),1);
    timeseries2 = zeros(max(TS1(end),TS2(end)),1);
    timeseries1(TS1) = 1;
    timeseries2(TS2) = 1;
end

% Calculate correlation
[cor,lag] = xcorr(timeseries1,timeseries2,maxlag);

% Discard zero lag (avoiding very big peak at zero lag) if autocorrelation
if isAcg
    cor(lag==0) = [];
    lag(lag==0) = [];
end

%Smooth ccg:
conWindow = ones(binsize,1)/binsize;
smCor = conv(cor,conWindow,'same');
sumacr = sum(smCor); % integrate
sumacr(sumacr<0) = 0; % correct for rounding errors

% Return if 0 correlation sum
if sumacr == 0
    disp('sum(lrCor)=0, so return')
    normLrCor = smCor;
    return
end

% Normalize CCGs
switch normMethod
    case 'integrating'
        normLrCor = smCor/ sumacr;
    case 'zscoring'
        normLrCor = zscore(smCor);
end

% Plot
if ~isequal(acgColour,[1,1,1]) %Plot if not white
    % bar(lrLag,normLrCor,'FaceColor','black')
    plot(lag,normLrCor,'Color',acgColour);
end

end