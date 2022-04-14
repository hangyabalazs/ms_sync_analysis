function parameter_space_plot(sortBy,scores,Ids,is3D)
%PARAMETER_SPACE_PLOT Organizes simulation results, and plots quantitative
%measures of a certain aspect to study parameter impacts.
%   PARAMETER_SPACE_PLOT(SORTBY,SCORES,IDS) shows the results of
%   large-scale parameter space simulations (e.g.: synchronization score
%   dependence on synaptic weight (subplots), network connection rate
%   (colored line), baseline excitation strength (x-axis)).
%   Optional parameters:
%   SORTBY: 1x3 numeric vector, specifying in which column order will be
%   COMBS (storing parameters of corresponding simulations) sorted, and
%   consequently, which parameter will be the subplots, colored lines,
%   x-axis on plots.
%   SCORES: #simulations vector, including synchronization scores (or
%   #simulations x 2, including median intraburst frequencies for theta
%   theta and non-theta). Rows are corresponding to IDs matrix rows.
%   IDS: #simulations x 2 matrix, containing 'animal' and 'recording' IDs.
%   Rows are corresponding to SCORES vector rows.
%   IS3D: optional, flag, plot parameters in 3D?
%
%   See also MODEL_SYNCH_SCORE, COLLECT_PROPERTIES,
%   SIMULATE_PARAMETER_SPACE, EXPLORE_PARAMETER_SPACE.
%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 07/01/2021

global RESULTDIR
global DATADIR

if nargin < 3
    if nargin == 0
        sortBy = [1,7,2];
    end
    % Collect synchronization scores to common matrix:
    [scores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'});
end

% whether a pair of values (theta, delta) are provided? :
isThDe = size(scores,2)-1; % controls later behaviour

% suppose simulation runs happened in the same order (same recording Ids
% corresponds to same parameter arrangements across animals)
% Load parameter combinations matrix (rows: recordings, columns: parameters)
load(fullfile(DATADIR,num2str(Ids(1,1)),'parameter_combinations.mat'),'combs','combTable');
% sort recordings (ascending) similarly to combs matrix (to match rows):
[Ids,inx] = sortrows(Ids);
scores = scores(inx,:);

% Take the mean/median across animals (repetitions with the same parameter arrangement)
inx = double(categorical(Ids(:,2))); % corresponding recordings (repetitions)
mprop1 = accumarray(inx,scores(:,1),[],@mean); % mean property vector
if isThDe
    mprop2 = accumarray(inx,scores(:,2),[],@mean);
end
% mprop1 = accumarray(inx,scores(:,1),[],@nanmedian); % median property vector
% if isThDe mprop2 = accumarray(inx,scores(:,1),[],@nanmedian); end

% Create common matrix:
allMatrix = [combs,mprop1];
if isThDe allMatrix = [allMatrix,mprop2]; end
allMatrix = sortrows(allMatrix,sortBy); % sort according to input specifications

nParameters = size(combs,2); % number of controlled parameters
nUniques = zeros(nParameters,1); % allocate, number of unique parameters for each parameter type
uniPars = cell(nParameters,1); % allocate, unique parameters for each parameter type
for it = 1:nParameters
    uniPars{it} = unique(allMatrix(:,it));
    nUniques(it) = numel(uniPars{it});
end

figure('Position',[50,50,1450,432]);
smprop1 = allMatrix(:,nParameters+1:end); % sorted mprop1
minVal = floor(min(min(smprop1(~isinf(smprop1))))); % minimum score (for ploting)
maxVal = ceil(max(max(smprop1(~isinf(smprop1))))); % maximum score (for ploting)
nPars1 = nUniques(sortBy(1));
nPars2 = nUniques(sortBy(2));
nPars3 = nUniques(sortBy(3));
for it1 = 1:nPars1 %subplots
    a1 = subplot(isThDe+1,nPars1,it1);
% % % % %     figure
    % create a second row of subplots for activity during delta:
    if isThDe a2 = subplot(isThDe+1,nPars1,it1+nPars1); end
    for it2 = 1:nPars2 % lines
        actColor = (it2+1) / (nPars2+3); % line color
        linewidth = 1;%2.2-1.5*it2/nPars2; % line width
        startInx = nPars3 * nPars2 * (it1-1) + nPars3 * (it2-1) + 1;
        actInd = startInx:startInx+nPars3-1; %ALLMATRIX(ACTIND): x axis dots
        if isThDe % if score-pairs are given (theta-delta)
            subplot(a1), hold on
            thPoints = allMatrix(actInd,nParameters+1);
            plot(uniPars{sortBy(3)},thPoints,'Color',[0,actColor,0],'LineWidth',linewidth);
            %             text(1:numel(thPoints),thPoints,num2cell(actInd)) %recordingIds
            subplot(a2), hold on
            dePoints = allMatrix(actInd,nParameters+2);
            plot(uniPars{sortBy(3)},dePoints,'Color',[actColor,0,0],'LineWidth',linewidth);
            %             text(1:numel(dePoints),thPoints,num2cell(actInd)) %recordingIds
        else
            subplot(a1), 
            hold on
            dataPoints = allMatrix(actInd,nParameters+1);
            plot(uniPars{sortBy(3)},dataPoints,'Color',[0,actColor,0],'LineWidth',linewidth);
            %             text(1:numel(thPoints),thPoints,num2cell(actInd)) %recordingIds
        end
    end
    % Control plots:
    subplot(a1),
    pbaspect([1,1,1]), ylim([minVal,maxVal])
    xlabel(combTable{sortBy(3)})
    set(gca, 'XLimSpec', 'Tight');
    set(gca,'xtick',uniPars{sortBy(3)}); set(gca,'xticklabels',uniPars{sortBy(3)}) % OPTION 0: automatic
%     set(gca, 'xtick', [0.04,0.06,0.08]), set(gca, 'xticklabel', {'40','60','80'}), xlabel('Excitation (pA)'); % OPTION 1 (panel A: CR, weight, excitation)
%     set(gca, 'xtick', [0,0.5,1]), set(gca, 'xticklabel', {0,50,100}), xlabel('CR (%)'); % OPTION 2 (panel B: excitation, weight, CR)
%     set(gca, 'xtick', [0.001,0.006,0.012]), set(gca, 'xticklabel', {'1','6','12'}), xlabel('Syn. weight (nS)'); % OPTION 3 (panel B: excitation, CR, weight)
%     set(gca, 'xtick', [1,7,15]), set(gca, 'xticklabel', {'1','7','15'}), xlabel('Syn. delay (ms)'); % OPTION 4 (panel D: excitation, CR, delay)
%     set(gca, 'xtick', [0,0.1,0.2]), set(gca, 'xticklabel', {'0','10','20'}), xlabel('Stimulus variance (%)'); % OPTION 5 (panel E: excitation, CR, variance)
%     limits=[0,1];ylim(limits),set(gca, 'ytick', [limits(1),mean(limits),limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs, ylabel('% in-phase (%)'); %ylabel('Sync score')
    limits=[0,1];ylim(limits),set(gca, 'ytick', [limits(1),mean(limits),limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs, ylabel('Sync. score (%)')
    title([combTable{sortBy(1)}, ': ', num2str(uniPars{sortBy(1)}(it1))]); % OPTION 0: automatic
%     title(['CR: ', num2str(uniPars{sortBy(1)}(it1)*100), '%']); % OPTION 1 (panel A: CR, weight, excitation)
%     title(['Excitation: ', num2str(uniPars{sortBy(1)}(it1)*1000), 'pA']); % OPTION 2 (panel B: excitation, weight, CR) AND OPTION 3 (panel C: excitation, CR, weight) AND OPTION 4 (panel D: excitation, CR, delay) AND OPTION 5 (panel E: excitation, CR, variance)
    if isThDe % do this for delta plot:
        subplot(a2)
        pbaspect([1,1,1]), ylim([minVal,maxVal])
        xlabel(combTable{sortBy(3)})
        set(gca, 'XLimSpec', 'Tight');
        set(gca,'xtick',uniPars{sortBy(3)}); set(gca, 'xticklabels',uniPars{sortBy(3)})
        limits=[0,1];ylim(limits),set(gca, 'ytick', [limits(1),mean(limits),limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs, ylabel('% out-phase')
        title([combTable{sortBy(1)}, ': ', num2str(uniPars{sortBy(1)}(it1))])
    end
end

% Create legend for colored lines:
if isThDe
    subplot(a1)
    Lgnd = legend(num2str(uniPars{sortBy(2)}));
    Lgnd.Position(1) = 0.03;
    Lgnd.Position(2) = 0.7;
    title(Lgnd,combTable{sortBy(2)})
    subplot(a2)
    Lgnd = legend(num2str(uniPars{sortBy(2)}));
    Lgnd.Position(1) = 0.03;
    Lgnd.Position(2) = 0.2;
    title(Lgnd,combTable{sortBy(2)})
else
    Lgnd = legend(num2str(uniPars{sortBy(2)})); % OPTION 0: automatic
%     Lgnd = legend(num2str(uniPars{sortBy(2)}*1000)); % red lines: OPTION 1 (panel A: CR, weight, excitation) AND OPTION 2 (panel B: excitation, weight, CR)
%     Lgnd = legend(num2str(uniPars{sortBy(2)}*100)); % green lines: OPTION 3 (panel C: excitation, CR, weight) AND OPTION 4 (panel D: excitation, CR, delay) AND OPTION 5 (panel E: excitation, CR, variance)
    Lgnd.Position(1) = 0.03;
    Lgnd.Position(2) = 0.4;
    title(Lgnd,combTable{sortBy(2)}); % OPTION 0: automatic
%     title(Lgnd,'Syn. weight (uS)'); % red lines: OPTION 1 (panel A: CR, weight, excitation) AND OPTION 2 (panel B: excitation, weight, CR)
%     title(Lgnd,'CR (%)'); % green lines: OPTION 3 (panel C: excitation, CR, weight) AND OPTION 4 (panel D: excitation, CR, delay) AND OPTION 5 (panel E: excitation, CR, variance)
end

%% Create 3d surface plot:
if exist('is3D','var')
    % (here subplots are identical, only the identity of highlighted surface change):
    figure('Position',[50,50,1450,432]);
    for it1 = 1:nPars1
        subplot(1,nPars1,it1);
        for it2 = 1:nPars1
            actInx = nPars2*nPars3*(it2-1)+1:nPars2*nPars3*it2;
            X = reshape(allMatrix(actInx,sortBy(2)),[nPars3,nPars2]);
            Y = reshape(allMatrix(actInx,sortBy(3)),[nPars3,nPars2]);
            Z = reshape(allMatrix(actInx,nParameters+1),[nPars3,nPars2]);
            if it1==it2
                surf(X,Y,Z,'FaceColor',[(it1+1)/(nPars1+1),0,0]); hold on
            else
                surf(X,Y,Z,'FaceColor',[0.7,0.7,0.7],'FaceAlpha',0.5); hold on
            end
        end
        pbaspect([1,1,1])
        xlabel(combTable{sortBy(2)}), xlim([uniPars{sortBy(2)}(1),uniPars{sortBy(2)}(end)])
        ylabel(combTable{sortBy(3)}), ylim([uniPars{sortBy(3)}(1),uniPars{sortBy(3)}(end)])
        title([combTable{sortBy(1)}, ': ', num2str(uniPars{sortBy(1)}(it1))])
        %     view([0,1,0.5])
    end
end
end