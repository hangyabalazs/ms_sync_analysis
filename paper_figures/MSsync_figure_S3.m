function MSsync_figure_S3()
%% Figure(2) S3 (arat):
ANA_RAT_GLOBALTABLE
%   panel A,B: calculation of theta and delta indices
cell_rhythmicity('20100728','4',4,11);
xlim([0,3000])
savefig(gcf,'Figure_S3_panelAB.fig')
close all
%   panel C: distribution of theta and delta indices during theta and
%   non-theta
compute_index_thresholds('isPlot',true,'issave',false);
figure(1)
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'), 'allCell');
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'), 'mO'); 
allCell(allCell(:,mO('thsumacr'))<THSUMACGTRESH,:) = [];
hold on, plot(allCell(:,mO('ThAcgThInx')),allCell(:,mO('ThAcgDeInx')),'.','Color',[0.5,0.5,0.5],'MarkerSize',7)
savefig(figure(1),'Figure_S3_panelC_1.fig'), 
figure(2)
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'), 'allCell');
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'), 'mO'); 
allCell(allCell(:,mO('desumacr'))<DESUMACGTRESH,:) = [];
hold on, plot(allCell(:,mO('DeAcgThInx')),allCell(:,mO('DeAcgDeInx')),'.','Color',[0.5,0.5,0.5],'MarkerSize',7)
savefig(figure(2),'Figure_S3_panelC_2.fig')
%   panel D: all cells' acgs during theta and non-theta
plot_real_acgs_with_thresholds('theta');
savefig(gcf,'Figure_S3_panelD_1.fig')
plot_real_acgs_with_thresholds('delta');
savefig(gcf,'Figure_S3_panelD_2.fig')
close all
end