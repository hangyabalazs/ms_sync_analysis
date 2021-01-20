eqns={
  'gNa=120; gK=36; Cm=1'
  'INa(v,m,h) = gNa.*m.^3.*h.*(v-50)' % Inactivating sodium current
  'IK(v,n) = gK.*n.^4.*(v+77)' % Potassium current
  'dv/dt = (10-INa(v,m,h)-IK(v,n))/Cm; v(0)=-65'
  'dm/dt = aM(v).*(1-m)-bM(v).*m; m(0)=.1'
  'dh/dt = aH(v).*(1-h)-bH(v).*h; h(0)=.1'
  'dn/dt = aN(v).*(1-n)-bN(v).*n; n(0)=0'
  'aM(v) = (2.5-.1*(v+65))./(exp(2.5-.1*(v+65))-1)'
  'bM(v) = 4*exp(-(v+65)/18)'
  'aH(v) = .07*exp(-(v+65)/20)'
  'bH(v) = 1./(exp(3-.1*(v+65))+1)'
  'aN(v) = (.1-.01*(v+65))./(exp(1-.1*(v+65))-1)'
  'bN(v) = .125*exp(-(v+65)/80)'
};
data = dsSimulate(eqns);

% plotting
figure;
plot(data.time,data.(data.labels{1}))
xlabel('time (ms)');
ylabel('membrane potential (mV)');
title('Hodgkin-Huxley neuron')