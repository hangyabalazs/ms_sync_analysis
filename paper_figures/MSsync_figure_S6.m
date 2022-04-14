function MSsync_figure_S6()
%% Figure(3) S6 (theta follower, arat):
ANA_RAT_GLOBALTABLE
example_cells_plot({20100728,9,2,7;20100728,9,4,10;20100728,9,4,7},[656,668],[0,0.0005],[0,0.1]);
savefig(gcf,'Figure_S6_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('NT_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end