function plot_property_group(groupIds,prop)
%PLOT_PROPERTY_GROUP Plots one measure of given rhythmicity groups.
%   PLOT_PROPERTY_GROUP(GROUPIDS,PROP) plots given properties of CTB, CTT, 
%   CD, DT, NT, NN in 2D (theta vs delta). Property can be any of the mO 
%   object (related to allCell columns, e.g.: Firing rate during theta vs 
%   delta -> prop = {'thetaFr', 'deltaFr'}).
%   Parameters:
%   GROUPIDS: string, specifying the rhythmicity group (e.g. 'CTB').
%   PROP: 2 element array, containing propertyId pairs (mO map object).

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 30/12/2019

global RESULTDIR

if nargin == 0
    variable_definitions; %groupIds, prop definition
    figure
end

symbols = {'20,[0,114,189]/255,''filled'',''^'',''LineWidth'',1';...
    '20,[76,190,238]/255,''filled'',''d'',''LineWidth'',1';...
    '20,[216,83,25]/255,''filled'',''LineWidth'',1';...
    '20,[119,172,48]/255,''filled'',''p'',''LineWidth'',1';...
    '20,[126,47,142]/255,''x'',''LineWidth'',1';...
    '20,[180,180,180]/255,''filled'',''h'',''LineWidth'',1'};

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

% Load rhythmicity table:
load(fullfile(RESULTDIR,'rhythmic_groups','rhGroups'),'rhGroups');

nCells = [];
for it = 1:length(groupIds)
    rhIndex = find(ismember(rhGroups(:,1),{groupIds{it}})); % find rhythmicity groups index
    if ~isempty(rhIndex)
        inx = get_rhGroup_indices_in_allCell(groupIds{it});
    else
        [~,isDel,rowIds] = get_optoGroup_indices_in_allCell(groupIds{it});
        inx = rowIds(isDel==0);
    end
%     IDs = allCell(inx,mO('animalId'):mO('cellId'));
    thetaData = allCell(inx,mO(prop{1}));
    deltaData = allCell(inx,mO(prop{2}));
    [sColor,symbol,markerSize] = rhgroup_colors(groupIds{it});
    eval(['scatter(thetaData,deltaData,20,sColor,',symbol,');']);
    hold on, axis equal
    nCells = [nCells,erase(groupIds{it},'_'),': ',num2str(length(inx)),', '];
end
lgnd = legend(erase(groupIds,'_'));
set(lgnd,'color','none');

% Control outliers and handle plot:
allPoints = [allCell(:,mO(prop{1}));allCell(:,mO(prop{2}))];
allPoints(isnan(allPoints)) = [];
allPoints = sort(allPoints);
CI = [allPoints(round(length(allPoints)/2/20)),allPoints(end-round(length(allPoints)/2/20))];
xlim(CI), ylim(CI), plot(CI,CI,'k')
comp = get(gca,'children');
set(gca,'children',flipud(comp)) % send the uppermost object behind everybody
title(nCells)
xlabel(prop{1})
ylabel(prop{2})

% Regression
if length(groupIds) == 1
    [R,p] = lincirc_corr2(thetaData,deltaData);
    title(['R: ', num2str(R),', p: ', num2str(p)])
end
end