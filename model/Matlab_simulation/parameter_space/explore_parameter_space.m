function explore_parameter_space()
%EXPLORE_PARAMETER_SPACE Calculates synchronization scores and other
%related results for parameter/ variance space analysis.
%   EXPLORE_PARAMETER_SPACE is the main function assessing parameter space
%   simulations (executed previuosly by SIMULATE_PARAMETER_SPACE).
%   First, it runs necessary parts of general MAIN_ANALYSIS (network activity
%   plot titled with actual parameters: HIPPO_FIELD_MS_UNIT (call 
%   ORGANIZE_PARAMETER_SPACE_PNGS for visual exploration), state detection: 
%   HIPPO_STATE_DETECTION, burst parameters: CELL_BURST_PARAMETERS). Second,
%   it calculates synchronization scores (simulation time ratio the network
%   spent in the "expected state": theta during stronger, delta during weaker
%   stimulation). Third, intraburst firing rates are compared between 
%   expected states.
%
%   See also SIMULATE_PARAMETER_SPACE, CELL_BURST_PARAMETERS, 
%   MODEL_SYNCH_SCORE, COLLECT_PROPERTIES, MAIN_ANALYSIS, 
%   ORGANIZE_PARAMETER_SPACE_PNGS, HIPPO_FIELD_MS_UNIT, 
%   HIPPO_STATE_DETECTION, CELL_BURST_PARAMETERS, MODEL_GLOBALTABLE_PAR,
%   MODEL_GLOBALTABLE_VAR.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 08/10/2020

global RESULTDIR
global WORKFOLDER

% Column sorting vector definitions for parameter space plots:
if contains(WORKFOLDER,'parameter_space')  % parameter space (delays, stimVar fixed)
    sortBy = [1,7,2];
elseif contains(WORKFOLDER,'delay_space')  % delays space (connRate, stimVar fixed)
    sortBy = [2,1,6];
elseif contains(WORKFOLDER,'variance_space') % variance space (connRate, delays fixed)
    sortBy = [2,1,4];
end

%% Analysis:
create_directories();
% Run necessary parts of MAIN_ANALYSIS (I/4.,II.,VI.):
%I/4.: Plot hippocampal field and septal unit activity:
    funcCallDef = 'hippo_field_MS_unit(animalId,recordingId,true)';
    execute_activeRecIds(funcCallDef,'rec');

%II.: Determine delta and theta segments of hippocampal field potential,
%   compute phase angles, create figures:
    funcCallDef = 'hippo_state_detection(animalId,recordingId,true)';
    execute_activeRecIds(funcCallDef,'rec');
    
%VI.: Calculate burst parameters of MS cells:
    funcCallDef = 'cell_burst_parameters(animalId,recordingId,shankId,cellId,''issave'',true)';
    execute_activeRecIds(funcCallDef,'cell');
    
%% Synchronization scores:
% Calculate synchronization scores for each recording (parameter arrangements):
mkdir(fullfile(RESULTDIR,'synch_scores'));
funcCallDef = ['synchScore = model_synch_score(animalId,recordingId);',...
    'save(fullfile(RESULTDIR,''synch_scores'',[animalId,recordingId]),''synchScore'')'];
execute_activeRecIds(funcCallDef,'rec');
% Collect synchronization scores to common matrix:
[synchScores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'},true);
% Plot synchronization scores:
parameter_space_plot(sortBy,synchScores,Ids);

%% Antiphase synchronization scores:
% Calculate anti-phase synchronization scores for each recording (parameter arrangements):
mkdir(fullfile(RESULTDIR,'antiphase_scores'));
funcCallDef = ['maxlag = 0.3*NSR; maxFr = 6; toI = [6,15]*NSR;',...
    '[~,h] = ccg_peakLag_offset(animalId,recordingId,maxlag,maxFr,toI);',...
    'aphScore = [h(1),h(4)];',...
    'save(fullfile(RESULTDIR,''antiphase_scores'',[animalId,recordingId]),''aphScore'')'];
execute_activeRecIds(funcCallDef,'rec');
% Collect synchronization scores to common matrix:
[aphScores,Ids] = collect_properties(fullfile(RESULTDIR,'antiphase_scores'),'rec',{'aphScore'},true);
% Plot antiphase-synchronization scores:
parameter_space_plot(sortBy,aphScores,Ids);

%% Intraburst firing rates (iBFR) during "expected segments":
% Collect median iBFRs to common matrix:
[burstFR,Ids] = collect_properties(fullfile(RESULTDIR,'expected_segments_bursts'),...
    'cell',{'medBurstFrTh','medBurstFrDe'},true);
% Plot iBFRs:
parameter_space_plot(sortBy,burstFR,Ids)
end