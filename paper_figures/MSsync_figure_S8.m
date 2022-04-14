function MSsync_figure_S8()
%% Figure(3) S8 (theta follower, amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({20170608,45,1,2;20170608,45,1,25;20170608,45,1,84},[307,320],[0,0.0006],[0,0.09]);
savefig(gcf,'Figure_S8_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('NT_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end