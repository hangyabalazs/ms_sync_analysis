function wavelet_spectrum(animalIdN,recordingIdN,tWindow,isLinear,issave)
%WAVELET_SPECTRUM Plots time-frequency domain representation of the
%recording.
%   WAVELET_SPECTRUM() calculates and plots the time-frequency representation
%   of a recording by applying Morlet wavelet transformation.
%   Needs hangya-matlab-code package to be downloaded!
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   TWINDOW: 1x2 vector, time limits (in sec) to calculate spectrum, (e.g.
%   [366,376]).
%   ISLINEAR: optional, flag, use linear y axis square?
%   ISSAVE: optional, flag, save?
%
%   See also EEGWAVELET.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/01/2019

global RESULTDIR
global NSR

if nargin == 0
    variable_definitions(); %animalIdN,recordingIdN,(tWindow,issave) definitions
    figure('Position',get(0,'ScreenSize'))
end

fieldPot = loadFieldPot(animalIdN,recordingIdN);

% Cut fieldPot
if exist('tWindow','var')
    fieldPot = fieldPot(tWindow(1)*NSR:tWindow(2)*NSR);
end

if any(fieldPot)
    [pow,~,f] = eegwavelet(fieldPot,NSR);
    f = f(f>0.5); % frequencies below 0.5 are deleted
    nnsr = 10; % resampling rate for ploting
    timeVec = 1/nnsr:1/nnsr:length(fieldPot)/NSR;
    frInd = 70:min(124,numel(f));
    rsPow = pow(frInd,NSR/nnsr:NSR/nnsr:end);
    % sKS = 5; rsPow = conv2(rsPow,ones(sKS)/(sKS^2),'same'); %smooth
    if exist('isLinear','var')
        imagesc(timeVec,frInd,rsPow),set(gca,'clim',[0,500])
        set(gca,'ytick',[71,83,93,100,112,124])
        set(gca,'yticklabel',{'10','5','3','2','1','0.5'})
    else
%         cLims = prctile(pow(:),[10,90]); % limit colors
        cLims = prctile(pow(:),[1,99]); % limit colors
%         cLims = prctile(pow(:),[5,95]); % limit colors
        levels = cLims(1):diff(cLims)/100:cLims(2);
        contourf(timeVec,f(frInd),rsPow,levels,'LineStyle','none');
    end
    colormap('jet')
end

if exist('issave','var')
    saveas(gcf,fullfile(RESULTDIR,'wavelet_spectrum',[animalIdN,recordingIdN,'.png']));
    close
end
end