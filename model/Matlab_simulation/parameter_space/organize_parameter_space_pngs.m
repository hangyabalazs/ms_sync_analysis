function organize_parameter_space_pngs(sortBy)
%ORGANIZE_PARAMETER_SPACE_PNGS Sorts parameter space simulation results
%based on given criteria.
%   ORGANIZE_PARAMETER_SPACE_PNGS(SORTBY) sorts parameter space simulation 
%   result pngs (HIPPO_FIELD_MS_UNIT generated raster-, state detection-, 
%   and wavelet plots) according to the given vector SORTBY. It eases the 
%   visual exploration of different parameter effects. Source folder path 
%   of pngs: RESULTDIR\field_and_unit, target folder: RESULTDIR\sorted_parameter_space.
%   Originaly, parameter combination matrix columns are: 1st: connRate,
%   2nd: stimAmpMus, 3rd: stimVars, 4th: synDelayMus, 5th: synWeightMus.
%   Input parameters:
%   SORTBY: vector, specifying which parameter to use first, second, ...
%   etc. to organize recordings (1 recording = 1 parameter arrangement).
%   E.g.: [2,3,1] belongs to stimAmpMus, stimVars, connRate organized folder.
%
%   See also SIMULATE_PARAMETER_SPACE, EXPLORE_PARAMETER_SPACE, 
%   CONVERT_MODEL_OUTPUT, HIPPO_FIELD_MS_UNIT, GENERATE_AND_SIMULATE_MODEL.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 25/09/2020

global DATADIR
global RESULTDIR

if nargin == 0
    variable_definitions; %sortBy definitions
end

load(fullfile(RESULTDIR,'parameters.mat'),'activeRecIds');
animals = unique(activeRecIds(:,1));
nRepetition = numel(animals); % number of repetition for each parameter arrangement (= #animals)
load(fullfile(DATADIR,animals{1},'parameter_combinations.mat'),'combs');
% Check if recordings were organized differently across animals:
for it = 1:nRepetition
    nCombs = load(fullfile(DATADIR,animals{it},'parameter_combinations.mat'),'combs');
    if ~isequal(nCombs.combs,combs) % When the raws are not identical across animals
        return
    end
end

% sort parameter combination matrix's rows (recordings) according to SORTBY vector:
[sortedCombs,inx] = sortrows(combs,sortBy);

% remove previous sorting:
if exist(fullfile(RESULTDIR,'sorted_parameter_space'),'dir')
    rmdir(fullfile(RESULTDIR,'sorted_parameter_space'));
end
% create target folder for sorted pngs:
mkdir(fullfile(RESULTDIR,'sorted_parameter_space'));
for it = 1:size(sortedCombs,1)
    for it2 = 1:nRepetition % go trough each animal
        srcFile = fullfile(RESULTDIR,'field_and_unit',[animals{it2},num2str(inx(it)),'.png']);
        trgtFile = fullfile(RESULTDIR,'sorted_parameter_space',[num2str(it),'_',animals{it2},num2str(inx(it)),'.png']);
        copyfile(srcFile,trgtFile);
    end
end
end