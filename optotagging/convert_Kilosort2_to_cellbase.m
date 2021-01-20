function convert_Kilosort2_to_cellbase(dataDirectory,targetDirectory)
%CONVER_KILOSORT2_TO_CELLBASE Creates TT files for cellbase initiation.
%   CONVER_KILOSORT2_TO_CELLBASE(DATADIRECTORY,TARGETDIRECTORY)
%
%   See also CONVER_KILOSORT_TO_CELLBASE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

sr = 30000;
nsr = 10000;

[~,timestamps] = load_open_ephys_data(fullfile(dataDirectory,'100_CH1.continuous'));
timeShift = timestamps(1);

clusterIDs = tdfread(fullfile(dataDirectory,'cluster_group.tsv'));
goodClusterIDs = clusterIDs.cluster_id(find(ismember(clusterIDs.group,'good','rows')));

spikeClustersPath = fullfile(dataDirectory,'spike_clusters.npy');
spikeTimesPath= fullfile(dataDirectory,'spike_times.npy');
spike_clusters = readNPY(spikeClustersPath);
spike_times = readNPY(spikeTimesPath);

if isempty(goodClusterIDs)
    return;
end

% goodSpikes = arrayfun(@(x) ismember(x,goodClusterIDs),spike_clusters);
% spike_times(~goodSpikes)= [];
% spike_clusters(~goodSpikes)= [];

% Create TT1_... for each cell
for it = 1:length(goodClusterIDs)
    TS = double(round(spike_times(spike_clusters==goodClusterIDs(it))/(sr/nsr)));
    TS = TS + timeShift*nsr;
    TS(TS==0) = 1; % change 0 indices
    save(fullfile(targetDirectory,['TT1_',num2str(goodClusterIDs(it)),'.mat']),'TS');
end

end