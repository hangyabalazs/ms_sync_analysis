function MSsync_figure5()
%figure5: you can use either NEURON_MODEL_SIMULATION.m (Matlab) or 
%...\model\Neuron_simulation\single_neuron\modified_Golomb\save_output.hoc
%(Neuron) for the simulation of the model neuron. Whichever you use, adjust
%current amplitude to 0.1 nA for rhythmicity frequency analysis (panelB) and
%to -0.3 nA for H current charactheristic sag response (panelC). (if Matlab
%is used: change this in NEURON_MODEL_PARAMETERS. If Neuron: change this
%directly in the .hoc file. If you make rhythmicity frequency analysis
%you can similarly modify K* (slowly inactivating D-type K) taub to 120 or 200 ms).
%Here we suppose you already have it.

%% Figure 5:
MODEL_GLOBALTABLE
%   panelA: shematic model neuron
%   panelB: rhythmicity frequency dependence on tau_b(K*)
%   To resimulate this, run the following code with the small modifications
%   on the top of the file: (option1 for 2 Hz, option2 for 4 Hz firing)
%   SIMTIME = 3000; current = 0.1; TAUB = 200 (for 2 Hz, TAUB = 120 for 4 Hz)
%   CODEFOLDER\model\Neuron_simulation\single_neuron\modified_Golomb\save_output.hoc
potentials = dlmread('C:\Users\Barni\ONE_DRIVE\kutatas\KOKI\Theta_synchronization\figures\5_model\model_neuron\voltage_Ih_2Hz_taub_200ms.dat', 'r');
figure, plot(potentials,'Color',[0.8500,0.3250,0.0980]), xlabel('Time (1/40 ms)'), ylabel('Voltage (mV)')
savefig(gcf,'panelB_1.fig'), close all
potentials = dlmread('C:\Users\Barni\ONE_DRIVE\kutatas\KOKI\Theta_synchronization\figures\5_model\model_neuron\voltage_Ih_4Hz_taub_120ms.dat', 'r');
figure, plot(potentials,'Color',[0,0.4470,0.7410]), xlabel('Time (1/40 ms)'), ylabel('Voltage (mV)')
savefig(gcf,'panelB_2.fig'), close all
%   panelC: H current characthersitic sag response:
%   To resimulate this, run the following code with the small modifications
%   on the top of the file: (option3 for with, option4 without H current)
%   SIMTIME = 700; current = -0.3; TAUB = 120; GIH = 0.0001 (or 0 -> without H current)
%   CODEFOLDER\model\Neuron_simulation\single_neuron\modified_Golomb\save_output.hoc
potentials = dlmread('C:\Users\Barni\ONE_DRIVE\kutatas\KOKI\Theta_synchronization\figures\5_model\model_neuron\voltage_without_Ih.dat', 'r');
figure, plot(potentials,'k')
potentials = dlmread('C:\Users\Barni\ONE_DRIVE\kutatas\KOKI\Theta_synchronization\figures\5_model\model_neuron\voltage_Ih.dat', 'r');
hold on, plot(potentials,'Color',[0.9290,0.6940,0.1250])
xlabel('Time (1/40 ms)'), ylabel('Voltage (mV)')
savefig(gcf,'panelC.fig'), close all
%   panelD: shematic model network
%   panelE: model network, non-theta - theta transition
%   This is a demonstrative simulation (network parameters are stored here: 
%   ...\MODEL\DATA\network\20211123\n0). For resimulate it, copy parameters.txt to
%   CODEFOLDER\model\Neuron_simulation\networkmodel\pacemaker_network\actual_run
%   and run CODEFOLDER\model\Neuron_simulation\networkmodel\pacemaker_network\pacemaker_network_simulation.hoc
% rw1 version:
wavelet_spectrum('20211123','n0',[0.001,12]); 
%USE THIS IN WAVELET_SPECTRUM.M: cLims = prctile(pow(:),[1,99]); % limit colors
set(gca,'ytick',[1,4,7,10]);set(gca,'yticklabel', {1,4,7,10})
set(gca,'xtick',[2,4,6,8,10,12]);set(gca,'xticklabel', {2,4,6,8,10,12})
title('20211123 n0'); set(gca,'TickDir','out','box','off'); set(gca,'FontSize',15,'LineWidth',0.75);
savefig(gcf,'panelE_1_rw1.fig'), close all
IDs = [repmat({'20211123','n0'},20,1),repmat({1},20,1),num2cell(1:20).'];
raster_plot(IDs,[0.001,12])
savefig(gcf,'panelE_2_rw1.fig')
close all
end