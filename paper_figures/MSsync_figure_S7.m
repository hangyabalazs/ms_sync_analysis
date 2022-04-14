function MSsync_figure_S7()
%% Figure(3) S7 (follower, amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({201801082,1,1,5;201801082,1,1,8;201801082,1,1,122},[309,321],[0,0.0005],[0,0.15]);
savefig(gcf,'Figure_S7_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('DT_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end