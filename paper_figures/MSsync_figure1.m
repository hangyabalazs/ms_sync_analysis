function MSsync_figure1()
% requires MAIN_ANALYSIS preprocess step

%% panel A: histology (amouse)
%   -hippo: nissl, fluorescent, atlas (20172107/7/Right)
%   -MS: nissl, fluorescent, atlas (201801082/7/Right)

%% panel B, C, D: MS cluster separation (amouse)
%   B: 128 channel silicon probe layout and waveform view
%   C: amplitude based cluster separation
%   D: clusters' autocorrelations
ANA_MOUSE_GLOBALTABLE;
multip_cells_clustering_examp('20170607','23',[32,117,36]);
savefig(figure(1),'panelB_1.fig')
savefig(figure(3),'panelB_2.fig')
savefig(figure(7),'panelC.fig')
savefig(figure(2),'panelD_1.fig')
savefig(figure(4),'panelD_2.fig')
close all

%% panel E: 32 channel hippo probe signal (amouse)
%uncomment plotMat(...,'shft',4000) and comment out
%plotMat(...,'shft',1000) in PYRAMIDAL_LAYER_PHASE_CHANGE:
pyramidal_phase_change('20171207','12',[375,378]);
savefig(gcf,'panelE.fig')
close all

%% panel F: hippo spectral differencies across datasets (+ shilouettes)
%requires SAVE_HIPPOCAMPAL_FIELD to run first (save out resampled data from radiatum)
ANA_RAT_GLOBALTABLE
sColor = dataset_colors(PROJECTID);
load(fullfile(PREPROCDIR,'20100616','7','20100616_7_radiatum.mat'),'fieldPot');
[~,freqs,sNormFT] = spectrumFFT(fieldPot,NSR,[0,10],4);
figure, plot(freqs,sNormFT,'Color',sColor)
ANA_MOUSE_GLOBALTABLE
sColor = dataset_colors(PROJECTID);
load(fullfile(PREPROCDIR,'201801101','56','201801101_56_radiatum.mat'),'fieldPot');
[~,freqs,sNormFT] = spectrumFFT(fieldPot,NSR,[0,10],4);
hold on, plot(freqs,sNormFT,'Color',sColor)
FREE_MOUSE_GLOBALTABLE
sColor = dataset_colors(PROJECTID);
load(fullfile(PREPROCDIR,'20161989','127128','20161989_127128_radiatum.mat'),'fieldPot');
[~,freqs,sNormFT] = spectrumFFT(fieldPot,NSR,[0,10],4);
plot(freqs,sNormFT,'Color',sColor)
savefig(gcf,'panelF.fig')
close all

%% panel G: wavelet of a delta theta transition (arat)
ANA_RAT_GLOBALTABLE
wavelet_spectrum('20100728','5',[1000,1250],true);
savefig(gcf,'panelG.fig')
close all

%% panel H: zoomed non-theta - theta transition: radiatum raw, wavelet, MS activity (arat)
wavelet_spectrum('20100728','5',[1132,1144],true);
savefig(gcf,'panelH_1.fig'), close all

rowIds = find_rowIds('20100728','5',[4,4,4,4,4,4,4,4,4,1,1,1,1,4,4],[11,13,8,3,5,12,9,10,2,12,8,4,13,4,6]);
raster_plot(rowIds,[1132,1144])
savefig(gcf,'panelH_2.fig')
close all

%% FIGURE1 supp1 (arat, fmouse histology)
%   -arat hippo: ChAT, fluorescent, atlas (Viktor7_1247_PV_2c_1)
%   -arat MS: ChAT, fluorescent, atlas (Viktor9_1268_Chat_4c_2)
%   -fmouse hippo: Dil, fluorescent, atlas (1750_3_ms1_2,5x_MODIF)
%   -fmouse MS: Dil, fluorescent, atlas (hc_right_top_2.5x)

%% FIGURE1 supp2 pyramidal layer phase change (amouse)
%   panelA: histolology Nissl, fluor, atlas (201801102_3HPC_13_J)
ANA_MOUSE_GLOBALTABLE
pyramidal_phase_change('201801102','12',[1204,1206]);
savefig(figure(1),'supp2_panelC.fig')
savefig(figure(2),'supp2_panelB.fig')
close all
end