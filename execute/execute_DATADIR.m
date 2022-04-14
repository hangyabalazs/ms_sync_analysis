function [output1,output2] = execute_DATADIR(funcCallDef,m)
%EXECUTE_DATADIR executes given instructions for all recording/ cells.
%   [OUTPUT1,OUTPUT2] = EXECUTE_DATADIR(FUNCCALDEF,M) iterates trough all
%   recordings in DATADIR executing FUNCCALDEF function call definition on
%   each.
%   If M is 'rec' it executes the function call on every recording. If M
%   is 'cell' it lists all cells from the PREPROCDIR (given animal,
%   recording), and executes the function call for every cell.
%   Parameters:
%   FUNCCALDEF: string (e.g. 'save_hippocampal_field(animalIdN,recordingIdN,true)').
%   M: string, controlling function behaviour ('rec' or 'cell').
%   OUTPUT1 and OUTPUT2: arrays (vector and cell), storing optional outputs.
%
%   See also MAIN_ANALYSIS, COLLECT_ACTIVE_RECORDINGS, EXECUTE_ACTIVERECIDS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
load(fullfile(RESULTDIR,'parameters.mat'));

if nargin == 0
    variable_definitions; %funcCallDef, (isKeep) definition
end

animalFolders = dir(DATADIR);

output1 = zeros(1000,1);
output2 = cell(1000,1);
cntr = 1;
for it1 = 1:length(animalFolders) % iterate trough all animals
    animalIdN = animalFolders(it1).name;
    recordingFolders = dir(fullfile(DATADIR, animalIdN));
    for it2 = 1:length(recordingFolders) % iterate trough all recordings
        recordingIdN = recordingFolders(it2).name;
        animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
        recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining
        if strcmp(m,'rec') % mode1: iterate trough recordings
            eval(funcCallDef); % evaluate function call
            cntr = cntr+1;
        elseif strcmp(m,'cell') % mode2: iterate trough all cells
            for shankId = 1:4 % iterate trough all shanks
                if exist(fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,'.clu.',num2str(shankId)]))
                    clu = load(fullfile(DATADIR,animalIdN, recordingIdN,[animalId,recordingId,'.clu.',num2str(shankId)]));
                    cellIDs = unique(clu);
                    for it4 = 1:length(cellIDs)
                        cellId = cellIDs(it4);
                        eval(funcCallDef); % evaulate function call
                    end
                end
            end
        end
    end
    
    output1(it1+1:end) = [];
    output2(it1+1:end) = [];
end
end