function hippo_state_detection(animalIdN,recordingIdN,issave)
%HIPPO_STATE_DETECTION Detects hippocampal states.
%   HIPPO_STATE_DETECTION(ANIMALIDN,RECORDINGIDN,ISSAVE) loads hippocampal
%   field potential data and calls THETA_DETECTION with the appropriate 
%   arguments for detecting dominant states (theta or delta). It saves a 
%   plot from the detection, logical vectors for the bimodal state (theta 
%   and delta), phase angles of frequency components.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   ISSAVE: optional, flag, save?
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, HIPPO_FIELD_MS_UNIT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global PREPROCDIR
global PROJECTID
global NSR
global HPTHBAND
global HPDEBAND
global TSCCGSMWINDOW
global THRATIOTHRESH
global DERATIOTHRESH

if nargin == 0
    variable_definitions(); %animalIdN,recordingIdN,(issave) definitions
    figure('Position',get(0,'Screensize'));
end

h = gcf;
% set(h,'Position',get(0,'Screensize'));
set(h,'Position',[1,41,1097,505]);

% Load data:
fieldPot = loadFieldPot(animalIdN,recordingIdN);

% Theta/delta filtered signal, amplitude based theta detection:
if ismember(PROJECTID,{'OPTOTAGGING'}) % in opto experiments minimal theta amp. is required (ISMAD exists)
    specParFile = fullfile(PREPROCDIR,animalIdN,recordingIdN,[animalIdN,'_',recordingIdN,'_specific_parameters.mat']);
    if exist(specParFile,'file') % if specific parameters were defined for an animal
        load(specParFile);
        [theta,delta,thetaTransf,deltaTransf] = theta_detection(fieldPot,hpthband,hpdeband,nsr,tsccgsmwindow,thratiothresh,deratiothresh,windowS,isMAD);
    else
        % in opto experiments minimal theta amp. is required (ISMAD exists)
        [theta,delta,thetaTransf,deltaTransf] = theta_detection(fieldPot,HPTHBAND,HPDEBAND,NSR,TSCCGSMWINDOW,THRATIOTHRESH,DERATIOTHRESH,TSCCGSMWINDOW,true);
    end
else % in other projects, global variables control the detection:
    [theta,delta,thetaTransf,deltaTransf] = theta_detection(fieldPot,HPTHBAND,HPDEBAND,NSR,TSCCGSMWINDOW,THRATIOTHRESH,DERATIOTHRESH,TSCCGSMWINDOW);
end
title([animalIdN,'_',recordingIdN]);

if exist('issave','var')
    %     savefig(fullfile(RESULTDIR,'theta_detection','figures',[animalId, recordingId]));
    saveas(gcf,fullfile(RESULTDIR,'theta_detection','pngs',[animalIdN,recordingIdN,'.png']));
    close;
    save(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalIdN,recordingIdN]),'theta','delta');
    thetaAng = angle(thetaTransf);
    deltaAng = angle(deltaTransf);
    save(fullfile(RESULTDIR,'theta_detection','phase_angles',[animalIdN,recordingIdN]),'thetaAng','deltaAng');
end
end