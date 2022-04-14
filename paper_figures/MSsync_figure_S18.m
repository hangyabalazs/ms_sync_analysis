function MSsync_figure_S18()
%%Figure S18: you need to run first SIMULATE_PARAMETER_SPACE for the
%simulation of all the parameter distributions. Than run EXPLORE_PARAMETER_SPACE
%for process results!!

%% Figure S18 (parameter and variance space analysis, model):
%   panelA: parameter space analysis (discrete peak at 60 pA)
%   To rerun simulations: SIMULATE_PARAMETER_SPACE (randomized steps can 
%   produce slightly different results).
% rw1 version:
MODEL_GLOBALTABLE_par
[synchScores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'});
parameter_space_plot([1,7,2],synchScores,Ids)
savefig(gcf,'Figure_S18_panelA_rw1.fig'), close
%   panelB: parameter space analysis (exc. fixed to 60 pA, x axis: conn. rate)
parameter_space_plot([2,7,1],synchScores,Ids);
savefig(gcf,'Figure_S18_panelB_rw1.fig'), close
%   panelC: parameter space analysis (exc. fixed to 60 pA, x axis: syn. weight)
parameter_space_plot([2,1,7],synchScores,Ids);
savefig(gcf,'Figure_S18_panelC_rw1.fig'), close
%   panelD: delay space analysis
MODEL_GLOBALTABLE_delay
[synchScores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'});
parameter_space_plot([2,1,6],synchScores,Ids)
savefig(gcf,'Figure_S18_panelD_rw1.fig')
close all
%   panelE: variance space analysis
MODEL_GLOBALTABLE_var
[synchScores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'});
parameter_space_plot([2,1,4],synchScores,Ids)
savefig(gcf,'Figure_S18_panelE_rw1.fig')
close all
end