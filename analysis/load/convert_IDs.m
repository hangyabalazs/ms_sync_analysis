function IDs = convert_IDs(IDs)
%CONVERT_IDS Converts IDs array to conventional IDs cell.
%   IDS = CONVERT_IDS(IDS)  In IDS each row belongs to a cell. 
%   Output: #cells x 4 (animalId,recordingId, shankId, cellId) cell
%   array containing strings.
%   Possible input options:
%   IDs: rowIds vector pointing to given rows of allCell table.
%   IDs: partially numeric cell array (e.g. cellIds are numbers).
%   
%   See also RASTER_PLOT, TWO_CYCLES_PHASEHISTOGRAM.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 06/11/2020

if ~iscell(IDs) % if rowIds (in allCell matrix) are given
    global RESULTDIR
    for it = 1:numel(IDs)
        % Load data table
        load(fullfile(RESULTDIR,'cell_features','allCell.mat'), 'allCell');
        % Load map for allCell matrix (mO):
        load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'),'mO');
        IDs2{it,1} = allCell(IDs(it), mO('animalId'));
        IDs2{it,2} = allCell(IDs(it), mO('recordingId'));
        IDs2{it,3} = allCell(IDs(it), mO('shankId'));
        IDs2{it,4} = allCell(IDs(it), mO('cellId'));
    end
    IDs = IDs2;
end
IDs = cellfun(@num2str,IDs,'un',0);
end