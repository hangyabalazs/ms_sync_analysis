function CTB_vs_CTT()
%CTB_VS_CTT Pacemaker vs. tonic theta cells separation.
%   CTB_VS_CTT demonstrates pacemaker (CTB) vs. tonic (CTT) group separation
%   based on burst index computed from theta acg (CELL_RHYTHMICITY). It also
%   shows the different rhythmicity frequencies.
%
%   See also GENERATE_RH_GROUPS, RHYTHMICITY_FREQUENCIES.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/09/2020

global RESULTDIR
global NSR

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Scatter plot:
figure, hold on
% Pacemakers:
CTBs = get_rhGroup_indices_in_allCell('CTB');
[sColor,symbol] = rhgroup_colors('CTB');
thFrCTBs = NSR./rhythmicity_frequencies(CTBs);
burstInxCTBs = allCell(CTBs,mO('thetaBurstInx'));
eval(['scatter(thFrCTBs,burstInxCTBs,20,sColor,',symbol,')'])
% Tonic:
CTTs = get_rhGroup_indices_in_allCell('CTT');
[sColor,symbol] = rhgroup_colors('CTT');
thFrCTTs = NSR./rhythmicity_frequencies(CTTs);
burstInxCTTs = allCell(CTTs,mO('thetaBurstInx'));
eval(['scatter(thFrCTTs,burstInxCTTs,20,sColor,',symbol,')'])

xlabel('Rhythmicity frequency (Hz, theta)')
ylabel('Burst index (theta)')

% Boxplot:
figure('Position',[100,100,180,270])
boxplot([thFrCTBs;thFrCTTs],[zeros(numel(thFrCTBs),1);ones(numel(thFrCTTs),1)],...
    'Labels',{'CTB','CTT'},'Colors','k','Widths',2/3,'symbol','');
ylabel('Rhythmicity frequency (Hz, theta)')
figure('Position',[400,100,180,270])
boxplot([burstInxCTBs;burstInxCTTs],[zeros(numel(burstInxCTBs),1);ones(numel(burstInxCTTs),1)],...
    'Labels',{'CTB','CTT'},'Colors','k','Widths',2/3,'symbol','');
ylabel('Burst index (theta)')
end