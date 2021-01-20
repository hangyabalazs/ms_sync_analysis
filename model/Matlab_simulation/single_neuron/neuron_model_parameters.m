%NEURON_MODEL_PARAMETERS.
%   Simple one compartment model neuron cell property-, simulation- and 
%   channel parameter- definitions (= Neuron_simulation/CTBtemplate.tem).
%   This script defines many parameters for channels' differential 
%   equations.
%   At the bottom of the script a commented section defines properties of 
%   the original Golomb model (Please uncomment it to overdefine parameters
%   and produce the original behaviour).
%   References:
%   -	Golomb D, Donner K, Shacham L, Shlosberg D, Amitai Y, Hansel D. 
%       Mechanisms of firing patterns in fast-spiking cortical interneurons. 
%       PLoS Comput Biol. 2007 Aug;3(8):e156. doi: 10.1371/journal.pcbi.0030156. 
%       Epub 2007 Jun 20. PMID: 17696606; PMCID: PMC1941757.
%   -	Káli S, Zemankovics R. 
%       The effect of dendritic voltage-gated conductances on the neuronal impedance: a quantitative model.
%       J Comput Neurosci. 2012 Oct;33(2):257-84. doi: 10.1007/s10827-012-0385-9.
%       Epub 2012 Feb 17. PMID: 22350741.
%   -	Borg-Graham L.J. (1999) 
%       Interpretations of Data and Mechanisms for Hippocampal Pyramidal Cell Models.
%       In: Ulinski P.S., Jones E.G., Peters A. (eds) Models of Cortical Circuits.
%       Cerebral Cortex, vol 13. Springer, Boston, MA. https://doi.org/10.1007/978-1-4615-4903-1_2.
%
%   See also NEURON_MODEL_SIMULATION, TAU_SS_CURVES, ADJUST_IH_PARAMETERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2020

% Simulation parameters:
sr = 1000; % sampling rate in ms!!!
simLength = 700*sr; % total length in ms!!

% Cell properties:
diam = 30*1e-4; % (units here: cm, Neuron units: um)
L = 5000*1e-8/(3.14159265359*diam); % (units here: cm2, Neuron units: um2)
A = diam*pi*L; % (cm2)
% Leakage
e_pas = -60; % (mV)
g_pas = 0.0001*1000; % specific membrane conductance (units here: mS/cm2, Neuron units: S/cm2)
Cm = 1; % (uF/cm2) membrane conductance

% Stimulation parameters: amplitudes (uA) can be:
%   0.1*1e-3 (rhythmic bursting) OR 
%   -0.3*1e-3 (hyperpolarization: sag and rebound)
curAmp = -0.3*1e-3; % (units here: uA, Neuron units: nA)
curVec = zeros(simLength,1);
curVec(50*sr:simLength-150*sr) = curAmp/A; % (uA/cm2)

% Transient Na:
Nas.ena = 50; % (115-65)
Nas.taum = 0.001; % (ms)
% Neuron produces slightly different results because integration stepsize
% (more like taum: ~0.02 ms)
Nas.gnaMax = 0.1125*1000;  % (units here: mS/cm2, Neuron units: S/cm2)
Nas.theta_m = -24; % (mV)
Nas.sigma_m = 11.5; % (mV)
Nas.theta_h = -58.3; % (mV)
Nas.sigma_h = -6.7; % (mV)
Nas.theta_t_h = -60; % (mV)
Nas.sigma_t_h = -12; % (mV)

% Slowly inactivating d-type K (controlls bursting behaviour)
Kd.eka = -90; % ~(-12-65)
Kd.gkdMax = 0.0018*1000; % (units here: mS/cm2, Neuron units: S/cm2), (originaly in Golomb model: 0.00039 S/cm2)
Kd.tau_a = 2; % (ms)
Kd.tau_b = 120; % originaly in Golomb model 150 (ms)
Kd.theta_a = -50; % (mV)
Kd.sigma_a = 20; % (mV)
Kd.theta_b = -60; % originaly in Golomb model -70 (mV)
Kd.sigma_b = -6; % (mV)

% Delayed rectifier K (repolarization)
Kdr.eka = Kd.eka;
Kdr.gkdrMax = 0.225*1000;  % (units here: mS/cm2, Neuron units: S/cm2)
Kdr.theta_hn = -12.4;  %(mV)
Kdr.sigma_n = 6.8; % (mV)

% H-current
% (original parameters' notation: (find paper references in function's help)
%   - Kali-Zemankovic paper ("K-Z")
%   - Borg-Graham model/Table IV. ("B-G"))
%   - Szaabolcs modfied Borg-Graham model ("Sz"))
IH.eIH = -30; % (mV), K-Z: -30 mV, B-G: -17 mV, Sz: -30 mV
IH.gmaxIH = 0.0001*1000;  % (units here: mS/cm2, Neuron units: S/cm2), K-Z: 0.11 S/m2, B-G: 0.003 uS, Sz: 0.0001 mS/cm2
IH.X_v0 = -98; % (mV),(denoted also as X_v1/2), half activated steady state, K-Z: -80 mV, B-G: -98 mV, Sz:-0.09 V
IH.X_k0 = -6.73; % (mV), (denoted also as k = RT/zF), K-Z: -12.4 mV, B-G: ?, Sz:-0.01 V
IH.X_kt = 1.2353/1000; % (1/s), (denoted also as G), rate coefficient, K-Z: 23 1/s, B-G: -, Sz: 5 1/s
IH.X_gamma = 0.81; % (unitless), asymmetry parameter, K-Z: 0.45, B-G: -, Sz: 0.8
IH.X_tau0 = 0.13*1000; % (ms),  K-Z: 14 ms, B-G: 180 ms, Sz: 0.001 s

%% Original Golomb parameters (uncomment this part for the original model)
% diam = 10*1e-4; % (units here: cm, Neuron units: um)
% L = 100*1e-8/(3.14*diam); % (units here: cm2, Neuron units: um2)
% A = diam*pi*L; % (cm2)
% 
% % Stimulation:
% curAmp = 4.2*1e-6; %% (units here: uA, Neuron units: nA)
% curVec = zeros(simLength,1);
% curVec(50*sr:550*sr) = curAmp/A; % (uA/cm2)
% % %Modified channel properties:
% e_pas = -70; % passive equilibrium (mV)
% g_pas = 0.00025*1000;  % (units here: mS/cm2, Neuron units: S/cm2)
% Kd.theta_b = -70; % (mV)
% Kd.tau_b = 150; % (ms)
% IH.gmaxIH = 0; % delete H current