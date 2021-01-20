function raster_plot_cellId(animalId,recordingId,shankIds,cellIds)
%RASTER_PLOT_CELLID calls simply turns
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKIDS: number vector, (e.g. [1,2]).
%   CELLIDS: number vector, (e.g [2,3]).
%
%   See also RASTER_PLOT.
%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 08/08/2018

if nargin == 0
    variable_definitions; %animalId, recordingId, shankIds, cellsIds, tWindow definitions
    figure('Position',get(0, 'Screensize'));
end
rowIds = find_rowIds(animalId,recordingId,shankIds,cellIds);
raster_plot_rowId(rowIds,tWindow);
end