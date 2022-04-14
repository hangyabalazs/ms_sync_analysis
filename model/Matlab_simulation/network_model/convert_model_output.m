function convert_model_output(resPath,animalId,recordingId,issave)
%CONVERT_MODEL_OUTPUT Converts Neuron simulations to project-specific
%format.
%   CONVERT_MODEL_OUTPUT(RESPATH,ANIMALID,RECORDINGID,ISSAVE) saves out 
%   .res and .clu files (standard format in this project for clustered 
%   spikes), and creates theoretical hippocampal field by convolving 
%   summed neuronal spike train with a Gaussian window (definition is 
%   hard-coded in the function!!!!). 
%   It also creates a network activity plot (wavelet, raster, theta
%   detection) by calling HIPPO_FIELD_MS_UNIT.
%   Parameters:
%   RESPATH: string (e.g. '202004271').
%   ANIMALID: string (e.g. '202004271').
%   RECORDINGID: string (e.g. '1').
%   ISSAVE: optional, flag, save spiketimes (res (time of all spikes), clu
%   clu (clusterId to res), TT1_*.mat (1 for each cell)), theoretical hippo
%   signal (fieldPot vector)?
%
%   See also: GENERATE_AND_SIMULATE_MODEL, RUN_NETWORK_SIMULATION,
%   CREATE_NETWORK_PARAMETERS, HIPPO_FIELD_MS_UNIT, ORGANIZE_PARAMETER_SPACE_PNGS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 28/01/2019

global PREPROCDIR
global SR
global NSR

if ~exist('resPath','var')
    % Path to Neuron software folder's network simulation directory:
    model_resPath_def;
end

paramFile = fopen(fullfile(resPath,'actual_run','parameters.txt'),'r');
nCells = sum(str2num(fgetl(paramFile)));
recLength = sum(str2num(fgetl(paramFile)));
fclose(paramFile);

% Parameter definition:
APthresh = 0; %threshold for APs (mV)

% Load Neuron-generated time and potential vector (binary files):
timeVec = dlmread(fullfile(resPath,'actual_run','time.dat'), 'r');
timeVec = timeVec(2:end); %erase first element
potentials = dlmread(fullfile(resPath,'actual_run','potentials.dat'), 'r');

allCellAct = reshape(potentials, nCells, []).'; % each cells' potential is stored in one row
% nplot(1/SR:1/SR:size(allCellAct,1)/SR,allCellAct); k

% Find AP times:
% allocate vectors:
APseries = zeros(timeVec(end), nCells);
res = zeros(nCells*recLength,1); % timepoint of AP
clu = zeros(nCells*recLength,1); % clusterId of AP
lastPos = 1;
for it = 1:nCells % iterate trough each cell
    cellAct = allCellAct(:, it);
    [pks,locs] = findpeaks(cellAct);
    locs(pks<APthresh) = []; % thresholding (find APs)
    res(lastPos:lastPos+length(locs)-1) = locs; % time of AP
    clu(lastPos:lastPos+length(locs)-1) = it; % cellId
    TS = round(locs/(SR/NSR)); % rescale time
    TS(TS==0) = 1; % change index if equals 0
%     hold on, plot_raster_lines_fast(TS,[it,it+1]); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    APseries(TS,it) = 1; % create spiketrain
    if exist('issave','var')
        save(fullfile(PREPROCDIR,animalId,recordingId,['TT1_',num2str(it),'.mat']),'TS');
    end
    lastPos = lastPos+length(locs);
end
res(lastPos:end) = []; % clear unused positions
clu(lastPos:end) = []; % clear unused positions
% Order APs (time):
[res,inx] = sort(res);
clu = clu(inx);

% Gaussian kernel:
nPoints = 50; %20; % HARD CODED HERE!!!
kernel = gausswin(nPoints)/nPoints*2;
% Derive theoretical hippocampal signal:
fieldPot = sum(APseries,2).'; % average spike trains
fieldPot = conv(fieldPot,kernel,'same'); % convolve with gaussian kernel

if exist('issave','var')
    clufileID = fopen(fullfile(resPath,'actual_run',[animalId,recordingId,'.clu.1']), 'w');
    fprintf(clufileID, '%d\n', clu);
    fclose(clufileID);
    resfileID = fopen(fullfile(resPath,'actual_run',[animalId,recordingId,'.res.1']), 'w');
    fprintf(resfileID, '%d\n', res);
    fclose(resfileID);
    goodClusterIDs = 1:nCells;
    save(fullfile(resPath,'actual_run',[animalId,recordingId,'_goodClusterIDs1.mat']),'goodClusterIDs');
    save(fullfile(PREPROCDIR,animalId,recordingId,[animalId,'_',recordingId,'_radiatum.mat']),'fieldPot');
end
end