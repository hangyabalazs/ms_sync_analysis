function opto_rh_group()
%OPTO_RH_GROUP helps to visualize the distribution of 5 rhythmicity groups
%in the 3 types of tagged neurons (PV+,GABA,glutamate).
%
%   See also MAIN_ANALYSIS, GET_RHGROUP_INDICES_IN_ALLCELL_OPTO.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 26/05/2021

global RESULTDIR

% ID lists:
optoGroups = {'PVR','VGA','VGL'}; % 3 types of tagged neurons
% 5 types of rhythmic neurons (pacemakers, theta followers, followers,
% delta, tonic, non-rhythmic):
rhGroups = {'CTB','NT_','DT_','CD_','CTT','NN_'};

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

grpPrcnt = zeros(numel(optoGroups),numel(rhGroups)+1); % allocate storage
for it = 1:numel(optoGroups) % iterate trough all opto groups
    rowIds = get_optoGroup_indices_in_allCell(optoGroups{it}); % tagged cells
    nCells = numel(rowIds);
    for it2 = 1:numel(rhGroups) % iterate trough all rhythmicity groups
        grpPrcnt(it,it2) = numel(intersect(rowIds,get_rhGroup_indices_in_allCell_opto(rhGroups{it2}))); % number of rhythmic neurons
    end
    grpPrcnt(it,end) = nCells - sum(grpPrcnt(it,1:numel(rhGroups))); % number of 'other' cells
    grpPrcnt(it,:) = grpPrcnt(it,:)/nCells;
end

%% Option 1 (barplot):
ba = bar(grpPrcnt,'stacked','FaceColor','flat');
% Change colors:
for it = 1:numel(rhGroups) % iterate trough all rhythmicity groups
    ba(it).CData = rhgroup_colors(rhGroups{it});
end
ba(end).CData = [1,1,1];
% ylabel('Number of cells')
ylabel('Percentage of cells')
xlabel('Opto group')
xticklabels(optoGroups)

%% Option 2 (piechart):
% figure
% for it = 1:3
%     subplot(1,4,it), pieChart = pie(grpPrcnt(it,:));
%     pieChart(1).FaceColor = rhgroup_colors('CTB');
%     pieChart(3).FaceColor = rhgroup_colors('NT_');
%     pieChart(5).FaceColor = rhgroup_colors('DT_');
%     pieChart(7).FaceColor = rhgroup_colors('CD_');
%     pieChart(9).FaceColor = rhgroup_colors('CTT');
%     pieChart(11).FaceColor = rhgroup_colors('NN_');
%     pieChart(13).FaceColor = [1,1,1];
% end

legend('pacemaker','theta-follower','follower','delta','tonic','non-rhythmic','other')
end