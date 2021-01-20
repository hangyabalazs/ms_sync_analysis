function compute_index_thresholds(varargin)
%COMPUTE_INDEX_THRESHOLDS Calculates significance thresholds.
%   COMPUTE_INDEX_THRESHOLDS(ISPLOT,ISSAVE) calculates rhythmicity index 
%   thresholds (both theta and delta), based on Poisson process control. 
%   Sorts all generated fictious data and determines significance level 
%   rhythmicity indices both during theta and delta.
%   Parameters:
%   ISPLOT: optional, logical, controlls if plots will be dispalyed or not
%   (deafult: true)?
%
%   See also MAIN_ANALYSIS, CREATE_FICTIOUS_DATA, CELL_RHYTHMICITY.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global THSUMACGTRESH
global DESUMACGTRESH
global SIGNIFLEVEL
global NSR

%Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p,'isPlot',true,@islogical);
addParameter(p,'issave',true,@islogical);
parse(p,varargin{:});
isPlot = p.Results.isPlot;
issave = p.Results.issave;

if nargin == 0
    variable_definitions; %(isPlot,issave) definitions
end

signif = 100 / SIGNIFLEVEL;

% Collect all fictious cell data:
cellFNames = listfiles(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','acgs'));
nCells = length(cellFNames); %number of fictious cells

% Define map object
keySet = {'ThAcgThInx','ThAcgDeInx','DeAcgThInx','DeAcgDeInx',...
    'thsumacr','nAPtheta','thetaLength','thetaFr'...
    'desumacr','nAPdelta','deltaLength','deltaFr'};
valueSet = 1:12;
fictMap = containers.Map(keySet,valueSet); % map object for fictiousCells matrix

% Allocate matrix for pseudo cells
fictiousCells = zeros(nCells,valueSet(end));
for it = 1:length(cellFNames)
    load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','acgs',cellFNames{it}),...
        'ThAcgThInx','ThAcgDeInx','DeAcgThInx','DeAcgDeInx','thsumacr','desumacr',...
        'nAPtheta','nAPdelta','thetaLength','deltaLength');
    thetaFr = nAPtheta / thetaLength * NSR;
    deltaFr = nAPdelta / deltaLength * NSR;
    for it2 = 1:length(keySet) % looks unneccesary, but for the sake of correctness...
        fictiousCells(it,valueSet(it2)) = eval(keySet{it2});
    end
end

%% DURING THETA:
% Filter noisy acgs:
thetafictiousCells = fictiousCells;
noisyAcgsTh = thetafictiousCells(:,fictMap('thsumacr')) < THSUMACGTRESH;
thetafictiousCells(noisyAcgsTh,:) = [];
thetafictiousCellsTh = sortrows(thetafictiousCells,fictMap('ThAcgThInx')); % theta index sorted
thetafictiousCellsDe = sortrows(thetafictiousCells,fictMap('ThAcgDeInx')); % delta index sorted
% theta index threshold during theta:
thetaThInxtrsh = thetafictiousCellsTh(end-round(size(thetafictiousCellsTh,1)/signif),fictMap('ThAcgThInx'));
% delta index threshold during theta:
thetaDeInxtrsh = thetafictiousCellsDe(end-round(size(thetafictiousCellsDe,1)/signif),fictMap('ThAcgDeInx'));

if isPlot
    figure; hold on
    plot(thetafictiousCells(:,fictMap('ThAcgThInx')),thetafictiousCells(:,fictMap('ThAcgDeInx')), '.');
    plot([thetaThInxtrsh,thetaThInxtrsh],[-1,thetaDeInxtrsh],'k'); % theta index threshold
    plot([-1,thetaThInxtrsh],[thetaDeInxtrsh,thetaDeInxtrsh],'k'); % theta index threshold
    plot([thetaThInxtrsh,min(1,thetaThInxtrsh/thetaDeInxtrsh)],[thetaDeInxtrsh,min(1,thetaDeInxtrsh/thetaThInxtrsh)],'k'); %where both index is significant
    title({['Randpoisson during THETA, integral threshold: ' num2str(THSUMACGTRESH)]; ...
        ['thetaIndex tresh; ',num2str(thetaThInxtrsh),', deltaIndex tresh; ',num2str(thetaDeInxtrsh)]});
    xlabel('Theta index')
    ylabel('Delta index')
    if issave
        savefig(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','fictTHETA'));
        close
    end
end

%% DURING DELTA:
deltafictiousCells = fictiousCells;
noisyAcgsDe = deltafictiousCells(:,fictMap('desumacr')) < DESUMACGTRESH;
deltafictiousCells(noisyAcgsDe,:) = [];
deltafictiousCellsTh = sortrows(deltafictiousCells,fictMap('DeAcgThInx')); %theta index sorted
deltafictiousCellsDe = sortrows(deltafictiousCells,fictMap('DeAcgDeInx')); % delta index sorted
% theta index threshold during delta:
deltaThInxtrsh = deltafictiousCellsTh(end-round(size(deltafictiousCellsTh,1)/signif),fictMap('DeAcgThInx'));
% delta index threshold during delta:
deltaDeInxtrsh = deltafictiousCellsDe(end-round(size(deltafictiousCellsDe,1)/signif),fictMap('DeAcgDeInx'));

if isPlot
    figure; hold on
    plot(deltafictiousCells(:,fictMap('DeAcgThInx')),deltafictiousCells(:,fictMap('DeAcgDeInx')), '.');
    plot([deltaThInxtrsh,deltaThInxtrsh],[-1,deltaDeInxtrsh],'k'); % theta index threshold
    plot([-1,deltaThInxtrsh],[deltaDeInxtrsh,deltaDeInxtrsh],'k'); % theta index threshold
    plot([deltaThInxtrsh, min(1,deltaThInxtrsh/deltaDeInxtrsh)],[deltaDeInxtrsh,min(1,deltaDeInxtrsh/deltaThInxtrsh)],'k'); %where both index is significant
    title({['Randpoisson during DELTA, integral threshold: ' num2str(DESUMACGTRESH)]; ...
        ['thetaIndex tresh; ',num2str(deltaThInxtrsh),', deltaIndex tresh; ',num2str(deltaDeInxtrsh)]});
    xlabel('Theta index')
    ylabel('Delta index')
    if issave
        savefig(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','fictDELTA'));
        close
    end
end

%% Save
if issave
    save(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','fictMap'),'fictMap'); %map object
    save(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','fictiousCells'),'fictiousCells'); %all fictious cells data
    save(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','indexTresholds'),...
        'thetaThInxtrsh','thetaDeInxtrsh','deltaThInxtrsh','deltaDeInxtrsh'); %thresholds
end
end