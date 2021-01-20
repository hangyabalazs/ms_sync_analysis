A=5000; %surface (d*l*pi)

s = [];
s.populations(1).name='NAS';
s.populations(1).equations= 'dv/dt = @current./Cm; Cm=1; v(0)=-65;  {INas}'; 

data=dsSimulate(s, 'tspan',[0 5000]);

% plotting
hold on, plot(data.time/1000,data.(data.labels{1}))


% figure;
% plot(data.time/1000,data.(data.labels{1}))
