function cellPairs = cell_IdPairs(animalIds,recordingId)
%CELL_IDPAIRS() creates all possible pairings from a recording 
%   (in model simulations, = fixed parameter arrangement).
%   Parameters:
%   ANIMALIDS: cell array of strings (e.g. {'202106259'}, add more 
%   animalIds to obtain an average in model simulations).
%   RECORDINGID: string (e.g. '20').
%
%   See also ALL_CCG, EXPLORE_PARAMETER_SPACE, PLOT_INTERV_RASTER_CCG,
%   CCG_PEAKLAG_OFFSET, FIND_CORECORDED_CELL_PAIRS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 05/04/2022

global PREPROCDIR

nAnimals = numel(animalIds); % number of animals

% Create cell pairs ID list:
cellPairs = cell(20000,8);
cntr = 1;
for it1 = 1:nAnimals
    cellIdFnameS = listfiles(fullfile(PREPROCDIR,animalIds{it1},recordingId),'TT');
    pairIds = nchoosek(1:numel(cellIdFnameS),2); % create all possible combinations
    for it2 = 1:size(pairIds,1)
        [shankId1,cellId1] = cbId2shankcellId(cellIdFnameS{pairIds(it2,1)});
        [shankId2,cellId2] = cbId2shankcellId(cellIdFnameS{pairIds(it2,2)});
        cellPairs{cntr,1} = animalIds{it1};
        cellPairs{cntr,2} = recordingId;
        cellPairs{cntr,3} = shankId1;
        cellPairs{cntr,4} = cellId1;
        cellPairs{cntr,5} = animalIds{it1};
        cellPairs{cntr,6} = recordingId;
        cellPairs{cntr,7} = shankId2;
        cellPairs{cntr,8} = cellId2;
        cntr = cntr + 1;
    end
end
cellPairs(cntr:end,:) = []; % erase additional allocated rows

end