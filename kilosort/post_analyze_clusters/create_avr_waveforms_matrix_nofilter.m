function create_avr_waveforms_matrix_nofilter(animalIdN,recordingIdN)
%CREATE_AVR_WAVEFORMS_MATRIX_NOFILTER Calculates average waveform for all
%   clusters on all channels. 
%   CREATE_AVR_WAVEFORMS_MATRIX_NOFILTER(ANIMALIDN,RECORDINGIDN,NSPKSEXT)
%   creates mean waveform matrices for all clusters (in the recording) on 
%   all channels, averaged across all spikes. It saves ALLAVGWAVEFORMS 
%   (ngoodCluster x nChannels x windowSize matrix) for all clusters. 
%   (Indices starts from 0, python consistent). Data is directly read from
%   .dat file.
%   Parameters:
%   ANIMALIDN: string (e.g. '20170216').
%   RECORDINGIDN: string (e.g. '45').
%
%   See also VISUAL_OVERLAPING_CLUSTERS, VISUAL_MERGE_CLUSTERS.
%   Calculates average waveform for all cluster on all channels. (Indices
%   starts from 0, python consistent).  Data is directly read from .dat file.
%
%   See also VISUAL_OVERLAPING_CLUSTERS, VISUAL_MERGE_CLUSTERS, 
%   CREATE_AVR_WAVEFORMS_MATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/03/2021

global DATADIR
global ROOTDIR
global PROJECTID
global NSEPTALCHANNELS
global SR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN definitions
end

%HARD CODED HERE!!
nWindow = 0.004*SR+1; %window around spike
nPoints = (nWindow-1)/2;

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

datFile = fullfile(DATADIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_septum.dat']);
fileInfo = dir(datFile);
samplesPerChannels = fileInfo.bytes/2/NSEPTALCHANNELS;
m = memmapfile(datFile,'Format',{'int16',[NSEPTALCHANNELS,samplesPerChannels],'x'});
data = m.Data.x;

load(fullfile(DATADIR,animalIdN,[animalId,'_chanMap.mat']),'chanMap'); %load channel map

ST1 = readNPY(fullfile(DATADIR, animalIdN, recordingIdN, 'spike_times.npy'));
clu1 = readNPY(fullfile(DATADIR, animalIdN, recordingIdN, 'spike_clusters.npy'));
[cids, cgs] = readClusterGroupsCSV(fullfile(DATADIR,animalIdN,recordingIdN,'cluster_groups.csv'));
goodClus1 = cids(cgs == 2);%identified as 'good'

allAvgWaveforms = zeros(length(goodClus1), NSEPTALCHANNELS, nWindow); %all clusters average waveforms for all channels
for it1 = 1:length(goodClus1)
    ST = ST1(clu1 == goodClus1(it1));
    ST(ST<nPoints | ST>size(data,2)-nPoints) = []; %clear spikes that dont have a 2*nPoints window around (rec start and end)
    templateMatrix = zeros(length(ST),NSEPTALCHANNELS,nWindow);
    for it2 = 1:length(ST)
        templateMatrix(it2,:,:) = data(:,ST(it2)-nPoints:ST(it2)+nPoints);
    end
    %average waveform:
    avrgWave = zeros(nWindow, NSEPTALCHANNELS);
    for it2 = 1:NSEPTALCHANNELS
        avrgWave(:, it2) = mean(squeeze(templateMatrix(:, it2, :))).'; %average waveform on one channel
        avrgWave(:, it2) = avrgWave(:, it2)-mean(avrgWave(:, it2)); %align around zero
%         avrgWave(:, it2) = avrgWave(:, it2) + abs(min(avrgWave(:, it2))); %shift above zero
    end
    avrgWave = avrgWave(:, chanMap);
    allAvgWaveforms(it1, :, :) = avrgWave.';
end
save(fullfile(ROOTDIR,'WAVEFORMS',animalIdN,recordingIdN,...
        [animalId,recordingId,'_avr_waveforms.mat']),'allAvgWaveforms');
end