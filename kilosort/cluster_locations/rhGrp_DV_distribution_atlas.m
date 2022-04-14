function rhGrp_DV_distribution_atlas()
%RHGRP_DV_DISTRIBUTION_ATLAS to demonstrate dorso-ventral distribution of
% all of the rhythmicity groups. It plots the cell locations on the mouse 
% brain atlas. (Designed for amouse recordings with 128 channel septal 
% probe, parameters are defined accordingly).
%
%   See also RHGRP_DV_DISTRIBUTION, CLUSTER_LOCATION_DEPTHS, 
%   VISUAL_OVERLAPING_CLUSTERS, RECORDING_DEPTH_AMOUSE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 13/04/2022

chSep = 22.5/1000; % electrode channel separation (mm)
electL = chSep*32; %electrode length (mm)

%% Read the appropriate section (Paximos atlas):
atlasPath = 'C:\Users\Barni\ONE_DRIVE\kutatas\KOKI\MS_sync\review1\Matlab_reco';
atlastag = 'p0p62'; % AP: Bregma + 0.62
I.p0p62 = imread(fullfile(atlasPath,'Bp0p62.tif'));
corners.p0p62 = [51 967; 49 577];
corner_coordinates.p0p62 = [-4.75 4.75; 0.5 6];
% corners.p0p62 = [364 654; 171 496];
% corner_coordinates.p0p62 = [-1.5 1.5; 1.5 5.5];

%% Electrode insertion location:
insAng = 8; % insertion angle (degree)
insLocX = -0.5; % ML coordinate
insLocY = 0.58; % brain surface DV coordinate (on Paximos atlas at the ML coordinate)
% Calculate insertion coordinates on figure:
insLocXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),insLocX);
insLocYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),insLocY);

%% Recording locations:
% Recording 1:
rec1TopX = insLocX + (3.5-electL)*sin(insAng*pi/180); % first recording, electrode ML location (most dorsal channels)
rec1TopY = insLocY + (3.5-electL)*cos(insAng*pi/180); % first recording, electrode DV location (most dorsal channels)
rec1TipX = insLocX + 3.5*sin(insAng*pi/180); % first recording, electrode ML location (most ventral channels)
rec1TipY = insLocY + 3.5*cos(insAng*pi/180); % first recording, electrode DV location (most ventral channels)
% Calculate first recording coordinates on figure:
rec1TopXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),rec1TopX);
rec1TopYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),rec1TopY);
rec1TipXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),rec1TipX);
rec1TipYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),rec1TipY);

% Recording 2:
rec2TopX = insLocX + (4-electL)*sin(insAng*pi/180); % second recording, electrode ML location (most dorsal channels)
rec2TopY = insLocY + (4-electL)*cos(insAng*pi/180); % second recording, electrode DV location (most dorsal channels)
rec2TipX = insLocX + 4*sin(insAng*pi/180); % second recording, electrode ML location (most ventral channels)
rec2TipY = insLocY + 4*cos(insAng*pi/180); % second recording, electrode DV location (most ventral channels)
% Calculate second recording coordinates on figure:
rec2TopXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),rec2TopX);
rec2TopYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),rec2TopY);
rec2TipXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),rec2TipX);
rec2TipYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),rec2TipY);

% Recording 3:
rec3TopX = insLocX + (4.5-electL)*sin(insAng*pi/180); % third recording, electrode ML location (most dorsal channels)
rec3TopY = insLocY + (4.5-electL)*cos(insAng*pi/180); % third recording, electrode DV location (most dorsal channels)
rec3TipX = insLocX + 4.5*sin(insAng*pi/180); % third recording, electrode ML location (most ventral channels)
rec3TipY = insLocY + 4.5*cos(insAng*pi/180); % third recording, electrode DV location (most ventral channels)
% Calculate third recording coordinates on figure:
rec3TopXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),rec3TopX);
rec3TopYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),rec3TopY);
rec3TipXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),rec3TipX);
rec3TipYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),rec3TipY);

%% Get cluster locations:
% grpId = 'NT_';
% rowIds = get_rhGroup_indices_in_allCell(grpId);
% grpColor = rhgroup_colors(grpId);
% chRowIds = cluster_location_depths(rowIds);
figure, hold on
execute_rhGroups('cluster_location_depths(rowIds,sColor,it/10);',1);
output = execute_rhGroups('output{it} = {cluster_location_depths(rowIds,sColor,it/10),sColor};',[]);

%% Plot
figure, imshow(I.p0p62)
hold on, plot(insLocXFig,insLocYFig,'*')% insertion location
plot([rec3TopXFig,rec3TipXFig],[rec3TopYFig,rec3TipYFig],'Color',[1,1,1]*0.7,'LineWidth',6) % third recording location
plot([rec2TopXFig,rec2TipXFig],[rec2TopYFig,rec2TipYFig],'Color',[1,1,1]*0.5,'LineWidth',6) % second recording location
plot([rec1TopXFig,rec1TipXFig],[rec1TopYFig,rec1TipYFig],'Color',[1,1,1]*0,'LineWidth',6) % first recording location

edges = rec1TopY+(0:0.1:1.8);
% figure, hold on
for it = 1:numel(output)
    % Calculate (DV and ML) positions for clusters:
    clustersX = rec1TopX + (output{it,1}{1}(:,2)*chSep)*sin(insAng*pi/180) + (output{it,1}{1}(:,1)*chSep)*sin(insAng*pi/180); % first recording, electrode ML location (top channels)
    clustersY = rec1TopY + (output{it,1}{1}(:,2)*chSep)*cos(insAng*pi/180); % first recording, electrode DV location (top channels)
    % Calculate cluster coordinates on figure:
    clustersXFig = interp1(corner_coordinates.(atlastag)(1,:),corners.(atlastag)(1,:),clustersX)+it*10;
    clustersYFig = interp1(corner_coordinates.(atlastag)(2,:),corners.(atlastag)(2,:),clustersY);
    
    % Cluster locations:
    scatter(clustersXFig,clustersYFig,10,output{it,1}{2},'filled','MarkerEdgeColor','k');
    histogr = histcounts(clustersY,edges);
    plot(edges(1:end-1)+diff(edges),histogr,'Color',output{it,1}{2},'LineWidth',2);
end
legend('pacemaker','tonic','delta','follower','theta-follower','non-rhythmic')
end