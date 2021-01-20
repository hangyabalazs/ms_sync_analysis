% KILOSORT_CLUSTERING_WRAPPER go trough recordings and calls
% STANDARD_CONFIG2 and MASTER_KILOSORT (Kilosort2) %(or STANDARD_CONFIG and 
% KILOSORT_CLSUTERING (Kilosort1)).
%   Kilosort 1 or 2 need to be downloaded and installed previously!

% Parameters defined here:
totnCh = 64; % total number of channels
actnCh = 64; % number of active channels (for Kilosort1)
nClusters = 64; % pre-dfeined desired number of cluster (for Kilosort1)
% totnCh = 32;
% actnCh = 32;
% nClusters = 32;
sr = 30000; % sampling rate
rootDir = 'L:\Barni\transfer\DATA';
animalFolders = {'20191022'};

for it1 = 1:length(animalFolders) % go trough each animals
    animalId = animalFolders{it1};
    recordingFolders = dir(fullfile(rootDir,animalId));
    recordingFolders = return_used_folders(recordingFolders,true,{'.','n'});
    for it2 = 1:numel(recordingFolders) % go trough recordings
        recordingId = recordingFolders(it2).name;
        binaryId = [animalId, recordingId, '_septum.dat'] % raw-data file
        %Kilosort 1:
        %StandardConfig(); %standard parameter definitions
        %kilosort_clustering(); %start clustering
        %Kilosort 2:
        StandardConfig2(); % standard parameter definitions
        master_kilosort(); % start clustering
        
        % Move output files to target recording folders:
        outputFiles = dir(fullfile(rootDir,animalId));
        names = {outputFiles.name};
        dates = {outputFiles.date};
        isdirs = {outputFiles.isdir};
        for it = 1:numel(outputFiles)
            if ~isdirs{it} & isempty(findstr(names{it},'chanMap.mat'))
                source = fullfile(rootDir,animalId,outputFiles(it).name);
                destination = fullfile(rootDir, animalId, recordingId, outputFiles(it).name);
                movefile(source,destination)
            end
        end
        close all;
    end
end