function allWavePower = sort_channels_energy(templates)
%SORT_CHANNELS_ENERGY Sort channels based on waveform energies.
%   ALLWAVEPOEWR = SORT_CHANNELS_ENERGY(TEMPLATES) sorts channels by energy
%   for the specified clusters' waveforms. It returns ALLWAVEPOWER 
%   (#cells x #channels x 2 matrix), storing the sorted amplitude-channelId
%   pairs for the given cells.
%   Parameters:
%   TEMPLATES: #cells x #samplePoints x #channels matrix, storing the mean
%   waveforms of cells.
%
%   See also CREATEEVENTFILE_SHANK.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 03/09/2020

for it1 = 1:size(templates, 1) % go trough all cells
    waveforms = squeeze(templates(it1, :, :)).';% # channels x #samplePoints matrix
    wavePower = [sum(waveforms.^2,2), (1:size(waveforms, 1)).']; % power on channels
    wavePower = flipud(sortrows(wavePower)); % sort channels according to wave power
    allWavePower(it1, :, :) = wavePower;
end

end