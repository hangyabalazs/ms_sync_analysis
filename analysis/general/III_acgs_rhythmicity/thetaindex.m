function thinx = thetaindex(cor,lags,isPlot,colour)
%THETAINDEX Calculates theta index.
%   THINX = THETAINDEX(COR,LAGS,ISPLOT,COLOUR) calculate theta index for 
%   provided COR correlation vector.
%   Parameters:
%   COR: correlation vector.
%   LAGS: is the lag vector (time shifts) for COR.
%   ISPLOT: whether to display or not.
%   COLOUR: colour of asterisk on plot.
%   THINX: theta index.
%
%   Theta index (thinx):
%         1. Find peak in theta band (MSTHBAND) on acg.
%         2. Average around (mthp = peak location +- 20 msec) it.
%         3. Calculate baseline (mtht = peak location/2 and peak location*1.5) and
%         average it.
%         4. (mthp-mtht)/max(mtht, mthp) -> normalize into [-1, 1].
%
%   See also CELL_RHYTHMICITY, CORRELATION, DELTAINDEX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global NSR
global CGWINDOW
global MSTHBAND

% Theta peak
corres = 1 / NSR;   % COR resolution in seconds
thpeak = cor(lags>=(NSR/MSTHBAND(2)) & lags<=(NSR/MSTHBAND(1)));   % COR first theta peak
[~,pl] = max(thpeak);
ploc = round((CGWINDOW+1/MSTHBAND(2))/corres + pl);   % peak loc. index to cor
flank = 0.02 / corres;   % 20 ms flanks around the peak, in cor data points
mthp = mean(cor(ploc-flank:ploc+flank)); % mean in a ~50 msec timewindowsize around peak (+/-20 ms)
peaklag = lags(ploc);   % lag for the theta peak

% Troughs
tloc1 = round(CGWINDOW/corres + (ploc-CGWINDOW/corres)*0.5); % pre-trough loc index to cor
tloc2 = round(CGWINDOW/corres + (ploc-CGWINDOW/corres)*1.5); % post-trough loc index to cor
mtht1 = mean(cor(tloc1-flank:tloc1+flank));
mtht2 = mean(cor(tloc2-flank:tloc2+flank));
mtht = (mtht1 + mtht2) / 2; % mean in 50 ms time window around the troughs

% Theta index
thinx = (mthp - mtht) / max(mthp,mtht); % theta index
% thinx = diff([mtht, mthp]); % theta index

% Plot
if isPlot
    hold on
    plot(peaklag,mthp,colour); % plot a star at theta peak
    plot(lags(tloc1),mtht1,colour); % plot a star at 1st baseline value
    plot(lags(tloc2),mtht2,colour); % plot a star at 2nd baseline value
end
end