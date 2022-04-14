%MODEL_PARAMETER_DEFINITIONS defines model parameters for simulations
%executed either from GENERATE_AND_SIMULATE_MODEL or SIMULATE_PARAMETER_SPACE.
%
%   See also SIMULATE_PARAMETER_SPACE, GENERATE_AND_SIMULATE_MODEL,
%   EXPLORE_PARAMETER_SPACE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/10/2019

% Definition of basic network parameters:
nCells = 20; % number of cells in the network
deltaMod = 0; % no delta modulation (amplitude)
% animalId in parameter/ variance space: animalIdb+ number of the repetition,
% when parameters are fixed: animalId = animalIdb):
animalIdb = '20211123';
maxLatency = 1000; % maximum delay between cell stimulations (to avoid phase reset sync)

% Parameter/ variance space analysis (combinations):
if  exist('WORKFOLDER','var') & contains(WORKFOLDER,{'parameter_space','delay_space','variance_space'})
    segmLength = [5000,10000,5000]; % segment length in ms (non-theta, theta, non-theta)
    tonicIncreases = 1.4; % stimulation strength increases at non-theta - theta
    synDecayMus = 2; % mean synaptic decays (ms) (Neuron built-in Expsyn object)
    synVars = 0.1; % synaptic variances in delay and weight
    thrshMu = -70; % mean synaptic reversal potential (Neuron built-in Expsyn object)
    nRepeat = 10; % number of simulation repetation for each parameter combination
    if contains(WORKFOLDER,'parameter_space')
        stimAmpMus = [4,5,6,7,8]*0.01; % mean stimulation amplitudes (nA) (Neuron built-in IClamp object)
        synWeightMus = [1,3,6,9,12]*0.001; % mean synaptic weights (Neuron built-in NetCon object)
        connRates = [0,0.2,0.4,0.6,0.8,1]; % connection rates (not every cell connected) (VARYING)
        synDelayMus = 7; % mean synaptic delays (ms) (Neuron built-in Netcon object) (FIXED)
        stimVars = 0.1; % variance stimulation amplitude (FIXED)
    elseif contains(WORKFOLDER,'delay_space')
        stimAmpMus = 0.06; % mean stimulation amplitudes (nA) (Neuron built-in IClamp object)
        synWeightMus = 0.003; % mean synaptic weights (Neuron built-in NetCon object)
        connRates = [0,0.2,0.4,0.6,0.8,1]; % connection rates (not every cell connected) (VARYING)
        synDelayMus = [1,4,7,11,15]; % mean synaptic delays (ms) (Neuron built-in Netcon object) (VARYING)
        stimVars = 0.1; % variances stimulation amplitude (FIXED)
    elseif contains(WORKFOLDER,'variance_space')
        stimAmpMus = 0.06; % mean stimulation amplitudes (nA) (Neuron built-in IClamp object)
        synWeightMus = 0.003; % mean synaptic weights (Neuron built-in NetCon object)
        connRates = [0,0.2,0.4,0.6,0.8,1]; % connection rates (not every cell connected) (FIXED)
        synDelayMus = 7; % mean synaptic delays (ms) (Neuron built-in Netcon object) (FIXED)
        stimVars = [0,0.05,0.1,0.15,0.2]; % variances stimulation amplitude (VARYING)
    end
else % Model network analysis (with fixed parameters):
    segmLength = [20000,20000,20000]; % segment length in ms (non-theta, theta, non-theta)
    connRate = 0.6; % connection rate (not every cell connected)
    stimAmpMu = 0.06; % mean stimulation amplitude (0.06nA/5000um2 -> 1.2uA/cm2) (Neuron built-in IClamp object)
    tonicIncrease = 1.4; % stimulation strength increase at non-theta - theta
    stimVar = 0.1; % variance stimulation amplitude
    synDecayMu = 2; % mean synaptic decay (ms) (Neuron built-in Expsyn object)
    synDelayMu = 7; % mean synaptic delay (ms) (Neuron built-in Netcon object)
    synWeightMu = 0.003; % mean synaptic weight (0.001uS/5000um2 -> 0.2pS/um2) (Neuron built-in NetCon object)
    synVar = 0.1; % synaptic variances in decay and weight (IN DELAY??????????????????)
    thrshMu = -70; % mean synaptic reversal potential (Neuron built-in Expsyn object)
    nRepeat = 60; % number of repetitions
end