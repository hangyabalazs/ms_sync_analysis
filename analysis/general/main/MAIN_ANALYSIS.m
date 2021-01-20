function MAIN_ANALYSIS()
%MAIN_ANALYSIS Main funxtion for analyzing electrophisiological data,
%recorded from anesthetized rats, mouse, freely moving mouse, optotagged
%mouse, and model simulations.
%   First, you need to run one of the following script (global varriable
%   and path definitions): ANA_RAT_GLOBALTABLE, ANA_MOUSE_GLOBALTABLE,
%   FREE_MOUSE_GLOBALTABLE, OPTO_GLOBALTABLE, MODEL_GLOBALTABLE.
%
%   See also ANA_RAT_GLOBALTABLE, ANA_MOUSE_GLOBALTABLE,
%   FREE_MOUSE_GLOBALTABLE, OPTO_GLOBALTABLE, MODEL_GLOBALTABLE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global PROJECTID
global MSTHBAND

%% I. Preprocess data (creation of PREPROCDIR)
create_directories(); % create analysis folders
% Ignore this section in model project (data is preprocessed by other
% routines)!!!
if ~isequal(PROJECTID,'MODEL')
    %   For clustering septal recordings: KILOSORT_CLUSTERING_WRAPPER.
    %1. Find pyramidal layer (based on histology and theta phase reversal on
    %   hippocampal linear probe, help: pyramidal_phase_change()).
    %2. Save resampled radiatum (250 um in mouse, 400 um in rat below pyramidal
    %   layer) channel (e.g.: [animalId,'_',recordingId,'_radiatum.mat'] in
    %   PREPROCDIR\animalId\recordingId directory).
    funcCallDef = 'save_hippocampal_field(animalId,recordingId,true)';
    execute_activeRecIds(funcCallDef,'rec');
    %2. Save septal field (optional):
    %     funcCallDef = 'save_septal_field(animalIdN,recordingIdN,channelId,true)';
    %     %channelId?
    %     execute_activeRecIds(funcCallDef,'rec');
    %3. Septum: after clustering (clu (clusterIDs) and res (spikeTime) files are
    %   created: help: createEventFile_shank())
    %   save unit activities (e.g.: ['TT',shankId,'_',cellId,'.mat'] in
    %   PREPROCDIR\animalId\recordingId directory).
    funcCallDef = 'generate_TS_files(animalIdN,recordingIdN,shankId,cellId)';
    execute_DATADIR(funcCallDef,'cell');
end

%4. Plot hippocampal field and septal unit activity (optional):
funcCallDef = 'hippo_field_MS_unit(animalId,recordingId,true)';
execute_activeRecIds(funcCallDef,'rec');

%% II. State detection
%   Determine delta and theta segments of hippocampal field potential,
%   compute phase angles, create figures:
funcCallDef = 'hippo_state_detection(animalId,recordingId,true)';
execute_activeRecIds(funcCallDef,'rec');

%% III. Auto correlations, rhythmicity indices
%   Calculate autocorrelations of septal cells, and compute rhythmicity, burst indices:
funcCallDef = 'cell_rhythmicity(animalId,recordingId,shankId,cellId,''issave'',true)';
execute_activeRecIds(funcCallDef,'cell');

%% IV. Poisson control process for significant rhythmicity indices
%   Start a Poisson process (Shuffle APs to create fictious data):
funcCallDef = 'create_fictious_data(animalId,recordingId,shankId,cellId,''issave'',true)';
execute_activeRecIds(funcCallDef,'cell');

%   Calculate autocorrelations of fictious cells, and compute rhythmicity indices:
funcCallDef = 'cell_rhythmicity(animalId,recordingId,shankId,cellId,''isFictious'',true,''issave'',true,''isPlot'',false)';
execute_activeRecIds(funcCallDef,'cell');
%   Build up fictCell matrix and determine significance thresholds:
compute_index_thresholds('isPlot',true);

%% V. Phase preference
%   Compute phase preference of MS cells relative to hippocampal field:
funcCallDef = 'cell_phase_preference(animalId,recordingId,shankId,cellId,''issave'',true,''isPlot'',true)';
execute_activeRecIds(funcCallDef,'cell');

%% VI. Burst properties
%   Calculate burst parameters of MS cells:
funcCallDef = 'cell_burst_parameters(animalId,recordingId,shankId,cellId,''issave'',true)';
execute_activeRecIds(funcCallDef,'cell');

%% VII. Build allCell matrix:
%   Collect all cells' features to a common matrix (allCell). Define rhythmicity
%   during theta/ delta.
build_allCell();

%% VIII. Rhythmicity groups:
%   Plot real cells' acgs with the rhIndex thresholds computed above (section
%   IV.):
plot_real_acgs_with_thresholds('theta',true); %during theta
%   During theta (plot both theta and delta index ordered):
%     plot_real_acgs_with_thresholds2('segm','theta','issave',true);
plot_real_acgs_with_thresholds('delta',true); %during delta
%   During delta (plot both theta and delta index ordered):
%     plot_real_acgs_with_thresholds2('segm','delta','issave',true);

% Generate rhythmicity groups indices:
generate_rh_groups();
% Collect rhythmicity groups in recordings:
create_cellTypes()

%Create acg, mean acg, phase preference plots for rhythmicity groups:
funcDef = 'cell_groups(rowIds,[''rhythmic_groups\'',rhGroups{it,1}]);';
execute_rhGroups(funcDef,[]);

%% IX. Pacemakers' (CTB) synchronization:
group_synchronization(get_rhGroup_indices_in_allCell('CTB'),'PACEMAKER_SYNCH',[MSTHBAND;MSTHBAND]);
% only after main_analysis run terminated on all datasets
%     plot_synchronization_theories();

%% X. Opto-tagged groups:
if isequal(PROJECTID,'OPTOTAGGING')
    % Create acg, mean acg, phase preference plots for optotagged groups:
    funcDef = 'cell_groups(rowIds(isDel==0),[''opto_groups\'',optoGroups{it}]);';
    execute_optoGroups(funcDef);
end

%% XI. Network: calculate and plot cross-correlations of rhythmicity groups
create_ccgMatrix();
%     plot_ccg_network();
end