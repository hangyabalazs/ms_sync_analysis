function MSsync_figure_S15()
%% Figure S15 (tonic, fmouse):
FREE_MOUSE_GLOBALTABLE
example_cells_plot({20161989,139140,3,19;20161989,139140,3,59;20161989,139140,3,66},[1247.9,1259.9],[0,0.00045],[0,0.08]);
savefig(gcf,'Figure_S15_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTT');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end