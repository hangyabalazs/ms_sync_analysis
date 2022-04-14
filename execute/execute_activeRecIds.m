function [output1,output2,IDs] = execute_activeRecIds(funcCallDef,m,issort)
%EXECUTE_ACTIVERECIDS executes given instructions for all active recording/
%cells in active recordings.
%   [OUTPUT1,OUTPUT2?IDS] = EXECUTE_ACTIVERECIDS(FUNCCALDEF,M) iterates 
%   trough all active recordings, executing FUNCCALDEF function call 
%   definition on each.
%   If M is 'rec' it executes the function call on every recording. If M
%   is 'cell' it lists all cells from the PREPROCDIR (given animal,
%   recording), and executes the function call for every cell.
%   Parameters:
%   FUNCCALDEF: string (e.g. 'save_hippocampal_field(animalIdN,recordingIdN,true)').
%   M: string, controlling function behaviour ('rec' or 'cell').
%   ISSORT: sort ACTIVERECIDS array. If not specified, than instructions 
%   will be executed in the original order of recordings (based on
%   filenames).
%   OUTPUT1 and OUTPUT2: arrays (vector and cell), storing optional outputs.
%   IDS: optional output, collecting Ids of elements.
%
%   See also MAIN_ANALYSIS, COLLECT_ACTIVE_RECORDINGS, EXECUTE_DATADIR,
%   EXECUTE_RHGROUPS, COLLECT_PROPERTIES.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
load(fullfile(RESULTDIR,'parameters.mat'));

if nargin == 0
    variable_definitions; % funcCallDef definition
    %     figure
end

if exist('issort','var')
    activeRecIds = cellstr(string(sortrows(str2double(activeRecIds)))); % sort recordings
    'Recording order sorted!'
end

cntr = 1;
output1 = zeros(15000,1); % optional outputs
output2 = cell(15000,1); % optional outputs
% output, collection of Ids:
if strcmp(m,'rec')
    IDs = zeros(2000,2); % animalId|recordingId
elseif strcmp(m,'cell')
    IDs = zeros(20000,4); % animalId|recordingId|shankId|cellId
end
for it1 = 1:size(activeRecIds,1) % iterate trough active recordings
    animalId = activeRecIds{it1,1};
    recordingId = activeRecIds{it1,2};
    if strcmp(m,'rec') % mode1: iterate trough recordings
        eval(funcCallDef); % evaluate function call
        IDs(cntr,:) = [str2num(animalId),str2num(recordingId)];
        cntr = cntr+1;
    elseif strcmp(m,'cell') % mode2: iterate trough all cells
        cellIdFnameS = listfiles(fullfile(PREPROCDIR,animalId, recordingId),'TT');
        for it2 = 1:length(cellIdFnameS) % iterate trough all cells
            [shankId,cellId] = cbId2shankcellId(cellIdFnameS{it2});
            eval(funcCallDef); % evaluate function call
            IDs(cntr,:) = [str2num(animalId),str2num(recordingId),shankId,cellId];
            cntr = cntr+1;
        end
    end
end

output1(cntr:end) = [];
output2(cntr:end) = [];
IDs(cntr:end,:) = [];
end