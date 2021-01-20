function multip_cells_clustering_examp(animalId,recordingId,cellIds)
%MULTIP_CELLS_CLUSTERING_EXAMP Demonstrates cluster separation of 2 cells.
%   MULTIP_CELLS_CLUSTERING_EXAMP demonstrates cluster separation (made by 
%   Kilosort and compatible phy GUI): waveforms, acgs, amplitude separation
%   on 2 channels.
%   Parameters:
%   ANIMALID: string (e.g. '20170607').
%   RECORDINGID: string (e.g. '23').
%   CELLIDS: number vector (e.g. [32,117]).
%
%   See also CREATE_AVR_WAVEFORMS_MATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 27/10/2020

global DATADIR
global NSEPTALCHANNELS
global SR

if nargin == 0
    variable_definitions; %animalId,recordingId,cellIds definitions
end

% HARD CODED here:
amplif = 1/0.195; % amplification
nPoints = 10*1e-3*SR; % +/-10 ms snippet around spike to filter
timeInterest = 2*1e-3*SR; % +/-2 ms window to look for amplitude (max and min)
timeInterest = nPoints-timeInterest:nPoints+timeInterest;
[b,a] = butter(3,[600 6000]/SR/2,'bandpass');   % Butterworth filter

% Read all spikes from binary file:
datFname = fullfile(DATADIR,animalId,recordingId,[animalId,'_',recordingId,'_septum.dat']);
% datFile = fullfile(datadir,animalId,recordingId,[animalId,recordingId,'_128ch.dat']);
fileInfo = dir(datFname);
samplesPerChannels = fileInfo.bytes/2/NSEPTALCHANNELS;
m = memmapfile(datFname,'Format',{'int16',[NSEPTALCHANNELS,samplesPerChannels],'x'});

allST = readNPY(fullfile(DATADIR, animalId, recordingId, 'spike_times.npy'));
allClu = readNPY(fullfile(DATADIR, animalId, recordingId, 'spike_clusters.npy'));

allAmps = {}; % cell array for all amplitude values
chIds = []; % channelIds
for it1 = 1:numel(cellIds)
    ST = allST(allClu == cellIds(it1));
    ST(ST<nPoints | ST>size(m.Data.x,2)-nPoints) = []; % clear spikes that dont have a 2*nPoints window around (rec start and end)
    nSpikes = numel(ST);
    fTemplateMatrix = zeros(nSpikes,nPoints*2+1,NSEPTALCHANNELS); % filtered template matrix
    amps = zeros(nSpikes,NSEPTALCHANNELS);
    %     energies = zeros(nSpikes,NSEPTALCHANNELS);
    for it2 = 1:nSpikes
        dataWindow = double(m.Data.x(:,ST(it2)-nPoints:ST(it2)+nPoints))/amplif;
        fTemplateMatrix(it2,:,:) = filtfilt(b,a,dataWindow.');
        SpkWind = squeeze(fTemplateMatrix(it2,timeInterest,:));
        amps(it2,:) = range(SpkWind);
        %     energies(it2,:) = sum(SpkWind.^2);
    end
    allAmps{end+1} = amps;
    avrgWave = squeeze(mean(fTemplateMatrix(:,timeInterest,:),1));
    [~,chId] = max(range(avrgWave));
    chIds(end+1) = chId; % biggest waveform power on CHID channel
    spkIds = randperm(nSpikes,100); % extract random spikes as background waveforms
    exampWaves = fTemplateMatrix(spkIds,timeInterest,:);
    
    % Plot waveform
    chInterest = chId-rem(chId,4)-7:chId-rem(chId,4)+12; % channels of interest
    chInterest(chInterest<1 | chInterest>NSEPTALCHANNELS) = []; % clear out-of-probe channels
    figure('Position',[(it1-1)*300,10,300,300]),
    for it=1:numel(chInterest)
        subplot(5,4,it)
        plot(squeeze(exampWaves(:,:,chInterest(it))).','Color',[0.6,0.6,0.6]) %[0, 0.4470, 0.7410]
        hold on, plot(avrgWave(:,chInterest(it)),'k','LineWidth',2)
        ylim([-200,100]), xlim([1,82])
        set(gca,'Visible','off')
        if it==numel(chInterest) | chInterest(it)==chId
            plot([82,82],[-200,0],'k','LineWidth',2); % 0.2 mV bar
            plot([62,82],[-200,-200],'k','LineWidth',2); % 1 ms bar
        end
    end
    
    %Acg
    timeseries = zeros(ST(end),1);
    timeseries(ST) = 1;
    [cor,lag] = xcorr(timeseries,timeseries,50*1e-3*SR); % acg in +/- 50 ms window
    cor(lag==0) = []; %clear zero lag
    lag(lag==0) = [];
    
    figure('Position',[(it1-1)*300,300,300,300]), bar(lag,cor,'k'),title(cellIds(it1))
    xlabel('Lag (ms/20)'), ylabel('Autocorrelation'), % setmyplot_balazs
end

figure('Position',[it1*300,300,300,300]), xlim([0,300]), ylim([0,300]), hold on
plot(allAmps{2}(:,chIds(1)),allAmps{2}(:,chIds(2)),'g.')
plot(allAmps{1}(:,chIds(1)),allAmps{1}(:,chIds(2)),'.','Color',[0.2,0.2,0.2])
if numel(cellIds)>2
    plot(allAmps{3}(:,chIds(1)),allAmps{3}(:,chIds(2)),'.','Color',[0.2,0,0])
    if numel(cellIds)>3
        plot(allAmps{4}(:,chIds(1)),allAmps{4}(:,chIds(2)),'.','Color',[0.4,0.4,0.4])
    end
end
xlabel(['Amplitude',num2str(chIds(1)),' (uV)'])
ylabel(['Amplitude',num2str(chIds(2)),' (uV)'])
title([animalId,recordingId])
end
