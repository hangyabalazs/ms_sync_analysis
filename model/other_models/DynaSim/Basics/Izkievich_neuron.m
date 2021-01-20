eqns={
  'C=100; vr=-60; vt=-40; k=.7; Iapp=70; ton=200; toff=800'
  'a=.03; b=-2; c=-50; d=100; vpeak=35'
  'dv/dt = (k*(v-vr)*(v-vt)-u+I(t))/C; v(0)=vr'
  'du/dt = a*(b*(v-vr)-u); u(0)=0'
  'if(v>vpeak)(v=c; u=u+d)'
  'I(t) = Iapp*(t>ton&t<toff) .*(1+.5*rand(1,Npop))' % define applied input using reserved variables 't' for time and 'dt' for fixed time step of numerical integration
  'monitor I'                              % indicate to store applied input during simulation
  'monitor w(t) = u.*v'                    % defining a function of state variables to monitor (note that monitor expressions follow Matlab's syntax)
};
data = dsSimulate(eqns, 'tspan',[0 1000]);

figure; % <-- Figure 2 in DynaSim paper
subplot(2,1,1);
plot(data.time,data.pop1_v); % plot voltage
xlabel('time (ms)');
ylabel('output, v');
title('Izhikevich neuron with noisy drive')

subplot(2,1,2);
plot(data.time,data.pop1_I); % plot input function
xlabel('time (ms)');
ylabel('INput, I(t)');