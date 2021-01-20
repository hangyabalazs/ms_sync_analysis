function [nSpikes,burstLe] = merge_bursts(TS,maxBurstL)
%MERGE_BURSTS Merge burst spikes.
%   [NSPIKES,BURSTLE] = MERGE_BURSTS(TS,MAXBURSTL) returns 
%   #intraburst-spikes (NSPIKES) and burst lengths (BURSTLE) for all bursts.
%   Parameters:
%   TS: #APx1 vector, specifying timepoints of spikes (units: ms).
%   MAXBURSTL: maximal burst length (in ms (if NSR = 1000)).
%   NSPIKES: vector, number of spikes in the bursts.
%   BURSTLE: vector, burstlengths in NSR (1 ms if NSR = 1000).
%
%   See also BURST_PROPERTIES, PACEMAKER_SYNCHRONIZATION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

% Allocate
nSpikes = ones(numel(TS),1);
burstLe = ones(numel(TS),1);
cnt = 1; 
for it2 = 2:length(TS)
    apDiff = TS(it2) - TS(it2-1); % subsequent ISI
    if apDiff < maxBurstL % if actual and next spike is in a common burst
        nSpikes(cnt) = nSpikes(cnt) + 1;
        burstLe(cnt) = burstLe(cnt) + apDiff;
    else % if actual and next spike is not in a common burst
        cnt = cnt + 1;
    end
end

% Delete remaining part:
nSpikes(cnt+1:end) = [];
burstLe(cnt+1:end) = [];
end