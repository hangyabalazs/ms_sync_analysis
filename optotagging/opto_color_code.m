function colorCodes = opto_color_code(cellIdList)
%OPTO_COLOR_CODE Returns color codes (opto group color) for given cells.
%   COLORCODES = OPTO_COLOR_CODE(CELLIDLIST) iterates trough all cells and
%   extracts which opto cell group they belong to. Than returns the opto
%   group's color triplet.
%   Parameters:
%   CELLIDLIST: string array, cellbaseId of a cells (e.g. 'PVR02_180821a_1.32').
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

nCells = length(cellIdList);
colorCodes = zeros(nCells,3);

for it = 1:nCells
    str = cellIdList{it}(1:3);
    
    switch str
        case 'CHT' % yellow
            colorCodes(it,:) = [0.9290,0.6940,0.1250];
        case 'PVR' % blue
            colorCodes(it,:) = [0,0,1];
        case 'VGA' % green
            colorCodes(it,:) = [0,1,0];
        case 'VGL' % grey
            colorCodes(it,:) = [0.1,0.1,0.1];
    end
end
end