function MSsync_figure_S4()
%% Figure(2) S4 (pacemakers, amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({20171208,12,1,55;20171208,12,1,69;20171208,12,1,171},[321,333],[0,0.0004],[0,0.12]);
savefig(gcf,'Figure_S4_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTB');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end