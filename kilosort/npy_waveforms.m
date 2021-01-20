function npy_waveforms(animalId,recordingId)
%NPY_WAVEFORMS Plots spike amplitudes (max from channels).
%   NPY_WAVEFORMS(ANIMALID,RECORDINGID) shows amplitude (peak to peak) 
%   values.
%   Parameters:
%   ANIMALID: string (e.g. '20100806').
%   RECORDINGID: string (e.g. '45').
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

global DATADIR
global NSEPTALCHANNELS

amps = readNPY(fullfile(DATADIR,animalId,recordingId,'amplitudes.npy'));
tempIds = double(readNPY(fullfile(DATADIR,animalId,recordingId,'spike_templates.npy')));
templ = double(readNPY(fullfile(DATADIR,animalId,recordingId,'templates.npy')));
load(fullfile(DATADIR,animalId,recordingId,[animalId,recordingId,'_goodClusterIDs1.mat']));
goodSpks = find(ismember(tempIds,goodClusterIDs));

tempAmp = zeros(size(templ,1),1);
for it = 1:size(templ,1)
     tempAmp(it) = max(range(squeeze(templ(it,:,:))));
end
% figure, TTK_plot_waveform(squeeze(templ(1,:,:)))
figure('Position',[10,200,500,420])
plot(amps);
% plot(tempAmp(tempIds+1).*amps);
end