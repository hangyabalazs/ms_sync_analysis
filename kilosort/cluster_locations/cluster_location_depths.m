function chRowIds = cluster_location_depths(rowIds,grpColor,grpShift)
%CLUSTER_LOCATION_DEPTHS to demonstrate dorso-ventral distribution of
%rhythmicity groups.
%   CLUSTER_LOCATION_DEPTHS() finds the dorso-ventral (DV) and 
%   medio-lateral (ML) location (= highest amplitude channel location) of 
%   the cells specified by ROWIDS. If the cells are coming from the second
%   or the third recording, the electrode displacement is also taken into
%   account. Optionally, it can visualize spatial distribution of the given
%   cell group with different colors (specified in the input).
%   Example call:
%   "execute_rhGroups('cluster_location_depths(rowIds,sColor,it/10);',1);"
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   get_rhGroup_indices_in_allCell('CTB')).
%   GRPCOLOR: optional, plot results?
%   GRPSHIFT: optional, shift cell locations a bit, randomly to avoid masking?
%
%   See also CREATE_AVR_WAVEFORMS_MATRIX, VISUAL_OVERLAPING_CLUSTERS, 
%   RECORDING_DEPTH_AMOUSE, RHGRP_DV_DISTRIBUTION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/04/2022

global ROOTDIR
global RESULTDIR

% HARD CODED (parameter definitions):
% Electrode:
nchRow = 4; % number of channels in a row
chSep = 22.5; % channel separation (distance between electrode site rows' bottom)
% Recordings:
firstDepth = 3.5*1000; % first dorso-ventral depth (um)
lastDepth = (4.5 + 0.720)*1000; % last dorso-ventral depth of electrode tip site (um)
% Total number of channels from different depths in one animal (3 recording
% depths):
nChDepths = round((lastDepth - firstDepth)/chSep);

load(fullfile(RESULTDIR,'cell_features','allCell.mat'),'allCell');
load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'),'mO');
nCell = size(allCell,1);
% animalChg = [0;find(diff(allCell(:,1))~=0);nCell]; % last cell locations from 1 animal

chRowIds = zeros(numel(rowIds),2); % dominant channel locations (columns: depth|horizontal) for cells (rows)
for it = 1:numel(rowIds)
    animalId = num2str(allCell(rowIds(it),mO('animalId')));
    recordingId = num2str(allCell(rowIds(it),mO('recordingId')));
    % shankId = num2str(allCell(rowIds(it),mO('shankId')));
    cellId = num2str(allCell(rowIds(it),mO('cellId')));
    % Get recording depth:
    depth = recording_depth_amouse(animalId,recordingId)*1000;
    
    % Determine channel row number:
    load(fullfile(ROOTDIR,'WAVEFORMS',animalId,recordingId,...
        [animalId,'_',recordingId,'_',cellId,'_waveform.mat']),'avrgWave');
    % Calculate spike amplitude from average wave:
    [~,chId] = max(max(avrgWave) - min(avrgWave));
    chShift = round((depth-firstDepth)/chSep);
    %     animalNum = find(histcounts(rowIds(it),animalChg));
    % Dominant amplitude channel position:
    chRowIds(it,1) = rem(chId,nchRow); % horizontal position
    chRowIds(it,2) = ceil(chId/nchRow) + chShift; % depth + channel shift
end

% For visualization: shift a bit randomly cells (and rhythmicity groups
% from eachother):
if exist('grpShift','var')  
    % horizontal position + rh group shift + random shift:
    chRowIds(:,1) = chRowIds(:,1) + grpShift + rand(numel(rowIds),1)/10;
    % depth + random shift:
    chRowIds(:,2) = chRowIds(:,2) + rand(numel(rowIds),1)/3;
end
if exist('grpColor','var') % Plot positions
    scatter(chRowIds(:,1),nChDepths+1-chRowIds(:,2),30,grpColor,'filled','MarkerEdgeColor','k');
end
end