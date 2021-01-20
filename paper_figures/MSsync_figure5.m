function MSsync_figure5()
% Requires almost all steps from MAIN_ANALYSIS (I-VIII. steps)!
%% figure 5:
ANA_RAT_GLOBALTABLE
example_cells_plot({20100728,4,4,10;20100728,4,4,11;20100728,4,4,13},[1231,1243]);
savefig(gcf,'panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('DT_');
cell_groups(rowIds)
savefig(figure(1),'panelC_1.fig')
savefig(figure(2),'panelC_2.fig')
savefig(figure(3),'panelD.fig')
savefig(figure(4),'panelE.fig')
savefig(figure(5),'panelG_1.fig')
savefig(figure(6),'panelG_2.fig')
close all

%% figure 5 supplement1 (amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({201801082,1,1,5;201801082,1,1,8;201801082,1,1,122},[309,321]);
savefig(gcf,'supp1_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('DT_');
cell_groups(rowIds)
savefig(figure(1),'supp1_panelC_1.fig')
savefig(figure(2),'supp1_panelC_2.fig')
savefig(figure(3),'supp1_panelD.fig')
savefig(figure(4),'supp1_panelE.fig')
savefig(figure(5),'supp1_panelG_1.fig')
savefig(figure(6),'supp1_panelG_2.fig')
close all

%% figure 5 supplement2 (arat):
ANA_RAT_GLOBALTABLE
example_cells_plot({20100728,9,2,7;20100728,9,4,10;20100728,9,4,7},[656,668]);
savefig(gcf,'supp2_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('NT_');
cell_groups(rowIds)
savefig(figure(1),'supp2_panelC_1.fig')
savefig(figure(2),'supp2_panelC_2.fig')
savefig(figure(3),'supp2_panelD.fig')
savefig(figure(4),'supp2_panelE.fig')
savefig(figure(5),'supp2_panelG_1.fig')
savefig(figure(6),'supp2_panelG_2.fig')
close all

%% figure 5 supplement3 (amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({20170608,45,1,2;20170608,45,1,25;20170608,45,1,84},[307,320]);
savefig(gcf,'supp3_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('NT_');
cell_groups(rowIds)
savefig(figure(1),'supp3_panelC_1.fig')
savefig(figure(2),'supp3_panelC_2.fig')
savefig(figure(3),'supp3_panelD.fig')
savefig(figure(4),'supp3_panelE.fig')
savefig(figure(5),'supp3_panelG_1.fig')
savefig(figure(6),'supp3_panelG_2.fig')
close all

%% figure 5 supplement4 (fmouse):
FREE_MOUSE_GLOBALTABLE
example_cells_plot({20161750,5054,2,32;20161750,5054,2,68;20161750,5054,3,65},[858,870]);
savefig(gcf,'supp4_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('NT_');
cell_groups(rowIds)
savefig(figure(1),'supp4_panelC_1.fig')
savefig(figure(2),'supp4_panelC_2.fig')
savefig(figure(3),'supp4_panelD.fig')
savefig(figure(4),'supp4_panelE.fig')
savefig(figure(5),'supp4_panelG_1.fig')
savefig(figure(6),'supp4_panelG_2.fig')
close all

%% figure 5 supplement5 rhythmicity group ratios:
ANA_RAT_GLOBALTABLE
rhGroup_pie({'CTB','CTT','CD_','DT_','NT_','NN_'})
savefig(gcf,'supp5_1.fig'), close
ANA_MOUSE_GLOBALTABLE
rhGroup_pie({'CTB','CTT','CD_','DT_','NT_','NN_'})
savefig(gcf,'supp5_2.fig'), close
FREE_MOUSE_GLOBALTABLE
rhGroup_pie({'CTB','CTT','CD_','DT_','NT_','NN_'})
savefig(gcf,'supp5_3.fig'), close
close all
end