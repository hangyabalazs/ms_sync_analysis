function build_allCell()
%BUILD_ALLCELL Collects every properties of MS cells.
%   BUILD_ALLCELL() collects every calculated properties (theta and delta: 
%   acgs, rhythmicities, phase preferences, burst properties) of all cells to 
%   a single matrix ALLCELL. Also determines rhythmicity identity.
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, CELL_RHYTHMICITY,
%   CELL_BURST_PARAMETERS, CELL_PHASE_PREFERENCE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global THSUMACGTRESH
global DESUMACGTRESH
global CGWINDOW
global NSR
global PHASEHISTEDGES

% Collect all real cell data:
cellFNames = listfiles(fullfile(RESULTDIR,'MS_cell_rhythmicity','acgs'));
nCells = length(cellFNames); % number of fictious cells

% Define map object
keySet = {'animalId','recordingId','shankId','cellId',...
    'ThAcgThInx','ThAcgDeInx','DeAcgThInx','DeAcgDeInx','nAPtheta','nAPdelta', ...
    'thetaLength','deltaLength','thsumacr','desumacr','thetaFr','deltaFr','thetaBurstInx', ...
    'thetaMA','thetaMRL','thetaZ','thetaPRayleigh','thetaU','thetaPRao1','thetaPRao2',...
    'deltaMA','deltaMRL','deltaZ','deltaPRayleigh','deltaU','deltaPRao1','deltaPRao2',...
    'thetaHistValuesFirst','thetaHistValuesLast','deltaHistValuesFirst','deltaHistValuesLast',...
    'thetaAcgFirst','thetaAcgLast','deltaAcgFirst','deltaAcgLast',...
    'duringTheta','duringDelta','rhGroup',...
    'nSingleAPsTh','singleApRatioTh','medBurstLeTh','medBurstnAPTh','medBurstFrTh',...
    'nSingleAPsDe','singleApRatioDe','medBurstLeDe','medBurstnAPDe','medBurstFrDe'};
acgLe = CGWINDOW * NSR * 2; % length of ACGs
paramLength = [1,1,1,1,...
    1,1,1,1,1,1,...
    1,1,1,1,1,1,1,...
    1,1,1,1,1,1,1,...
    1,1,1,1,1,1,1,...
    1,length(PHASEHISTEDGES)-2,1,length(PHASEHISTEDGES)-2,...
    1,acgLe-1,1,acgLe-1,...
    1,1,1,...
    1,1,1,1,1,...
    1,1,1,1,1];
valueSet = cumsum(paramLength);
mO = containers.Map(keySet,valueSet); % map object

% Load index thresholds:
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','indexTresholds'));

% Allocate matrix for cell features
allCell = zeros(nCells,valueSet(end));
for it = 1:length(cellFNames)
    IDvector = regexp(cellFNames{it},'\d*','Match');
    animalId = str2num(IDvector{1});
    recordingId = str2num(IDvector{2});
    shankId = str2num(IDvector{3});
    cellId = str2num(IDvector{4});
    load(fullfile(RESULTDIR,'MS_cell_rhythmicity','acgs',cellFNames{it}));
    load(fullfile(RESULTDIR,'MS_cell_phase_pref','phaseData',cellFNames{it}));
    load(fullfile(RESULTDIR,'MS_cell_bursts',cellFNames{it}));
    
    % Determine rhythmicity group belon
    % THETA:
    if thsumacr < THSUMACGTRESH % not enough data
        duringTheta = 3;
    elseif ThAcgThInx/thetaThInxtrsh > max(ThAcgDeInx/thetaDeInxtrsh,1) % theta rhythmic
        duringTheta = 2;
    elseif ThAcgDeInx/thetaDeInxtrsh > max(ThAcgThInx/thetaThInxtrsh,1) % delta rhythmic
        duringTheta = 1;
    elseif ThAcgThInx < thetaThInxtrsh & ThAcgDeInx < thetaDeInxtrsh % not-rhythmic
        duringTheta = 0;
    end
    
    % DELTA:
    if desumacr < DESUMACGTRESH % not enough data
        duringDelta = 3;
    elseif DeAcgThInx/deltaThInxtrsh > max(DeAcgDeInx/deltaDeInxtrsh,1) % theta rhythmic
        duringDelta = 2;
    elseif DeAcgDeInx/deltaDeInxtrsh > max(DeAcgThInx/deltaThInxtrsh,1) % delta rhythmic
        duringDelta = 1;
    elseif DeAcgThInx < deltaThInxtrsh & DeAcgDeInx < deltaDeInxtrsh % not-rhythmic
        duringDelta = 0;
    end
    
    cntr = 1;
    while cntr<=length(keySet) % looks unneccesary, but for the sake of correctness...
        if ~isempty(regexp(keySet{cntr},'First','Match')) % in the case of vector value parameter
            startInd = valueSet(cntr);
            endInd = valueSet(cntr+1);
            varName = keySet{cntr}(1:end-5); % cut 'First' from the end of the name
            allCell(it,startInd:endInd) = eval(varName);
            cntr = cntr + 1;
        else % in the case of single value parameter
            if exist(keySet{cntr},'var') % if already computed
                allCell(it,valueSet(cntr)) = eval(keySet{cntr});
            else % if not computed yet
                allCell(it,valueSet(cntr)) = NaN;
            end
        end
        cntr = cntr + 1;
    end
end

allCell = sortrows(allCell,[mO('animalId'),mO('recordingId'),mO('shankId'),mO('cellId')]);

%% Save
save(fullfile(RESULTDIR,'cell_features','allCellMap'),'mO'); % map object
save(fullfile(RESULTDIR,'cell_features','allCell'),'allCell'); % all real cells data
end