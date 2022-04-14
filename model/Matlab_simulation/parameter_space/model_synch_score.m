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
actState = load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');
expState = load(fullfile(RESULTDIR,'expected_segments',[animalId,recordingId]),'theta','delta');
thRatio = sum(actState.theta(find(expState.theta))) / sum(expState.theta);
deRatio = sum(actState.delta(find(expState.delta))) / sum(expState.delta);
synchScore = mean([thRatio,deRatio]);
end