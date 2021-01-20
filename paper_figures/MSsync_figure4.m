function MSsync_figure4()
% Requires almost all steps from MAIN_ANALYSIS (I-VIII. steps)!
%% figure 4:
ANA_RAT_GLOBALTABLE
example_cells_plot({20100304,2,1,4;20100304,2,1,3;20100304,2,2,3},[679,691]);
savefig(gcf,'panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTT');
cell_groups(rowIds)
savefig(figure(1),'panelC_1.fig')
savefig(figure(2),'panelC_2.fig')
savefig(figure(3),'panelD.fig')
savefig(figure(4),'panelE.fig')
savefig(figure(5),'panelG_1.fig')
savefig(figure(6),'panelG_2.fig')
close all

%% figure 4 supplement1 pacemaker vs. tonic separation:
%   panelA: arat
ANA_RAT_GLOBALTABLE
CTB_vs_CTT
savefig(figure(1),'supp1_panelA_1.fig')
savefig(figure(2),'supp1_panelA_2.fig')
savefig(figure(3),'supp1_panelA_3.fig')
close all
%   panelB: example cells (arat)
%example1
cell_rhythmicity('20100728','5',4,13);
xlim([-1000,1000])
savefig(gcf,'supp1_panelB_1_1.fig'), close
ISI(find_rowIds('20100728','5',4,13));
savefig(gcf,'supp1_panelB_1_2.fig'), close
%example2
cell_rhythmicity('20100304','1',1,5);
xlim([-1000,1000])
savefig(gcf,'supp1_panelB_2_1.fig'), close
ISI(find_rowIds('20100304','1',1,5));
savefig(gcf,'supp1_panelB_2_2.fig'), close
%example3
cell_rhythmicity('20100805','4',4,8);
xlim([-1000,1000])
savefig(gcf,'supp1_panelB_3_1.fig'), close
ISI(find_rowIds('20100805','4',4,8));
savefig(gcf,'supp1_panelB_3_2.fig'), close
plot_hippo_and_cells('20100805','4',[4],[8],32,[570.3,570.45])
savefig(gcf,'supp1_panelB_3_3.fig'), close

ANA_MOUSE_GLOBALTABLE
CTB_vs_CTT
savefig(figure(1),'supp1_panelC_1.fig')
savefig(figure(2),'supp1_panelC_2.fig')
savefig(figure(3),'supp1_panelC_3.fig')
close all
FREE_MOUSE_GLOBALTABLE
CTB_vs_CTT
savefig(figure(1),'supp1_panelD_1.fig')
savefig(figure(2),'supp1_panelD_2.fig')
savefig(figure(3),'supp1_panelD_3.fig')
close all

%% figure 4 supplement2 (amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({20170608,45,1,7;20170608,45,1,58;20170608,45,1,74},[306,318]);
savefig(gcf,'supp2_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTT');
cell_groups(rowIds)
savefig(figure(1),'supp2_panelC_1.fig')
savefig(figure(2),'supp2_panelC_2.fig')
savefig(figure(3),'supp2_panelD.fig')
savefig(figure(4),'supp2_panelE.fig')
savefig(figure(5),'supp2_panelG_1.fig')
savefig(figure(6),'supp2_panelG_2.fig')
close all

%% figure 4 supplement3 (fmouse):
FREE_MOUSE_GLOBALTABLE
example_cells_plot({20161989,139140,3,19;20161989,139140,3,59;20161989,139140,3,66},[1247.9,1259.9]);
savefig(gcf,'supp3_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTT');
cell_groups(rowIds)
savefig(figure(1),'supp3_panelC_1.fig')
savefig(figure(2),'supp3_panelC_2.fig')
savefig(figure(3),'supp3_panelD.fig')
savefig(figure(4),'supp3_panelE.fig')
savefig(figure(5),'supp3_panelG_1.fig')
savefig(figure(6),'supp3_panelG_2.fig')
close all
end