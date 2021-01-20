function visual_merge_clusters(animalIdN,recordingIdN,issave)
%VISUAL_MERGE_CLUSTERS Identifying same clusters from same recordings.
%   VISUAL_MERGE_CLUSTERS(ANIMALIDN,RECORDINGIDN) reads in
%   CREATE_AVR_WAVEFORMS_MATRIX() generated average waveforms.
%   (Also contains post-modification (spliting, merging clusters -> new
%   clusters) clusters.
%   It calculates a similarity (nCLusters x nClusters) matrix.
%   Sequentially plots all potentially common clusters's
%   waveforms and autocorrelations.
%   Parameters:
%   ANIMALIDN: string (e.g. '20170216').
%   RECORDINGIDN: string (e.g. '45').
%   ISSAVE: optional, flag, save corresponding clusterIds?
%
%   See also CREATE_AVR_WAVEFORMS_MATRIX, SIMILARITY_MATRIX,
%   TTK_PLOT_WAVEFORM, VISUAL_OVERLAPING_CLUSTERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global ROOTDIR
global DATADIR
global SR
global NSR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN, definitions
end

% Hard coded here!!!
nChComp = 10; % number of channels to compare waveforms on
minComChs = 7; % minimal number of overlaping clusters

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

%% Load spikes
sT = readNPY(fullfile(DATADIR,animalId,recordingId,'spike_times.npy'));% spike times
clu = readNPY(fullfile(DATADIR,animalId,recordingId,'spike_clusters.npy')); % spike Ids

%% Load waveforms:
% Load waveform (nCLusters x nChannels x windowSize) template matrix::
load(fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,'_avr_waveforms.mat']));
templates = allAvgWaveforms;
[cids,cgs] = readClusterGroupsCSV(fullfile(DATADIR,animalIdN,recordingIdN,'cluster_groups.csv'));
goodClus = cids(cgs==2); % identified as 'good'

%% Calculate similarity scores between clusters:
similarity = similarity_matrix(templates,nChComp,minComChs);
similarity = triu(similarity,1); %keep upper triangle matrix
% Find potentially same clusters (similarity>0):
% [rowInx, colInx] = find(similarity ~= 0);
% figure; imagesc(similarity)
% text(colInx-0.5, rowInx+0.3, num2str(goodClus(colInx).'))
% text(colInx-0.5, rowInx-0.3, num2str(goodClus(rowInx).'))
% title([animalId, ': ',recordingId,' ',recordingId])
close all;

%% Plot all potential pairs
sameClus = []; % allocate vector for same clusters
c = 1;
% figurePos = [0, 0; 0, 1; 0, 2; 1, 0; 1, 1; 1, 2; 2, 0; 2, 1; 2, 2; 3, 0; 3, 1; 3, 1; 4, 0; 4, 1; 4, 2; 5, 0; 5, 1; 5, 2];
figurePos = [0, 0; 1, 0; 2, 0; 3, 0; 4, 0; 0, 1; 1, 1; 2, 1; 3, 1; 4, 1; 0, 2; 1, 2; 2, 2; 3, 2; 4, 2; 0, 3; 1, 3; 2, 3; 3, 3; 4, 3];
clusterAdv = diff(colInx);
for it1 = 1:length(colInx)
    figure('Position',[50+figurePos(c, 1)*370,50+figurePos(c, 2)*280,360,270])
    % Cluster 2:
    subplot(54,2,[1:2:63])
    TTK_plot_waveform(squeeze(templates(colInx(it1), :, :)).');
    title([num2str(goodClus(colInx(it1))), ', score: ', num2str(similarity(rowInx(it1), colInx(it1))*10^9)]);
    % Adjust colormap:
    maxLim = max(reshape([squeeze(templates(rowInx(it1), :, :)),...
        squeeze(templates(colInx(it1), :, :))],1, []));
    set(gca,'clim',[0,maxLim]);
    % Calculate autocorrelation:
    subplot(54,2,[65:2:107])
    ST1act = sT(clu==goodClus(colInx(it1)))/(SR/NSR);
    correlation(ST1act,ST1act);
    
    % Cluster 1:
    subplot(54,2,[2:2:64])
    TTK_plot_waveform(squeeze(templates(rowInx(it1), :, :)).');
    set(gca,'clim',[0, maxLim]);
    title(num2str(goodClus(rowInx(it1))));
    % autocorrelation:
    subplot(54,2,[66:2:108])
    ST2act = sT(clu==goodClus(rowInx(it1)))/(SR/NSR);
    correlation(ST2act,ST2act);
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
    save(fullfile(ROOTDIR,'MERGE_CLUSTERS','same_clusters',...
        [animalId,'_',recordingId1,'_',recordingId2,'_same.mat'],'sameClus'));
end
end