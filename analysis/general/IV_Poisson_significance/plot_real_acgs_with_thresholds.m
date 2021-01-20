function plot_real_acgs_with_thresholds(segm,issave)
%PLOT_REAL_ACGS_WITH_THRESHOLDS Plots all MS unit acgs.
%   PLOT_REAL_ACGS_WITH_THRESHOLDS(SEGM,ISSAVE) plots sorted acgs of MS 
%   units during the specified state (theta or delta) with the rhythmicity
%   thresholds.
%   Parameters:
%   SEGM: which acgs to display ('theta' or 'delta')
%   ISSAVE: optional, flag, save? 
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, CELL_RHYTHMICITY,
%   COMPUTE_INDEX_TRESHOLDS, IMAGECCGS, PLOT_REAL_ACGS_WITH_THRESHOLDS2.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/08/2018

global RESULTDIR
global NSR
global CGWINDOW
global THSUMACGTRESH
global DESUMACGTRESH

if nargin == 0
    variable_definitions; %segm,(issave) definitions
end

% load allCell matrix:
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','indexTresholds.mat'));

if strcmp(segm, 'delta')
    th1 = deltaThInxtrsh;
    th2 = deltaDeInxtrsh;
    ThParCol = mO('DeAcgThInx'); % column of theta index
    DeParCol = mO('DeAcgDeInx'); % column of delta index
    sumacrcol = mO('desumacr'); % column of acg integrate
    acgInxFirst = mO('deltaAcgFirst'); % starting column of ACG
    acgInxLast = mO('deltaAcgLast'); % last column of ACG
    sumacrtresh = DESUMACGTRESH;
end
if strcmp(segm, 'theta')
    th1 = thetaThInxtrsh;
    th2 = thetaDeInxtrsh;
    ThParCol = mO('ThAcgThInx'); % column of theta index
    DeParCol = mO('ThAcgDeInx'); % column of delta index
    sumacrcol = mO('thsumacr'); % column of acg integrate
    acgInxFirst = mO('thetaAcgFirst'); % starting column of ACG
    acgInxLast = mO('thetaAcgLast'); % last column of ACG
    sumacrtresh = THSUMACGTRESH;
end

% Mark acg-s with non-sufficient amount of data:
noisyRows = (allCell(:,sumacrcol)<sumacrtresh);
allCell(noisyRows,:) = []; %delete

% Order acgs based on rhythmicity indices
allCell(allCell(:,ThParCol)<0,ThParCol) = 0;
allCell(allCell(:,DeParCol)<0,DeParCol) = 0;
indQuotient = [allCell(:,ThParCol)/th1,allCell(:,DeParCol)/th2];
[maxRatios,ids] = max(indQuotient.');
% more positive: more theta rhythmic, more negative (id=2): more delta rhythmic
maxRatios(ids==2) = -maxRatios(ids == 2); 
[sMaxRatios,sortIds] = sort(maxRatios);

figure;
imageccgs(allCell,acgInxFirst:acgInxLast,sortIds);
w = NSR*CGWINDOW; % window in msec

% Find last rhythmic row in sorted matrix
thTresh = find(sMaxRatios>1,1,'first');
deTresh = max([find(sMaxRatios<-1,1,'last'),0]);
hold on; plot([0,w*2],[thTresh+0.5,thTresh+0.5],'b','LineWidth',2); % theta threshold
plot([0,w*2], [deTresh+0.5,deTresh+0.5],'r','LineWidth',2); % delta threshold
xticks = [1,w/3,w/1.5,w/1.2,w,7*w/6,4*w/3,5*w/3,w*2];
xlabels = {-w,-w*2/3,-w/3,-w/6,0,w/6,w/3,w*2/3,w};
set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
set(gca,'xlim',[(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]) % limit between +/-2 sec

% Save
if exist('issave','var')
    savefig(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds',['real_acgs_',segm]));
    close
end

end