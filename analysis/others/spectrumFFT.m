function [normFt,freqs,snormFt] = spectrumFFT(data1,nsr,freqLims,resol)
%SPECTRUMFFT Shows spectral profile of a signal.
%   [NORMFFT,FREQS,SNORMFT] = SPECTRUMFFT(DATA,NSR) calculates and plots
%   spectrum of DATA sampled at NSR.
%   Parameters:
%   DATA1: numerical vector (time signal)
%   NSR: sampling rat
%   FREQLIMS: frequency limits in Hz (eg.: [0,10])
%   RESOL: frequency resolution of the FFT (#points/Hz).
%   NORMFFT: vector, normalized FFT.
%   FREQS: vector, specifying frequencies corresponding to NORMFFT.
%   SNORMFT: vector, smoothed, normalized FFT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/12/2018

if ~exist('resol','var')
    resol = 8;
end

xdftData = (1/length(data1))*fft(data1, nsr*resol); %Fourier transform
freqs = linspace(-(nsr/2), (nsr/2), length(xdftData)-1);
xdftData(1) = [];
sxdftData = abs(fftshift(xdftData)); %shift zero frequency to the center

sxdftData = sxdftData(freqs>freqLims(1) & freqs<freqLims(2));
freqs = freqs(freqs>freqLims(1) & freqs<freqLims(2));
normFt = sxdftData/sum(sxdftData); %normalize
snormFt = filtfilt(ones(1,resol)/resol,1,normFt); %smoothed

% plot(freqs,normFt);
end