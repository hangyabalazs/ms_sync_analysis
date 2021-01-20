function run_network_simulation(resPath)
%RUN_NETWORK_SIMULATION Runs Neuron simulation with defined parameters.
%   RUN_NETWORK_SIMULATION(RESPATH) runs Neuron software network simulation 
%   (located at: \model\Neuron_simulation\networkmodel\pacemaker_networkpacemaker_network_simulation.hoc).
%   IMPORTANT! Neuron installation is required for this step, and mknrndll
%   need to run in the folder where the hoc file is located (for translation
%   of mod files).
%
%   See also: GENERATE_AND_SIMULATE_MODEL, CREATE_NETWORK_PARAMETERS,
%   CONVERT_MODEL_OUTPUT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 05/04/2018

if ~exist('resPath','var')
    % Path to Neuron software folder's network simulation directory:
    model_resPath_def;
end
if ~exist(fullfile(resPath,'actual_run','parameters.txt'),'file')
    create_network_parameters; %create network parameters
end
% load(fullfile(resPath,'actual_run','basic_network_parameters.mat'),'nCells','segmLength');

%%RUN NEURON SIMULATION:
% remove flag file (indicator of NEURON termination) if exists:
if exist(fullfile(resPath,'actual_run','flag_file'), 'file')
    delete(fullfile(resPath,'actual_run','flag_file'))
end
% run simulation:
winopen(fullfile(resPath,'pacemaker_network_simulation.hoc'))

% wait NEURON to complete stimulation:
iterationThresh = 0;
while exist(fullfile(resPath,'actual_run','flag_file'), 'file') ~=2
    pause(0.5);
    iterationThresh = iterationThresh + 1;
%     if iterationThresh>nCells*sum(segmLength) % if neuron is unresponsive for a longer time
%         ['Waiting for more than ' num2str(iterationThresh) ' iteration']
%         return
%     end
end

end