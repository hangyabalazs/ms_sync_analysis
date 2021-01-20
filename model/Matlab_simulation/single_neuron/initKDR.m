function output = initKDR(v)
%INITKDR intialize KDR channel state varriables.
%   See also NEURON_MODEL_SIMULATION.

%Parameter definitions:
neuron_model_parameters;

ninfi = 1/(1 + exp(-(v-Kdr.theta_hn)/Kdr.sigma_n));
taun = (0.087+11.4/(1+exp((v+14.6)/8.6)))*(0.087 + 11.4/(1 + exp (-(v-1.3)/18.7)));
output = [ninfi,taun];
end