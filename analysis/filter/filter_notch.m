function fdata = filter_notch(data,sr,noiseHz)
%FILTER_NOTCH Filters data with a notch filter (remove noise).
%   FDATA = FILTER_NOTCH(DATA,SR,NOISEHZ) creates a symmetrical notch filter.
%   Parameters:
%   DATA: vector, signal to filter.
%   SR: number, sampling rate.
%   NOISEHZ: number, center of noise.
%   FDATA: filtered signal.
%
%   Implemented based on:  
%   dsp.stackexchange.com/questions/1088/filtering-50hz-using-a-notch-filter-in-matlab
%


freqRatio = noiseHz/(sr/2); %ratio of notch freq. to Nyquist freq.
notchWidth = 0.1;       %#width of the notch

notchZeros = [exp(sqrt(-1)*pi*freqRatio), exp(-sqrt(-1)*pi*freqRatio)]; %zeros
notchPoles = (1-notchWidth) * notchZeros; %poles

b = poly(notchZeros); %# Get moving average filter coefficients
a = poly(notchPoles); %# Get autoregressive filter coefficients

%#filter signal x
fdata = filter(b,a,data);
end