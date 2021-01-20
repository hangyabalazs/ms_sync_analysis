function output = initIH(v)
%INITIH intialize IH channel state varriables.
%   See also NEURON_MODEL_SIMULATION.

%Parameter definitions:
neuron_model_parameters;

tauIh = (1 / ( (IH.X_kt * (exp (IH.X_gamma * (v - IH.X_v0) / IH.X_k0))) + (IH.X_kt * (exp ((IH.X_gamma - 1)  * (v - IH.X_v0) / IH.X_k0)))) + IH.X_tau0);
infIh = 1/(1+exp(-(v-IH.X_v0)/IH.X_k0));
output = [infIh,tauIh];
end