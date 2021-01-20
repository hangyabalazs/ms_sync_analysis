function [ThHist, DeHist] = ISI(rowId,edges)
%ISI Interspike interval histogram  of a cell.
%   [THHIST,DEHIST] = ISI(ROWID,EDGES) calculates interspike intervall for
%   the specified cell during theta and non-theta.
%   Parameters:
%   ROWID: number, rowId in allCell matrix (e.g. 437).
%   EDGES: vector, specifying ISI histogram edges in ms 
%   (default: 0:0.01*NSR:0.5*NSR).
%   THHIST: 1 x nEdges vector, phase histogram during theta.
%   DEHIST: 1 x nEdges vector, phase histogram during delta.
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 27/10/2020


global RESULTDIR
global NSR

if nargin == 0
    variable_definitions; %rowId, (edges) definitions
    figure
end

if ~exist('edges','var')
    edges = [0:0.005*NSR:0.3*NSR]; % bins
end

% Load data table
load(fullfile(RESULTDIR,'cell_features','allCell.mat'), 'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'),'mO');

animalId = num2str(allCell(rowId, mO('animalId')));
recordingId = num2str(allCell(rowId, mO('recordingId')));
shankId = num2str(allCell(rowId, mO('shankId')));
cellId = allCell(rowId, mO('cellId'));

% Load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');

% Load cell activity (TS):
TS = loadTS(animalId,recordingId,shankId,cellId);

thActTime = TS(theta(TS)==1);
deActTime = TS(delta(TS)==1);

% Under theta:
ThHist = histcounts(diff(thActTime),edges, 'Normalization', 'probability');

% Under delta:
DeHist = histcounts(diff(deActTime),edges, 'Normalization', 'probability');

stairs(edges(1:end-1), ThHist), hold on
stairs(edges(1:end-1), DeHist)
end