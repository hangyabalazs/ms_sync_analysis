function TTK_plot_waveform(avrgWave)
%TTK_PLOT_WAVEFORM Shows average waveforms of a cell for every channel.
%   TTK_PLOT_WAVEFORM(AVRGWAVE) plots average waveforms for each channel. 
%   (Spatialy ordered)
%   Parameters:
%   AVRGWAVE: nPoints x nChannels (e.g. 82 x 128) matrix corresponding to
%   one cluster.
%
%   See also VISUAL_OVERLAPING_CLUSTERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global NSEPTALCHANNELS

% Hard coded here!!!
nRows = 32; % number of rows of septal electrode array

nPoints = size(avrgWave,1);

avrgWave = avrgWave.';
chMap = repmat([1:4].', nRows, 1);
% Order channels spatially:
spatialWave = zeros(nRows, NSEPTALCHANNELS/nRows*nPoints);
for it1 = 1:4
    spatialWave(:, (it1-1)*nPoints+1:it1*nPoints) = avrgWave(chMap == it1, :);
end
imagesc(spatialWave), colormap jet
% Plot borders between recording sites columns
hold on, line([nPoints, nPoints*2, nPoints*3; nPoints, nPoints*2, nPoints*3],...
    [0, 0, 0; NSEPTALCHANNELS, NSEPTALCHANNELS, NSEPTALCHANNELS], 'Color', [0.5,0.5,0.5]);
% Plot borders between recording sites rows
hold on, line(repmat([0;nPoints*4],1,NSEPTALCHANNELS),...
    [0.5:NSEPTALCHANNELS; 0.5:NSEPTALCHANNELS], 'Color', [0.5,0.5,0.5]);
c = colormap(bone); colormap(flipud(c))
colormap copper
end