function simulate_parameter_space()
%SIMULATE_PARAMETER_SPACE Parameter space perambulation.
%   SIMULATE_PARAMETER_SPACE() creates the parameter space of pacemaker 
%   network and explore it by running NEURON simulations and save out 
%   preprocessed data for each parameter arrangement. 
%   Call EXPLORE_PARAMETER_SPACE after the simulations to obtain results.
%   Basically:
%   - each parameter arrangement is simulated 10 times
%   - a 10 s non-theta (weaker stim.), a 10 s theta (stronger stim.) and a 
%   subsequent 10 s non-theta (weaker stim.) is simulated (to see 
%   desynchronization as well).
%   Adjustable parameters:
%   - connRate: average connection rate in the network.
%   - synDecay: average synaptical decays.
%   - synDelay: average synaptical delays.
%   - synWeight: average synaptical weights.
%   - stimAmp: average electrode stimulation strength on every cell (during
%   non-theta, during theta it is increased to TONICINCREASE fold).
%   - stimVar: variances of the stimulation amplitude.
%   Workflow is the same as in the help of GENERATE_AND_SIMULATE_MODEL,
%   except that each simulation is repeated 10 times for each parameter
%   arrangements, and actual parameters (for all combinations) are drawn at
%   the begining.
%
%   See also MODEL_PARAMETER_DEFINITIONS, CREATE_NETWORK_PARAMETERS, 
%   RUN_NETWORK_SIMULATION, CONVERT_MODEL_OUTPUT, MODEL_NETWORK_GRAPH, 
%   ORGANIZE_PARAMETER_SPACE_PNGS, GENERATE_AND_SIMULATE_MODEL, 
%   EXPLORE_PARAMETER_SPACE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/03/2019

%Run MODEL_GLOBALTABLE_par OR MODEL_GLOBALTABLE_var to initialize
%run-parameters

global RESULTDIR
global WORKFOLDER
global DATADIR
global PREPROCDIR

%% Simulation:
% results path definition:
model_resPath_def;
% Network parameter definitions (basic, stimulations, synapses, etc.)
model_parameter_definitions; %Overwrite parameters here

% Create all possible varriation (parameter space):
[ca, cb, cc, cd, ce, cf, cg, ch] = ndgrid(connRates,stimAmpMus,tonicIncreases,stimVars,synDecayMus,synDelayMus,synWeightMus,synVars);
% 1st: connRate, 2nd: stimAmpMus, 3rd: stimVars, 4th: synDelayMus (or decay,
% see Help), 5th: synWeightMus, 6th: tonicIncreases, 7th: synVars
combTable = {'CRs','excs','tIncr','vars','decays','delays','weigths','synVar'};
combs = [ca(:), cb(:), cc(:), cd(:), ce(:), cf(:), cg(:), ch(:)];
% xlswrite(fullfile(resPath, 'parameter_space', 'paramSpace.xlsx'),combs);

for it1 = 1:nRepeat % repeat simulation for each parameter arrangement (resample distribution)
    animalId = [animalIdb,num2str(it1)]; % given ID of the series of simulations
    mkdir(fullfile(DATADIR,animalId));
    save(fullfile(DATADIR,animalId,'parameter_combinations.mat'),'combs','combTable');
    save(fullfile(DATADIR,animalId,'basic_network_parameters.mat'),'nRepeat','nCells','segmLength','connRates',...
    'stimAmpMus','tonicIncreases','stimVars','synDelayMus','synDelayMus','synWeightMus','thrshMu','synVars','deltaMod');
    for it2 = 1:size(combs,1) % iterate trough each parameter arrangement
        recordingId = num2str(it2);
        % Creation of actual network parameters:
        create_network_parameters(resPath,nCells,segmLength,combs(it2,1),combs(it2,2),...
            combs(it2,3),combs(it2,4),combs(it2,5),combs(it2,6),combs(it2,7),...
            thrshMu,combs(it2,8),deltaMod,maxLatency);
        % Run Neuron simulation:
        run_network_simulation(resPath);
        % Preprocess (save spiketimes and theoretical hippo output) Neuron output:
        mkdir(fullfile(DATADIR,animalId,recordingId));
        mkdir(fullfile(PREPROCDIR,animalId,recordingId));
        convert_model_output(resPath,animalId,recordingId,true); close
        % Copy files to DATADIR:
        recFiles = return_used_folders(dir(fullfile(resPath,'actual_run')),false,{'.'});
        for it3 = 1:length(recFiles)
            if ~isequal(recFiles(it3).name,'potentials.dat') & ~isequal(recFiles(it3).name,'time.dat')
                movefile(fullfile(resPath,'actual_run',recFiles(it3).name),fullfile(DATADIR,animalId,recordingId,recFiles(it3).name));
            else
                delete(fullfile(resPath,'actual_run',recFiles(it3).name));
            end
        end
    end
end

%% Collect new recordings:
activeRecIds = collect_active_recordings();
save(fullfile(RESULTDIR,'parameters'),'activeRecIds','-append')

%% Save "expected-state' vectors (delta during weaker stimulation, theta during stronger):
mkdir(fullfile(RESULTDIR,'expected_segments'));
theta = false(1,sum(segmLength));
theta(segmLength(1)+maxLatency+1:segmLength(1)+segmLength(2)) = 1;
delta = false(1,sum(segmLength));
delta([maxLatency+1:segmLength(1),segmLength(1)+segmLength(2)+maxLatency+1:sum(segmLength)]) = 1;
% save vectors temporarily to RESULTDIR and than copy for all recordings
save(fullfile(RESULTDIR,'expected_segments','theta_delta.mat'),'theta','delta');
funcCallDef = ['copyfile(fullfile(RESULTDIR,''expected_segments'',''theta_delta.mat''),',...
    'fullfile(RESULTDIR,''expected_segments'',[animalId,recordingId,''.mat'']))'];
execute_activeRecIds(funcCallDef,'rec');
delete(fullfile(RESULTDIR,'expected_segments','theta_delta.mat'));
end