function plot_raster_lines_fast(TS,yCoords,lineColor)
%PLOT_RASTER_LINES_FAST Fast method to make a raster plot.
%   PLOT_RASTER_LINES_FAST(TS,YCORODS,LINECOLOR) plots the activity of a 
%   cell, firing at the timepoints specified in ACTTIME vector. Improved 
%   performance because raster lines are not handled as individual objects
%   but as parts of a continous line containing NaNs between each line.
%   Parameters:
%   TS: vector, containing spike times of a cell.
%   YCOORDS: optional, 1x2 vector, y coordinates of the raster lines (default: [0,1]).
%   LINECOLOR: optional, colorcode (character) for plot color (default: k -> black).
%
%   See also RASTER_PLOT, HIPPO_FIELD_MS_UNIT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2019

if nargin < 3
    if nargin < 2
        yCoords = [0,1];
    end
    lineColor = 'k';
end

TS = reshape(TS,1,[]); % convert to row vector

xVector = [TS;TS;NaN(1,length(TS))];
xVector = xVector(:);
yVector = repmat([yCoords.';NaN],1,length(TS));
yVector = yVector(:);
plot(xVector,yVector,lineColor)
end