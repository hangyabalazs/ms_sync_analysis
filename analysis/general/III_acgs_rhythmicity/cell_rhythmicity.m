function cell_rhythmicity(animalId,recordingId,shankId,cellId,varargin)
%CELL_RHYTHMICITY Calculates rhythmicity related measures of MS cells.
%   CELL_RHYTHMICITY(ANIMALID,RECORDINGID,SHANKID,CELLID,ISFICTIOUS,ISSAVE,
%   ISPLOT) calculates auto correlation and calculates rhythmicity and 
%   burst during theta, delta segments.
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 2).
%   ISFICTIOUS: optional, logical, run analysis for real MS cells or Poisson process
%   created fictious data (default: false)?
%   ISSAVE: optional, logical, save?
%   ISPLOT: optional, logical, controlls if plots will be dispalyed or not
%   (deafult: true)?
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, CREATE_FICTIOUS_DATA, 
%   CORRELATION, THETAINDEX, DELTAINDEX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global BURSTWINDOW
global NSR

%Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p, 'isFictious',false,@islogical);
addParameter(p, 'issave',false,@islogical);
addParameter(p, 'isPlot',true,@islogical);
parse(p,varargin{:});

isFictious = p.Results.isFictious;
issave = p.Results.issave;
isPlot = p.Results.isPlot;

if nargin == 0
    variable_definitions; %animalId,recordingId,shankId,cellId (isFictious,issave,isPlot) definitions
end

% Load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');

% Load cell activity (TS):
if ~isFictious %load real MS cell data:
    % load AP timestamps (TS)
    TS = loadTS(animalId,recordingId,shankId,cellId);
    
    % Create logical vectors for unit activites:
    actPattern = zeros(size(theta,2), 1);
    % index in the actPattern (1 where actTime fires, 0 where not)
    actPattern(TS) = 1;
    
    % timeserie under theta (1 where cell fires and there is theta, 0 elsewhere)
    thetaActPattern = actPattern.*theta';
    % timeserie under delta (1 where cell fires and there is delta, 0 elsewhere)
    deltaActPattern = actPattern.*delta';
else % load fictious data (Poisson process produced):
    load(fullfile(RESULTDIR,'FICTIOUS_DATA',animalId,recordingId, ...
        [num2str(shankId),'_',num2str(cellId),'.mat']),'thetaActPattern','deltaActPattern');
end

% Autocorrelation
if isPlot
    f1 = figure; hold on
    thetaColour = [0,0.4470,0.7410];
    deltaColor = [0.8500,0.3250,0.0980];
else %avoid ploting
    thetaColour = [1,1,1]; %white
    deltaColor = [1,1,1]; %white
end

% During theta
[thetaAcg,thsumacr,alag] = correlation(thetaActPattern,thetaActPattern,true,thetaColour); %acg
colour1 = 'k*';
ThAcgThInx = thetaindex(thetaAcg,alag,isPlot,colour1);
colour2 = 'y*';
ThAcgDeInx = deltaindex(thetaAcg,alag,isPlot,colour2);

% During delta
[deltaAcg, desumacr, alag] = correlation(deltaActPattern,deltaActPattern,true,deltaColor); %acg
colour3 = 'g*';
DeAcgThInx = thetaindex(deltaAcg,alag,isPlot,colour3);
colour4 = 'c*';
DeAcgDeInx = deltaindex(deltaAcg,alag,isPlot,colour4);

%Calculate other parameters:
nAPtheta = sum(thetaActPattern); % number of APs during theta
nAPdelta = sum(deltaActPattern); % number of APs during delta
thetaLength = sum(theta); % total length of theta
deltaLength = sum(delta); % total length of delta
thetaFr = nAPtheta / thetaLength * NSR; % firing rate during theta
deltaFr = nAPdelta / deltaLength * NSR; % firing rate during delta
a = mean(thetaAcg(alag>BURSTWINDOW(1)&alag<BURSTWINDOW(2)));
b = mean(thetaAcg);
thetaBurstInx = (a - b) / max(a,b);   % burst index

if isPlot
    %Handle plot
    ylim = get(gca,'ylim');
    xlim = get(gca,'xlim');
    text(xlim(1)+xlim(2)/10, ylim(2)-(ylim(2)-ylim(1))/10, ...
        {['theta index: ', num2str(ThAcgThInx), ...
        ', delta index: ', num2str(ThAcgDeInx)]; ['APs: ' num2str(nAPtheta), ...
        ', theta length:', num2str(thetaLength), ' (ms), sum(acr): ', num2str(thsumacr)]});
    text(xlim(1)+xlim(2)/10, ylim(1)+(ylim(2)-ylim(1))/10, ...
        {['theta index: ', num2str(DeAcgThInx), ...
        ', delta index: ', num2str(DeAcgDeInx)]; ['APs: ', num2str(nAPdelta), ...
        ', delta length:', num2str(deltaLength), ' (ms), sum(acr): ', num2str(desumacr)]});
    title(['ACG of: ', animalId, recordingId, ', shn: ', num2str(shankId), ', cell: ', num2str(cellId)]);
    xlabel('msec');
end

if issave
    if ~isFictious % save real MS cell data
        if isPlot
            savefig(fullfile(RESULTDIR,'MS_cell_rhythmicity','figures',...
                [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]));
            close
        end
        save(fullfile(RESULTDIR,'MS_cell_rhythmicity','acgs',...
            [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]),...
            'thetaAcg','deltaAcg','ThAcgThInx','ThAcgDeInx','DeAcgThInx','DeAcgDeInx',...
            'thsumacr','desumacr','nAPtheta','nAPdelta','thetaLength','deltaLength',...
            'thetaFr','deltaFr','thetaBurstInx');
    else % save fictious cell data
        if isPlot
            savefig(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','figures',...
                [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]));
            close
        end
        save(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','acgs',...
            [animalId,'_',recordingId,'_',num2str(shankId),'_',num2str(cellId)]),...
            'thetaAcg','deltaAcg','ThAcgThInx','ThAcgDeInx','DeAcgThInx','DeAcgDeInx',...
            'thsumacr','desumacr','nAPtheta','nAPdelta','thetaLength','deltaLength',...
            'thetaFr','deltaFr','thetaBurstInx');
    end
end
end