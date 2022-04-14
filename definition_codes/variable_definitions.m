% animalId = '20180821';
% recordingId = '4';
% animalIdN = '20201120';
% recordingIdN = '19';
% recordingIdN1 = '45';
% recordingIdN2 = '67';
% shankId = '4';
% cellId = 7;
% shankIds = [1,1,1];
% cellIds = [21,79,85];
% channelId = 32;
% tWindow = [311,323]; %in 's'
% segm = 'theta';
% rowIds = [1,2];
% rowIds = get_rhGroup_indices_in_allCell('CTB');
% rowIds = get_optoGroup_indices_in_allCell('PVR',true);

% funcCallDef = 'MSTHBAND,HPTHBAND,MSDEBAND,HPDEBAND';
% funcCallDef = ['load(fullfile(RESULTDIR,''cell_features\allCell.mat''));',...
%     'load(fullfile(RESULTDIR,''cell_features\allCellMap.mat''));',...
%     'sum(allCell(:,mO(''thsumacr''))<THSUMACGTRESH)/size(allCell,1)'];
% funcCallDef = 'figure, twocycles_phaseHistogram(get_rhGroup_indices_in_allCell(''CTB''),''isPlotCos'',true), title(PROJECTID)';
% funcCallDef = 'MAIN_ANALYSIS';
% resPath = 'D:\MODEL\DATA\n20191105\1';%!
% funcCallDef = 'group_synchronization(get_rhGroup_indices_in_allCell(''CTT''),''CTT'',[MSTHBAND;MSTHBAND]);';
% funcCallDef = 'BURSTWINDOW';
% funcCallDef = 'variable_definitions2';
% funcCallDef = ['[thPoints,dePoints,nPoints,IDs] = burst_properties(get_rhGroup_indices_in_allCell(''CTB''));',...
%                 'save(fullfile(RESULTDIR,''PACEMAKER_SYNCH\intraburst_interspike_interval''),',...
%                 '''thPoints'',''dePoints'',''IDs'',''nPoints'');'];
% loadWhat = 'synchScores'; %'synchScores','allBurstnAP','allBurstFr','allBurstLe','FRs'
% sortBy = [2,5,1]; %[5,3,2],[5,1,2]
% folderNames = {'D:\OPTOTAGGING\DATA\20190911',...
%     'D:\OPTOTAGGING\DATA\20190925',...
%     'D:\OPTOTAGGING\DATA\20191014',...
%     'D:\OPTOTAGGING\DATA\20191016',...
%     'D:\OPTOTAGGING\DATA\20191018',...
%     'D:\OPTOTAGGING\DATA\20191022'};
% funcCallDef = 'parts = strsplit(allPath{it1},''\''); hippo_field_MS_unit(parts{4},parts{5},true);'
% levelId = 1;
% folderNames = {'D:\OPTOTAGGING\analysis\final_analysis\PREPROC'}; levelId = 2; 
% funcCallDef = 'mkdir(fullfile(ROOTDIR,''WAVEFORMS'',animalId,recordingId));waveforms(animalId,recordingId);';
% funcCallDef = 'plot_spk_amplitudes(animalId,recordingId);';
% funcCallDef = 'npy_waveforms(animalId,recordingId)';
% funcCallDef = 'pos = strfind(allPath{it1},''\''); id1 = regexprep(allPath{it1}(pos(5)+1:pos(6)-1),''n'',''''); id2 = regexprep(allPath{it1}(pos(6)+1:end),''n'',''''); outputId{it1} = [id1(3:end),recAlphabet{str2num(id2)}];';
% funcCallDef = 'output1(it1) = model_synch_score(animalId,recordingId);'; %general_go_trough_recordings
% funcCallDef = 'output2{it1} = model_bursts(animalId,recordingId,''Le'');'; %general_go_trough_recordings
% funcCallDef = 'files = listfiles(fullfile(PREPROCDIR,animalId,recordingId),''TT''); output2{it1} = numel(files);'; %general_go_trough_recordings
% funcCallDef = 'load(fullfile(PREPROCDIR,animalId,recordingId,[''TT'',num2str(shankId),''_'',num2str(cellId)]));load(fullfile(RESULTDIR,''theta_detection'',''theta_segments'',[animalId,recordingId]));output2{cntr,1}=animalId;output2{cntr,2}=recordingId;output2{cntr,3}=(sum(theta(TS))-1)/sum(theta)*NSR;output2{cntr,4}=(sum(delta(TS))-1)/sum(delta)*NSR;cntr=cntr+1;';
% funcCallDef = 'animalId = regexprep(animalIdN,''n'',''''); recordingId = regexprep(recordingIdN,''n'','''');load(fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,''_goodClusterIDs1.mat'']));output{cntr,1} = animalIdN;output{cntr,2} = recordingIdN;output{cntr,3} = numel(goodClusterIDs);';
% funcCallDef = 'waveFile = listfiles(fullfile(DATADIR,animalIdN,recordingIdN),''_avr_waveforms''); if ~isempty(waveFile) copyfile(fullfile(DATADIR,animalIdN,recordingIdN,waveFile{1}),fullfile(ROOTDIR,''waveforms'',waveFile{1})); end';
% funcCallDef = 'somogyi_papers';
% funcCallDef = 'pacemaker_synchronization';
% isKeep = true;
% funcCallDef = 'rhGroup_pie(rhythmGroups,grpColorMap)';
% funcCallDef = 'burst_indices_boxplot(rhythmGroups,grpColorMap)';
% funcCallDef = 'medianFRs = median_acg_frequency(get_rhGroup_indices_in_allCell(''CTT''))';
% lims = [390,430];
% load(fullfile(RESULTDIR,'synchScores.mat')); propVector = synchScores;
% groupIds  = {'CTB','CTT'};%,'CD_','DT_','NT_','NN_'};
% groupIds  = {'VGL'};
% rhythmGroups = {'CTB','CTT','CD_','DT_','NT_','NN_'};;
% grpColorMap = [[0,114,189]/255;...
%     [76,190,238]/255;...
%     [216,83,25]/255;...
%     [119,172,48]/255;...
%     [126,47,142]/255;...
%     [180,180,180]/255];
% prop = {'medBurstLeTh','thetaMA'};%{'deltaFr','thetaFr'},{'medBurstLeDe','medBurstLeTh'},{'medBurstnAPDe','medBurstnAPTh'},{'medBurstFrDe','medBurstFrTh'}
% prop = {'ThAcgThInx','thetaMRL'};
% rowInx = get_optoGroup_indices_in_allCell('VGL',0.01,true);
% rowInx = get_rhGroup_indices_in_allCell('CTB');
% rowIds = [get_rhGroup_indices_in_allCell('CTB');get_rhGroup_indices_in_allCell('CTT')];
% rowIds = find_rowIds(20100805,4,4,8);
% windowS = 6*NSR; tP = 1138*NSR; rowIds = [613,615,610,606,608,614,611,612,605,589,585,581,590,607,609];

%Example cells for EXAMPLE_CELLS_PLOT:
%Rat
% IDs = {20100616,9,2,2;20100616,9,2,4;20100616,9,3,8}; tWindow = [832,844]; acgYLims = [0,0.0014]; phaseYLims = [0,0.1]; %CD
% IDs = {20100728,3,4,5;20100728,3,4,9;20100728,3,4,10}; tWindow = [1284,1296]; acgYLims = [0,0.0006]; phaseYLims = [0,0.2]; %CTB
% IDs = {20100304,2,1,4;20100304,2,1,3;20100304,2,2,3}; tWindow = [679,691]; acgYLims = [0,0.0004]; phaseYLims = [0,0.1]; %CTT
% IDs = {20100728,4,4,10;20100728,4,4,11;20100728,4,4,13}; tWindow = [1231,1243]; acgYLims = [0,0.0006]; phaseYLims = [0,0.2]; %DT
% IDs = {20100728,9,2,7;20100728,9,4,10;20100728,9,4,7}; tWindow = [656,668]; acgYLims = [0,0.0005]; phaseYLims = [0,0.1]; %NT
%Amouse
% IDs = {201801082,1,1,21;201801082,1,1,79;201801082,1,1,85}; tWindow = [311,323]; acgYLims = [0,0.0006]; phaseYLims = [0,0.15]; %CD
% IDs = {20171208,12,1,55;20171208,12,1,69;20171208,12,1,171}; tWindow = [321,333]; acgYLims = [0,0.0004]; phaseYLims = [0,0.12]; %CTB
% IDs = {20170608,45,1,7;20170608,45,1,58;20170608,45,1,74}; tWindow = [306,318]; acgYLims = [0,0.0007]; phaseYLims = [0,0.07]; %CTT
% IDs = {201801082,1,1,5;201801082,1,1,8;201801082,1,1,122}; tWindow = [309,321]; acgYLims = [0,0.0005]; phaseYLims = [0,0.15]; %DT
% IDs = {20170608,45,1,2;20170608,45,1,25;20170608,45,1,84}; tWindow = [307,320]; acgYLims = [0,0.0006]; phaseYLims = [0,0.09]; %NT
%Fmouse
% IDs = {20161695,1824,4,3;20161695,1824,4,22;20161695,1824,4,65}; tWindow = [226,238]; acgYLims = [0,0.00055]; phaseYLims = [0,0.12]; %CTB
% IDs = {20161989,139140,3,19;20161989,139140,3,59;20161989,139140,3,66}; tWindow = [1247.9,1259.9]; acgYLims = [0,0.00045]; phaseYLims = [0,0.08]; %CTT
% IDs = {20161750,5054,2,32;20161750,5054,2,68;20161750,5054,3,65}; tWindow = [858,870]; acgYLims = [0,0.0003]; phaseYLims = [0,0.1]; %NT
%PVR: 
% IDs = {20180821,1,4,23}; tWindow = [296,308]; acgYLims = [0,0.00044]; phaseYLims = [0,0.15];
% IDs = {20180821,1,4,23;20180821,1,4,34;20180821,1,4,38}; tWindow = [280,320];
% IDs = {20180821,2,3,43;20180821,2,2,27;20180821,2,4,23}; tWindow = [280,320];%4,2; 2,42 
% IDs = {20180821,3,4,2;20180821,3,4,17;20180821,3,4,1}; tWindow = [395,435];%2,0; 4,48
%VGA:
% IDs = {20190512,5,3,34}; tWindow = [298,310]; acgYLims = [0,0.00044]; phaseYLims = [0,0.15];
% IDs = {20190512,4,1,2;20190512,4,2,42}; tWindow = [270,310];
%VGL:
% IDs = {20190510,6,4,65}; tWindow = [270,282]; acgYLims = [0,0.00044]; phaseYLims = [0,0.15];
% IDs = {20180906,8,4,16;20180906,8,4,36;20180906,8,4,39}; tWindow = [550,590];
% IDs = {20190510,7,2,64;20190510,7,4,14;20190510,7,2,15}; tWindow = [550,590];
%20190510,7,3,25;20190510,7,4,12;20190510,7,3,24
% IDs = {20180906,7,4,67;20180906,7,4,3;20180906,7,3,46}; tWindow = [550,590];
%20180906,7,4,8;20180906,7,3,59;20180906,7,4,36

% noiseBand = [4,6];
% otherBand = [0.5,1];
% combId = [1,2,5,3,4]; %organize_parameter_space_pngs()
% % shankId = 1;
% % cellId = 2;
% rhythmGroup = 'CTT';
% rhythmGroups = {'CTB'};
% rowInx = get_rhGroup_indices_in_allCell('NT_');
% prop = {'deltaFr','thetaFr'};
% optoGroup = 'VGA';
% rowInx = get_optoGroup_indices_in_allCell('VGL');
% segm = 'delta';
% % isPlotCells = false;
% issave = true;
% isPlotCos = true;
% isPlotHistogram = true;
% sourcefolderName = 'C:\Users\Barni\ONE_DRIVE\kutatas\KOKI\MS_sync\FIGURE7\rw1\parameter_space';
% targetfolderName = '';
% saveFormat = 'svg';
% funcCallDef = 'MakeStimEvents2_p(folderPaths{it1});';
% resDir = 'D:\OPTOTAGGING\KATI_cholinergic_tagged\DATADIR';
% levelId = 2;
% rootDir = 'L:\Barni\septo_hippo_project\OPTOTAGGING\analysis';
% resPath1 = 'final_analysis';
% resPath2 = 'final_analysis_2threshold';
% cellId = 'VGL01_180906b_1.59';%'PVR02_180821d_4.7';
% %
%  resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH'};
%  resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
%       'D:\MODEL\analysis\final_analysis\PACEMAKER_SYNCH'};
%  resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\OPTOTAGGING\analysis\final_analysis\PACEMAKER_SYNCH'};
%  resPaths = {'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%      'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
%       'D:\MODEL\analysis\final_analysis\PACEMAKER_SYNCH';...
%  	 'D:\OPTOTAGGING\analysis\final_analysis\PACEMAKER_SYNCH'};