function MSsync_figure_S13()
%% Figure S13 (pacemaker vs. tonic):
%   panelA: arat
ANA_RAT_GLOBALTABLE
CTB_vs_CTT
savefig(figure(1),'Figure_S13_panelA_1.fig')
savefig(figure(2),'Figure_S13_panelA_2.fig')
savefig(figure(3),'Figure_S13_panelA_3.fig')
close all
%   panelB: example cells (arat)
%example1
cell_rhythmicity('20100728','5',4,13);
xlim([-1000,1000])
savefig(gcf,'Figure_S13_panelB_1_1.fig'), close
ISI(find_rowIds('20100728','5',4,13));
savefig(gcf,'Figure_S13_panelB_1_2.fig'), close
%example2
cell_rhythmicity('20100304','1',1,5);
xlim([-1000,1000])
savefig(gcf,'Figure_S13_panelB_2_1.fig'), close
ISI(find_rowIds('20100304','1',1,5));
savefig(gcf,'Figure_S13_panelB_2_2.fig'), close
%example3
cell_rhythmicity('20100805','4',4,8);
xlim([-1000,1000])
savefig(gcf,'Figure_S13_panelB_3_1.fig'), close
ISI(find_rowIds('20100805','4',4,8));
savefig(gcf,'Figure_S13_panelB_3_2.fig'), close
plot_hippo_and_cells('20100805','4',[4],[8],32,[570.3,570.45])
savefig(gcf,'Figure_S13_panelB_3_3.fig'), close

ANA_MOUSE_GLOBALTABLE
CTB_vs_CTT
savefig(figure(1),'Figure_S13_panelC_1.fig')
savefig(figure(2),'Figure_S13_panelC_2.fig')
savefig(figure(3),'Figure_S13_panelC_3.fig')
close all
FREE_MOUSE_GLOBALTABLE
CTB_vs_CTT
savefig(figure(1),'Figure_S13_panelD_1.fig')
savefig(figure(2),'Figure_S13_panelD_2.fig')
savefig(figure(3),'Figure_S13_panelD_3.fig')
close all
end