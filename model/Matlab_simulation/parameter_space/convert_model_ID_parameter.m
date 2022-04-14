function output = convert_model_ID_parameter(argument)
%CONVERT_MODEL_ID_PARAMETER for parameter arrangement - simulation Id
%pairing in modeling studies.
%   CONVERT_MODEL_ID_PARAMETER(ARGUMENT)
%   Option1: if ARGUMENT is a RECORDINGID (string) returns parameter 
%   arrangement for a given simulation ID.
%   Option2: if ARGUMENT is a parameter arrangement (vector), returns the 
%   simulation ID.
%   
%   See also SIMULATE_PARAMETER_SPACE, HIPPO_FIELD_MS_UNIT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 14/08/2021

global DATADIR

% Load parameter combinations (different simulations -> recordings):
animalIds = listdir(DATADIR);
% Check if repetitive simuilations (~animals) were executed in the same
% order (COMB matrix are identical across animals):
animal1 = load(fullfile(DATADIR,animalIds{1},'parameter_combinations.mat'));
for it = 2:numel(animalIds)
    r = load(fullfile(DATADIR,animalIds{it},'parameter_combinations.mat'));
    if ~isequal(animal1,r)
        error('Different parameter combination orders! Simulations should be sorted first!')
    end
end
load(fullfile(DATADIR,animalIds{10},'parameter_combinations.mat'));

if isstr(argument) % if recordingId is provided
    output = combs(str2num(argument),:); % parameter arrangement
else % if parameter arrangement is provided
    [~,output] = ismembertol(argument,combs,eps,'ByRows',true); % recordingId
    output = num2str(output);
end

end