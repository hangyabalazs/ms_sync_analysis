function MSsync_figure_R1()
%% Figure R1 (change of ccgs between pacemakers, arat)
% states: theta (first 5 s), theta (last 5 s), non-theta
ANA_RAT_GLOBALTABLE
ccg_change('20100728','5',[4,4],[3,13],5,7,[])
limits=[-500,500]; xlim(limits),set(gca, 'xtick', [limits(1),mean(limits),limits(2)]);set(gca, 'xticklabel', {limits(1),'',limits(2)})
limits=[0,3e-3];ylim(limits),set(gca, 'ytick', [limits(1),limits(2)/2,limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs
savefig(gcf,['Figure_R1_1.fig']);
close

ccg_change('20100728','5',[4,4],[8,13],5,7,[])
limits=[-500,500]; xlim(limits),set(gca, 'xtick', [limits(1),mean(limits),limits(2)]);set(gca, 'xticklabel', {limits(1),'',limits(2)})
limits=[0,3e-3];ylim(limits),,set(gca, 'ytick', [limits(1),limits(2)/2,limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs
savefig(gcf,['Figure_R1_2.fig']);
close

ccg_change('20100728','3',[4,4],[9,10],5,7,[])
limits=[-500,500]; xlim(limits),set(gca, 'xtick', [limits(1),mean(limits),limits(2)]);set(gca, 'xticklabel', {limits(1),'',limits(2)})
limits=[0,3e-3];ylim(limits),,set(gca, 'ytick', [limits(1),limits(2)/2,limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs
savefig(gcf,['Figure_R1_3.fig']);
close

ccg_change('20100728','6',[4,4],[6,8],10,7,[])
limits=[-500,500]; xlim(limits),set(gca, 'xtick', [limits(1),mean(limits),limits(2)]);set(gca, 'xticklabel', {limits(1),'',limits(2)})
limits=[0,3e-3];ylim(limits),,set(gca, 'ytick', [limits(1),limits(2)/2,limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs
savefig(gcf,['Figure_R1_4.fig']);
close all
end