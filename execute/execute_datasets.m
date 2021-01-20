function execute_datasets()
%EXECUTE_DATASETS executes given instructions for all datasets.
%   EXECUTE_DATASETS iterates trough all datasets executing FUNCCALDEF 
%   (specified in VARIABLE_DEFINITIONS or stored in the current directory/
%   funcCallDef.mat file) function call definition on each.
%
%   See also MAIN_ANALYSIS, EXECUTE_ACTIVERECIDS, EXECUTE_RHGROUPS,
%   EXECUTE_OPTOGROUPS, DATASET_COLORS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

ANA_RAT_GLOBALTABLE, variable_definitions; load('funcCallDef.mat')
[sColor,symbol,markerSize] = dataset_colors(PROJECTID); % data set color, symbols for ploting
eval(funcCallDef); % evaluate function call

ANA_MOUSE_GLOBALTABLE, variable_definitions; load('funcCallDef.mat')
[sColor,symbol,markerSize] = dataset_colors(PROJECTID); % data set color, symbols for ploting
eval(funcCallDef); % evaluate function call

OPTO_GLOBALTABLE, variable_definitions; load('funcCallDef.mat')
[sColor,symbol,markerSize] = dataset_colors(PROJECTID); % data set color, symbols for ploting
eval(funcCallDef); % evaluate function call

FREE_MOUSE_GLOBALTABLE, variable_definitions; load('funcCallDef.mat')
[sColor,symbol,markerSize] = dataset_colors(PROJECTID); % data set color, symbols for ploting
eval(funcCallDef); % evaluate function call

MODEL_GLOBALTABLE, variable_definitions; load('funcCallDef.mat')
[sColor,symbol,markerSize] = dataset_colors(PROJECTID); % data set color, symbols for ploting
eval(funcCallDef); % evaluate function call
% OR when MAIN_ANALYSIS is executed for all datasets, and no model was simulated yet:
% (network parameters are specified in model_parameter_definitions());
% generate_and_simulate_model();
% OR when you want to simulate the parameter space:
% MODEL_GLOBALTABLE_par; simulate_parameter_space; explore_parameter_space;
% OR when you want to simulate the variance space:
% MODEL_GLOBALTABLE_var; simulate_parameter_space; explore_parameter_space;
end