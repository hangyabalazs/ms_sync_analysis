function MSsync_figure_S23()
%% Figure S23 (identification of double recorded cells, amouse):
% = Figure R3
ANA_MOUSE_GLOBALTABLE
animalId = '20170608';
recordingId1 = '45'; % first recordingId, more dorsal
cellIds1 = [7,52,55,60,73,75,88,116,133,134]; % ancestor candidate cellIds from the first recording
recordingId2 = '6'; % shifted second recording, more ventral.
cellId2 = 24; % putative duplicated cellId in a deeper second recording.
shankId = '1';

maxLag = 1000;
acgYLims = [0,6e-4];

% Ancestor candidates
for it = 1:numel(cellIds1)
    % Waveform
    figure('Position',[50+it*110,100,100,200]);
    load(fullfile(ROOTDIR,'WAVEFORMS',animalId,recordingId1,...
        [animalId,'_',recordingId1,'_',num2str(cellIds1(it)),'_waveform.mat']));
    TTK_plot_waveform(avrgWave); % plot average waveform
    set(gca,'Visible','off'), ylim([18.5,32.5]), set(gca,'clim',[0,10])
    savefig(gcf,['Figure_S23_',num2str(it),'_waveform.fig']);
    close
    
    % Autocorrelation:
    figure('Position',[50+it*110,310,100,100])
    TS = loadTS(animalId,recordingId1,shankId,cellIds1(it));
    correlation(TS,TS,true,[0,0,0]);
    xlim([-maxLag,maxLag]); ylim(acgYLims); setmyplot_balazs
    savefig(gcf,['Figure_S23_',num2str(it),'_acg.fig']);
    close
end

% Duplicated cell:
% Waveform
figure('Position',[50,50,100,200])
load(fullfile(ROOTDIR,'WAVEFORMS',animalId,recordingId2,...
    [animalId,'_',recordingId2,'_',num2str(cellId2),'_waveform.mat']));
TTK_plot_waveform(avrgWave); % plot average waveform
set(gca,'Visible','off'), ylim([0.5,14.5]), set(gca,'clim',[0,10])
savefig(gcf,['Figure_S23_0_waveform.fig']);
close

% Autocorrelation:
figure('Position',[50,310,100,100])
load(fullfile(PREPROCDIR,animalId,recordingId2,[num2str(cellId2),'.mat']),'TS');
correlation(TS,TS,true,[0,0,0]);
xlim([-maxLag,maxLag]); ylim(acgYLims); setmyplot_balazs
savefig(gcf,['Figure_S23_0_acg.fig']);
close all
end