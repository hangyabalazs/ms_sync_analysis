function shft = plotMat(varargin)
%PLOT_MAT Plots matrix columns to a common x axis, shifted.
%   SHFT = PLOT_MAT(DATAMATRIX) plots columns of DATAMATRIX shifted.
%   Optional parameters:
%   TIMEVEC: timepoints belonging to DATAMATRIX's columns' elements 
%   (default: 1:size(DATAMATRIX,1)).
%   SHFT: vertical shift between the DATAMATRIX rows 
%   (default: max amplitude of signals).
%   PLOTCOLOR: colorcode (character) for plot color (default: k -> black).

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2019

p = inputParser;
addRequired(p,'dataMatrix',@isnumeric);
addParameter(p,'timeVec',[],@isnumeric);
addParameter(p,'shft',[],@isnumeric);
addParameter(p,'plotColor','k',@ischar);
parse(p,varargin{:});
names = fieldnames(p.Results);
for it=1:length(names)
    eval([names{it} '=p.Results.' names{it} ';']);
end

if isempty(timeVec) 
    timeVec = 1:size(dataMatrix, 1); 
end

if size(dataMatrix, 2)>1 % execute only if dataMatrix contains multiple signals (columns)
    if isempty(shft) % compute vertical shift
        shft = max(max(dataMatrix)-min(dataMatrix));
    end
    shftMatrix = repmat(0:shft:(size(dataMatrix, 2)-1)*shft, size(dataMatrix, 1), 1);
    shftedMatrix = shftMatrix+dataMatrix;
    plot(timeVec,shftedMatrix,plotColor);
else % if dataMatrix is a vector...
    plot(timeVec,dataMatrix)
end

xlim([timeVec(1),timeVec(end)])
allPoints = shftedMatrix(:);
ylim([min(allPoints),max(allPoints)])
end