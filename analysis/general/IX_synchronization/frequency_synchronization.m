function [thAccRatio,deAccRatio,nPairs,IDs,condPairs] = frequency_synchronization(rowIds,frBands,cond)
%FREQUENCY_SYNCHRONIZATION Calculates rhythmicity speed differences of MS
%units.
%   [THACCRATIO,DEACCRATIO,NPAIRS,IDS] = FREQUENCY_SYNCHRONIZATION(ROWIDS,
%   FRBANDS,COND) shows the frequency difference (between CTBs recorded in
%   paralel) distribution.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   FRBANDS: 2x2 vector, specifying frequency bands of interest (Hz) (e.g.
%   theta frequency during theta, delta frequency during delta? [3,8;0.5,2.5]).
%   COND: vector, optional. Filtering cell pairs: at least one member of 
%   the pair should be included in COND vector (e.g.: fr. synch of 
%   pacemaker - PV+ pacemaker (=COND) pairs).
%   THACCRATIO: vector, relative rhythmicity speed ratios between cell pairs
%   during theta (in interval: [1/frBands(1,2),1/frBands(1,1)]).
%   DEACCRATIO: vector, relative rhythmicity speed ratios between cell pairs
%   during delta (in interval: [1/frBands(2,2),1/frBands(2,1)]).
%   NPAIRS: number of elements in ROWIDS (cell pairs).
%   IDS: collection of cell-pair Ids.
%
%   See also: RH_FREQUENCY_DEVIATIONS, FREQUENCY_SYNCHRONIZATION_OPTO,
%   GROUP_SYNCHRONIZATION, PLOT_SYNCHRONIZATION_THEORIES.
%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 07/08/2018
%   log: 09/04/2021 BK (COND added)

global RESULTDIR
global MSTHBAND

if nargin == 0
    variable_definitions; %rowIds definition
end
if ~exist('frBands','var') % if not provided...
    frBands = [MSTHBAND;MSTHBAND]; % MS theta frequency band during both states
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

% Calculate rhythmicity cycle times (1/frequency)s from acgs:
[ctThAll,ctDeAll] = rhythmicity_frequencies(rowIds,frBands);

% Allocate:
thAccRatio = zeros(200,1); % theta accaleration ratio
deAccRatio = zeros(200,1); % delta accaleration ratio
IDs = zeros(200,10);
condPairs = [];
n = [];
cnt = 1;

% Find neurons recorded in the same recording:
[~,~,ind] = unique(allCell(rowIds,mO('animalId'):mO('recordingId')),'rows');
for it1 = 1:ind(end)
    coRecIds = find(ind==it1); % neurons from the same recording
    if numel(coRecIds) > 1
        actPairs = nchoosek(coRecIds,2); % create all possible pair varriations
        for it2 = 1:size(actPairs,1)
            % Process further only if at least 1 member of the cell pair is
            % included in the condition vector:
            if exist('cond','var') & ~any(ismember(rowIds(actPairs(it2,:)),cond))
                continue
            end
            if exist('cond','var') & sum(ismember(rowIds(actPairs(it2,:)),cond))==2
                condPairs(end+1) = cnt;
            end
            ctTh1 = ctThAll(actPairs(it2,1));
            ctTh2 = ctThAll(actPairs(it2,2));
            thAccRatio(cnt) = 1 - min(ctTh1,ctTh2) / max(ctTh1,ctTh2); % slower ACG peak is a bigger number
            ctDe1 = ctDeAll(actPairs(it2,1));
            ctDe2 = ctDeAll(actPairs(it2,2));
            deAccRatio(cnt) = 1 - min(ctDe1,ctDe2) / max(ctDe1,ctDe2);
            IDs(cnt,:) = [allCell(actPairs(it2,1),mO('animalId'):mO('cellId')),actPairs(it2,1),...
                allCell(actPairs(it2,2),mO('animalId'):mO('cellId')),actPairs(it2,2)];
            cnt = cnt + 1;
        end
    end
end
thAccRatio(cnt:end) = [];
deAccRatio(cnt:end) = [];
IDs(cnt:end,:) = [];
nPairs = cnt-1;
end