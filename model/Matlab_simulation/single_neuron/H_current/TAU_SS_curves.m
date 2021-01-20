function TAU_SS_curves()
%TAU_SS_CURVES Plots channels' voltage dependent time constants and steady
%state curves.
%   TAU_SS_CURVES plots time constant and steady state curves (with respect
%   to varying v potentials) from different channel models (including H 
%   current models, Golomb model's channel models).
%
%   See also ADJUST_IH_PARAMETERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2020

%% generic H current (IH_params.mod) from Szabolcs Kali:
v = -20:0.1:20; % in mV
X_v0 = -0.09;
X_k0 = -0.01;
X_kt = 5;
X_gamma = 0.8;
X_tau0 = 0;
inf = ((X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) ./ ((X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) + (X_kt * (exp ((X_gamma - 1)  * (v - X_v0) / X_k0)))));
inf(isnan(inf))=1;
tau = 1 ./ ( (X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) + (X_kt * (exp ((X_gamma - 1)  * (v - X_v0) / X_k0)))) + X_tau0;
% inf = ((5 * (exp (0.8 * (v + 0.09) / -0.01)))./ ((5 * (exp (0.8 * (v + 0.09) / -0.01))) + (5 * (exp ((0.8 - 1)  * (v + 0.09) / -0.01)))));
% tau = 1 ./ ( (5 * (exp (0.8 * (v +0.09) / -0.01))) + (5 * (exp ((0.8 - 1)  * (v +0.09) / -0.01)))) + 0;
figure; 
subplot(2, 1, 1), plot(v, inf), legend('inf'), title('IH params')
subplot(2, 1, 2), plot(v, tau), legend('tau')


%% H_CA1_pyr_prox.mod (Szabolcs Kali)
v = -20:0.1:20; % in mV
tau =  (exp (33.0 * (v + 0.075))) ./ (11.0 * (1 + (exp (83.0* (v + 0.075)))));
inf =  1 ./ (1 + (exp (300*(v + 0.083))));
figure; 
subplot(2, 1, 1), plot(v, inf), legend('inf'), title('H CA1 pyr prox')
subplot(2, 1, 2), plot(v, tau), legend('tau')

%% CA1 Ih (Migliore, 2012) from modeldb 
%(https://senselab.med.yale.edu/modeldb/showmodel.cshtml?model=144541&file=/Ih_current/h.mod#tabs-2):
v = -150:0.1:0;
zetal = 4;
vhalfl = -90;
zetat = 2.2;
gmt = .4;
vhalft = -75;
qtl = 1;
q10 = 4.5;
celsius = 20;
qt = q10^((celsius-33)/10);
a = exp(0.0378*zetat*(v-vhalft));
a0t = 0.0046;
linf = 1./(1+ exp(0.0378*zetal*(v-vhalfl)) );
taul = exp(0.0378*zetat*gmt*(v-vhalft))./(qtl*qt*a0t*(1+a));
figure; 
subplot(2, 1, 1), plot(v, linf), legend('ss'), title('Migliore CA1 Ih')
subplot(2, 1, 2), plot(v, taul), legend('tau')

close all
%% kdr.mod
v = -100:0.1:50;
ninfi=1./(1 + exp(-(v+12.4)/6.8));
taun = (0.087 + 11.4 ./ (1 + exp ((v+14.6)/8.6))) .* (0.087 + 11.4 ./ (1 + exp (-(v-1.3)/18.7)));
figure; 
subplot(2, 1, 1), plot(v, ninfi), legend('ninfi'); title('kdr')
subplot(2, 1, 2), plot(v, taun), legend('taun')
ylabel('ms'), xlabel('mV')

%% nas.mod
v = -100:0.1:50;
tauh = 0.5 + 14 ./ ( 1 + exp(-(v+60)/-12));
hinfi = 1./(1 + exp(-(v+58.3)/-6.7));
figure; 
subplot(2, 1, 1), plot(v, hinfi), legend('hinfi'); title('nas')
subplot(2, 1, 2), plot(v, tauh), legend('tauh')
ylabel('ms'), xlabel('mV')
end