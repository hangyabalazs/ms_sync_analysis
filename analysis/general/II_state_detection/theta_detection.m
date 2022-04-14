function [theta, delta, thetaTransf, deltaTransf] = theta_detection(fieldPot,thBand,deBand,nsr,tscgwindow,thratioTresh,deratioTresh,windowS,isMAD)
%THETA_DETECTION Detects theta segments in (hippocampal) field potentials.
%   [THETA,DELTA,THETATRANSF,DELTATRANSF] = THETA_DETECTION(FIELDPOT,
%   THBAND,DEBAND,NSR,TSCGWINDOW,THRATIOTRESH,DERATIOTRESH,WINDOWS,ISMAD)
%   Additionally, calculates phases of dominant oscillations (hilbert transf.).
%   Filters field data for theta (THBAND) and for delta (DEBAND). (For this
%   purposes bandpass filter is used.) Centralize, normalize
%   ((feeg-mean(feeg))/standard deviation(eeg)) and hilbert transform
%   (calculating angle and amplitude) them.
%   Definition: if theta's /delta's amplitude's ratio>THRATIOTRESH, theta 
%   is dominant against delta (ratio is filtered before with moving
%   average), if this ratio<DERATIOTRESH, delta is dominant.
%   Parameters:
%   FIELDPOT: field potential vector.
%   THBAND: theta band (Hz) (e.g. [3,8]).
%   DEBAND: non-theta (delta) band (Hz) (e.g. [0.5,3]).
%   NSR: sampling rate (e.g. 1000).
%   TSCGWINDOW: window (in sec) for theta/delta amplitude ratio's smoothing
%   (e.g. 5).
%   THRATIOTRESH: theta/delta amplitude ratio threshold for dominant theta 
%   (e.g. 1).
%   DERATIOTRESH: theta/delta amplitude ratio threshold for dominant delta
%   (e.g. 1).
%   WINDOWS: window size for negligibly small theta-delta segments (e.g. 5).
%   ISMAD: optional, flag, use minimal stregth of theta amplitude
%   threshold for dominant theta detection?
%
%   See also HIPPO_STATE_DETECTION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 03/08/2018

stdNorm = std(fieldPot);

% Filter in theta band:
firOrder = 1024;
if length(fieldPot)<firOrder*3
    firOrder = 64, % short data -> firOrder would be too large
end 
thetaFilter = fir1(firOrder,thBand/(nsr/2),'bandpass');
thetaFeeg = filtfilt(thetaFilter,1,fieldPot);
thetaSFeeg = (thetaFeeg - mean(thetaFeeg))./stdNorm; % standardize feeg
% thetaSFeeg = thetaFeeg;
thetaTransf = hilbert(thetaSFeeg); % hilbert transform to frequency domain
thetaAmp = abs(thetaTransf); % theta amplitude

% Filter in delta band:
deltaFilter = fir1(firOrder,deBand/(nsr/2),'bandpass');
deltaFeeg = filtfilt(deltaFilter,1,fieldPot);
deltaSFeeg = (deltaFeeg - mean(deltaFeeg))./stdNorm;
% deltaSFeeg = deltaFeeg;
deltaTransf = hilbert(deltaSFeeg);
deltaAmp = abs(deltaTransf);

% Theta-delta ratio
ratio_feeg = thetaAmp./(deltaAmp);
ratio_feeg(ratio_feeg>10) = 10; % replace too large values

% Smooth ratio with moving average:
wSize = nsr * tscgwindow; % window size
if length(ratio_feeg) < wSize*3 
    wSize = 100, % short data -> firOrder would be too large
end 
coeff = ones(1, wSize)/wSize;
ratio_feeg(isnan(ratio_feeg)) = 0;
ratioSFeeg = filtfilt(coeff, 1, ratio_feeg);

% Smooth theta amplitude with moving average:
maxAmp = median(thetaAmp) + mad(thetaAmp,1)*5;
thetaAmp(thetaAmp>maxAmp) = maxAmp; % replace too large values
thetaAmp(isnan(thetaAmp)) = 0;
thetaAmpS = filtfilt(coeff,1,thetaAmp);
    
if exist('isMAD','var')
    thTresh = median(thetaAmpS);% + mad(thetaAmpS,1)*0.5;
else
    thTresh = 0;
end

% Find transition points:
theta = [0 (ratioSFeeg >= thratioTresh) & (thetaAmpS > thTresh) 0]; % thresholding
% Sorting out too short delta and theta segments
[theta,ths1,ths2] = unifying_and_short_killer(theta,windowS*nsr,windowS*nsr);

if isequal(thratioTresh,deratioTresh) % practically, if there is only one threshold
    delta = theta==0;
    ddelta = diff(delta);
    des1 = find(ddelta==1);
    des2 = find(ddelta==-1);
else
    delta = [0 (ratioSFeeg < deratioTresh) 0];   % thresholding
    % Sorting out too short delta and theta segments
    [delta, des1, des2] = unifying_and_short_killer(delta,windowS*nsr,windowS*nsr);
    overlap = theta & delta;
    delta(overlap==1) = 0;  % non-overlaping theta, delta binary vectors
    theta(overlap==1) = 0;  % non-overlaping theta, delta binary vectors
end

% Plot:
timeVec = 1/nsr:1/nsr:length(fieldPot)/nsr; % time vector
xlim([timeVec(1),timeVec(end)])
standardizedField = (fieldPot - mean(fieldPot))./stdNorm; % just for visualization...
% standardizedField = fieldPot;
hold on
plot(timeVec, standardizedField, 'k')
plot(timeVec, thetaSFeeg, 'Color', [0, 0.4470, 0.7410])
plot(timeVec, deltaSFeeg, 'Color', [0.8500, 0.3250, 0.0980])
domTh = theta*thratioTresh; % just for visualization...
domTh(ths1) = NaN; % just for visualization...
domTh(ths2) = NaN; % just for visualization...
plot(timeVec, domTh,'Color',[1,0,0],'LineWidth',2)
domDe = delta*deratioTresh; % just for visualization...
domDe(des1) = NaN; % just for visualization...
domDe(des2) = NaN; % just for visualization...
% plot(timeVec, domDe,'Color',[0.6,0,0],'LineWidth',2)
plot(timeVec, ratioSFeeg,'g')
% plot(timeVec, (ratioSFeeg + ones(size(ratioSFeeg))), 'g') %shift the plot to make it visible
yLims = prctile(standardizedField,[0.1, 99.9]); %adjust y axes
if yLims(1) ~= yLims(2) & ~isnan(yLims(1))
    ylim([yLims(1),max(yLims(2),max(ratioSFeeg))]);
end
% legend('standardized field', 'st. and theta filtered field', 'st. and delta filtered field', 'theta', 'averaged ratio');
plot([timeVec(1),timeVec(1)+1],[0,0],'k','LineWidth',2) % 1 s bar
% ylim([-0.5,1.5])
plot([timeVec(1),timeVec(1)],[0,1/(stdNorm*0.000195)],'k','LineWidth',2) % 1 mV bar
xlabel('Seconds');
hold off;
end