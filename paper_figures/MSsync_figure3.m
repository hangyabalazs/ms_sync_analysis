function MSsync_figure3()
% Requires almost all steps from MAIN_ANALYSIS (I-VIII. steps)!
%% figure 3:
ANA_RAT_GLOBALTABLE
 example_cells_plot({20100616,9,2,2;20100616,9,2,4;20100616,9,3,8},[832,844]);
savefig(gcf,'panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CD_');
cell_groups(rowIds)
savefig(figure(1),'panelC_1.fig')
savefig(figure(2),'panelC_2.fig')
savefig(figure(3),'panelD.fig')
savefig(figure(4),'panelE.fig')
savefig(figure(5),'panelG_1.fig')
savefig(figure(6),'panelG_2.fig')
close all

%% figure 3 supplement1 (amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({201801082,1,1,21;201801082,1,1,79;201801082,1,1,85},[311,323]);
savefig(gcf,'supp1_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CD_');
cell_groups(rowIds)
savefig(figure(1),'supp1_panelC_1.fig')
savefig(figure(2),'supp1_panelC_2.fig')
savefig(figure(3),'supp1_panelD.fig')
savefig(figure(4),'supp1_panelE.fig')
savefig(figure(5),'supp1_panelG_1.fig')
savefig(figure(6),'supp1_panelG_2.fig')
close all
end