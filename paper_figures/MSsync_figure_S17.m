function MSsync_figure_S17()
%% Figure S17:
% panel A: arat ccg of rh groups
ANA_RAT_GLOBALTABLE
plot_ccg_network();
savefig(gcf,'Figure_S17.fig'), close all

% panel B, C: arat ccg scores during delta, theta
% = Figure R7
[pTh,pDe] = ccg_score_test({{'CTB','CTB'},{'CTT','CTT'},{'DT_','DT_'},{'CTB','CTT'},{'CTB','DT_'},{'CTT','DT_'}});
savefig(figure(2),'Figure_S17_22_B.fig')
savefig(figure(1),'Figure_S17_22_C.fig')
close all
end