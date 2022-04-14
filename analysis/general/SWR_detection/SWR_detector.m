function [SWRcenter,isSWR] = SWR_detector(animalIdN,recordingIdN,issave,isPyr)
%SWR_DETECTOR() Identifies sharp-wave-ripple complexes (SWR) in hippocampal
%field activity.
%   [SWRCENTER,ISSWR] = SWR_DETECTOR(ANIMALIDN,RECORDINGIDN,ISSAVE,ISPYR)
%   filters hippocampal signal to RIPPLEBAND (default: [90,200] Hz) and 
%   calculates its energy by Hilbert transforming and taking the absolute
%   value of it. SWRs are defined where this energy exceeds THRESH1
%   (mean(energy)+std(energy)*STDMULTIP1, default STDMULTIP1 = 2) for at
%   least MINLE (default: 25 ms) and at least one exceeds THRESH2
%   (mean(energy)+std(energy)*STDMULTIP2, default STDMULTIP2 = 6).
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   ISSAVE: logical, save (if exist and true)?
%   ISPYR: logical, flag, if exist and true: load pyramidal layer.
%   SWRCENTER: numeric vector, storing SWR center timepoints.
%   ISSWR: logical vector, 1 during SWR, 0 elsewhere.
%
%   See also MAIN_ANALYSIS, CELL_SWR_FR, BURST_DETECTOR.

%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/02/2019

global NSR
global RESULTDIR

% Hard coded parametersSWR filter:
firOrder = 1024; % SWR filter order
rippleBand = [90,200]; % ripple band (Hz)
rippleFilter = fir1(firOrder,rippleBand/(NSR/2),'bandpass');
stdMultip1 = 2; % std multiplier for THRESH1
stdMultip2 = 6; % std multiplier for THRESH2
minLe = 0.025 * NSR; % minimal length for exceeding THRESH1 (ms)
if ~exist('isPyr','var')
    isPyr = false;
end

% Load data:
fieldPot = loadFieldPot(animalIdN,recordingIdN,isPyr);

SWR = filtfilt(rippleFilter,1,fieldPot); % filter signal

% SWREnergy = movmax(SWRPot,0.01*NSR);
SWREnergy = abs(hilbert(SWR)).';
thresh1 = mean(SWREnergy) + std(SWREnergy) * stdMultip1
thresh2 = mean(SWREnergy) + std(SWREnergy) * stdMultip2;
isSWR1 = SWREnergy > thresh1;
isSWR2 = SWREnergy > thresh2;
isSWR = zeros(1,length(isSWR1));
diffSWR = diff([0;isSWR1;0]);
startSWR = find(diffSWR==1);
stopSWR = find(diffSWR==-1);
SWRcenter = [];
for it = 1:length(startSWR)
    % If:
    %   - at least MINLE ms long segment, larger than THRESH1 &
    %   - and crossing THRESH2 during this segment
    if (stopSWR(it)-startSWR(it) > minLe) & any(isSWR2(startSWR(it):stopSWR(it)))
        SWRcenter(end+1) = round(mean([startSWR(it),stopSWR(it)]));
        isSWR(startSWR(it):stopSWR(it)) = 1;
    end
end

% Remove short segments:
% isSWR = unifying_and_short_killer([0,isSWR,0],0.01*NSR,0.025*NSR);

timeVec = 1 / NSR : 1 / NSR : length(isSWR) / NSR;
plot(timeVec,SWREnergy)
hold on; plot(timeVec,isSWR*thresh1,'r')

if exist('issave','var') & issave
    %     savefig(fullfile(RESULTDIR,'SWR_detection',[animalId, recordingId]));
    saveas(gcf,fullfile(RESULTDIR,'SWR_detection','pngs',[animalIdN,recordingIdN,'.png']));
    close all;
    save(fullfile(RESULTDIR,'SWR_detection','SWR_segments',[animalIdN, recordingIdN]),'isSWR','SWRcenter');
end
end