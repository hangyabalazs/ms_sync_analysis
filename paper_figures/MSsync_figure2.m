function MSsync_figure2()
% Requires almost all steps from MAIN_ANALYSIS (I-VIII. steps)!

%% figure 2:
ANA_RAT_GLOBALTABLE
example_cells_plot({20100728,3,4,5;20100728,3,4,9;20100728,3,4,10},[1284,1296],[0,0.0006],[0,0.2]);
savefig(gcf,'panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTB');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end