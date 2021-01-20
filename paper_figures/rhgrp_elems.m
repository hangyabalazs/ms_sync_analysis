function [nElems,pers] = rhgrp_elems()
%RHGRP_ELEMS Computes percentage distributions of rhythmicity groups.
%
%   See also CREATE_AVR_WAVEFORMS_MATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

global RESULTDIR
global THSUMACGTRESH
global DESUMACGTRESH

nElems = [length(get_rhGroup_indices_in_allCell('CTB'));...
    length(get_rhGroup_indices_in_allCell('CTT'));...
    length(get_rhGroup_indices_in_allCell('DT_'));...
    length(get_rhGroup_indices_in_allCell('NT_'));...
    length(get_rhGroup_indices_in_allCell('TD_'));...
    length(get_rhGroup_indices_in_allCell('CD_'));...
    length(get_rhGroup_indices_in_allCell('ND_'));...
    length(get_rhGroup_indices_in_allCell('TN_'));...
    length(get_rhGroup_indices_in_allCell('DN_'));...
    length(get_rhGroup_indices_in_allCell('NN_'))];

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');
nallCell = sum(allCell(:,mO('thsumacr'))>THSUMACGTRESH & allCell(:,mO('desumacr'))>DESUMACGTRESH);
pers = nElems / nallCell;
end