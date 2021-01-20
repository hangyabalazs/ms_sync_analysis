function cell_burst_parameters(animalId,recordingId,shankId,cellId,varargin)
%CELL_BURST_PARAMETERS Calculates burst parameters for a given cell.
%   CELL_BURST_PARAMETERS(ANIMALID,RECORDINGID,SHANKID,CELLID,ISSAVE) 
%   computes burst length, intraburst frequency, intraburst #AP for a MS 
%   unit.
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 2).
%   ISSAVE: optional, logical, save?
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, BURST_DETECTOR.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global WORKFOLDER
global BURSTWINDOW
global NSR

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p, 'issave',false,@islogical);
parse(p,varargin{:});
issave = p.Results.issave;

if nargin == 0
    variable_definitions; %animalId,recordingId,shankId,cellId,(issave) definitions
end

% Load state vectors (define theta/delta segments):
% model parameter/ variance space analysis:
if contains(WORKFOLDER,{'parameter_space','variance_space'})
    %"Expected state" (dependent on stimulation strength) vectors:
    load(fullfile(RESULTDIR,'expected_segments',[animalId, recordingId]),'theta','delta');
    trgtFolder = 'expected_segments_bursts';
else
    load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');
    trgtFolder = 'MS_cell_bursts';
end
% load AP timestamps (TS)
TS = loadTS(animalId,recordingId,shankId,cellId);

thetaTs = TS(theta(TS)==1);
deltaTs = TS(delta(TS)==1);

%% Theta
[burstWindTh,burstStartTh,burstEndTh,singleAPTh] = burst_detector(thetaTs,BURSTWINDOW(2),length(theta));
burstAPTh = thetaTs(burstWindTh(thetaTs) == 1); % burst spikes
% Single APs:
nSingleAPsTh = length(singleAPTh); % number of single APs
singleApRatioTh = nSingleAPsTh / (nSingleAPsTh + length(burstStartTh)); % single Ap ratio: nSingle/(nSingle+nBurst)
% Bursts
burstLeTh = burstEndTh - burstStartTh; % burst lengths
medBurstLeTh = median(burstLeTh); % median burst length
if isnan(medBurstLeTh)
    medBurstnAPTh = NaN;
    medBurstFrTh = NaN;
else
    edges = [burstStartTh;burstEndTh(end)+1];
    nApsTh = histcounts(burstAPTh,edges).'; % number of APs in bursts
    medBurstnAPTh = median(nApsTh); % median intrabusrt nAP
    intraBurstFrTh = (nApsTh-1)./burstLeTh; % intraburst frequency
    medBurstFrTh = median(intraBurstFrTh) * NSR; % median intraburst firing rate
end

%% Delta
[burstWindDe,burstStartDe,burstEndDe,singleAPDe] = burst_detector(deltaTs,BURSTWINDOW(2),length(delta));
burstAPDe = deltaTs(burstWindDe(deltaTs) == 1); % burst spikes
% Single APs:
nSingleAPsDe = length(singleAPDe); % number of single APs
singleApRatioDe = nSingleAPsDe / (nSingleAPsDe + length(burstStartDe)); % single Ap ratio: nSingle/(nSingle+nBurst)
% Bursts
burstLeDe = burstEndDe - burstStartDe; % burst lengths
medBurstLeDe = median(burstLeDe); % median burst length
if isnan(medBurstLeDe)
    medBurstnAPDe = NaN;
    medBurstFrDe = NaN;
else
    edges = [burstStartDe;burstEndDe(end)+1];
    nApsDe = histcounts(burstAPDe,edges).'; % number of APs
    medBurstnAPDe = median(nApsDe); % median intrabusrt nAP
    intraBurstFrDe = (nApsDe-1)./burstLeDe; % intraburst frequency
    medBurstFrDe = median(intraBurstFrDe) * NSR; % median intraburst firing rate
end

if issave
    save(fullfile(RESULTDIR,trgtFolder,...
        [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]),...
        'nSingleAPsTh','nSingleAPsDe','singleApRatioTh','singleApRatioDe',...
        'medBurstLeTh','medBurstLeDe','medBurstnAPTh','medBurstnAPDe',...
        'medBurstFrTh','medBurstFrDe');
end
end