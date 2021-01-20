function output = initNAS(v)
%INITNAS intialize NAS channel state varriables.
%   See also NEURON_MODEL_SIMULATION.

%Parameter definitions:
neuron_model_parameters;

hinfi=1/(1 + exp(-(v-Nas.theta_h)/Nas.sigma_h));
tauh = 0.5 + 14 / ( 1 + exp(-(v-Nas.theta_t_h)/Nas.sigma_t_h));
minfi=1/(1 + exp(-(v-Nas.theta_m)/Nas.sigma_m));
output = [minfi,hinfi,tauh];
end