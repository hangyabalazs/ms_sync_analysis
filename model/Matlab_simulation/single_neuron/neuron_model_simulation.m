function neuron_model_simulation(isSimNeuron)
%NEURON_MODEL_SIMULATION Pacemaker model cell simulation.
%   NEURON_MODEL_SIMULATION is a Matlab version of Neuron software pacemaker
%   model neuron simulation. Depending on the parameters defined by
%   NEURON_MODEL_PARAMETERS it can simulate original and modified Golomb
%   model (cell surface-, aplied current-, passive properties-,
%   KD channel parameters- changed and H current added. -> Slower rhythmicity
%   and H current charactheristic sag response).
%   If ISSIMNEURON exists than a Neuron simulation is also runed and ploted
%   on top of Matlab figure.
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
%   See also NEURON_MODEL_PARAMETERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2020

% Parameter definitions:
neuron_model_parameters;

% Allocate vectors for recording membrane potential, currents, state varriables:
v = zeros(simLength,1); % membrane potential
tranCurrents = zeros(simLength,5); % transmembrane currents
NasParams = zeros(simLength,3); % [m,h,tau] state varriables
KdrParams = zeros(simLength,2); % [ninfi,tau] state varriables
KdParams = zeros(simLength,2); % [a,b] state varriables
IHParams = zeros(simLength,2); % [Ih,tau] state varriables

v(1) = -65; % intial potential
% Initialize state varriables:
NasParams(1,:) = initNAS(v(1));
KdrParams(1,:) = initKDR(v(1));
KdParams(1,:) = initKD(v(1));
IHParams(1,:) = initIH(v(1));

% simulate model:
for it = 2:simLength
    % Nas
    m = 1/(1 + exp(-(v(it-1)-Nas.theta_m)/Nas.sigma_m));
    h = 1/(1 + exp(-(v(it-1)-Nas.theta_h)/Nas.sigma_h));
    tauh = 0.5 + 14 / ( 1 + exp(-(v(it-1)-Nas.theta_t_h)/Nas.sigma_t_h));
    mPrev = NasParams(it-1,1);
    hPrev = NasParams(it-1,2);
    dm = (m-mPrev)/Nas.taum;
    dh = (h-hPrev)/tauh;
    NasParams(it,1) = mPrev+1/sr*dm;
    NasParams(it,2) = hPrev+1/sr*dh;
    NasParams(it,3) = tauh;
    
    % KDR
    n = 1/(1 + exp(-(v(it-1)-Kdr.theta_hn)/Kdr.sigma_n));
    taun = (0.087+11.4/(1+exp((v(it-1)+14.6)/8.6)))*(0.087 + 11.4/(1 + exp (-(v(it-1)-1.3)/18.7)));
    nPrev = KdrParams(it-1,1);
    dn = (n-nPrev)/taun;
    KdrParams(it,1) = nPrev+1/sr*dn;
    KdrParams(it,2) = taun;
    
    % KD
    a = 1/(1 + exp(-(v(it-1)-Kd.theta_a)/Kd.sigma_a));
    b = 1/(1 + exp(-(v(it-1)-Kd.theta_b)/Kd.sigma_b));
    aPrev = KdParams(it-1,1);
    bPrev = KdParams(it-1,2);
    da = (a-aPrev)/Kd.tau_a;
    db = (b-bPrev)/Kd.tau_b;
    KdParams(it,1) = aPrev+1/sr*da;
    KdParams(it,2) = bPrev+1/sr*db;
    
    % IH
    tauIh = (1 / ( (IH.X_kt * (exp (IH.X_gamma * (v(it-1) - IH.X_v0) / IH.X_k0))) + (IH.X_kt * (exp ((IH.X_gamma - 1)  * (v(it-1) - IH.X_v0) / IH.X_k0)))) + IH.X_tau0);
    infIh = 1/(1+exp(-(v(it-1)-IH.X_v0)/IH.X_k0));
    xPrev = IHParams(it-1,1);
    dx = (infIh-xPrev)/tauIh;
    IHParams(it,1) = xPrev+1/sr*dx; %state varriable x
    IHParams(it,2) = tauIh;
    
    % Calculate currents flowing trough the membrane:
    gna = Nas.gnaMax*NasParams(it,2)*NasParams(it,1)^3;
    ina = gna*(Nas.ena-v(it-1));
    gkdr = Kdr.gkdrMax*KdrParams(it,1)^2;
    ikdr = gkdr*(Kdr.eka-v(it-1));
    gkd = Kd.gkdMax*KdParams(it,1)^3*KdParams(it,2);
    ikd = gkd*(Kd.eka-v(it-1));
    gih = IH.gmaxIH*IHParams(it,1);
    iih = gih*(IH.eIH-v(it-1));
    ipas = g_pas*(e_pas-v(it-1));
    tranCurrents(it, :) = [ina,ikdr,ikd,iih,ipas];
    
    % Overall:
    % Without H current:
    %v(it) = v(it-1)+1/sr*(ina+ikdr+ikd+ipas+curVec(it));
    % With H current:
    v(it) = v(it-1)+1/sr*(ina+ikdr+ikd+iih+ipas+curVec(it))/Cm;
end

timeVec = 1/sr:1/sr:simLength/sr;
% State varriables:
figure
subplot(3,2,1),
yyaxis right, plot(timeVec,curVec,'LineWidth',3), ylabel('(uA/cm2)')
yyaxis left, plot(timeVec,v), ylabel('(mV)'), xlabel('Time (ms)')
xlabel('Time (ms)'), title('Stimulation')
subplot(3,2,2)
yyaxis left, plot(timeVec,tranCurrents(:,1:2)), xlabel('Time (ms)')
yyaxis right, plot(timeVec,tranCurrents(:,[4,3,5])), xlabel('Time (ms)')
title('Currents'), legend('Nas','Kdr','IH','Kd','Pas')
subplot(3,2,3)
yyaxis left, plot(timeVec,NasParams(:,1:2)), xlabel('Time (ms)')
yyaxis right, plot(timeVec,NasParams(:,3)), xlabel('Time (ms)')
title('NAS'), legend('m','h','tauh')
subplot(3,2,4)
yyaxis left, plot(timeVec,KdrParams(:,1)), xlabel('Time (ms)')
yyaxis right, plot(timeVec,KdrParams(:,2)), xlabel('Time (ms)')
title('KDR'), legend('n','taun')
subplot(3,2,5),  plot(timeVec,KdParams)
xlabel('Time (ms)'), title('KD'), legend('a','b')
subplot(3,2,6)
yyaxis left, plot(timeVec,IHParams(:,1)), xlabel('Time (ms)')
yyaxis right, plot(timeVec,IHParams(:,2)), xlabel('Time (ms)')
title('IH'), legend('Inf','tau')
% Membrane potential:
% figure;
% yyaxis right, plot(timeVec,curVec,'LineWidth',3), ylabel('(uA/cm2)')
% yyaxis left, plot(timeVec,v), ylabel('(mV)'), xlabel('Time (ms)')
% legend('Membrane','Stimulation'), title('Membrane potential')

%% Neuron simulation:
if exist('isSimNeuron','var')
    % %Original Golomb model
    % neuronModelPath = 'D:\septo_hippo_project_codes\model\Neuron_simulation\original_Golomb\';
    %Modified Golomb model (cell surface-, aplied current-, passive properties-,
    %KD channel parameters- changed and H current added):
    neuronModelPath = 'D:\septo_hippo_project_codes\model\Neuron_simulation\modified_Golomb\';
    winopen(fullfile(neuronModelPath,'save_output.hoc'))
    %Place a breakpoint here, and continue after Neuron finished
    timeVec = dlmread(fullfile(neuronModelPath,'time.dat'), 'r');
    potentials = dlmread(fullfile(neuronModelPath,'voltage_Ih.dat'), 'r');
    tplot(potentials)
end
end