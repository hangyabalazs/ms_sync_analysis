function plot_real_acgs_with_thresholds2(varargin)
%PLOT_REAL_ACGS_WITH_THRESHOLDS2 Plots sorted acgs of MS units.
%   PLOT_REAL_ACGS_WITH_THRESHOLDS2(SEGM,ISTEXT,ISSAVE) compares all cell's
%   rhythmicities during theta and delta.
%   Parameters:
%   SEGM: which acgs to display ('theta' or 'delta')
%   ISTEXT: logical, optional, whether to write or not cell IDs on plots.
%   ISSAVE: optional, flag, save?
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, CELL_RHYTHMICITY,
%   COMPUTE_INDEX_TRESHOLDS, IMAGECCGS, PLOT_REAL_ACGS_WITH_THRESHOLDS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global NSR
global CGWINDOW
global THSUMACGTRESH
global DESUMACGTRESH

%Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p,'segm','theta',@ischar);
addParameter(p,'istext',false,@islogical);
addParameter(p,'issave',false,@islogical);
parse(p,varargin{:});

segm = p.Results.segm;
istext = p.Results.istext;
issave = p.Results.issave;

if nargin == 0
    variable_definitions; %(segm, istext, issave) definitions
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Load thresholds:
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','indexTresholds'));

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

% Plot
sortedCell1 = allCell;
sortedCell1(sortedCell1(:,sumacrcol)<sumacrtresh,:) = []; % filter noisy acgs
[sortedCell1, sortinxes1] = sortrows(sortedCell1,ThParCol); % sort based on theta index

figure;
subplot(1,3,1);
a1 = gca;
imageccgs(sortedCell1(:,acgInxFirst:acgInxLast)); % plot all theta acgs
w = NSR * CGWINDOW; % window in msec
xticks = [1,w/3,w/1.5,w/1.2,w,7*w/6,4*w/3,5*w/3,w*2];
xlabels = {-w,-w*2/3,-w/3,-w/6,0,w/6,w/3,w*2/3,w};
set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
set(gca,'xlim',[(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]) % limit between +/-2 sec

dist = sortedCell1(:,ThParCol) - th1;
ix = length(dist(dist<=0));
hold on; plot([0,le],[ix+0.5,ix+0.5],'r');
if exist('istext','var')    
    text(zeros(1,size(sortedCell1,1)),[1:size(sortedCell1,1)], ...
        num2str(sortedCell1(:,[mO('animalId'),mO('recordingId'),mO('shankId'),mO('cellId')])));
    text(ones(1, size(sortedCell1,1))*(le-100),[1:size(sortedCell1,1)],num2str(sortedCell1(:,ThParCol)));
end
title('Theta index based');


[sortedCell2, sortinxes2] = sortrows(sortedCell1,DeParCol); % sort based on delta index

subplot(1,3,3);
a2 = gca;
imageccgs(sortedCell2(:,acgInxFirst:acgInxLast)); % plot all theta acgs
set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
set(gca,'xlim',[(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]) % limit between +/-2 sec
% title(['sorted, based on ThAcgDeEnergy, thresh: ' num2str(DeEnth)])
dist = sortedCell2(:,DeParCol) - th2;
ix = length(dist(dist<=0));
hold on; plot([0,le],[ix+0.5,ix+0.5],'r');
if istext
    text(zeros(1,size(sortedCell2,1)),[1:size(sortedCell2, 1)],...
        num2str(sortedCell2(:,[mO('animalId'),mO('recordingId'),mO('shankId'),mO('cellId')])));
    text(ones(1,size(sortedCell2,1))*(le-100),[1:size(sortedCell2,1)],num2str(sortedCell2(:,DeParCol)));
end
title('Delta index');

x1 = ones(1,length(sortinxes1(:,1)));
x2 = ones(1,length(sortinxes2(:,1)))*le;
subplot(1,3,2);
a3 = gca;
set(a3,'Ydir','reverse');
line([x1; x2],[sortinxes2';[1:length(sortinxes1)]]);

if istext
    text(ones(1,size(sortinxes1,1))*2,sortinxes2,num2str(abs(flipud([1:length(sortinxes1)])-sortinxes2')'));
end
linkaxes([a1,a2,a3]);

% Save
if exist('issave','var')
    savefig(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds',['real_acgs_2_',segm]));
    close
end

end