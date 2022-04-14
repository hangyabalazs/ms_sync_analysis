function compare_classifications(rootDir,resPath1,resPath2,rhGroupId)
%COMPARE_CLASSIFICATIONS Compares two runs outputs.
%   COMPARE_CLASSIFICATIONS(ROOTDIR,RESPATH1,RESPATH2) 
%   Specify a rhythmicity group name (e.g.: CTB), and this function plots
%   all of the difference between the given two runs.
%   Parameters:
%   ROOTDIR: string, common path of analysis folders' parent.
%   RESPATH1: string, analysis1 path.
%   RESPATH2: string, analysis1 path.
%   RHGROUPID = string, rhythmicity group ID (e.g.: 'CTB').
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

if nargin == 0
    variable_definitions; %rootDir, resPath1, resPath2, rhGroupId
end

%% Theta detection:
files1 = return_used_files(dir(fullfile(rootDir,resPath1,'theta_detection','pngs')),{'.','n'},true);
files2 = return_used_files(dir(fullfile(rootDir,resPath2,'theta_detection','pngs')),{'.','n'},true);
fileIds = unique([{files1.name},{files2.name}]);
for it = 1:length(fileIds)
    if exist(fullfile(rootDir,resPath1,'theta_detection','pngs',fileIds{it}),'file')
        A = imread(fullfile(rootDir,resPath1,'theta_detection','pngs',fileIds{it}));
        resA = imresize(A,[600,2400]);
        figure('Position',[1,430,1536,430]), imshow(resA)
    end
    if exist(fullfile(rootDir,resPath2,'theta_detection','pngs',fileIds{it}),'file')
        B = imread(fullfile(rootDir,resPath2,'theta_detection','pngs',fileIds{it}));
        resB = imresize(B,[600,2400]);
        figure('Position',[1,1,240,124]),imshow(resB)
    end
    waitforbuttonpress
    close all
end

%% Rhythmicity group
% analysis1:
load(fullfile(rootDir,resPath1,'parameters.mat'));
load(fullfile(rootDir,resPath1,'cell_features','allCell.mat'));
rowInd1 = get_rhGroup_indices_in_allCell(rhGroupId);
Ids1 = allCell(rowInd1,1:4);
% analysis2:
load(fullfile(rootDir,resPath2,'parameters.mat'));
load(fullfile(rootDir,resPath2,'cell_features','allCell.mat'));
Ids2 = allCell(get_rhGroup_indices_in_allCell(rhGroupId),1:4);
rowInd2 = get_rhGroup_indices_in_allCell(rhGroupId);
Ids2 = allCell(rowInd2,1:4);

% Additional cells in the first analysis in that rhythmicity group:
[diffs1,Ind1] = setdiff(Ids1,Ids2,'rows');
load(fullfile(rootDir,resPath1,'parameters.mat'));
cell_groups(rowInd1(Ind1));

% Additional cells in the second analysis in that rhythmicity group:
[diffs2,Ind2] = setdiff(Ids2,Ids1,'rows');
load(fullfile(rootDir,resPath2,'parameters.mat'));
cell_groups(rowInd2(Ind2));
end