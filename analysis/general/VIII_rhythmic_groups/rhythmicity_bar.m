function rhMatrix = rhythmicity_bar(rowIds,iT)
%RHYTHMICITY_BAR Shows rhythmicity during states with colored bars.
%   RHYTHMICITY_BAR(ROWIDS,IT) builds a nCell x 2 matrix from colored bars
%   indicating rhythmic modulations (blue-theta, red-delta, black-non rh.).
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   IT: optional, flag, take into account sum(acg) threshold?
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

global RESULTDIR
global THSUMACGTRESH
global DESUMACGTRESH

if nargin == 0
    variable_definitions; %rowIds,(iT) definitions
end

% Color definitions:
thColor = [0,0.4470,0.7410];
deColor = [0.8500,0.3250,0.0980];
nonColor = [0,0,0];
notColor = [0.5,0.5,0.5];

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');
% Load rhythmicity index thresholds:
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','indexTresholds'));
% Sort acgs based on theta-index-during-theta:
sortedCells1 = sortrows(allCell(rowIds,:),mO('ThAcgThInx'));

rhMatrix = zeros(size(rowIds,1),2);
barMatrix = zeros(size(rowIds,1),2,3);
ThAcgThInx = sortedCells1(:,mO('ThAcgThInx'));
ThAcgDeInx = sortedCells1(:,mO('ThAcgDeInx'));
DeAcgThInx = sortedCells1(:,mO('DeAcgThInx'));
DeAcgDeInx = sortedCells1(:,mO('DeAcgDeInx'));
for it= 1: numel(rowIds)
    % THETA:
    if ThAcgThInx(it)/thetaThInxtrsh > max(ThAcgDeInx(it)/thetaDeInxtrsh,1) % theta rhythmic
        rhMatrix(it,1) = 1;
        barMatrix(it,1,:) = thColor;
    elseif ThAcgDeInx(it)/thetaDeInxtrsh > max(ThAcgThInx(it)/thetaThInxtrsh,1) % delta rhythmic
        rhMatrix(it,1) = 2;
        barMatrix(it,1,:) = deColor;
    elseif ThAcgThInx(it) < thetaThInxtrsh & ThAcgDeInx(it) < thetaDeInxtrsh % not-rhythmic
        rhMatrix(it,1) = 3;
        barMatrix(it,1,:) = nonColor;
    end
    if exist('iT','var') & sortedCells1(it,mO('thsumacr')) < THSUMACGTRESH
        barMatrix(it,1,:) = notColor;
    end
    
    % DELTA:
    if DeAcgThInx(it)/deltaThInxtrsh > max(DeAcgDeInx(it)/deltaDeInxtrsh,1) % theta rhythmic
        rhMatrix(it,2) = 1;
        barMatrix(it,2,:) = thColor;
    elseif DeAcgDeInx(it)/deltaDeInxtrsh > max(DeAcgThInx(it)/deltaThInxtrsh,1) % delta rhythmic
        rhMatrix(it,2) = 2;
        barMatrix(it,2,:) = deColor;
    elseif DeAcgThInx(it) < deltaThInxtrsh & DeAcgDeInx(it) < deltaDeInxtrsh % not-rhythmic
        rhMatrix(it,2) = 3;
        barMatrix(it,2,:) = nonColor;
    end
    if exist('iT','var') & sortedCells1(it,mO('desumacr')) < DESUMACGTRESH
        barMatrix(it,2,:) = notColor;
    end
end

figure('Position',[350,332.2,200,420.8])
image(flipud(barMatrix))
set(gca,'Visible','off')
end