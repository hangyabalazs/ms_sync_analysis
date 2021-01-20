function MSsync_figure2()
% Requires almost all steps from MAIN_ANALYSIS (I-VIII. steps)!

%% figure 2:
ANA_RAT_GLOBALTABLE
example_cells_plot({20100728,3,4,5;20100728,3,4,9;20100728,3,4,10},[1284,1296]);
savefig(gcf,'panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTB');
cell_groups(rowIds)
savefig(figure(1),'panelC_1.fig')
savefig(figure(2),'panelC_2.fig')
savefig(figure(3),'panelD.fig')
savefig(figure(4),'panelE.fig')
savefig(figure(5),'panelG_1.fig')
savefig(figure(6),'panelG_2.fig')
close all

%% figure 2 supplement1 (arat):
%   panel A,B: calculation of theta and delta indices
cell_rhythmicity('20100728','4',4,11);
xlim([0,3000])
savefig(figure(6),'supp1_panelAB.fig')
close all
%   panel C: distribution of theta and delta indices during theta and
%   non-theta
compute_index_thresholds('isPlot',true,'issave',false);
figure(1)
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'), 'allCell');
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'), 'mO'); 
allCell(allCell(:,mO('thsumacr'))<THSUMACGTRESH,:) = [];
hold on, plot(allCell(:,mO('ThAcgThInx')),allCell(:,mO('ThAcgDeInx')),'.','Color',[0.5,0.5,0.5],'MarkerSize',7)
savefig(figure(1),'supp1_panelC_1.fig'), 
figure(2)
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'), 'allCell');
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'), 'mO'); 
allCell(allCell(:,mO('desumacr'))<DESUMACGTRESH,:) = [];
hold on, plot(allCell(:,mO('DeAcgThInx')),allCell(:,mO('DeAcgDeInx')),'.','Color',[0.5,0.5,0.5],'MarkerSize',7)
savefig(figure(2),'supp1_panelC_2.fig')
%   panel D: all cells' acgs during theta and non-theta
plot_real_acgs_with_thresholds('theta');
savefig(gcf,'supp1_panelD_1.fig')
plot_real_acgs_with_thresholds('delta');
savefig(gcf,'supp1_panelD_2.fig')
close all

%% figure 2 supplement2 (amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({20171208,12,1,55;20171208,12,1,69;20171208,12,1,171},[321,333]);
savefig(gcf,'supp2_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTB');
cell_groups(rowIds)
savefig(figure(1),'supp2_panelC_1.fig')
savefig(figure(2),'supp2_panelC_2.fig')
savefig(figure(3),'supp2_panelD.fig')
savefig(figure(4),'supp2_panelE.fig')
savefig(figure(5),'supp2_panelG_1.fig')
savefig(figure(6),'supp2_panelG_2.fig')
close all

%% figure 2 supplement3 (fmouse):
FREE_MOUSE_GLOBALTABLE
example_cells_plot({20161695,1824,4,3;20161695,1824,4,22;20161695,1824,4,65},[226,238]);
savefig(gcf,'supp3_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTB');
cell_groups(rowIds)
savefig(figure(1),'supp3_panelC_1.fig')
savefig(figure(2),'supp3_panelC_2.fig')
savefig(figure(3),'supp3_panelD.fig')
savefig(figure(4),'supp3_panelE.fig')
savefig(figure(5),'supp3_panelG_1.fig')
savefig(figure(6),'supp3_panelG_2.fig')
close all
end