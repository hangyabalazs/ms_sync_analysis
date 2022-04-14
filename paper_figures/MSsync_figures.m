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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure S1:
mkdir(fullfile(trgtDir,'FIGURE_S1'))
cd(fullfile(trgtDir,'FIGURE_S1'));
MSsync_figure_S1;
%% Figure S2:
mkdir(fullfile(trgtDir,'FIGURE_S2'))
cd(fullfile(trgtDir,'FIGURE_S2'));
MSsync_figure_S2;
%% Figure S3:
mkdir(fullfile(trgtDir,'FIGURE_S3'))
cd(fullfile(trgtDir,'FIGURE_S3'));
MSsync_figure_S3;
%% Figure S4:
mkdir(fullfile(trgtDir,'FIGURE_S4'))
cd(fullfile(trgtDir,'FIGURE_S4'));
MSsync_figure_S4;
%% Figure S5:
mkdir(fullfile(trgtDir,'FIGURE_S5'))
cd(fullfile(trgtDir,'FIGURE_S5'));
MSsync_figure_S5;
%% Figure S6:
mkdir(fullfile(trgtDir,'FIGURE_S6'))
cd(fullfile(trgtDir,'FIGURE_S6'));
MSsync_figure_S6;
%% Figure S7:
mkdir(fullfile(trgtDir,'FIGURE_S7'))
cd(fullfile(trgtDir,'FIGURE_S7'));
MSsync_figure_S7;
%% Figure S8:
mkdir(fullfile(trgtDir,'FIGURE_S8'))
cd(fullfile(trgtDir,'FIGURE_S8'));
MSsync_figure_S8;
%% Figure S9:
mkdir(fullfile(trgtDir,'FIGURE_S9'))
cd(fullfile(trgtDir,'FIGURE_S9'));
MSsync_figure_S9;
%% Figure S10:
mkdir(fullfile(trgtDir,'FIGURE_S10'))
cd(fullfile(trgtDir,'FIGURE_S10'));
MSsync_figure_S10;
%% Figure S11:
mkdir(fullfile(trgtDir,'FIGURE_S11'))
cd(fullfile(trgtDir,'FIGURE_S11'));
MSsync_figure_S11;
%% Figure S12:
mkdir(fullfile(trgtDir,'FIGURE_S12'))
cd(fullfile(trgtDir,'FIGURE_S12'));
MSsync_figure_S12;
%% Figure S13:
mkdir(fullfile(trgtDir,'FIGURE_S13'))
cd(fullfile(trgtDir,'FIGURE_S13'));
MSsync_figure_S13;
%% Figure S14:
mkdir(fullfile(trgtDir,'FIGURE_S14'))
cd(fullfile(trgtDir,'FIGURE_S14'));
MSsync_figure_S14;
%% Figure S15:
mkdir(fullfile(trgtDir,'FIGURE_S15'))
cd(fullfile(trgtDir,'FIGURE_S15'));
MSsync_figure_S15;
%% Figure S16:
mkdir(fullfile(trgtDir,'FIGURE_S16'))
cd(fullfile(trgtDir,'FIGURE_S16'));
MSsync_figure_S16;
%% Figure S17:
mkdir(fullfile(trgtDir,'FIGURE_S17'))
cd(fullfile(trgtDir,'FIGURE_S17'));
MSsync_figure_S17;
%% Figure S18:
mkdir(fullfile(trgtDir,'FIGURE_S18'))
cd(fullfile(trgtDir,'FIGURE_S18'));
MSsync_figure_S18;
%% Figure S19:
mkdir(fullfile(trgtDir,'FIGURE_S19'))
cd(fullfile(trgtDir,'FIGURE_S19'));
MSsync_figure_S19;
%% Figure S20:
mkdir(fullfile(trgtDir,'FIGURE_S20'))
cd(fullfile(trgtDir,'FIGURE_S20'));
MSsync_figure_S20;
%% Figure S21:
mkdir(fullfile(trgtDir,'FIGURE_S21'))
cd(fullfile(trgtDir,'FIGURE_S21'));
MSsync_figure_S21;
%% Figure S22:
mkdir(fullfile(trgtDir,'FIGURE_S22'))
cd(fullfile(trgtDir,'FIGURE_S22'));
MSsync_figure_S22;
%% Figure S23:
mkdir(fullfile(trgtDir,'FIGURE_S23'))
cd(fullfile(trgtDir,'FIGURE_S23'));
MSsync_figure_S23;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure R1:
mkdir(fullfile(trgtDir,'FIGURE_R1'))
cd(fullfile(trgtDir,'FIGURE_R1'));
MSsync_figure_R1;

%% Supplement tables 1,2
mkdir(fullfile(trgtDir,'SUPP_TABLES'))
cd(fullfile(trgtDir,'SUPP_TABLES'));
MSsync_supp_tables;

% Convert figs to png:
convert_all_figs(trgtDir,'','png',true);
end