function [sColor,symbol,markerSize] = dataset_colors(projectId)
%DATASET_COLORS Dataset color definitions.
%   [SCOLOR,SYMBOL,MARKERSIZE] = DATASET_COLORS returns the SCOLOR color
%   triplet vector, SYMBOL symbol definition (markerEdge, LineWidth, etc.)
%   string and MARKERSIZE properties for ploting PROJECTID identified 
%   dataset's results.
%   Parameters:
%   PROJECTID: string, at least containing the projectId (e.g.: ANA_RAT or
%   a path: D:\ANA_RAT\...).
%
%   See also EXECUTE_DATASETS, PLOT_SYNCHRONIZATION_THEORIES, RHGROUP_COLORS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 08/09/2020

allSymbols = {'ANA_MOUSE',30,[175,173,173]/255,'''filled'',''^'',''MarkerEdgeColor'',''black'',''LineWidth'',0.5';...
    'FREE_MOUSE',30,[21,21,21]/255,'''filled'',''d'',''MarkerEdgeColor'',''black'',''LineWidth'',0.5';...
    'ANA_RAT',30,[206,145,132]/255,'''filled'',''MarkerEdgeColor'',''black'',''LineWidth'',0.5';...
    'MODEL',80,[247,67,226]/255,'''filled'',''v'',''MarkerEdgeColor'',''black'',''LineWidth'',0.5';...
    'OPTOTAGGING',80,[130,170,210]/255,'''filled'',''p'',''MarkerEdgeColor'',''black'',''LineWidth'',0.5'}; %...
%     '10,[0,255,255]/255,''x'',''LineWidth'',1';...
%     '10,[0,255,0]/255,''h'',''LineWidth'',1'};
% allSymbols = {'ANA_MOUSE',20,[175,173,173]/255,'''filled'',''s'',''MarkerEdgeColor'',''black'',''LineWidth'',0.3';...
%     'FREE_MOUSE',20,[175,173,173]/255,'''filled'',''s'',''MarkerEdgeColor'',''black'',''LineWidth'',0.3';...
%     'ANA_RAT',20,[175,173,173]/255,'''filled'',''s'',''MarkerEdgeColor'',''black'',''LineWidth'',0.3';...
%     'MODEL',120,[247,67,226]/255,'''filled'',''v'',''MarkerEdgeColor'',''black'',''LineWidth'',0.3';...
%     'OPTOTAGGING',120,[130,170,255]/255,'''filled'',''^'',''MarkerEdgeColor'',''black'',''LineWidth'',0.5'};

inx = find(cellfun(@(x) contains(projectId,x),allSymbols(:,1)));
markerSize = allSymbols{inx,2};
sColor = allSymbols{inx,3};
symbol = allSymbols{inx,4};
end