function [pow,f] = wavelet_spectrum(animalIdN,recordingIdN,tWindow,isUncut,isLinear,issave)
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
%   ISUNCUT: optional, avoid truncatanation of recordings? (= don't remove 
%   stimulation times in FREEMOUSE and OPTO projects, and noisy parts in OPTO).
%   ISLINEAR: optional, use linear y axis square?
%   ISSAVE: optional, save?
%
%   See also EEGWAVELET, WAVELET_AVERAGE, HIPPO_FIELD_MS_UNIT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/01/2019

global RESULTDIR
global PREPROCDIR
global NSR

if nargin == 0
    variable_definitions(); %animalIdN,recordingIdN,(tWindow,issave) definitions
    figure('Position',get(0,'ScreenSize'))
end

if exist('isUncut','var') & isUncut % remove stimulation and noisy parts (fmouse, opto project)?
    load(fullfile(PREPROCDIR,animalIdN,recordingIdN,[regexprep(animalIdN,'n',''),'_',regexprep(recordingIdN,'n',''),'_radiatum.mat']));
else
	fieldPot = loadFieldPot(animalIdN,recordingIdN);
end

if exist('tWindow','var') % keep only a specified segment of the recording
    fieldPot = fieldPot(tWindow(1)*NSR:tWindow(2)*NSR);
end

if any(fieldPot)
    [pow,~,f] = eegwavelet(fieldPot,NSR);
    f = f(f>0.5); % frequencies below 0.5 are deleted
    nnsr = 10; % resampling rate for ploting
    timeVec = 1/nnsr:1/nnsr:length(fieldPot)/NSR;
% % % Older version     frInd = 70:min(124,numel(f));
    frInd = find(f<12 & f>0.5); % interesting frequencies
% % % % % % %     frInd = 58:min(124,numel(f));
    rsPow = pow(frInd,NSR/nnsr:NSR/nnsr:end);
    % sKS = 5; rsPow = conv2(rsPow,ones(sKS)/(sKS^2),'same'); %smooth
    if exist('isLinear','var') & isLinear
        imagesc(timeVec,frInd,rsPow),set(gca,'clim',[0,500])
        frTicks = [10,6,3,1];
        [~,frTickInd] = arrayfun(@(x) min(abs(f(frInd)-x)),frTicks);
        set(gca,'ytick',frInd(frTickInd));
        set(gca,'yticklabel',frTicks);
    else
%         cLims = prctile(pow(:),[10,90]); % limit colors
%         cLims = prctile(pow(:),[1,99]); % limit colors
        cLims = prctile(pow(:),[5,95]); % limit colors
        levels = cLims(1):diff(cLims)/100:cLims(2);
        contourf(timeVec,f(frInd),rsPow,levels,'LineStyle','none');
    end
    colormap('jet')
end

if exist('issave','var') & issave
    saveas(gcf,fullfile(RESULTDIR,'wavelet_spectrum',[animalIdN,recordingIdN,'.png']));
    close
end
end