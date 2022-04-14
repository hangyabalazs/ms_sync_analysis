function MSsync_figure3()
% Requires almost all steps from MAIN_ANALYSIS (I-VIII. steps)!
%% Figure 3 (follower, arat):
ANA_RAT_GLOBALTABLE
example_cells_plot({20100728,4,4,10;20100728,4,4,11;20100728,4,4,13},[1231,1243],[0,0.0006],[0,0.2]);
savefig(gcf,'panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('DT_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end