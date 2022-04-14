function rhGrp_DV_distribution()
% RHGRP_DV_DISTRIBUTION to demonstrate dorso-ventral distribution of
% all of the rhythmicity groups. (Designed for amouse recordings with 
% 128 channel septal probe, parameters are defined accordingly).
%
%   See also CLUSTER_LOCATION_DEPTHS, VISUAL_OVERLAPING_CLUSTERS, 
%   RECORDING_DEPTH_AMOUSE, RHGRP_DV_DISTRIBUTION_ATLAS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/04/2022

% HARD CODED (parameter definitions, should be the same in CLUSTER_LOCATION_DEPTHS):
% Electrode:
chSep = 22.5; % channel separation (distance between electrode site rows' bottom)
% Recordings:
firstDepth = 3.5*1000; % first dorso-ventral depth (um)
lastDepth = (4.5 + 0.720)*1000; % last dorso-ventral depth of electrode tip site (um)
% Total number of channels from different depths in one animal (3 recording
% depths):
nChDepths = round((lastDepth - firstDepth)/chSep);

figure, hold on
% Iterate trough all rhythmicity group types:
execute_rhGroups('cluster_location_depths(rowIds,sColor,it/10);',1);

% % lines between animals
% nAnimals = 11;
% plot([(1:nAnimals)*4-0.5;(1:nAnimals)*4-0.5],repmat([1;nChDepths],1,nAnimals),'k')
% xlabel('1 animal - 1 column');
% lines between electrode columns
nColumns = 4;
plot([(0:nColumns)+1/12;(0:nColumns)+1/12],repmat([1;nChDepths],1,nColumns+1),'k')

% Show electrode positions:
plot([-1/6,-1/6],nChDepths-[1,32]+1,'k','LineWidth',3)
plot([-2/6,-2/6],nChDepths-[23,54]+1,'k','LineWidth',3)
plot([-3/6,-3/6],nChDepths-[45,76]+1,'k','LineWidth',3)

xlabel('electrode columns');
ylabel({'cluster depth (channels, separation = 22.5 um)';...
    'ch1 depth (DV): 3.5 mm, ch76 depth (DV): 4.5+0.72 mm'});
nChDepths = 76;
yticks(nChDepths-[nChDepths,54,45,32,23,1]+1)
yticklabels([nChDepths,54,45,32,23,1])

title('Rhythmicity group locations')
end