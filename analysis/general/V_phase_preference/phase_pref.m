function [ftm,hang,hmvl,Z,pRayleigh,U,pRao,hValues] = phase_pref(TS,phases,isPlot,edges)
%PHASE_PREF Calculates MS units phase preferences to hippocampus.
%   [FTM,HANG,HMVL,Z,PRAYLEIGH,U,PRAO,HVALUES] = PHASE_PREF(TS,PHASES,ISPLOT,
%   EDGES) calculates cells phase preference significances (Rayleigh Z 
%   test: uniformity test against unipolarity and Rao U test: uniformity test 
%   against multimodality (spacing test)) with respect to a reference phase 
%   signal.
%   Parameters:
%   TS: vector, containing spike times of a cell.
%   PHASES: vector, phases of hilbert transformed filtered hippo signal.
%   ISPLOT: logical, controlls if histogram plots will be dispalyed or not?
%   EDGES: vector, histogram edges (e.g. -pi:pi/9:pi).
%   FTM: first trigonometric momentum.
%   HANG: mean angle.
%   HMVL: mean resultant vector length.
%   Z: statistics value of Rayleigh's Z test.
%   PRAYLEIGH: p value of Rayleigh's Z test.
%   U: statistics value of Rao's U test.
%   PRAO: p values of Rao's U test.
%   HVALUES: histogram of spikes' phase values.
%
%   See also CELL_PHASE_PREFERENCE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 24/09/2019


% Phase of APs
phase = phases(TS);
n = length(phase);
if n < 4
    ftm = NaN;
    hang = NaN;
    hmvl = NaN;
    Z = NaN;
    pRayleigh = NaN;
    U = NaN;
    pRao = [NaN, NaN];
    hValues = NaN(1,length(edges)-1);
    return
end

% Phase histogram
if isPlot
    h = histogram(phase,edges,'Normalization','probability','DisplayStyle','stairs');
    hValues = h.Values;
else
    hValues = histcounts(phase,edges,'Normalization','probability');
end

% Testing for non-uniform phase distribution
ftm = sum(exp(1).^(1i*phase)) / n;    % first trigonometric moment
hang = angle(ftm);   % mean angle
hmvl = abs(ftm);     % mean resultant length
[Z,pRayleigh,U,pRao] = b_rao(phase(:)');
end