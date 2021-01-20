function MSsync_figures(trgtDir)
% This code generates the paper figures (and supplements, tables).
%   For some figures/tables it uses final_analysis results.

if nargin == 0
    trgtDir = 'D:\MSsync_paper_figures_test';
end

%% Figure1:
mkdir(fullfile(trgtDir,'FIGURE1'))
cd(fullfile(trgtDir,'FIGURE1'));
MSsync_figure1;
%% Figure2:
mkdir(fullfile(trgtDir,'FIGURE2'))
cd(fullfile(trgtDir,'FIGURE2'));
MSsync_figure2;
%% Figure3:
mkdir(fullfile(trgtDir,'FIGURE3'))
cd(fullfile(trgtDir,'FIGURE3'));
MSsync_figure3;
%% Figure4:
mkdir(fullfile(trgtDir,'FIGURE4'))
cd(fullfile(trgtDir,'FIGURE4'));
MSsync_figure4;
%% Figure5:
mkdir(fullfile(trgtDir,'FIGURE5'))
cd(fullfile(trgtDir,'FIGURE5'));
MSsync_figure5;
%% Figure6:
mkdir(fullfile(trgtDir,'FIGURE6'))
cd(fullfile(trgtDir,'FIGURE6'));
MSsync_figure6;
%% Figure7:
mkdir(fullfile(trgtDir,'FIGURE7'))
cd(fullfile(trgtDir,'FIGURE7'));
MSsync_figure7;
%% Figure8:
mkdir(fullfile(trgtDir,'FIGURE8'))
cd(fullfile(trgtDir,'FIGURE8'));
MSsync_figure8;
%% Figure9:
mkdir(fullfile(trgtDir,'FIGURE9'))
cd(fullfile(trgtDir,'FIGURE9'));
MSsync_figure9;
%% Supplement tables 1,2
mkdir(fullfile(trgtDir,'SUPP_TABLES'))
cd(fullfile(trgtDir,'SUPP_TABLES'));
MSsync_supp_tables;

%Convert figs to png:
convert_all_figs(trgtDir,'','png',true);
end