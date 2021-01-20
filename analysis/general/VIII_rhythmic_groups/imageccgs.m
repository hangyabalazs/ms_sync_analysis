function imageccgs(dataMatrix,cols,rows,isTS)
%IMAGECCGS plots correlation array (one row = one cor) as an image.
%   IMAGECCGS(DATAMATRIX,COLS,ROWS,ISTS).
%   Parameters:
%   DATAMATRIX: matrix, storing acg/ccgs.
%   COLS: optional, vector, specifying columns of the desired part of 
%   DATAMATRIX to plot.
%   RAWS: optional, vector, specifying rows of the desired part of 
%   DATAMATRIX to plot.
%   ISTS: optional, flag, use T-score method for outlier range?
%
%   See also PLOT_REAL_ACGS_WITH_THRESHOLDS,
%   PLOT_REAL_ACGS_WITH_THRESHOLDS2, CELL_GROUPS, PLOT_CCG_NETWORK.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017


if ~exist('cols','var') 
    cols = 1:size(dataMatrix,2); 
end
if ~exist('rows','var') 
    rows = 1:size(dataMatrix,1);
end

imagesc(dataMatrix(rows,cols));

% Normalize colors:
allPoints = reshape(dataMatrix(rows,cols), 1,[]);
allPoints(isnan(allPoints)) = [];
allPoints = sort(allPoints);
if size(dataMatrix, 1) < 1
    return;
end

if exist('isTS','var')
    ts = tinv([0+signifLevel, 1-signifLevel],length(allPoints)-1); % T-Score
    CI = mean(allPoints) + ts*std(allPoints);
else
    CI = [allPoints(round(length(allPoints)/10)), allPoints(end-round(length(allPoints)/10))];
end
set(gca,'clim',CI);
end