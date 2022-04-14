function beta_theta_ratio(animalId,recordingId)
%BETA_THETA_RATIO designed to demonstrate antiphasic in model simulations.
%   BETA_THETA_RATIO calculates the theta vs. double-theta (beta) frequency
%   band power ratio during the whole simulation\recording and plots it.
%   Parameters:
%   ANIMALIDN: string (e.g. '202106259').
%   RECORDINGID: string (e.g. '20').
%
%   See also CCG_PEAKLAG_OFFSET, EXPLORE_PARAMETER_SPACE, 
%   SIMULATE_PARAMETER_SPACE, CCG_VARIANCE_CHANGE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 13/04/2022

global DATADIR
global RESULTDIR
global NSR
global HPTHBAND

fieldPot = loadFieldPot(animalId,recordingId);

% Parameter definitions:
betaBand = HPTHBAND * 2; % beta frequency band
stdNorm = std(fieldPot); % for standardization
firOrder = 1024; % filter order
if length(fieldPot) < firOrder * 3
    firOrder = 64; % short data -> firOrder would be too large
end 

% Filter in theta band
thetaFilter = fir1(firOrder,HPTHBAND/(NSR/2),'bandpass');
thetaFeeg = filtfilt(thetaFilter,1,fieldPot);
thetaSFeeg = (thetaFeeg - mean(thetaFeeg))./stdNorm; % standardize feeg
thetaTransf = hilbert(thetaSFeeg); % hilbert transform to frequency domain
thetaAmp = abs(thetaTransf); % theta amplitude
% Filter in beta band (double frequency)
betaFilter = fir1(firOrder,betaBand/(NSR/2),'bandpass');
betaFeeg = filtfilt(betaFilter,1,fieldPot);
betaSFeeg = (betaFeeg - mean(betaFeeg))./stdNorm; % standardize feeg
betaTransf = hilbert(betaSFeeg); % hilbert transform to frequency domain
betaAmp = abs(betaTransf); % theta amplitude

% Theta-delta ratio
ratio_feeg = betaAmp./(thetaAmp);
ratio_feeg(ratio_feeg>3) = 3; % replace too large values

% Plot:
timeVec = 1/NSR:1/NSR:length(fieldPot)/NSR; % time vector
xlim([timeVec(1),timeVec(end)])
standardizedField = (fieldPot - mean(fieldPot))./stdNorm; % just for visualization...
hold on
plot(timeVec, standardizedField, 'k')
plot(timeVec, thetaSFeeg, 'Color',[0, 0.4470, 0.7410])
plot(timeVec, betaSFeeg, 'Color',[0.4660, 0.6740, 0.1880])
plot(timeVec, ratio_feeg,'g')
xlabel('Seconds');
hold off;

title(cellstr(num2str(convert_model_ID_parameter(recordingId))))
end