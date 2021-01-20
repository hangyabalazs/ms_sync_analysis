function deinx = deltaindex(cor,lags,isPlot,colour)
%DELTAINDEX Calculates delta index of MS units.
%   DEINX = DELTAINDEX(COR,LAGS,ISPLOT,COLOUR) calculate delta index for 
%   provided COR correlation vector.
%   Parameters:
%   COR: correlation vector.
%   LAGS: is the lag vector (time shifts) for COR.
%   ISPLOT: whether to display or not.
%   COLOUR: colour of asterisk on plot.
%   DEINX: delta index.
%
%   Delta index (thinx):
%         1. find peak in delta band (MSDEBAND) on acg.
%         2. average around (mdep = peak location +- 20 msec) it
%         3. calculate baseline (mdet = peak location/2 and peak location*1.5) and
%         average it.
%         4. (mdep-mdet)/max(mdep, mdet) -> normalize into [-1, 1]
%
%   See also CELL_RHYTHMICITY, CORRELATION, THETAINDEX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global NSR
global CGWINDOW
global MSDEBAND

% Delta peak
corres = 1 / NSR;   % cor resolution in seconds
depeak = cor(lags>=(NSR/MSDEBAND(2)) & lags<=(NSR/MSDEBAND(1))); % cor first delta peak
[~,pl] = max(depeak);
ploc = round((CGWINDOW+1/MSDEBAND(2))/corres + pl); % peak loc. index to cor
flank = 0.02 / corres; % 20 ms flanks around the peak, in cor data points
mdep = mean(cor(ploc-flank:ploc+flank)); % mean in a ~50 msec timewindowsize around peak (+/- 20ms)

peaklag = lags(ploc); % lag for the delta peak

% Troughs
tloc1 = round(CGWINDOW/corres + (ploc-CGWINDOW/corres)*0.5); % pre-trough loc index to cor
tloc2 = round(CGWINDOW/corres + (ploc-CGWINDOW/corres)*1.5); % post-trough loc index to cor

mdet1 = mean(cor(tloc1-flank:tloc1+flank));
if tloc2+flank>length(cor) % if we cant average, because baseline "sticks out" (cor is too short)
    mdet2 = mean(cor(length(cor)-flank*2:length(cor)));
    tloc2 = length(cor);
else
    mdet2 = mean(cor(tloc2-flank:tloc2+flank));
end
mdet = (mdet1 + mdet2) / 2; % mean in 50 ms time CGWINDOW around the troughs

% Delta index
deinx = (mdep - mdet) / max(mdep,mdet); % delta index
% deinx = diff([mdet, mdep]); % delta index

% Plot
if isPlot
    hold on
    plot(peaklag, mdep, colour); % plot a star at theta peak
    plot(lags(tloc1), mdet1, colour); % plot a star at 1st baseline value
    plot(lags(tloc2), mdet2, colour); % plot a star at 2nd baseline value
end
end