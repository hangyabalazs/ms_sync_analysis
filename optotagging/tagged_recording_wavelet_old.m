function tagged_recording_wavelet(rowIds,tWindow)

global ROOTDIR
global RESULTDIR
global NSR

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Extract all unique recording IDs of cells in ROWIDS:
recIds = allCell(rowIds,mO('animalId'):mO('recordingId'));
unRecIds = unique(recIds,'rows');
unRecIds(ismember(unRecIds,[20180906,2],'rows'),:) = []; % REMOVE NOISY RECORDING!!!!!!!!!!!!!!!!!!

% Calculate cross coherences around transition(s):
[~,f] = wavelet_spectrum(num2str(unRecIds(1,1)),num2str(unRecIds(1,2)),tWindow,true); close
nFreqs = numel(f); % number of frequencies
allWavelets = zeros(size(unRecIds,1),nFreqs,diff(tWindow)*NSR+1); % store all trasnitions' cross coherences
for it = 1:size(unRecIds) %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 1:size(unRecIds)
%     figure
    animalId = num2str(unRecIds(it,1));
    recordingId = num2str(unRecIds(it,2));
    if exist(fullfile(ROOTDIR,'TRUNCATE',[animalId,'_',recordingId,'.mat']),'file')
        load(fullfile(ROOTDIR,'TRUNCATE',[animalId,'_',recordingId,'.mat']),'keepSegm');
        totalPow = NaN(nFreqs,keepSegm(end));
%         totalPow = NaN(nFreqs,keepSegm(end));
        truncPow = wavelet_spectrum(animalId,recordingId);
        totalPow(:,keepSegm) = truncPow;
        pow = totalPow(:,tWindow(1)*NSR:tWindow(2)*NSR);
    else
        pow = wavelet_spectrum(animalId,recordingId,tWindow);
    end
%     close;
    allWavelets(it,:,:) = pow;
end
avgWavelet = squeeze(mean(allWavelets,1,'omitnan')); % calculate average wavelet

% Plot:
figure
frInd = find(f<10 & f>0.5); % interesting frequencies
nnsr = 10; % resampling rate for ploting
timeVec = 1/nnsr:1/nnsr:size(avgWavelet,2)/NSR; % time vector
rsPow = avgWavelet(frInd,NSR/nnsr:NSR/nnsr:end); % resampled wavelet matrix
% % option 1.: (non-linear frequency scale):
% imagesc(timeVec,frInd,rsPow) % plot
% set(gca,'clim',[0,500])
% frTicks = [10,6,3,1]; % frequency axis tick labels
% [~,frTickInd] = arrayfun(@(x) min(abs(f(frInd)-x)),frTicks); % frequency axis ticks indices
% set(gca,'ytick',frInd(frTickInd)); % frequency axis ticks
% set(gca,'yticklabel',frTicks); % frequency axis tick labels

% % option 2.: (linear frequency scale):
cLims = prctile(rsPow(:),[0,98]); % limit colors
levels = cLims(1):diff(cLims)/100:cLims(2);
contourf(timeVec,f(frInd),rsPow,levels,'LineStyle','none');

colormap('jet')
end