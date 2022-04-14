function hippo_field_MS_unit(animalIdN,recordingIdN,issave)
%HIPPO_FIELD_MS_UNIT Hippocampal LFP and septal unit activity.
%   HIPPO_FIELD_MS_UNIT(ANIMALIDN,RECORDINGIDN,ISSAVE) helps to see 
%   hippocampal field, frequency components and septal unit activities 
%   together in time.
%   If the project is the model parameter space analysis, run
%   ORGANIZE_PARAMETER_SPACE_PNGS after this, for easier visual exploration.
%   It creates 3 subplots:
%   - wavelet spectrum of the hippocampal recording
%   - hippocampal raw signal, with theta- and delta-filtered  frequency
%   components. Theta/delta amplitude ratio is also visible.
%   - raster plot of MS units
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   ISSAVE: optional, flag, save?
%
%   See also MAIN_ANALYSIS, WAVELET_SPECTRUM, HIPPO_STATE_DETECTION,
%   CONVERT_MODEL_OUTPUT, ORGANIZE_PARAMETER_SPACE_PNGS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 27/08/2020

global PREPROCDIR
global RESULTDIR
global DATADIR
global PROJECTID
global NSR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN,(issave) definitions
end

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

figure('Position',get(0, 'Screensize')); %figure('Position',[-1535,1,1536*2,864])
ax1 = subplot(3,1,1);  wavelet_spectrum(animalIdN,recordingIdN); %ylim([0.5,8])

ax2 = subplot(3,1,2); hippo_state_detection(animalIdN,recordingIdN);

xLims = xlim; hShift = xLims(2)/20; % horizontal shift of cellID tags
ax3 = subplot(3,1,3); 
cellIdFnameS = listfiles(fullfile(PREPROCDIR,animalIdN,recordingIdN),'TT');
for it3 = 1:length(cellIdFnameS) % iterate trough all cells in the recording
    [shankId,cellId] = cbId2shankcellId(cellIdFnameS{it3});
    TS = loadTS(animalIdN,recordingIdN,shankId,cellId); % load timestamps
    lineColor = 'k';
    if strcmp(PROJECTID,'OPTOTAGGING') & isTaggedOpto(animalId,recordingId,cellIdFnameS(it3))
        lineColor = 'r'; % change raster color if tagged
    end
    plot_raster_lines_fast(TS/NSR,[it3,it3+1],lineColor); hold on
%     text(mod(hShift*it3,xLims(2)),it3+0.5,[num2str(shankId),'-',num2str(cellId)],...
%         'Color',[0,1,0],'FontWeight','bold');
end
linkaxes([ax1,ax2,ax3],'x')
subplot(ax1)

% In case of parameter space perambulation (model simulation):
paramCombFile = fullfile(DATADIR,animalIdN,'parameter_combinations.mat');
if strcmp(PROJECTID,'MODEL') & exist(paramCombFile,'file')
    load(paramCombFile);
    title(num2str(combs(str2num(recordingId),:)));
end
% linkaxes([ax2,ax3],'x')

if exist('issave','var')
    saveas(gcf,fullfile(RESULTDIR,'field_and_unit',[animalIdN,recordingIdN,'.png'])); close
end
end