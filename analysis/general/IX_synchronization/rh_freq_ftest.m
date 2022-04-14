function pFTest = rh_freq_ftest(rowIds,frBands)
%RH_FREQ_FTEST make an F test on for the given cells rhythmicity
%frequencies during delta and theta.
%   PFTEST = RH_FREQ_FTEST(ROWIDS,FRBANDS) gets the rhythmicity frequencies
%   of given cells, runs an F test, and boxplot the results.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   FRBANDS: 2x2 vector, specifying frequency bands of interest (Hz) (e.g.
%   theta frequency during theta, delta frequency during delta? [3,8;0.5,2.5]).
%   PFTEST: P value of F test. 
%
%   See also GROUP_SYNCHRONIZATION, RHYTHMICITY_FREQUENCIES, 
%   PLOT_SYNCHRONIZATION_THEORIES.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 20/05/2021

global MSTHBAND
global NSR

if nargin == 0
    variable_definitions; %rowIds,frband definitions
end
if ~exist('frBands','var') % if not provided...
    frBands = [MSTHBAND;MSTHBAND]; % MS theta frequency band during both states
end

rowIds = get_rhGroup_indices_in_allCell('CTB');

[ctThAll,ctDeAll] = rhythmicity_frequencies(rowIds,frBands);
deRhFr = NSR./ctDeAll;
thRhFr = NSR./ctThAll;

rhFRs = [deRhFr,thRhFr];
rhFRs(isoutlier(diff(rhFRs.')),:) = []; % remove large noise to avoid distortion
p = std_permutation_test(rhFRs);

% F test:
[~,pFTest1] = vartest2(thRhFr,deRhFr);
[~,pFTest2] = vartest2(rhFRs(:,2),rhFRs(:,1)); % without outliers
% [median(thRhFr),var(thRhFr),median(deRhFr),var(deRhFr)]

figure
boxplot(rhFRs,'Labels',{'Non-theta','Theta'},'Colors','k','Widths',2/3,'symbol','');
title(pFTest2)

% Test in the non-normalized datasets:
signrank(abs(thRhFr-mean(thRhFr)),abs(deRhFr-mean(deRhFr)))
signrank(abs(rhFRs(:,2)-mean(rhFRs(:,2))),abs(rhFRs(:,1)-mean(rhFRs(:,1)))) % without outliers
end