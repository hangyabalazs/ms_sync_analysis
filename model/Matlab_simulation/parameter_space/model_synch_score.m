function synchScore = model_synch_score(animalId,recordingId)
%MODEL_SYNCH_SCORE Calculates sycnhronization score for a given simulation.
%   SYNCHSCORE = MODEL_SYNCH_SCORE(ANIMALID,RECORDINGID) calculates a 
%   simple synchronization score, quantifying the ratio of time, when the 
%   network was in the expected state (theta during stronger theta 
%   stimulation, delta during weaker delta).
%   Requires HIPPO_STATE_DETECTION to run first and also expected state
%   vectors to be created (default: both are created by CONVERT_MODEL_OUTPUT)!!!
%
%   See also SIMULATE_PARAMETER_SPACE, EXPLORE_PARAMETER_SPACE, 
%   GENERATE_AND_SIMULATE_MODEL, CONVERT_MODEL_OUTPUT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 25/09/2020

global RESULTDIR
global DATADIR

if nargin == 0
    variable_definitions(); %animalId, recordingId definitions
end

% Load state vectors:
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');
load(fullfile(DATADIR,animalId,'basic_network_parameters.mat'),'segmLength');
thetaStim = [segmLength(1)+1,segmLength(1)+segmLength(2)]; % theta stimulation
deltaStim2 = [segmLength(1)+segmLength(2)+1,sum(segmLength)]; % delta stimulation

% Time ratio spent in the given state:
thRatio = sum(theta(thetaStim(1):thetaStim(2)))/diff(thetaStim);
deRatio = sum(delta(deltaStim2(1):deltaStim2(2)))/diff(deltaStim2);

% Mean of the two ratios:
synchScore = mean([thRatio,deRatio]);
end