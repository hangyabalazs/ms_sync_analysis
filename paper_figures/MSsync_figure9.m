function MSsync_figure9
% Requires almost all steps from MAIN_ANALYSIS (I-X. steps)!
%% figure 9:
OPTO_GLOBALTABLE
%   panel A-H: PV
example_cells_plot({20180821,1,4,23},[296,308]);
savefig(gcf,'panelABCG.fig'), close all
rowIds = get_optoGroup_indices_in_allCell('PVR');
cell_groups(rowIds)
savefig(figure(1),'panelD_1.fig')
savefig(figure(2),'panelD_2.fig')
savefig(figure(3),'panelE.fig')
savefig(figure(4),'panelF.fig')
savefig(figure(5),'panelH_1.fig')
savefig(figure(6),'panelH_2.fig')
close all
rhythmicity_bar(rowIds,true);
savefig(gcf,'panelD_0.fig'), close

%   panel I-P: VGAT
example_cells_plot({20190512,5,3,34},[298,310]);
savefig(gcf,'panelIJKO.fig'), close all
rowIds = get_optoGroup_indices_in_allCell('VGA');
cell_groups(rowIds)
savefig(figure(1),'panelL_1.fig')
savefig(figure(2),'panelL_2.fig')
savefig(figure(3),'panelM.fig')
savefig(figure(4),'panelN.fig')
savefig(figure(5),'panelP_1.fig')
savefig(figure(6),'panelP_2.fig')
close all
rhythmicity_bar(rowIds,true);
savefig(gcf,'panelL_0.fig'), close

%   panel Q-X: VGLUT
example_cells_plot({20190510,6,4,65},[270,282]);
savefig(gcf,'panelQRSW.fig'), close all
rowIds = get_optoGroup_indices_in_allCell('VGL');
cell_groups(rowIds)
savefig(figure(1),'panelT_1.fig')
savefig(figure(2),'panelT_2.fig')
savefig(figure(3),'panelU.fig')
savefig(figure(4),'panelW.fig')
savefig(figure(5),'panelX_1.fig')
savefig(figure(6),'panelX_2.fig')
close all
rhythmicity_bar(rowIds,true);
savefig(gcf,'panelT_0.fig'), close
end