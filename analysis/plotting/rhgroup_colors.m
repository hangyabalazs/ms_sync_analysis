function [sColor,symbol,markerSize,grpName] = rhgroup_colors(rhgroup)
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

allSymbols = {'CTB','pacemaker',20,[146,211,237]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'CTT','tonic',20,[255,237,74]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'CD_','theta-skipping',20,[233,79,53]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'DT_','follower',20,[130,178,121]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'NT_','theta-follower',20,[183,125,169]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'NN_','non-rhythmic',20,[180,180,180]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'AA_','silent',20,[255,255,255]/255,'''filled'',''o'',''MarkerEdgeColor'',''black''';...
    'AT_','delta-silent',20,[200,250,190]/255,'''filled'',''o'',''MarkerEdgeColor'',''black'''};

inx = find(cellfun(@(x) contains(rhgroup,x),allSymbols(:,1)));
if isempty(inx)
    markerSize = 20;
    sColor = [237,177,32]/255;
    symbol = '''filled'',''o'',''MarkerEdgeColor'',''black''';
else
    markerSize = allSymbols{inx,3};
    sColor = allSymbols{inx,4};
    symbol = allSymbols{inx,5};
    grpName = allSymbols{inx,2};
end
end