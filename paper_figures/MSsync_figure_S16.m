function MSsync_figure_S16()
%% Figure S16 (rhythmicity group ratios):
ANA_RAT_GLOBALTABLE
rhGroup_pie({'CTB','CTT','CD_','DT_','NT_','NN_'})
savefig(gcf,'Figure_S16_1.fig'), close
ANA_MOUSE_GLOBALTABLE
rhGroup_pie({'CTB','CTT','CD_','DT_','NT_','NN_'})
savefig(gcf,'Figure_S16_2.fig'), close
FREE_MOUSE_GLOBALTABLE
rhGroup_pie({'CTB','CTT','CD_','DT_','NT_','NN_'})
savefig(gcf,'Figure_S16_3.fig'), close
close all
end