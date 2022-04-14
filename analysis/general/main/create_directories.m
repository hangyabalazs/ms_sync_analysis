function create_directories()
%CREATE_DIRECTORIES creates all neccessary folders for MAIN_ANALYSIS.
%
%   See also MAIN_ANALYSIS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 27\08\2020

global RESULTDIR
global PROJECTID
global WORKFOLDER

% For preprocessed data:
execute_activeRecIds('mkdir(fullfile(PREPROCDIR,animalId,recordingId));','rec');
mkdir(fullfile(RESULTDIR,'field_and_unit'));
% For hippocampal state detection:
mkdir(fullfile(RESULTDIR,'theta_detection','figures'));
mkdir(fullfile(RESULTDIR,'theta_detection','pngs'));
mkdir(fullfile(RESULTDIR,'theta_detection','theta_segments'));
mkdir(fullfile(RESULTDIR,'theta_detection','phase_angles'));
% For auto-correlations:
mkdir(fullfile(RESULTDIR,'MS_cell_rhythmicity','figures')); %create folder
mkdir(fullfile(RESULTDIR,'MS_cell_rhythmicity','acgs')); %create folder
% For MS rhythmicity control process (Poisson):
mkdir(fullfile(RESULTDIR,'FICTIOUS_DATA'));
execute_activeRecIds('mkdir(fullfile(RESULTDIR,''FICTIOUS_DATA'',animalId,recordingId))','rec');
mkdir(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','figures'));
mkdir(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','acgs'));
mkdir(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds'));
% For MS phase preferences:
mkdir(fullfile(RESULTDIR,'MS_cell_phase_pref','phaseData'));
mkdir(fullfile(RESULTDIR,'MS_cell_phase_pref','histograms'));
% For MS burst properties:
if isequal(PROJECTID,'MODEL') & contains(WORKFOLDER,{'parameter_space','variance_space'})
    mkdir(fullfile(RESULTDIR,'expected_segments_bursts'));
end
mkdir(fullfile(RESULTDIR,'MS_cell_bursts'));
% For SWR analysis:
mkdir(fullfile(RESULTDIR,'SWR_detection','pngs'));
mkdir(fullfile(RESULTDIR,'SWR_detection','SWR_segments'));
mkdir(fullfile(RESULTDIR,'SWR_detection','MS_cell_SWR_firing_rates'));
% For saving allCell matrix:
mkdir(fullfile(RESULTDIR,'cell_features'));
% For rhythmicity groups:
rhGroups = {'CTB','CTT','CD_','TD_','DT_','AT_','AD_','TA_','DA_',...
    'AA_','AN_','NA_','NT_','ND_','TN_','DN_','NN_'};
cellfun(@(x) mkdir(fullfile(RESULTDIR,'rhythmic_groups',x)),rhGroups);
% For pacemaker (CTB) synchronization:
mkdir(fullfile(RESULTDIR,'PACEMAKER_SYNCH'));
% For opto groups:
if isequal(PROJECTID,'OPTOTAGGING')
    optoGroups = {'CHT','PVR','VGA','VGL'};
    cellfun(@(x) mkdir(fullfile(RESULTDIR,'opto_groups',x)),optoGroups);
    cellfun(@(x) mkdir(fullfile(RESULTDIR,'opto_cells',x)),optoGroups);
end
% For network of rhGroups (cross-correlations):
mkdir(fullfile(RESULTDIR,'network','3000')); %3000 ms window
mkdir(fullfile(RESULTDIR,'network','50')); %50 ms window
end