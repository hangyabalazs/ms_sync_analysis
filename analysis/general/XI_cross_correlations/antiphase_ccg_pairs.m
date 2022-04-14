function antiphase_ccg_pairs(rowIds)
%ANTIPHASE_CCG_PAIRS calculates and plots cell pairs' ccgs (delta and 
%theta) where the rhythmicity peak is at least MINPEAKLAG (specified below,
% e.g.: 50 ms) offset during theta.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%
%   See also FIT_VM_MIXTURE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 29/03/2022

global NSR
global CGBINS

% Hard coded parameters!!!!
minPeakLag = 50;
maxlag = 0.3*NSR; maxFr = 6; % arat
% maxlag = 0.3*NSR; maxFr = 5; % amouse
% maxlag = 0.2*NSR; maxFr = 10; % fmouse

% Get corecorded pairs:
funcCallDef = ['output2{cntr} = {animalId,recordingId,shankIds(1),cellIds(1),'...
            'animalId,recordingId,shankIds(2),cellIds(2)};'];
[~,~,cellPairs] = execute_corecorded_pairs(rowIds,funcCallDef);
cellPairs = vertcat(cellPairs{:});

% Compute ccgs:
[thCorr,thpeakLags] = all_ccg(cellPairs,'theta',maxlag,CGBINS,maxFr);
[deCorr,depeakLags] = all_ccg(cellPairs,'delta',maxlag,CGBINS,maxFr);

% Keep only those pairs, where ccg peak lag is at least MINPEAKLAG offset:
antiphaseIds = abs(thpeakLags) > minPeakLag; 
thCorr = thCorr(antiphaseIds,:);
thpeakLags = thpeakLags(antiphaseIds);
deCorr = deCorr(antiphaseIds,:);
depeakLags = depeakLags(antiphaseIds);

% Plot
figure('Position',[10,50,1400,400])
[~,inx] = sort(thpeakLags); % sort ccgs based on peak lags
inx = [inx(3:end);inx(1:2)];
subplot(1,2,1), imageccgs(thCorr(inx,:),-maxlag:maxlag), hold on, plot(thpeakLags(inx),1:numel(inx),'r.'), title('during theta')
subplot(1,2,2), imageccgs(deCorr(inx,:),-maxlag:maxlag), hold on, plot(depeakLags(inx),1:numel(inx),'r.'), title('during delta')
end

