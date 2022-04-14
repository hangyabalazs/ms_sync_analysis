function MSsync_figure_S5()
%% Figure(2) S5 (pacamakers, fmouse):
FREE_MOUSE_GLOBALTABLE
example_cells_plot({20161695,1824,4,3;20161695,1824,4,22;20161695,1824,4,65},[226,238],[0,0.00055],[0,0.12]);
savefig(gcf,'Figure_S5_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTB');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end