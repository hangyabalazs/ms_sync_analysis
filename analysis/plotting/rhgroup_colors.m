function [sColor,symbol,markerSize] = rhgroup_colors(rhgroup)
%RHGROUP_COLORS Rhythmicity group color definitions.
%   [SCOLOR,SYMBOL,MARKERSIZE] = RHGROUP_COLORS(RHGROUP) returns the SCOLOR
%   color triplet vector, SYMBOL symbol definition (markerEdge, LineWidth, 
%   etc.) string and MARKERSIZE properties for ploting RHGROUP identified
%   rhythmicity group's results.
%   Parameters:
%   RHGROUP: 3 letter string, at least containing the rhgroupId (e.g.: CTB 
%   or a path: D:\CTB\...).
%
%   See also DATASET_COLORS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2020

allSymbols = {'CTB',20,[146,211,237]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'CTT',20,[255,237,74]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'CD_',20,[233,79,53]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'DT_',20,[130,178,121]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'NT_',20,[183,125,169]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'NN_',20,[180,180,180]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'AA_',20,[255,255,255]/255,'''filled'',''o'',''MarkerEdgeColor'',''black'''};

inx = find(cellfun(@(x) contains(rhgroup,x),allSymbols(:,1)));
markerSize = allSymbols{inx,2};
sColor = allSymbols{inx,3};
symbol = allSymbols{inx,4};
end