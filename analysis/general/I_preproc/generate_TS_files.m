function generate_TS_files(animalIdN,recordingIdN,shankId,cellId)
%GENERATE_TS_FILES Creates spike time files.
%   GENERATE_TS_FILES(ANIMALIDN,RECORDINGIDN,SHANKID,CELLID) reads clu 
%   (clusterId) and res (spikeTime) files, rescale time (in NSR) and 
%   converts them to .mat files.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g. 2).
%
%   See also MAIN_ANALYSIS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global PREPROCDIR
global DATADIR
global PROJECTID
global SR
global NSR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN,shankId,cellId definitions
end

% In case of ANA_RAT project, ignore 0 and 1 clusters as they are noise clusters
if isequal(PROJECTID,'ANA_RAT') & (cellId == 0 | cellId == 1)
    return
end

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

if ~isequal(animalId,animalIdN) | ~isequal(recordingId,recordingIdN)
    return; % return when recording is ignored (dir name starts with 'n' in DATADIR)
end

clu = load(fullfile(DATADIR,animalIdN, recordingIdN,[animalId,recordingId,'.clu.',num2str(shankId)]));
res = load(fullfile(DATADIR,animalIdN, recordingIdN,[animalId,recordingId,'.res.',num2str(shankId)]));

TS = round(res(clu==cellId)/(SR/NSR)); % activity pattern
TS(TS==0) = 1; % change index if equals 0

dirName = fullfile(PREPROCDIR,animalIdN,recordingIdN);
if ~exist(dirName,'dir')
    status = mkdir(dirName);
end
fName = ['TT',num2str(shankId),'_',num2str(cellId),'.mat'];
save(fullfile(dirName,fName),'TS');
end