function create_ccgMatrix(varargin)
%CREATE_CCGMATRIX Calculates all intra- and intergroup crosscorrelations.
%   CREATE_CCGMATRIX(MAXLAG,BINSIZE) creates two (theta, non-theta) 5x5 
%   cell arrays, containing all possible (same recording) pairs' 
%   (identified by rowIds in allCell matrix) cross-correlations from the 
%   same (diagonal) and from different rhythmicity groups. 5 rhythmicity 
%   groups are: CTB, CTT,CD, DT, NT.
%   Parameters:
%   MAXLAG: number, optional, maximal shift of cross-correlation (ms, e.g. 3000).
%   BINSIZE: bin size for smoothing in sampling rate (default: CGBINS).
%
%   See also PLOT_CCG_NETWORK, CREATE_CELLTYPES, CREATE_CCGMATRIXIDS,
%   CROSS_CORRELATIONS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/05/2019

global RESULTDIR
global CGWINDOW
global NSR
global CGBINS

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p,'maxlag',CGWINDOW*NSR,@isnumeric);
addParameter(p,'binsize',CGBINS,@isnumeric);
parse(p,varargin{:});
maxlag = p.Results.maxlag;
binsize = p.Results.binsize;

if nargin == 0
    variable_definitions; %maxlag definitions
end

if ~exist(fullfile(RESULTDIR,'network','ccgMatrixIds.mat'))
    create_ccgMatrixIds();
    'ccgMatrixIds created'
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'));

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'));

load(fullfile(RESULTDIR,'network','ccgMatrixIds.mat'),'ccgMatrixIds')
ccgMatrixTh = cell(size(ccgMatrixIds)); % during theta
ccgMatrixDe = cell(size(ccgMatrixIds)); % during delta
for it = 1:numel(ccgMatrixIds) % iterate trough all connection types
    actConnections = ccgMatrixIds{it}; % actual connection type
    actCcgsTh = zeros(maxlag*2+1,size(actConnections,1)); % ccgs during theta
    actCcgsDe = zeros(maxlag*2+1,size(actConnections,1)); % ccgs during delta
    for it2 = 1:size(actConnections,1) % iterate trough all pairs of this connection tzpe
        pairIds = actConnections(it2,:);
        animalId = num2str(allCell(pairIds(1),mO('animalId')));
        recordingId = num2str(allCell(pairIds(1),mO('recordingId')));
        shankId1 = allCell(pairIds(1),mO('shankId'));
        shankId2 = allCell(pairIds(2),mO('shankId'));
        cellId1 = allCell(pairIds(1),mO('cellId'));
        cellId2 = allCell(pairIds(2),mO('cellId'));

        [thetaCcg,deltaCcg] = cross_correlation(animalId,recordingId,...
            [shankId1,shankId2],[cellId1,cellId2],'maxlag',maxlag,...
            'binsize',binsize,'isPlot',false);
        actCcgsTh(:,it2) = thetaCcg;
        actCcgsDe(:,it2) = deltaCcg;
    end
    ccgMatrixTh{it} = actCcgsTh;
    ccgMatrixDe{it} = actCcgsDe;
end

save(fullfile(RESULTDIR,'network',num2str(maxlag),'ccgMatrixTh.mat'),'ccgMatrixTh');
save(fullfile(RESULTDIR,'network',num2str(maxlag),'ccgMatrixDe.mat'),'ccgMatrixDe');
end