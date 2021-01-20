function twocycles_phaseHistogram(IDs,varargin)
%TWO_CYCLES_PHASEHISTOGRAM Plots 2 cycle historam for MS units.
%   TWO_CYCLES_PHASEHISTOGRAM(IDS,ISPLOTCOS) plots 2 cycles of a MS unit 
%   phase preference histogram (relative to hippocampal oscillations).
%   Parameters:
%   ANIMALID: string (e.g. '20100304').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 2).
%   ISPLOTCOS: optional, plot 2 cycles of a cosine?
%
%   See also MAIN_ANALYSIS, CONVERT_IDS, THETA_DETECTION, CELL_PHASE_PREFERENCE,
%   PHASE_PREF, EXAMPLE_CELLS_PLOT,CONVERT_IDS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global PHASEHISTEDGES

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addParameter(p,'isPlotCos',false,@islogical);
parse(p,varargin{:});

isPlotCos = p.Results.isPlotCos;

if nargin == 0
    variable_definitions; % animalId,recordingId,shankId,cellId (isPlotCos) definitions
    figure;
end

IDs = convert_IDs(IDs);
nCell = size(IDs,1);

allThHist = zeros(nCell,numel(PHASEHISTEDGES)-1);
allDeHist = zeros(nCell,numel(PHASEHISTEDGES)-1);
for it = 1:nCell
    load(fullfile(RESULTDIR,'MS_cell_phase_pref','phaseData',[IDs{it,1},'_',IDs{it,2},...
        '_',IDs{it,3},'_',IDs{it,4}]));
    allThHist(it,:) = thetaHistValues;
    allDeHist(it,:) = deltaHistValues;
end

hold on
stairs([PHASEHISTEDGES,PHASEHISTEDGES(2:end)+2*pi],[mean(allThHist),mean(allThHist),mean(allThHist(end))])
stairs([PHASEHISTEDGES,PHASEHISTEDGES(2:end)+2*pi],[mean(allDeHist),mean(allDeHist),mean(allDeHist(end))])
xlim([-pi,3*pi])
% histogram('BinEdges',[PHASEHISTEDGES, PHASEHISTEDGES(2:end)+2*pi],...
%     'BinCounts',[thetaHistValues,thetaHistValues],'DisplayStyle','stairs','EdgeAlpha',0)
% histogram('BinEdges',[PHASEHISTEDGES, PHASEHISTEDGES(2:end)+2*pi],...
%     'BinCounts',[deltaHistValues,deltaHistValues],'DisplayStyle','stairs','EdgeAlpha',0)

if isPlotCos
    cosPoints = PHASEHISTEDGES(1):0.1:PHASEHISTEDGES(end)+2*pi;
    plot(cosPoints,cos(cosPoints+pi)*-0.05-0.05,...
        'Color',[0,0,0]);
end
end