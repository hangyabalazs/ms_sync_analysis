function group_synchronization(rowIds,grpId,frBands)
%GROUP_SYNCHRONIZATION Calculates synchronization measures for MS units.
%   GROUP_SYNCHRONIZATION(ROWIDS,GRPID,FRBANDS) calculates 6 measures for
%   5 possible ways of synchronization of the given cells:
%   - firing rate increase, acg theta peak increase
%   - rhythmicity frequency increase
%   - intraburst firing rate increase
%   - less theta skipping
%   - frequency sycnhronization.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   GRPID: string, groupId of the given group (how ROWID was defined), for
%   saving results.
%   FRBANDS: 2x2 vector, specifying frequency bands of interest (Hz) (e.g.
%   theta frequency during theta, delta frequency during delta? [3,8;0.5,2.5]).
%
%   See also MAIN_ANALYSIS, FIRING_RATES, RHYTHMICITY_FREQUENCIES, 
%   BURST_PROPERTIES, THETA_SKIPPING, FREQUENCY_SYNCHRONIZATION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/09/2020


global RESULTDIR
global NSR

if nargin == 0
    variable_definitions; %rowIds,grpId,frBands definitions
end
if numel(rowIds)==0 
    return;
end


%% Individual cell measures:
%% Firing rate (1.1.) and aurocorrelation theta peak value (1.2.):
[thPoints,dePoints,nPoints,IDs] = firing_rates(rowIds);
save(fullfile(RESULTDIR,grpId,'firing_rates'),...
        'thPoints','dePoints','IDs','nPoints');
[~,~,thPoints,dePoints,~,~,nPoints,IDs] = rhythmicity_frequencies(rowIds,frBands); %acg peak value
save(fullfile(RESULTDIR,grpId,'acg_theta_peaks'),...
        'thPoints','dePoints','IDs','nPoints');
%% Rhythmicity frequency (autocorrelation theta peak location) (2.):
[thPoints,dePoints,~,~,~,~,nPoints,IDs] = rhythmicity_frequencies(rowIds,frBands);
thPoints = NSR./thPoints; dePoints = NSR./dePoints;
save(fullfile(RESULTDIR,grpId,'rhythmicity_frequencies'),...
        'thPoints','dePoints','IDs','nPoints');
%% Intraburst ISI (3. measure):
[thPoints,dePoints,~,~,~,~,nPoints,IDs] = burst_properties(rowIds);
save(fullfile(RESULTDIR,grpId,'intraburst_interspike_interval'),...
        'thPoints','dePoints','IDs','nPoints');
%% Theta skipping (4. measure):
[thPoints,dePoints,nPoints,IDs] = theta_skipping(rowIds,frBands);
save(fullfile(RESULTDIR,grpId,'theta_skipping'),...
        'thPoints','dePoints','IDs','nPoints');
%% Cell-pair measure:
%% Relative rhythmicity frequency difference (5. measure):
[thPoints,dePoints,nPoints,IDs] = frequency_synchronization(rowIds,frBands);
save(fullfile(RESULTDIR,grpId,'frequency_synchronization'),...
        'thPoints','dePoints','IDs','nPoints');
end