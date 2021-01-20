function create_fictious_data(animalId,recordingId,shankId,cellId,varargin)
%CREATE_FICTIOUS_DATA Creates random rhythmicity data from real data.
%   CREATE_FICTIOUS_DATA(ANIMALID,RECORDINGID,SHANKID,CELLID,ISSAVE) 
%   shuffles action potentials of a given real cell, and saves the new, 
%   randomly distributed, fictious AP times.
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 2).
%   ISSAVE: optional, logical, save?
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, CELL_RHYTHIMICITY, 
%   CORRELATION, THETAINDEX, DELTAINDEX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 24/09/2019

global ROOTDIR
global RESULTDIR
global PROJECTID
global PREPROCDIR

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p, 'issave',false,@islogical);
parse(p,varargin{:});

issave = p.Results.issave;

if nargin == 0
    eval([PROJECTID,'_variables']); %animalId, recordingId, shankId, cellId (issave) definitions
end

% Load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');

% Load AP timestamps (TS)
TS = loadTS(animalId,recordingId,shankId,cellId);

% Segment data:
thetaTS = TS(theta(TS)==1); % spikes during theta
deltaTS = TS(delta(TS)==1); % spikes during delta
nApTheta = length(thetaTS); % number of action potentials during theta
nApDelta = length(deltaTS); % number of action potentials during theta

% Create frequency-matched Poisson process:
poissonTSTheta = randpoisson(nApTheta,sum(theta));
thetaActPattern = zeros(sum(theta),1);
thetaActPattern(poissonTSTheta) = 1;
poissonTSDelta = randpoisson(nApDelta,sum(delta));
deltaActPattern = zeros(sum(delta),1);
deltaActPattern(poissonTSDelta) = 1;

if issave
    save(fullfile(fullfile(RESULTDIR,'FICTIOUS_DATA',animalId,recordingId),...
        [num2str(shankId),'_',num2str(cellId),'.mat']),...
        'thetaActPattern','deltaActPattern');
end

end