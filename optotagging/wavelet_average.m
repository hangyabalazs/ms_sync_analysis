function [avgWavelet,f,thDeRatio] = wavelet_average(unRecIds,tWindow,nnsr,isThDeRatio)
%WAVELET_AVERAGE returns the average wavelet spectrum for specified 
% non-truncated (contains photostimulation and noisy parts) recordings. 
% Optionally, it also cumputes the theta-delta frequency band power ratio 
% change between the begining and immediately after the terminantion of 
% photostimulatoin (10 sec long intervals).
%   Parameters:
%   UNRECIDS: nRecordings x 2 vector, specifies which recordings to
%   consider for the average (animalId, recordingId, e.g.: list of 
%   tagged glumataterg cells recordings).
%   TWINDOW: 1x2 vector, specifying time limits (e.g.: [1/NSR,400]).
%   NNSR: new sampling rate, ease storage of individual wavelets (e.g.: 10).
%   ISTHDERATIO: logical, calculate theta-delta power ratio increase?
%
%   See also TAGGED_RECORDING_WAVELET, WAVELET_SPECTRUM.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 08/04/2022


global NSR
global PREPROCDIR
global ROOTDIR
global HPTHBAND
global HPDEBAND

% HARD-CODED HERE!!!!
frRange = [0.5,6.1]; nFreqs = 45; % interestic frequency range for averaging (ploting)
% frRange = [0.5,12]; nFreqs = 57;
sec1 = 1:10*NSR; % section length to consider during calculation of
% frequency power ratios (at the begining of photostim and after the end of it)

nRecordings = size(unRecIds,1);
% Allocate matrices for each recordings:
allWavelets = zeros(nRecordings,nFreqs,(diff(tWindow)*NSR+1)/(NSR/nnsr)); % individual wavelets
thDeRatio = zeros(nRecordings,2); % individual theta-delta ratios
for it = 1:nRecordings % iterate trough all recordings
    animalId = num2str(unRecIds(it,1));
    recordingId = num2str(unRecIds(it,2));
    % Load the non-truncated fieldPot (instead of loadFieldPot()):
    load(fullfile(PREPROCDIR,animalId,recordingId,[animalId,'_',recordingId,'_radiatum.mat']));
    
    % Calculate wavelet for the whole recording:
    [pow,~,f] = eegwavelet(fieldPot,NSR);
    f = f(f>0.5); % frequencies below 0.5 Hz are deleted
    frInd = find(f>=frRange(1) & f<=frRange(2)); % interesting frequencies' indices
    % extract interestion freuencies and time from wavelet:
    allWavelets(it,:,:) = pow(frInd,tWindow(1)*NSR:NSR/nnsr:tWindow(2)*NSR);
    
    % Calculate theta-delta power ratio change beginig vs. after
    % stimulation (only in OPTO PROJECT)
    if exist('isThDeRatio','var') & isThDeRatio
        % Load stimulation end point:
        load(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.mat']),'s2'); % end time of photostimulation
        sec2 = s2 + sec1; % section 2 (right after the photostim end)
        % Load theta and delta frequency ranges (can be specified differently than the global):
        specParFile = fullfile(PREPROCDIR,animalId,recordingId,[animalId,'_',recordingId,'_specific_parameters.mat']);
        if exist(specParFile,'file') % if specific parameters were defined for an animal
            load(specParFile);
        else
            hpthband = HPTHBAND;
            hpdeband = HPDEBAND;
        end
        
        thFIndex = f>hpthband(1) & f<hpthband(2); % theta frequency indices
        deFIndex = f>hpdeband(1) & f<hpdeband(2); % delta frequency indices
        % Calculate theta-delta ratio:
        thDeRatio(it,1) = sum(mean(pow(thFIndex,sec1))) / sum(mean(pow(deFIndex,sec1)));
        thDeRatio(it,2) = sum(mean(pow(thFIndex,sec2))) / sum(mean(pow(deFIndex,sec2)));
    end
end

avgWavelet = squeeze(mean(allWavelets,1,'omitnan')); % calculate average wavelet
f = f(frInd);
end