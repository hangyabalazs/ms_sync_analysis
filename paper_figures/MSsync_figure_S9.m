function MSsync_figure_S9()
%% Figure(3) S9 (theta follower, fmouse):
FREE_MOUSE_GLOBALTABLE
example_cells_plot({20161750,5054,2,32;20161750,5054,2,68;20161750,5054,3,65},[858,870],[0,0.0003],[0,0.1]);
savefig(gcf,'Figure_S9_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('NT_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end