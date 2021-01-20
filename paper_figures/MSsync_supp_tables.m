function MSsync_supp_tables

%% supplement table 1: #rhythmic cells:
ANA_RAT_GLOBALTABLE
[nElems,pers] = rhgrp_elems();
xlswrite('supp_table1_1.xlsx',[[nElems;sum(nElems)],round([pers;sum(pers)]*100,1)]);
ANA_MOUSE_GLOBALTABLE
[nElems,pers] = rhgrp_elems();
xlswrite('supp_table1_2.xlsx',[[nElems;sum(nElems)],round([pers;sum(pers)]*100,1)]);
FREE_MOUSE_GLOBALTABLE
[nElems,pers] = rhgrp_elems();
xlswrite('supp_table1_3.xlsx',[[nElems;sum(nElems)],round([pers;sum(pers)]*100,1)]);

%% supplement table 2: pacemaker synchronization statistics:
clear all
resPaths = {'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
    'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
    'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\MODEL\analysis\final_analysis\PACEMAKER_SYNCH'};
signRanks = plot_synchronization_theories(resPaths); close all
% pooled data statistics in the 5th column, and model is in the 4th ->
% exchange them:
signRanks = signRanks(:,[1,2,3,5,4]);
xlswrite('supp_table2.xlsx',signRanks);
end