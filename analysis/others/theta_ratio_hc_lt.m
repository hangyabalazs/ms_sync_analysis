function theta_ratio_hc_lt()
%THETA_RATIO_HC_LT Time ratio of theta in homecage and linear track 
%(FREE_MOUSE project).
%   THETA_RATIO_HC_LT() calculates the time ratio of theta segments in
%   homecage and linear track (fmouse project).
%
% See also: FMOUSE_RECLENGTHS

global DATADIR
global RESULTDIR
global ROOTDIR

load(fullfile(RESULTDIR,'parameters.mat'),'activeRecIds');
nRecs = size(activeRecIds,1);

load(fullfile(DATADIR,'recLenghts.mat'),'hc_lt_lenghts');
Ids = strcat(hc_lt_lenghts(:,1),hc_lt_lenghts(:,2),hc_lt_lenghts(:,3));

thetaRatios = zeros(nRecs,2);
for it = 1:nRecs
    animalId = activeRecIds{it,1};
    recordingId = activeRecIds{it,2};
    [s,inx] = ismember([animalId,recordingId],Ids);
    if s
        load(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.mat']));
        hcLength = hc_lt_lenghts{inx,4};
        ltLength = hc_lt_lenghts{inx,5};
        ltLength = ltLength-sum(stim(hcLength+1:ltLength+hcLength));
        hcLength = hcLength-sum(stim(1:hcLength));
        
        load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');
        thetaRatios(it,1) = sum(theta(1:hcLength))/hcLength;
        thetaRatios(it,2) = sum(theta(hcLength:hcLength+ltLength))/ltLength;
    end
end

figure
boxplot(thetaRatios,'Labels',{'HC','LT'},'Colors','k','Widths',2/3,'symbol','');
ylabel('Time: theta/total')
signRank = signrank(thetaRatios(:,1),thetaRatios(:,2))
[~,pTTest] = ttest(thetaRatios(:,1),thetaRatios(:,2))
title(['Signrank: ',num2str(signRank),', Ttest: ',num2str(pTTest)])
end