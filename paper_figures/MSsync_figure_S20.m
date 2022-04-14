function MSsync_figure_S20()
%% Figure S20 panel A, B (antiphasic pacemaker pairs, ccg during theta and non-theta, arat):
% = Figure R4
ANA_RAT_GLOBALTABLE
antiphase_ccg_pairs(get_rhGroup_indices_in_allCell('CTB'))
savefig(gcf,'Figure_S20_panelA_B.fig');
close all

%% Figure S20 panel C, D (inphase pacemaker pairs, ccg, model):
% = Figure R5 panel A, B
MODEL_GLOBALTABLE_par
% model parameters: 60% CR, 60 pA stim. amp. with 10% variance, 2 ms decay,
% 7 ms delay, 3 nS syn. weight
ccg_peakLag_offset('202106259','46',0.3*NSR,6,6*NSR:15*NSR,true);
savefig(gcf,'Figure_S20_panelC_D.fig');
close all

%% Figure S20 panel E, F, G (antiphasic pacemaker pairs, ccg, model):
% = Figure R5 panel C, D
MODEL_GLOBALTABLE_par
% model parameters: 20% CR, 70 pA stim. amp. with 10% variance, 2 ms decay,
% 7 ms delay, 1 nS syn. weight
ccg_peakLag_offset('202106259','20',0.3*NSR,6,6*NSR:15*NSR,true);
savefig(gcf,'Figure_S20_panelE_F.fig');
close all
% = Figure R5 panel E, F
plot_interv_raster_ccg('202106259','20',[1,1],[18,9],[6*NSR,15*NSR]);
savefig(gcf,'Figure_S20_panelG.fig')
close all
end