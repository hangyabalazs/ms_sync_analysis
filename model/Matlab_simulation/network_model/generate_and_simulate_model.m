function generate_and_simulate_model(isAnalysis)
%GENERATE_AND_SIMULATE_MODEL Creates a series of simulation with same 
%core parameters.
%   GENERATE_AND_SIMULATE_MODEL(ISANALYSIS) creates a series of simulations
%   and than run automatic analysis on the results (if ISANALYSIS exists).
%   Workflow:
%   1. Definition of average network parameters (same across simulations).
%   2. Creation of actual network parameters (sampling normal distribution).
%   3. Execute Neuron network simulation .hoc file with the defined parameters.
%   (RESPATH need to be in the Neuron installation folder).
%   4. Convert Neuron output binary files to Matlab interpretable formats 
%   (partly preprocess Neurons data: assign spikes to clusters (creation of
%   .res and .clu files), calculate theoretical hippocampal signal).
%   5. Copy simulation data from Neuron's folder to DATADIR.
%   6. Repeat 2-5. NRECORDING times, generating new "actual"
%   parameters in each iteration.
%   Parameters:
%   ISANALYSIS: flag variable, if exist MAIN_ANALYSIS is called after
%   simulations.
%
%   See also MODEL_PARAMETER_DEFINITIONS, CREATE_NETWORK_PARAMETERS, 
%   RUN_NETWORK_SIMULATION, CONVERT_MODEL_OUTPUT, MODEL_NETWORK_GRAPH, 
%   SIMULATE_PARAMETER_SPACE, EXPLORE_PARAMETER_SPACE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/03/2019

MODEL_GLOBALTABLE

global WORKFOLDER
global DATADIR
global PREPROCDIR

%results path definition:
model_resPath_def;
% etwork parameter definitions (basic, stimulations, synapses, etc.)
model_parameter_definitions; % overwrite parameters here

mkdir(fullfile(DATADIR,animalIdb));
save(fullfile(DATADIR,animalIdb,'basic_network_parameters.mat'),'nCells','segmLength','connRate',...
    'stimAmpMu','tonicIncrease','stimVar','synDelayMu','synWeightMu','thrshMu','synVar','deltaMod');

% Simulate model multiple times (nRecordings)
for it = 1:nRepeat
    recordingId = num2str(it);
    % Creation of actual network parameters:
    create_network_parameters(resPath,nCells,segmLength,connRate,stimAmpMu,...
        stimVar,synDelayMu,synWeightMu,thrshMu,synVar,tonicIncrease,deltaMod);
    % Run Neuron simulation:
    run_network_simulation(resPath);
    % Preprocess Neuron output:
    mkdir(fullfile(DATADIR,animalIdb,recordingId));
    mkdir(fullfile(PREPROCDIR,animalIdb,recordingId));
    convert_model_output(resPath,animalIdb,recordingId,true); close
    % Copy files to DATADIR:
    recFiles = return_used_folders(dir(fullfile(resPath,'actual_run')),false,{'.'});
    for it2 = 1:length(recFiles)
        movefile(fullfile(resPath,'actual_run',recFiles(it2).name),fullfile(DATADIR,animalIdb,recordingId,recFiles(it2).name));
    end
end
clear all
MODEL_GLOBALTABLE
activeRecIds = collect_active_recordings();
save(fullfile(RESULTDIR, 'parameters'),'activeRecIds','-append')

% Optional, run model results analysis (MAIN_ANALYSIS)
if exist('isAnalysis','var')
    MAIN_ANALYSIS
end
end