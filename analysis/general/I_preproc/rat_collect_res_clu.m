function [goodClus,STs,cluIds] = rat_collect_res_clu(animalIdN,recordingIdN)
%RAT_COLLECT_RES_CLU Collects spike times for ANA_RAT project.
%   [GOODCLUS,STS,CLUIDS] = RAT_COLLECT_RES_CLU(ANIMALIDN,RECORDINGIDN) 
%   collects all spike times and clusterIDs from the 4 shanks (rat 
%   project). It shifts clusterId numbers to avoid overlaping clusterIds 
%   from different shanks.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   Outputs:
%   GOODCLUS: vector, containing good cluster Ids.
%   STS: vector, spike times of the recording.
%   CLUIDS: vector, cluster Ids for STS vector.
%
%   See also CREATE_AVR_WAVEFORMS_MATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 04/09/2020

global DATADIR

animalId = regexprep(animalIdN,'n',''); %remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); %remove n from filename begining

STs = []; % spike times
cluIds = []; % clusterIds
maxCluId = 0;
for shankId = 1:4 % go trough shanks
    if exist(fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,'.clu.',num2str(shankId)]))
        clu = load(fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,'.clu.',num2str(shankId)]));
        res = load(fullfile(DATADIR,animalIdN,recordingIdN,[animalId,recordingId,'.res.',num2str(shankId)]));
        % Clear noise clusters:
        noiseClus = (clu==0|clu==1);
        res(noiseClus) = [];
        clu(noiseClus) = [];
        if ~isempty(clu)
            STs = [STs;res];
            cluIds = [cluIds;clu+maxCluId]; % shift clusterIds to avoid mixing with previous shanks
            maxCluId = max(unique(clu));
        end
    end
end

% Sort in time:
[STs,inx] = sort(STs);
cluIds = cluIds(inx);
goodClus = max(unique(cluIds));
end