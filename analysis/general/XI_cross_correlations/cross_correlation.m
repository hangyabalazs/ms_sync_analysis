function [thetaCcg,deltaCcg,thsumccr,desumccr,clag] = cross_correlation(animalId,recordingId,shankIds,cellIds,varargin)
%CROSS_CORRELATION Cross-correlation of an MS unit.
%   [THETACCG,DELTACCG,THSUMCCR,DESUMCCR,CLAG] = CROSS_CORRELATION(ANIMALID,
%   RECORDINGID,SHANKIDS,CELLIDS,MAXLG,BINSIZE,ISPLOT) calculates 
%   cross-correlation of two co-recorded cells during both theta and 
%   non-theta.
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKIDS: 2 element number vector (e.g. [1,1]).
%   CELLIDS: 2 element number vector (e.g [2,3]).
%   MAXLAG: number, optional, maximal shift of cross-correlation (ms, e.g. 3000).
%   BINSIZE: number, optional, bin size for smoothing in sampling rate (default: CGBINS).
%   ISPLOT: optional, logical, controlls if plots will be dispalyed or not
%   (deafult: true)?
%   ISSUFFT: optional, logical, if true cell pairs with insufficient amount
%   of spikes (<500) cause return command (default: false).
%   THETACCG: vector, normalized crosscorrelogram during theta.
%   DELTACCG: vector, normalized crosscorrelogram during delta.
%   THSUMCCR: integral of smoothed crosscorrelogram during theta.
%   DESUMCCR: integral of smoothed crosscorrelogram during theta.
%   CLAG: lag vector.
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, CELL_RHYTHMICITY, CORRELATION,
%   CREATE_CCGMATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global PROJECTID
global NSR
global CGWINDOW
global CGBINS

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p,'maxlag',CGWINDOW*NSR,@isnumeric);
addParameter(p,'binsize',CGBINS,@isnumeric);
addParameter(p,'isPlot',true,@islogical);
addParameter(p,'isSuffT',false,@islogical);
parse(p,varargin{:});

maxlag = p.Results.maxlag;
binsize = p.Results.binsize;
isPlot = p.Results.isPlot;
isSuffT = p.Results.isSuffT;

if nargin == 0
    eval([PROJECTID,'_variables']); %animalId, recordingId, shankIds, cellIds (ccgWindow,issave,isPlot,isSuffT) definitions
end

% Load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');

% Load AP timestamps (TS):
TS1 = loadTS(animalId,recordingId,shankIds(1),cellIds(1));
TS2 = loadTS(animalId,recordingId,shankIds(2),cellIds(2));

% Cell_1
% Create logical vectors for unit activites:
actPattern1 = zeros(size(theta, 2), 1);
% index in the actPattern (1 where actTime fires, 0 where not)
actPattern1(TS1) = 1;
% timeserie under theta (1 where cell fires and there is theta, 0 elsewhere)
thetaActPattern1 = actPattern1.*theta';
% timeserie under delta (1 where cell fires and there is delta, 0 elsewhere)
deltaActPattern1 = actPattern1.*delta';

% Cell_2
% Create logical vectors for unit activites:
actPattern2 = zeros(size(theta, 2), 1);
% index in the actPattern (1 where actTime fires, 0 where not)
actPattern2(TS2) = 1;
% timeserie under theta (1 where cell fires and there is theta, 0 elsewhere)
thetaActPattern2 = actPattern2.*theta';
% timeserie under delta (1 where cell fires and there is delta, 0 elsewhere)
deltaActPattern2 = actPattern2.*delta';

%Filter noisy data:
if isSuffT & (length(TS1) < 500 || length(TS2) < 500)
    thetaCcg = zeros(maxlag*2+1,1);
    deltaCcg = zeros(maxlag*2+1,1);
    thsumccr = 0;
    desumccr = 0;
    clag = -maxlag:1:maxlag;
    return;
end

% Colors:
if isPlot
    f1 = figure('Position', [100, 100, 1600, 800]);
    acgColour1 = [0, 0.4470, 0.7410];
    acgColour2 = [0.8500, 0.3250, 0.0980];
else %avoid ploting
    acgColour1 = [1, 1, 1];
    acgColour2 = [1, 1, 1];
end

% Autocorrelations:
if isPlot
    a1 = subplot(3, 1, 1); hold on,
    correlation(thetaActPattern1,thetaActPattern1,acgColour1,maxlag,binsize,'integrating');
    correlation(deltaActPattern1,deltaActPattern1,acgColour2,maxlag,binsize,'integrating');
    a2 = subplot(3, 1, 3); hold on,
    correlation(thetaActPattern2,thetaActPattern2,acgColour1,maxlag,binsize,'integrating');
    correlation(deltaActPattern2,deltaActPattern2,acgColour2,maxlag,binsize,'integrating');
    a3 = subplot(3, 1, 2); hold on,
end

% Cross correlation under theta:
[thetaCcg,thsumccr,clag] = correlation(thetaActPattern1,thetaActPattern2,acgColour1,maxlag,binsize,'integrating');
% Cross correlation under delta:
[deltaCcg,desumccr,clag] = correlation(deltaActPattern1,deltaActPattern2,acgColour2,maxlag,binsize,'integrating');
end