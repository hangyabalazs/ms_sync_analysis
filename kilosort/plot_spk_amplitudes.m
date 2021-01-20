function plot_spk_amplitudes(animalId,recordingId)
%PLOT_SPKS_AMPLITUDES Plots spike amplitudes (max from channels).
%   PLOT_SPKS_AMPLITUDES(ANIMALID,RECORDINGID) selects biggest amplitude
%   channels for all spikes and collects spike amplitude (peak to peak) 
%   values.
%   CREATE_AVR_WAVEFORMS_MATRIX should be called before.
%   Parameters:
%   ANIMALID: string (e.g. '20100806').
%   RECORDINGID: string (e.g. '45').
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

global ROOTDIR

files = listfiles(fullfile(ROOTDIR,'WAVEFORMS',animalId,recordingId),'_waveform.mat');
figure('Position',[10,200,500,420]), hold on
arvgAmp = zeros(numel(files),1);
for it= 1:numel(files)
    load(fullfile(ROOTDIR,'WAVEFORMS',animalId,recordingId,files{it}),'avrgWave','amps');
    [amp,inx] = max(range(avrgWave));
    arvgAmp(it) = amp;
%     plot(it,amp);
end
plot(arvgAmp), ylim([0,500])
close
end