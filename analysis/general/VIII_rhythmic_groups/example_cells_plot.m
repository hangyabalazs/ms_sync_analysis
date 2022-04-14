function example_cells_plot(IDs,tWindow,acgYLims,phaseYLims)
%EXAMPLE_CELLS_PLOT plots 3 example MS unit activity, properties, and hippo
%LFP.
%   EXAMPLE_CELLS_PLOT(IDS,TWINDOW) plots 3 MS units activities (from the 
%   same recording), with hippocampal state detection. It also provides 
%   acgs, phase preferences and PSTH plots (if OPTO set) for the given cells.
%   Parameters:
%   IDS: 3x4 cell array containing 3 IDs (animalId, recordingId, shankId, 
%   cellId) of MS cells (e.g. {20180821,1,4,23;20180821,1,4,34;20180821,1,4,38}); 
%   or a 1x3 vector containing rowIds (in allCell).
%   TWINDOW: 1x2 vector, (e.g. [832,844]).
%   ACGYLIMS: 1x2 vector, controlling y axis limits on individual cells' 
%   acg plots (e.g.: [0,0.0006]).
%   PHASEYLIMS: 1x2 vector, controlling y axis limits on individual cells' 
%   phase plots (e.g.: [0,0.15]).
%
%   See also CELL_GROUPS, CELL_RHYTHMICITY, CELL_PHASE_PREFERENCE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/11/2019

global RESULTDIR
global PROJECTID

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'), 'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

if nargin == 0
    variable_definitions; %IDs,tWindow,acgYLims,phaseYLim definitions
end

if iscell(IDs)
    for it = 1:size(IDs,1)
        rowIds(it) = find_rowIds(IDs{it,1},IDs{it,2},IDs{it,3},IDs{it,4});
    end
else
    rowIds = IDs;
end

animalId = num2str(allCell(rowIds(1),mO('animalId')));
recordingId = num2str(allCell(rowIds(1),mO('recordingId')));

% F = figure('Position',get(0,'Screensize'));
F = figure('Position',[1,41,1097,505]);

%% MS unit raster plot and hippocampal data:
subplot(3,5,[1,2,6,7,11,12]);
raster_plot(rowIds,tWindow);

%% Open desired septal cells plots:
for it = 1:length(rowIds)
    shankId = allCell(rowIds(it), mO('shankId'));
    cellId = allCell(rowIds(it), mO('cellId'));
    
    % Acgs:
    subplot(3,5,3+(it-1)*5), hold on, title([num2str(shankId),' ',num2str(cellId)])
    plot(allCell(rowIds(it),mO('thetaAcgFirst'):mO('thetaAcgLast')))
    plot(allCell(rowIds(it),mO('deltaAcgFirst'):mO('deltaAcgLast')))
    ylim(acgYLims)
    if isequal(PROJECTID,'FREE_MOUSE') 
        xlim([2000,4000]); 
    else
        xlim([1000,5000]); 
    end
    
    % Two-cycle phase histogram:
    subplot(3,5,4+(it-1)*5);
    twocycles_phaseHistogram({animalId,recordingId,shankId,cellId});
    ylim(phaseYLims)
    
    % Firing rates:
    thetaFr = round(allCell(rowIds(it),mO('thetaFr')),2);
    deltaFr = round(allCell(rowIds(it),mO('deltaFr')),2);
    title({['Theta: ',num2str(thetaFr),' Hz'],['Delta: ',num2str(deltaFr),' Hz']});
    
    % PSTH:
    if isequal(PROJECTID,'OPTOTAGGING') 
        H_opto = figure;
        cellBName = myName2cbName(animalId,recordingId,shankId,cellId);
        plot_PSTH(cellBName,H_opto);
        H_opto2 = getframe(gcf); X = frame2im(H_opto2);
        figure(F), subplot(3,5,5+(it-1)*5); imshow(X);
        close(H_opto);
    end
end

end