function compare_classifications(rootDir,resPath1,resPath2)
%COMPARE_CLASSIFICATIONS Compares two runs outputs.
%   COMPARE_CLASSIFICATIONS(ROOTDIR,RESPATH1,RESPATH2) 
%   Specify a rhythmicity group name (e.g.: CTB), and this function plots
%   all of the difference between the given two runs.
%   Parameters:
%   ROOTDIR: string, common path of analysis folders' parent.
%   RESPATH1: string, analysis1 path.
%   RESPATH2: string, analysis1 path.
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

if nargin == 0
    variable_definitions; %rootDir, resPath1, resPath2
end

% Theta detection:
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
    
allCell1 = load(fullfile(rootDir,resPath1,'cell_features','allCell.mat'));
allCell1 = allCell1.allCell;
mO1 = load(fullfile(rootDir,resPath1,'cell_features','allCellMap.mat'));
mO1 = mO1.mO;
load(fullfile(rootDir,resPath1,'rhythmic_groups','rhGroups.mat'),'rhGroups');
IDs1 = allCell1(allCell1(:,mO1('rhGroup'))==13,1:4);

allCell2 = load(fullfile(resPath2,'cell_features','allCell.mat'));
allCell2 = allCell2.allCell;
mO2 = load(fullfile(resPath2,'cell_features','allCellMap.mat'));
mO2 = mO2.mO;
load(fullfile(resPath2,'rhythmic_groups','rhGroups.mat'),'rhGroups');
IDs2 = allCell2(allCell2(:,mO2('rhGroup'))==13,1:4);

dffIds1 = setdiff(IDs1,IDs2,'rows');
dffIds2 = setdiff(IDs2,IDs1,'rows');

for it = 1: size(dffIds, 1)
    animalId = num2str(dffIds(it,1));
    recordingId = num2str(dffIds(it,2));
    shankId = num2str(dffIds(it,3));
    cellId = num2str(dffIds(it,4));
    rowId1 = find(allCell1(:, mO1('animalId')) == str2num(animalId) & ...
        allCell1(:, mO1('recordingId')) == str2num(recordingId) & ...
        allCell1(:, mO1('shankId')) == str2num(shankId) & ...
        allCell1(:, mO1('cellId')) == str2num(cellId));
    rowId2 = find(allCell2(:, mO1('animalId')) == str2num(animalId) & ...
        allCell2(:, mO2('recordingId')) == str2num(recordingId) & ...
        allCell2(:, mO2('shankId')) == str2num(shankId) & ...
        allCell2(:, mO2('cellId')) == str2num(cellId));
    %Autocorrelation
    openfig(fullfile(resPath1,'MS_cell_rhythmicity','figures',[animalId,...
        '_',recordingId,'_',shankId,'_',cellId,'.fig']));
    text(0,0.0001,{allCell1(rowId1,mO1('ThAcgThInx'))/thetaThInxtrsh1,...
        allCell1(rowId1,mO1('ThAcgDeInx'))/thetaDeInxtrsh1,...
        allCell1(rowId1,mO1('DeAcgThInx'))/deltaThInxtrsh1,...
        allCell1(rowId1,mO1('DeAcgDeInx'))/deltaDeInxtrsh1});
    
    openfig(fullfile(resPath2,'MS_cell_rhythmicity','figures',[animalId,...
        '_',recordingId,'_',shankId,'_',cellId,'.fig']));
    text(0,0.0001,{allCell2(rowId2,mO2('ThAcgThInx'))/thetaThInxtrsh2,...
        allCell2(rowId2,mO2('ThAcgDeInx'))/thetaDeInxtrsh2,...
        allCell2(rowId2,mO2('DeAcgThInx'))/deltaThInxtrsh2,...
        allCell2(rowId2,mO2('DeAcgDeInx'))/deltaDeInxtrsh2});
    
    [~,b] = ismember(dffIds(it,:), allCell1(:,1:4),'rows');
    rhGroups(allCell1(b,mO1('rhGroup')),1)
    close all
end

end