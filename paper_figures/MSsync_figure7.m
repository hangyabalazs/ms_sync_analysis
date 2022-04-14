function MSsync_figure7
%% Figure 7 (photostimulatoin of glutamaterg cells evoke theta in the hippo):
% = figure R6
OPTO_GLOBALTABLE
% panel A: shematics of the experiment (made by Daniel Schlingloff)
% panel B: example wavelet spectrum
figure, wavelet_spectrum('20190510','6',[1/NSR,400],true);
% Paper figure is produced with:
%   frInd = find(f<=6.1 & f>=0.5);
%   levels = 0:cLims(2)/100:cLims(2);
setmyplot_balazs
xlim([0,400]), xlabel('Times (s)'), set(gca,'xtick',[0,120,240,360])
ylim([0.5,6]), ylabel('Frequency (Hz)'), set(gca,'ytick',[0.5,3,6])
savefig(figure(1),'panelB.fig')
close all
% panel C, D: average wavelet spectrum, theta-delta frequency ratio change
tagged_recording_wavelet(get_optoGroup_indices_in_allCell('VGL',1),[1/NSR,400]);
savefig(figure(1),'panelC.fig')
savefig(figure(2),'panelD.fig')
close all
end