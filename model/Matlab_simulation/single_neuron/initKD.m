function output = initKD(v)
%INITKD intialize KD channel state varriables.
%   See also NEURON_MODEL_SIMULATION.

%Parameter definitions:
neuron_model_parameters;

ainfi=1/(1 + exp(-(v-Kd.theta_a)/Kd.sigma_a));
binfi=1/(1 + exp(-(v-Kd.theta_b)/Kd.sigma_b));
output = [ainfi,binfi];
end
