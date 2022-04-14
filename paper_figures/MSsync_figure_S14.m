function MSsync_figure_S14()
%% Figure S14 (tonic, amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({20170608,45,1,7;20170608,45,1,58;20170608,45,1,74},[306,318],[0,0.0007],[0,0.07]);
savefig(gcf,'Figure_S14_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTT');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end