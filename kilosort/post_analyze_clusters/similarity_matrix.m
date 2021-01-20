function similarity = similarity_matrix(templates1,nChComp,minComChs,templates2,nChShift)
%SIMILARITY_MATRIX Waveform based similarity scores between clustered units.
%   SIMILARITY = SIMILARITY_MATRIX(TEMPLATES1,NCHCOMP,MINCOMCHS,TEMPLATES2,
%   NCHSHIFT) calculates similarity scores between clusters in one 
%   recording (for merging) or from two subsequent recordings (overlaping 
%   channels: amouse project) based on waveforms.
%   Parameters:
%   TEMPLATES1: nCLusters1 x nChannels x windowSize matrix, containing all
%   clusters' average waveforms on all channels (from the first recording).
%   NCHCOMP: number of top energy channels to compare waveforms on.
%   MINCOMPCHS: minimal number of top energy channels to match between 
%   similar clusters.
%   TEMPLATES2: optional (Specify if you want to compare overlaping 
%   clusters between subsequent recordings, amouse project), 
%   nCLusters2 x nChannels x windowSize matrix, containing all clusters'
%   average waveforms on all channels (from the second recording). 
%
%   See also VISUAL_OVERLAPING_CLUSTERS, VISUAL_MERGE_CLUSTERS, 
%   CREATE_AVR_WAVEFORMS_MATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 04/09/2020

if ~exist('templates2','var')
    templates2 = templates1;
    nChShift = 0;
end

%% Sort channels based on amplitudes (biggest waveforms at the top)
% Recording1:
spikeEnergy1 = squeeze(sum(abs(templates1), 3));
[~,inx1] = sort(spikeEnergy1.','descend');
% Recording2:
spikeEnergy2 = squeeze(sum(abs(templates2), 3));
[~,inx2] = sort(spikeEnergy2.','descend');

%% Similarity matrix:
% allocate similarity matrix (nClusters1 x nClusters2):
similarity = zeros(size(templates1, 1), size(templates2, 1));
for it1 = 1:size(templates1, 1) % go trough all clusters in recording1
    % after shifting, cluster will be on shiftInx channels in rec2
    shiftInx1 = inx1(:,it1) - nChShift;
    for it2 = 1:size(templates2, 1) % go trough all clusters in recording2
        % compare template1 and template2, for the same channels
        inters = intersect(shiftInx1(1:nChComp),inx2(1:nChComp,it2));
        if numel(inters) > minComChs % at least MINCOMCHS channels are common from NUMCH top energy channels
            weight1 = spikeEnergy1(it1, inters+nChShift).';
            % Scaled (with energy on channel) template on top energy channels:
            scTemp1 = abs(squeeze(templates1(it1,inters+nChShift,:))).*repmat(weight1,1,size(templates1,3));
            weight2 = spikeEnergy2(it2, inters).';
            % Scaled (with energy on channel) template on top energy channels:
            scTemp2 = abs(squeeze(templates2(it2, inters,:))).*repmat(weight2,1,size(templates2,3));
            % point by point difference on top energy channels:
            differ = scTemp1 - scTemp2;
            similarity(it1, it2) = 1 / sum(sum(abs(differ))) * numel(inters);
        end
    end
end