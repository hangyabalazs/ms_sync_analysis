function [SWRfr,nonSWRfr,SWRFrInx] = cell_SWR_fr(animalId,recordingId,shankId,cellId,issave)
%CELL_SWR_FR Calculates MS units' firing rates related to Sharp-Wave-Ripple
%complexes (SWR).
%   CELL_SWR_FR(ANIMALID,RECORDINGID,SHANKID,CELLID,ISSAVE,ISPLOT)
%   For SWRs detection consult with SWR_DETECTOR. Firing rates are computed
%   during non-theta segments for both during SWRs and nonSWRs.
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 2).
%   ISSAVE: logical, save?
%   SWRFR: firing rate during SWRs.
%   NONSWRFR: firing rate outside SWRs.
%   SWRFRINX: SWR associated firing rate index.
%
%   See also MAIN_ANALYSIS, SWR_DETECTOR.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 24/07/2020

global RESULTDIR

if nargin == 0
    variable_definitions; %animalId,recordingId,shankId,cellId channelId definitions
end

%load cell activity (TS):
TS = loadTS(animalId,recordingId,shankId,cellId);

% load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'delta');
% load SWR logical vector (define SWR segments):
load(fullfile(RESULTDIR,'SWR_detection','SWR_segments',[animalId,recordingId]),'isSWR','SWRcenter');

if SWRcenter < 12 %number of detected SWRs
    nSWRspks = Inf;
    nNonSWRspks = Inf;
    SWRleng = Inf;
    nonSWRleng = Inf;
    SWRfr = Inf;
    nonSWRfr = Inf;
    SWRFrInx = Inf;
else  
    nSWRspks = sum(delta(TS)==1 & isSWR(TS)==1); % number of SWR spikes
    nNonSWRspks = sum(delta(TS)==1 & isSWR(TS)==0); % number of non-SWR spikes
    SWRleng = sum(isSWR); % total length of all SWRs during delta
    nonSWRleng = sum(isSWR==0 & delta); % total length of all nonSWRs during delta
    
    SWRfr = max(0,(nSWRspks-1)/SWRleng); % firing rate during SWRs
    nonSWRfr = max(0,(nNonSWRspks-1)/nonSWRleng); % firing rate out of SWRs
    
    SWRFrInx = (SWRfr - nonSWRfr) / max(SWRfr,nonSWRfr); % SWR associated firing rate index
end

if issave
    save(fullfile(RESULTDIR,'SWR_detection','MS_cell_SWR_firing_rates',...
        [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]),...
        'nSWRspks','nNonSWRspks','SWRleng','nonSWRleng',...
        'SWRfr','nonSWRfr','SWRFrInx');
end
end