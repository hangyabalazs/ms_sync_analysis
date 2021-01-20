function cell_phase_preference(animalId,recordingId,shankId,cellId,varargin)
%CELL_PHASE_PREFERENCE Calculates phase related measures of MS cells.
%   CELL_PHASE_PREFERENCE(ANIMALID,RECORDINGID,SHANKID,CELLID,ISSAVE,ISPLOT)
%   calls PHASE_PREF to calculate all phase-related statistics and 
%   histograms of a MS unit to obtain phase preference with hippocampal 
%   theta and non-theta (delta).
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 2).
%   ISSAVE: optional, logical, save?
%   ISPLOT: optional, logical, controlls if plots will be dispalyed or not
%   (deafult: true)?
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, PHASE_PREF, 
%   TWO_CYCLES_PHASEHISTOGRAM.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 24/09/2019

global RESULTDIR
global PHASEHISTEDGES

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p, 'isPlot',true,@islogical);
addParameter(p, 'issave',false,@islogical);
parse(p,varargin{:});
isPlot = p.Results.isPlot;
issave = p.Results.issave;
if nargin == 0
    variable_definitions; %animalId,recordingId,shankId,cellID,(isPlot,issave) definitions
end

% load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');
% load AP timestamps (TS)
TS = loadTS(animalId,recordingId,shankId,cellId);

thetaTS = TS(theta(TS)==1); % theta spikes
deltaTS = TS(delta(TS)==1); % delta spikes

% load hippocampal phase vectors:
load(fullfile(RESULTDIR,'theta_detection','phase_angles',[animalId, recordingId]),'thetaAng','deltaAng');

if isPlot % Initialize plot
    figure, hold on
    title(['Phase pref of: ',animalId,recordingId,', shn: ',num2str(shankId),', cell: ',num2str(cellId)]);
end

% THETA:
[thetaFTM,thetaMA,thetaMRL,thetaZ,thetaPRayleigh,thetaU,thetaPRao,thetaHistValues] = ...
    phase_pref(thetaTS,thetaAng,isPlot,PHASEHISTEDGES);

% DELTA:
[deltaFTM,deltaMA,deltaMRL,deltaZ,deltaPRayleigh,deltaU,deltaPRao,deltaHistValues] = ...
    phase_pref(deltaTS,deltaAng,isPlot,PHASEHISTEDGES);

% Separate vector data:
thetaPRao1 = thetaPRao(1); % Rao test 1st parameter during theta
thetaPRao2 = thetaPRao(2); % Rao test 2st parameter during theta
deltaPRao1 = deltaPRao(1); % Rao test 1st parameter during delta
deltaPRao2 = deltaPRao(2); % Rao test 2st parameter during delta

if issave
    save(fullfile(RESULTDIR,'MS_cell_phase_pref','phaseData',...
        [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]),...
        'thetaFTM','thetaMA','thetaMRL','thetaZ','thetaPRayleigh','thetaU','thetaPRao',...
        'deltaFTM','deltaMA','deltaMRL','deltaZ','deltaPRayleigh','deltaU','deltaPRao',...
        'thetaPRao1','thetaPRao2','deltaPRao1','deltaPRao2',...
        'thetaHistValues','deltaHistValues');
    if isPlot
        savefig(fullfile(RESULTDIR,'MS_cell_phase_pref','histograms',...
            [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]));
        close
    end
end
end