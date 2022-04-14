function visual_overlaping_clusters(animalIdN,recordingIdN1,recordingIdN2,issave)
%VISUAL_OVERLAPING_CLUSTERS Identifying same clusters from shifted
%recordings.
%   VISUAL_OVERLAPING_CLUSTERS(ANIMALIDN,RECORDINGIDN1,RECORDINGIDN2)
%   helps to identify same clusters from different recordings, shifted
%   in deepth (RECORDINGIDN1 was recorded first, RECORDINGIDN2 was next,
%   shifted) (relevant in amouse project).
%   Reads in CREATE_AVR_WAVEFORMS_MATRIX() generated average waveforms.
%   (Also contains post-modification (spliting, merging clusters -> new
%   clusters) clusters.
%   It calculates a similarity (nCLusters1 x nClusters2) matrix for the two
%   recordings. Sequentially plots all potentially common clusters's
%   waveforms and autocorrelations.
%   Parameters:
%   ANIMALIDN: string (e.g. '20170216').
%   RECORDINGIDN1: string (e.g. '45').
%   RECORDINGIDN2: string (e.g. '67') (second rec, shifted).
%   ISSAVE: optional, flag, save corresponding clusterIds?
%
%   See also CREATE_AVR_WAVEFORMS_MATRIX, SIMILARITY_MATRIX,
%   TTK_PLOT_WAVEFORM, VISUAL_MERGE_CLUSTERS, CLUSTER_LOCATION_DEPTHS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global DATADIR
global ROOTDIR
global SR
global NSR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN1, recordingIdN2 definitions
end

% Hard coded here!!!
dShift = 500; % downward shift (um)
chSep = 22.5; % channel separation (distance between adjacent channels bottoms)
nchRow = 4; % number of channels in a row
nChRowShift = round(dShift/chSep); % downshift on channel scale
nChShift = nchRow * nChRowShift;
nChComp = 16; % number of channels to compare waveforms on
minComChs = 8; % minimal number of overlaping clusters

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId1 = regexprep(recordingIdN1,'n',''); % remove n from filename begining
recordingId2 = regexprep(recordingIdN2,'n',''); % remove n from filename begining

%% Load spikes
% spike times of the 2 recordings:
sT1 = readNPY(fullfile(DATADIR,animalIdN,recordingIdN1,'spike_times.npy'));
sT2 = readNPY(fullfile(DATADIR,animalIdN,recordingIdN2,'spike_times.npy'));
% spike Ids of the 2 recordings:
clu1 = readNPY(fullfile(DATADIR,animalIdN,recordingIdN1,'spike_clusters.npy'));
clu2 = readNPY(fullfile(DATADIR,animalIdN,recordingIdN2,'spike_clusters.npy'));

%% Load waveforms:
% Load waveform (nCLusters x nChannels x windowSize) template matrix for
% recording1:
% load(fullfile(DATADIR,animalIdN,recordingIdN1,[animalId,recordingId1,'_avr_waveforms.mat']));
load(fullfile(ROOTDIR,'WAVEFORMS',animalIdN,recordingIdN1,[animalId,recordingId1,'_avr_waveforms.mat']));
templates1 = allAvgWaveforms; clear allAvgWaveforms;
[cids1, cgs1] = readClusterGroupsCSV(fullfile(DATADIR,animalIdN,recordingIdN1,'cluster_groups.csv'));
goodClus1 = cids1(cgs1 == 2);%identified as 'good'
% Load waveform (nCLusters x nChannels x windowSize) template matrix for
% recording2:
% load(fullfile(DATADIR,animalIdN,recordingIdN2,[animalId,recordingId2,'_avr_waveforms.mat']));
load(fullfile(ROOTDIR,'WAVEFORMS',animalIdN,recordingIdN2,[animalId,recordingId2,'_avr_waveforms.mat']));
templates2 = allAvgWaveforms; clear allAvgWaveforms;
[cids2, cgs2] = readClusterGroupsCSV(fullfile(DATADIR,animalIdN,recordingIdN2,'cluster_groups.csv'));
goodClus2 = cids2(cgs2 == 2); % identified as 'good'

%% Calculate similarity scores between clusters:
similarity = similarity_matrix(templates1,nChComp,minComChs,templates2,nChShift);
% Find potentially same clusters (similarity>0):
[rowInx, colInx] = find(similarity ~= 0);
% figure; imagesc(similarity)
% text(colInx-0.5, rowInx+0.3, num2str(goodClus2(colInx).'))
% text(colInx-0.5, rowInx-0.3, num2str(goodClus1(rowInx).'))
% title([animalId, ': ', recordingId1, ' ', recordingId2])
% close all;

%% Plot all potential pairs
sameClus = []; % allocate vector for same clusters
c = 1;
% figurePos = [0, 0; 0, 1; 0, 2; 1, 0; 1, 1; 1, 2; 2, 0; 2, 1; 2, 2; 3, 0; 3, 1; 3, 1; 4, 0; 4, 1; 4, 2; 5, 0; 5, 1; 5, 2];
figurePos = [0, 0; 1, 0; 2, 0; 3, 0; 4, 0; 5, 0; 0, 1; 1, 1; 2, 1; 3, 1; 4, 1; 5, 1; 0, 2; 1, 2; 2, 2; 3, 2; 4, 2; 5, 2; 0, 3; 1, 3; 2, 3; 3, 3; 4, 3; 5, 3];
clusterAdv = diff(colInx);
for it1 = 1:length(colInx) % go trough each potential pairs
    %     figure('Position',[50+figurePos(c, 1)*370,50+figurePos(c, 2)*280,360,270])
    figure('Position',[50+figurePos(c, 1)*250,50+figurePos(c, 2)*230,290,220])
    % Cluster 2:
    subplot(54,2,[45:2:107])
    TTK_plot_waveform(squeeze(templates2(colInx(it1), :, :)).'); % plot average waveform
    % Adjust colormap:
    maxLim = max(reshape([squeeze(templates1(rowInx(it1),:,:)),...
        squeeze(templates2(colInx(it1),:,:))],1,[]));
    set(gca,'clim',[0,maxLim]);
    % Calculate autocorrelation:
    subplot(54,2,[1:2:43])
    ST2act = sT2(clu2==goodClus2(colInx(it1)))/(SR/NSR);
    correlation(ST2act,ST2act,true);
    title([num2str(goodClus2(colInx(it1))),', score: ',num2str(similarity(rowInx(it1),colInx(it1))*10^9)]);
    
    % Cluster 1:
    subplot(54,2,[2:2:64])
    TTK_plot_waveform(squeeze(templates1(rowInx(it1),:,:)).'); % plot average waveform
    % Adjust colormap:
    set(gca,'clim',[0, maxLim]);
%     if rowInx(it1)>numel(goodClus1)
%         continue
%     end
    title(num2str(goodClus1(rowInx(it1))));
    
    % Calculate autocorrelation:
    subplot(54, 2, [66:2:108])
    ST1act = sT1(clu1==goodClus1(rowInx(it1)))/(SR/NSR);
    correlation(ST1act,ST1act,true);
    
    c = c + 1;
    if c >20 'out from screen';  end
    if clusterAdv(it1)>0 % jump to next potential cluster-pair group
        c
        close all; % place a breakpoint here to see similar clusters
        c = 1;
    end
    %For storing pairIds:
    if exist('issave','var')
        prompt = 'Press 1 if same, 0 if not: ';
        issame = input(prompt);
        if issame
            sameClus = [sameClus; goodClus1(rowInx(it1)), goodClus2(colInx(it1))];
        end
    end
end
% Save results (create folder before):
if exist('issave','var')
    save(fullfile(ROOTDIR,'OVERLAPING','same_clusters',...
        [animalId,'_',recordingId1,'_',recordingId2,'_same.mat'],'sameClus'));
end
end