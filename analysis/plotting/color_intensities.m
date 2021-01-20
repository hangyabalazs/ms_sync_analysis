function colIntens = color_intensities(allPoints,rowIds)
%COLOR_INTENSITIES Gray colormap for a given range of points.
%   COLINTENS = COLOR_INTENSITIES(ALLPOINTS,ROWIDS) creates a gray colormap
%   representing intensities (e.g. firing rates) in ALLPOINTS. Light colors
%   are deleted for better visualization. 
%   Parameters:
%   ALLPOINTS: vector or matrix, including all recorded values belonging to
%   a feature. The function sort them in ascending order.
%   ROWIDS: vector of rowIds in ALLPOINTS, identifying points of interest.
%   COLINTENS:(#rowIds x 3 colormap) specifying the gray colors of specific
%   (ROWIDS) rows.
%
%   See also CELL_GROUPS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

allPoints = allPoints(:);
myPoints = allPoints(rowIds);

nPoints = numel(allPoints(:));
allPoints = sort(allPoints(:));
allPoints(isnan(allPoints)) = [];
largeScale = 10;
pRange = round([allPoints(round(nPoints*0.05)),allPoints(end-round(nPoints*0.05))]*largeScale);
delLightColors = 30; % delete light colors from map
allColors = flipud(gray(pRange(2)-pRange(1)+1+delLightColors));
allColors(1:delLightColors,:)=[]; % delete white colors from map

myPointsScaled = round(myPoints*largeScale);
myPointsScaled(myPointsScaled<pRange(1)) = pRange(1); % too small
myPointsScaled(myPointsScaled>pRange(2)) = pRange(2); % too large
myPointsScaled = myPointsScaled-pRange(1)+1;
colIntens = allColors(myPointsScaled, :);
end