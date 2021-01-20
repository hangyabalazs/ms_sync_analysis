function [allData,Ids] = collect_properties(path,m,props,issave)
%COLLECT_PROPERTIES Collect given properties for all recordings or cells.
%   [ALLDATA,IDS] = COLLECT_PROPERTIES(PATH,M,PROPS,ISSAVE) reads given 
%   information (PROPS) from .mat files belonging to recordings OR cells 
%   stored in a common folder by calling EXECUTE_ACTIVERECIDS and than save
%   out a common data and ID matrix:
%   (ALLDATA: #rec (or #cells) x #properties, IDs: rows: recordings (or
%   cells), columns: ANIMALID, RECORDINGID, (SHANKID, CELLID)).
%   By default it loads all variables from the given files, but keep only
%   the PROP specified ones (faster). To load only given variables insert
%   the following line before the end of load function in FUNCCALLDEF:
%   ,''',strjoin(props,''','''),'''
%   That would reduce speed, but in this way conflicts from loaded undesired
%   variables (e.g.: redefinition of animalIds in EXECUTE_ACTIVERECIDS)
%   could be avoided.
%   Parameters:
%   PATH: string, path to folder where files are stored.
%   M: string, controlling function behaviour ('rec' or 'cell').
%   PROPS: cell array containing strings, specifying which variables to
%   to collect from .mat files (e.g.: {'medBurstFrDe','medBurstFrTh'}).
%   ISSAVE: optional, flag, save?
%
%   See also EXECUTE_ACTIVERECIDS, CELL_BURST_PARAMETERS, MODEL_SYNCH_SCORE,
%   EXPLORE_PARAMETER_SPACE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 08/10/2020

if strcmp(m,'rec')
    funcCallDef = ['load([''',path, '\''',',[animalId,recordingId]]);',...
        'output2{cntr} = [',strjoin(props,','),'];'];
elseif strcmp(m,'cell')
    funcCallDef = ['load([''',path, '\''',',[animalId,''_'',recordingId,',...
        '''_'',num2str(shankId),''_'',num2str(cellId)]]);',...
        'output2{cntr} = [',strjoin(props,','),'];'];
end
[~,allData,Ids] = execute_activeRecIds(funcCallDef,m);
allData = cell2mat(allData); % convert to matrix

if exist('issave','var')
    save(fullfile(path,'allData.mat'),'allData','Ids');
end
end
