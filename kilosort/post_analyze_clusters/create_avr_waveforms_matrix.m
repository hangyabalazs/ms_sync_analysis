function create_avr_waveforms_matrix(animalIdN,recordingIdN,nSpksExt)
%CREATE_AVR_WAVEFORMS_MATRIX Creates mean waveforms matrices fo all cells
%in the recording.
%   CREATE_AVR_WAVEFORMS_MATRIX(ANIMALIDN,RECORDINGIDN,NSPKSEXT) creates
%   mean waveform matrices for all clusters (in the recording) on all 
%   channels, averaged across all spikes. It saves AVRGWAVE 
%   (windowSize x nChannels matrix, waveforms), AMPS (NSPKSx1 vector,
%   peak to peak amplitudes of spikes on all channels), ENERGIES 
%   (NSPKSx1 vector, energies of spikes on all channels) for all clusters. 
%   Data is directly read from .dat file.
%   Parameters:
%   ANIMALIDN: string (e.g. '20170216').
%   RECORDINGIDN: string (e.g. '45').
%   NSPKSEXT: optional, number, specifying first how many spikes to
%   extract (e.g. 100).
%
%   See also VISUAL_OVERLAPING_CLUSTERS, VISUAL_MERGE_CLUSTERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global ROOTDIR
global DATADIR
global NSEPTALCHANNELS
global SR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN,(nSpksExt) definitions
end
if ~exist('nSpksExt','var') nSpksExt = Inf; end % if not specified extract all spikes

% HARD CODED HERE!!
amplif = 1 / 0.195;
nPoints = 5 * 1e-3 * SR; % +/-5 ms snippet around spike to filter
timeInterest = 2 * 1e-3 * SR; % +/-2 ms window to look for amplitude (max and min)
timeInterest = nPoints-timeInterest:nPoints+timeInterest;
[b,a] = butter(3,[600 6000]/SR/2,'bandpass');   % Butterworth filter

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

%% Load raw-data file:
datFile = fullfile(DATADIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_septum.dat']);
% datFile = fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,'_128ch.dat']);
fileInfo = dir(datFile);
recLength = fileInfo.bytes / 2 / NSEPTALCHANNELS;
m = memmapfile(datFile,'Format',{'int16',[NSEPTALCHANNELS,recLength],'x'});
data = m.Data.x;

load(fullfile(DATADIR,animalIdN,[animalId,'_chanMap.mat']),'chanMap'); % load channel map
% chanMap = 1:NSEPTALCHANNELS; %??? (in rat project)

%% Load spikes
% If Kilosort was used (amouse, fmouse, opto):
STsAll = readNPY(fullfile(DATADIR,animalIdN, recordingId,'spike_times.npy')); % spike times
cluIds = readNPY(fullfile(DATADIR, animalId, recordingId,'spike_clusters.npy')); % clusterIds
[cids,cgs] = readClusterGroupsCSV(fullfile(DATADIR,animalId,recordingId,'cluster_groups.csv'));
goodClus = cids(cgs == 2); %identified as 'good'

% If only res and clu files were given (rat):
% [goodClus,STsAll,cluIds] = rat_collect_res_clu(animalIdN,recordingIdN);

%% Average waveform matrices
for it1 = 1:numel(goodClus) % go trough all good clusters
    STs = STsAll(cluIds == goodClus(it1)); % find spikes of this cell
    % clear spikes that dont have a 2*nPoints window around (rec start and end)
    STs(STs<nPoints+1 | STs>recLength-nPoints) = [];
    % extract at first NSPKEXT spikes
    extractST = STs(1:min(nSpksExt,numel(STs)));
    nSpks = numel(extractST);
    % allocate template matrices for this cell
    fTemplateMatrix = zeros(nSpks,nPoints*2+1,NSEPTALCHANNELS);
    amps = zeros(nSpks,NSEPTALCHANNELS);
    energies = zeros(nSpks,NSEPTALCHANNELS);
    for it2 = 1:nSpks % cut a window around spike from raw-data
        spkWindow = double(data(:,extractST(it2)-nPoints:extractST(it2)+nPoints))/amplif;
        fTemplateMatrix(it2,:,:) = filtfilt(b,a,spkWindow.');
        SpkWind = squeeze(fTemplateMatrix(it2,timeInterest,:));
        amps(it2,:) = max(SpkWind) - min(SpkWind); % amplitudes
        energies(it2,:) = sum(SpkWind.^2); % energies
    end
    % average waveform on all channels (windowSize x nChannels matrix):
    avrgWave = squeeze(mean(fTemplateMatrix(:,timeInterest,:),1));
    avrgWave = avrgWave(:,chanMap); % order channels
    % create folders previously.
    save(fullfile(ROOTDIR,'WAVEFORMS',animalIdN,recordingIdN,...
        [animalId,'_',recordingId,'_',num2str(goodClusterIDs(it1)),'_waveform.mat']),...
        'avrgWave','amps','energies');%,'spkIds','exampWaves');
end

end