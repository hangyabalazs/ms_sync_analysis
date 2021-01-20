function ms_textual_details()

%% Results
% Number of cells
funcCallDef = ['load(fullfile(RESULTDIR,''cell_features\allCell.mat''));'...
    'load(fullfile(RESULTDIR,''cell_features\allCellMap.mat''));'...
    '[size(allCell,1),numel(unique(allCell(:,mO(''animalId'')))),'...
    'sum(allCell(:,mO(''thsumacr''))>THSUMACGTRESH & allCell(:,mO(''desumacr''))>DESUMACGTRESH),'...
    'sum(allCell(:,mO(''thsumacr''))>THSUMACGTRESH | allCell(:,mO(''desumacr''))>DESUMACGTRESH)]'];
save('funcCallDef.mat','funcCallDef')
execute_datasets();

% Number of pacemakers
funcCallDef = 'numel(get_rhGroup_indices_in_allCell(''CTB'')),';
save('funcCallDef.mat','funcCallDef')
execute_datasets();

% Number of theta-skipping
funcCallDef = 'numel(get_rhGroup_indices_in_allCell(''CD_'')),';
save('funcCallDef.mat','funcCallDef')
execute_datasets();

% Tonic theta neurons (numbers, rhythmicity frequencies)
funcCallDef = ['load(fullfile(RESULTDIR,''cell_features\allCell.mat''));',...
    'load(fullfile(RESULTDIR,''cell_features\allCellMap.mat''));',...
    'rowIds = get_rhGroup_indices_in_allCell(''CTT'');',...
    'thFr = rhythmicity_frequencies(rowIds,[MSTHBAND;MSDEBAND]);',...
    'try semed = se_of_median(NSR./thFr); catch semed = NaN; end;',...
    '[median(NSR./thFr), semed, numel(rowIds),',...
    'sum(allCell(rowIds,mO(''thetaFr'')) < allCell(rowIds,mO(''deltaFr'')))]'];
save('funcCallDef.mat','funcCallDef')
execute_datasets();

% Co recorded neurons 
funcCallDef = ['load(fullfile(RESULTDIR,''network\ccgMatrixIds.mat''));',...
    'sum(sum(cellfun(@numel,ccgMatrixIds)))/2'];
save('funcCallDef.mat','funcCallDef')
execute_datasets();

% Glutamatergic-theta rhythmic neurons 
OPTO_GLOBALTABLE
VGLs = get_optoGroup_indices_in_allCell('VGL');
[thFr,deFr] = firing_rates(VGLs);
[median(thFr./deFr),se_of_median(thFr./deFr);]
load(fullfile(RESULTDIR,'cell_features\allCell.mat'));
load(fullfile(RESULTDIR,'cell_features\allCellMap.mat'));
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity\thresholds\indexTresholds'));
sum(allCell(VGLs,mO('ThAcgThInx'))/thetaThInxtrsh > max(allCell(VGLs,mO('ThAcgDeInx'))/thetaDeInxtrsh,1) & ...
allCell(VGLs,mO('DeAcgThInx'))/deltaThInxtrsh > max(allCell(VGLs,mO('DeAcgDeInx'))/deltaDeInxtrsh,1))
% Or:
CTBs = get_rhGroup_indices_in_allCell('CTB');
sum(ismember(VGLs,CTBs))

%% Methods
% opto tagged neurons :
OPTO_GLOBALTABLE
load(fullfile(RESULTDIR,'cell_features\allCell.mat'));
load(fullfile(RESULTDIR,'cell_features\allCellMap.mat'));
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity\thresholds\indexTresholds'));
PVRs = get_optoGroup_indices_in_allCell('PVR');
animals = unique(allCell(PVRs,mO('animalId')));
t = [numel(animals)];
for it = 1:numel(animals)
    t = [t, sum(ismember(PVRs,find(allCell(:,mO('animalId')) == animals(it))))];
end
t
VGAs = get_optoGroup_indices_in_allCell('VGA');
animals = unique(allCell(VGAs,mO('animalId')));
t = [numel(animals)];
for it = 1:numel(animals)
    t = [t, sum(ismember(VGAs,find(allCell(:,mO('animalId')) == animals(it))))];
end
t
VGLs = get_optoGroup_indices_in_allCell('VGL');
animals = unique(allCell(VGLs,mO('animalId')));
t = [numel(animals)];
for it = 1:numel(animals)
    t = [t, sum(ismember(VGLs,find(allCell(:,mO('animalId')) == animals(it))))];
end
t

% State detection: Frequency bands, amplitude ratio threshold, window sizes
funcCallDef = ['[HPTHBAND,HPDEBAND,THRATIOTHRESH,DERATIOTHRESH,TSCCGSMWINDOW]'];
save('funcCallDef.mat','funcCallDef')
execute_datasets();
OPTO_GLOBALTABLE
load(fullfile(PREPROCDIR,'20181011\2\20181011_2_specific_parameters.mat'))
[hpthband,hpdeband,thratiothresh,deratiothresh,tsccgsmwindow]
load(fullfile(PREPROCDIR,'20190526\1\20190526_1_specific_parameters.mat'))
same: load(fullfile(PREPROCDIR,'20190526\2\20190526_2_specific_parameters.mat'))
[hpthband,hpdeband,thratiothresh,deratiothresh,tsccgsmwindow]
load(fullfile(PREPROCDIR,'20191022\2\20191022_2_specific_parameters.mat'))
same: load(fullfile(PREPROCDIR,'20191022\3\20191022_3_specific_parameters.mat'))
[hpthband,hpdeband,thratiothresh,deratiothresh,tsccgsmwindow]
% Number of truncated optotagging experiments:
OPTO_GLOBALTABLE
numel(dir(fullfile(ROOTDIR,'TRUNCATE')))-3

% Burst window lengths
funcCallDef = 'BURSTWINDOW';
save('funcCallDef.mat','funcCallDef')
execute_datasets();

% State detection: Frequency bands, amplitude ratio threshold, window sizes
MODEL_GLOBALTABLE
[HPTHBAND,HPDEBAND,THRATIOTHRESH,DERATIOTHRESH,TSCCGSMWINDOW]

% Burst window lengths
MODEL_GLOBALTABLE
BURSTWINDOW

%% Firing rate boxplot statistics
funcCallDef = 'execute_rhGroups(''[thFr,deFr] = firing_rates(rowIds); try signrank(thFr,deFr), catch [], end;'',[])';
save('funcCallDef.mat','funcCallDef')
execute_datasets();

delete('funcCallDef.mat')
end