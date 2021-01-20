function create_network_parameters(resPath,nCells,segmLength,connRate,stimAmpMu,stimVar,synDelayMu,synWeightMu,thrshMu,synVar,tonicIncrease,deltaMod)
%CREATE_NETWORK_PARAMETERS Creates all parameters of a model network.
%   CREATE_NETWORK_PARAMETERS(RESPATH,NCELLS,SEGMLENGTH,CONNRATE,STIMAMPMU,
%   STIMVAR,SYNDELAYMU,SYNWEIGHTMU,THRSHMU,SYNVAR,TONICINCREASE,DELTAMOD)
%   creates network parameters (synapsis, stimulations) by sampling normal 
%   distributions specified by their means and variance (inputs).
%   Parameters (defaults are specified below):
%   RESPATH: path to Neuron software folder's network simulation
%   directory.
%   NCELLS: number of cells in the network.
%   SEGMLENGTH: segment length in ms (non-theta, theta, non-theta).
%   CONNRATE: connection rate (not every cell connected).
%   STIMAMPMU: mean stimulation amplitude (nA) (Neuron built-in IClamp object).
%   TONICINCREASE: stimulation strength increase at non-theta - theta.
%   STIMVAR: variance stimulation amplitude.
%   SYNDELAYMU: mean synaptic delay (ms) (Neuron built-in Expsyn object) 
%   (or decays, depending on which row is commented in 
%   pacemaker_network_simulation.hoc file).
%   SYNWEIGHTMU: mean synaptic weight (Neuron built-in NetCon object).
%   THRESHMU: mean synaptic threshold (Neuron built-in Expsyn object).
%   SYNVAR: synaptic variance in delay and weight.
%   DELTAMOD: delta modulation amplitude (compared to tonic excitation).
% 
%   See also GENERATE_AND_SIMULATE_MODEL, CREATE_TXT_PARAMFILE, 
%   CONVERT_MODEL_OUTPUT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/07/2018

if nargin == 0
    % Definition of basic network parameters:
    model_resPath_def; % mcore parameter definitions
    model_parameter_definitions;
    save(fullfile(resPath,'actual_run','basic_network_parameters.mat'),'nCells','segmLength','connRate',...
    'stimAmpMu','tonicIncrease','stimVar','synDelayMu','synWeightMu','thrshMu','synVar','deltaMod');
end

% Parameter definitions:
deltaFr = 1; % delta modulation frequency (Hz)

%% STIMULATION
% TONIC STIMULATION:
% allocation (each row is a stimulating electrode on one cell),
% 4 columns: cellId|strength|duration|delay
stimMatrix = zeros(nCells*3, 4); % allocation (each row is a stimulating electrode on one cell)
% during delta1:
stimMatrix(1:nCells, 1) = (1:nCells).' - 1; % ID of stimulated cell
stimMatrix(1:nCells, 2) = sample_normal_dist(stimAmpMu, stimAmpMu*stimVar, nCells, 1); % delta tonic stimulation (weaker)
% during theta:
stimMatrix(nCells+1:nCells*2, 1) = (1:nCells).'-1; % ID of stimulated cell
stimMatrix(nCells+1:nCells*2, 2) = stimMatrix(1:nCells, 2) * tonicIncrease; % theta tonic stimulation (stronger)
% stimMatrix(nCells+1:nCells*2, 2) = (stimMatrix(1:nCells, 2)-stimAmpMu) / 3 + stimAmpMu;
% during delta2 (same as above):
stimMatrix(nCells*2+1:nCells*3, 1) = (1:nCells).' - 1; % ID of stimulated cell
stimMatrix(nCells*2+1:nCells*3, 2) = stimMatrix(1:nCells, 2);% delta tonic stimulation (weaker, same as above)

if length(segmLength) == 1 % same for all simulated segments
    segmLength = repmat(segmLength,1,3);
end

% stimulation lengths (during theta and delta1,2):
stimLengths = repmat(segmLength, nCells, 1);
stimMatrix(:, 3) = stimLengths(:);
% stimulation delays (first delta1, than theta, and delta2):
stimMatrix(1:nCells, 4) = repmat(0, nCells, 1); % elta
stimMatrix(nCells+1:nCells*2, 4) = repmat(segmLength(1), nCells, 1); % theta
stimMatrix(nCells*2+1:nCells*3, 4) = repmat(segmLength(1)+segmLength(2), nCells, 1); % delta

% DELTA MODULATION:
deltaMod = mean(stimMatrix(:,2))*deltaMod; % calculate actual amplitude
% allocation (each row is a stimulating electrode on one cell),
% 5 columns: cellId|peakAmplitude|frequency|duration|delay
deltaStimMatrix = zeros(nCells*2, 5);
% Peak amplitudes:
% during delta1
deltaStimMatrix(1:nCells, 1) = (1:nCells).' - 1; % ID of stimulated cell
deltaStimMatrix(1:nCells, 2) = deltaMod; % delta1 amplitude
% during delta2
deltaStimMatrix(nCells+1:nCells*2, 1) = (1:nCells).' - 1; % ID of stimulated cell
deltaStimMatrix(nCells+1:nCells*2, 2) = deltaMod; % delta2 amplitude
% delta modulation frequencies:
deltaStimMatrix(:, 3) = repmat(deltaFr,nCells*2,1); %delta modulation frequency
% stimulations lengths:
deltaLengths = repmat([segmLength(1),segmLength(3)], nCells, 1);% delta1
deltaStimMatrix(:, 4) = deltaLengths(:); % delta2
% stimulation delays:
deltaStimMatrix(1:nCells, 5) = repmat(0,nCells,1); % delta1
deltaStimMatrix(nCells+1:nCells*2, 5) = repmat(segmLength(1)+segmLength(2), nCells, 1); % delta2

%% SYNAPSIS
% synaptic thresholds (st, correctly reversal potential) for Neuron built-in Expsyn object (mV):
thrshMatrix = ones(nCells)*thrshMu;
thrshMatrix = thrshMatrix - diag(diag(thrshMatrix)); % clear "self-connections"
% synaptical delay (or decay, see Help) variance:
syDelaySigma = synDelayMu*synVar;
delayMatrix = sample_normal_dist(synDelayMu, syDelaySigma, nCells, nCells);
delayMatrix = delayMatrix - diag(diag(delayMatrix)); % clear "self-connections"
% synaptical weight varriance:
synWeightSigma = abs(synWeightMu*synVar);
weightMatrix = sample_normal_dist(synWeightMu, synWeightSigma, nCells, nCells);
weightMatrix = weightMatrix - diag(diag(weightMatrix)); % clear "self-connections"

% Discard specific synapses (edges) from total graph (specified by CONNRATE):
notChosenSyns = randperm(nCells*nCells,round(nCells*nCells*(1-connRate)));
thrshMatrix(notChosenSyns) = 0;
delayMatrix(notChosenSyns) = 0;
weightMatrix(notChosenSyns) = 0;

% Write parameters to excel file:
xlswrite(fullfile(resPath,'actual_run','header.xlsx'), [nCells,segmLength]);
xlswrite(fullfile(resPath,'actual_run','stimulation.xlsx'), stimMatrix);
xlswrite(fullfile(resPath,'actual_run','deltaStimulation.xlsx'), deltaStimMatrix);
xlswrite(fullfile(resPath,'actual_run','synapses.xlsx'), [thrshMatrix; delayMatrix; weightMatrix]);

% Convert .xlsx parameter files to txt, readable by Neuron
create_txt_paramfile(resPath);

end