function signRanks = plot_synchronization_theories(resPaths)
%PLOT_SYNCHRONIZATION_THEORIES Plots synchronization statistics for
%datasets.
%   SIGNRANKS = PLOT_SYNCHRONIZATION_THEORIES(RESPATHS) plots 6 measures
%   for 5 possible ways of synchronization of cells:
%    - firing rate increase, acg theta peak increase
%    - rhythmicity frequency increase
%    - intraburst firing rate increase
%    - less theta skipping
%    - frequency sycnhronization.
%   Parameters:
%   RESPATHS: 1x#dataSets array, specifying parent folder paths, storing the
%   results of GROUP_SYNCHRONIZATION analysis.
%   SIGNRANKS: matrix, paired signrank statistic values (rows: theories,
%   columns: datasets).
%
%   See also GROUP_SYNCHRONIZATION, DATASET_COLORS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/09/2020

if nargin == 0
    variable_definitions; %resPaths definitions
end

theories = {'firing_rates';'acg_theta_peaks';'rhythmicity_frequencies';...
    'intraburst_interspike_interval';'theta_skipping';'frequency_synchronization'};
nTheories = numel(theories);
nDataSets = numel(resPaths);

% Find dataset indices:
ratInx = find(cellfun(@(x) contains(x,'ANA_RAT'),resPaths)); % anest. rat results index
amouseInx = find(cellfun(@(x) contains(x,'ANA_MOUSE'),resPaths)); % anest. mouse results index
fmouseInx = find(cellfun(@(x) contains(x,'FREE_MOUSE'),resPaths)); % free mouse results index
modelInx = find(cellfun(@(x) contains(x,'MODEL'),resPaths)); % model results index
optoInx = find(cellfun(@(x) contains(x,'OPTOTAGGING'),resPaths)); % opto results index
DSNames = {'rat: ';'amouse: ';'fmouse: ';'pooled: ';'model: ';'opto: '}; % all dataset names
DSNames(cellfun(@isempty,{ratInx,amouseInx,fmouseInx,nDataSets+1,modelInx,optoInx})) = []; % clear missing datasets' names

%% Collect all results from all datasets, calculate statistics:
signRanks = zeros(nTheories,nDataSets+1);
tTests = zeros(nTheories,nDataSets+1);
nCells = zeros(nTheories,nDataSets+1);
ThDeMAll = cell(nTheories,1);
for it1 = 1:nTheories % go trough synchronization theories:
    ThDeM = zeros(2000,3); % theta-delta measure pairs (+dataset indices)
    cnt = 1;
    for it2 = 1:nDataSets % go trough datasets:
        load(fullfile(resPaths{it2},theories{it1})); % load results
        nPoints = numel(thPoints);
        ThDeM(cnt:cnt+nPoints-1,:) = [repmat(it2,nPoints,1),thPoints,dePoints]; % store results
        signRanks(it1,it2) = signrank(thPoints,dePoints); % statistics: paired signrank
        [~,pTTest] = ttest(thPoints,dePoints); % statistics: paired t-test
        tTests(it1,it2) = pTTest;
        nCells(it1,it2) = nPoints;
        %%Test shift direction:
        %h = 1 (alternative hyp (th>de) appr., 0hyp (th=de) rejected):
        %[p,h] = signrank(thPoints,dePoints,'tail','right')
        %h = 1 (alternative hyp (th<de) appr., 0hyp (th=de) rejected):
        %[p,h] = signrank(thPoints,dePoints,'tail','left')
        cnt = cnt + nPoints;
    end
    ThDeM(cnt:end,:) = [];
    ThDeMAll{it1} = ThDeM;
    % Pooled statistics:
    poolInd = find(ismember(ThDeM(:,1),[ratInx,amouseInx,fmouseInx]));
    signRanks(it1,end) = signrank(ThDeM(poolInd,2),ThDeM(poolInd,3)); % statistics: paired signrank
    [~,pTTest] = ttest(ThDeM(poolInd,2),ThDeM(poolInd,3)); % statistics: paired t-test
    tTests(it1,end) = pTTest;
    nCells(it1,end) = numel(poolInd);
end

%% Plot results:
for it1 = 1:nTheories % go trough synchronization theories:
    figure('Position',[10,50,500,500]), hold on
    xlabel('theta'), ylabel('delta')
    for it2 = 1:nDataSets % plot each datasets:
        [sColor,symbol,markerSize] = dataset_colors(resPaths{it2});
        ind = find(ThDeMAll{it1}(:,1)==it2);
        eval(['scatter(ThDeMAll{it1}(ind,2),ThDeMAll{it1}(ind,3),markerSize,sColor,',symbol,')']); % plot
    end
    poolInd = find(ismember(ThDeMAll{it1}(:,1),[ratInx,amouseInx,fmouseInx]));
    % Adjust scatter plot:
    allPoints = ThDeMAll{it1}(:,2:3);
    minV = min(allPoints(:)); maxV = max(allPoints(:));
    xlim([minV,maxV]),ylim([minV,maxV]), axis equal
    line([minV,maxV],[minV,maxV],'Color',[1,0,0],'LineStyle','--')
    
    title([[theories{it1},' (signed rank, t tests, #cells)'];
        strcat(DSNames,...
        num2str(signRanks(it1,[ratInx,amouseInx,fmouseInx,nDataSets+1,modelInx,optoInx]).'),{', '},...
        num2str(tTests(it1,[ratInx,amouseInx,fmouseInx,nDataSets+1,modelInx,optoInx]).'),{', '},...
        num2str(nCells(it1,[ratInx,amouseInx,fmouseInx,nDataSets+1,modelInx,optoInx]).'))]);
    
    % Real data, boxplot
    figure('Position',[510,50,150,500]); hold on, title('Pooled data')
    boxplot([ThDeMAll{it1}(poolInd,3),ThDeMAll{it1}(poolInd,2)],...
        'Labels',{'Non-theta','Theta'},'Colors','k','Widths',2/3,'symbol','');
    % Real data, boxplot difference
    figure('Position',[660,50,100,300]); hold on, title('Pooled data')
    boxplot(ThDeMAll{it1}(poolInd,2)-ThDeMAll{it1}(poolInd,3),...
        'Labels','Theta- Non-theta','Colors','k','Widths',2/3,'symbol','');
    % Model data, boxplot
    modelInd = find(ismember(ThDeMAll{it1}(:,1),modelInx));
    figure('Position',[760,50,150,500]); hold on, title('Model data')
    boxplot([ThDeMAll{it1}(modelInd,3),ThDeMAll{it1}(modelInd,2)],...
        'Labels',{'Non-theta','Theta'},'Colors','k','Widths',2/3,'symbol','');
    % Model data, boxplot difference
    figure('Position',[910,50,150,500]); hold on, title('Model data')
    boxplot(ThDeMAll{it1}(modelInd,2)-ThDeMAll{it1}(modelInd,3),...
        'Labels','Theta- Non-theta','Colors','k','Widths',2/3,'symbol','');
end
end