function createEventFile_shank(animalIdN,recordingIdN)
%CREATEEVENTFILE_SHANK Creates .res and .clu files from Kilosort output.
%   CREATEEVENTFILE_SHANK(ANIMALIDN,RECORDINGIDN) creates .res (spike time
%   in SR) and .clu (cluster ID) files from kilosort outputs (automatically
%   sorted, than manually validated experimental data), a pair (res-clu, 
%   rows are corresponding) for each shanks.
%   The sophisticated part of the code is neccesary, because Kilosort 
%   doesn't create average waveform template files for clusters created by 
%   splitting, merging manually.
%   This code is Kilosort clustered datasets: for amouse (only 1 shank),
%   fmouse and optotagging (mainly 4 shanks); and NOT for rat (data was 
%   originally provided in this format) and model (Use CONVERT_MODEL_OUTPUT
%   instead).
%   Parameters:
%   ANIMALIDN: string (e.g. '20170608').
%   RECORDINGIDN: string (e.g. '45').
%
%   See also SORT_CHANNELS_ENERGY, GENERATE_TS_FILES.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global DATADIR
global PROJECTID

if nargin == 0
    variable_definitions(); %animalIdN,recordingIdN definitions
end

% HARD CODED HERE!
numCh = 5; % number of channels to search biggest waveforms on (fmouse and opto projects)
nShanks = 4; % number of shanks (fmouse and opto projects)!!
chPerShnk = 8; %4 shank, 32 channel Buzsaki probe (fmouse and opto projects)!!

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

dataDir = fullfile(DATADIR,animalIdN,recordingIdN);

spike_clusters = readNPY(fullfile(dataDir,'spike_clusters.npy')); % load all clusterIds
spike_times = readNPY(fullfile(dataDir,'spike_times.npy')); % load all spike times

%% Extract 'good' cluster IDs:
if exist(fullfile(dataDir,'cluster_groups.csv'),'file')
    fid = fopen(fullfile(dataDir,'cluster_groups.csv'));
    clusterIDs = textscan(fid, '%d %s', 'Delimiter', '\t', 'HeaderLines', 1);
    goodInd = find(cellfun(@(x) strcmp(x,'good'),clusterIDs{2}));
    goodCluIds = clusterIDs{1}(goodInd);
else
    clusterIDs = tdfread(fullfile(dataDir,'cluster_group.tsv'));
    goodCluIds = clusterIDs.cluster_id(find(ismember(clusterIDs.group,'good','rows')));
end
% Save 'good' clusterIds:
save(fullfile(dataDir,[animalId,recordingId,'_goodClusterIDs.mat']),'goodCluIds');

% Allocate (In the case of amouse there is only 1 shank. Fmouse and opto
% recordings were (mainly) made by 4 shank Buzsaki probe -> shankId vector is
% modified later on, in this code.)
shankIds = ones(numel(goodCluIds),1);

if numel(goodCluIds) == 0
    return; % return if there is no 'good' clusters
end

if isequal(PROJECTID,'FREE_MOUSE') | isequal(PROJECTID,'OPTOTAGGING')
    % Read templates:
    templates = readNPY(fullfile(dataDir,'templates.npy'));

    %% Find missing 'good' clusters' shankIds:
    % Original number of clusters (created by Kilosort)
    nClusters = size(templates, 1) - 1;
    % Missing .npy files (since these clusters are the results of
    % merging, spliting):
    missingCluIds = goodCluIds(goodCluIds>nClusters);
    originalgoodCluIds = goodCluIds(goodCluIds<nClusters+1);
    if numel(missingCluIds) > 0
        for it1 = 1:numel(missingCluIds)
            % get shnak ID from user (who can easily determine it based on the phy GUI):
            prompt = [recordingId, ' ', num2str(missingCluIds(it1)), ': '];
            shId = input(prompt);
            shankIds(goodCluIds == missingCluIds(it1)) = shId;
        end
    end
    
    %% Find not-missing, 'good' clusters shankIds:
    templates = templates(originalgoodCluIds + 1, :, :);
    load(fullfile(DATADIR,animalIdN,[animalId,'_chanMap.mat']),'chanMap');
    chMapTrunc = readNPY(fullfile(dataDir,'channel_map.npy')).'+1;
    goodChannels = find(ismember(chanMap,chMapTrunc)); 
    allTemplates = templates;
    % If there are dead channels:
    if length(goodChannels) < length(chanMap)
        numCh = 1; % ...we cant look biggest waveforms on multiple channels
        allTemplates = zeros(size(templates,1),size(templates,2),length(chanMap));
        for it = 1:size(templates,1)
            actTemplate = zeros(size(templates,2),length(chanMap));
            actTemplate(:,goodChannels) = templates(it,:,:);
            allTemplates(it,:,:) = actTemplate;
        end
    end
    
    if size(allTemplates, 1) > 0 % at least one cell
        allWavePower = sort_channels_energy(allTemplates);
        for it1 = 1:size(allWavePower, 1) % go trough cells
            wavePower = squeeze(allWavePower(it1, :, :));
            %         wavePower(:, 2) = wavePower(:, 2) - 1;
            shankIds(it1) = mode(ceil(wavePower(1:numCh, 2)/chPerShnk)); % find shankId
        end
    end
end

% Extract 'good' spikes (spike times and clusters)
spike_times(~ismember(spike_clusters, goodCluIds))= [];
spike_clusters(~ismember(spike_clusters, goodCluIds))= [];

% Differentiate spikes across shanks:
for it1 = 1:nShanks %go trough shanks
    cellIdsonShank = goodCluIds(shankIds == it1); % clusters on this shank
    if numel(cellIdsonShank) > 0
        % Save good cluster ids on this shank:
        save(fullfile(dataDir,[animalId,recordingId,'_goodCluIds.',num2str(it1),'.mat']),'cellIdsonShank');
        
        % Find spikes of cells on this shank:
        indices = zeros(length(spike_times), 1);
        for it2 = 1:numel(cellIdsonShank)
            indices(spike_clusters == cellIdsonShank(it2)) = 1;
        end
        % Extract this shank's cells' spikes
        cellonShankST = spike_times(indices == 1); %spike times
        cellonShankSC = spike_clusters(indices == 1); %spike clusters
        
        % Save spikes' clusterIds on this shank:
        fileID = fopen(fullfile(dataDir,[animalId,recordingId,'.clu.',num2str(it1)]),'w');
        fprintf(fileID,'%d\n',cellonShankSC);
        fclose(fileID);
        % Save spikes' times on this shank:
        fileID = fopen(fullfile(dataDir,[animalId,recordingId,'.res.',num2str(it1)]),'w');
        fprintf(fileID,'%d\n',cellonShankST);
        fclose(fileID);
    end
end
end