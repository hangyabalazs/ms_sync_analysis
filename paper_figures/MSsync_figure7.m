function MSsync_figure7
%figure7: you can use either NEURON_MODEL_SIMULATION.m (Matlab) or 
%...\model\Neuron_simulation\single_neuron\modified_Golomb\save_output.hoc
%(Neuron) for the simulation of the model neuron. Whichever you use, adjust
%current amplitude to 0.1 nA for rhythmicity frequency analysis (panelB) and
%to -0.3 nA for H current charactheristic sag response (panelC). (if Matlab
%is used: change this in NEURON_MODEL_PARAMETERS. If Neuron: change this
%directly in the .hoc file. If you make rhythmicity frequency analysis
%you can similarly modify K* (slowly inactivating D-type K) taub to 120 or 200 ms).
%Here we suppose you already have it.
%figure7 supp1: you need to run first SIMULATE_PARAMETER_SPACE for the
%simulation of all the parameter distributions. Than run EXPLORE_PARAMETER_SPACE
%for process results!!

%% figure 7:
MODEL_GLOBALTABLE
%   panelA: shematic model neuron
%   panelB: rhythmicity frequency dependence on tau_b(K*)
%   To resimulate this, run the following code with the small modifications
%   on the top of the file: (option1 for 2 Hz, option2 for 4 Hz firing)
%   SIMTIME = 3000; current = 0.1; TAUB = 200 (for 2 Hz, TAUB = 120 for 4 Hz)
%   CODEFOLDER\model\Neuron_simulation\single_neuron\modified_Golomb\save_output.hoc
potentials = dlmread(fullfile(ROOTDIR,'figure7_simulations\voltage_Ih_2Hz_taub_200ms.dat'), 'r');
figure, plot(potentials,'Color',[0.8500,0.3250,0.0980]), xlabel('Time (1/40 ms)'), ylabel('Voltage (mV)')
savefig(gcf,'panelB_1.fig'), close all
potentials = dlmread(fullfile(ROOTDIR,'figure7_simulations\voltage_Ih_4Hz_taub_120ms.dat'), 'r');
figure, plot(potentials,'Color',[0,0.4470,0.7410]), xlabel('Time (1/40 ms)'), ylabel('Voltage (mV)')
savefig(gcf,'panelB_2.fig'), close all
%   panelC: H current characthersitic sag response:
%   To resimulate this, run the following code with the small modifications
%   on the top of the file: (option3 for with, option4 without H current)
%   SIMTIME = 700; current = -0.3; TAUB = 120; GIH = 0.0001 (or 0 -> without H current)
%   CODEFOLDER\model\Neuron_simulation\single_neuron\modified_Golomb\save_output.hoc
potentials = dlmread(fullfile(ROOTDIR,'figure7_simulations\voltage_without_Ih.dat'), 'r');
figure, plot(potentials,'k')
potentials = dlmread(fullfile(ROOTDIR,'figure7_simulations\voltage_Ih.dat'), 'r');
hold on, plot(potentials,'Color',[0.9290,0.6940,0.1250])
xlabel('Time (1/40 ms)'), ylabel('Voltage (mV)')
savefig(gcf,'panelC.fig'), close all
%   panelD: shematic model network
%   panelE: model network, non-theta - theta transition
%   This is a demonstrative simulation (network parameters are stored here: 
%   ...\MODEL\DATA\n20191105\n0). For resimulate it, copy parameters.txt to
%   CODEFOLDER\model\Neuron_simulation\networkmodel\pacemaker_network\actual_run
%   and run CODEFOLDER\model\Neuron_simulation\networkmodel\pacemaker_network\pacemaker_network_simulation.hoc
wavelet_spectrum('20191105','n0',[0.001,15],true);
savefig(gcf,'panelE_1.fig'), close all
IDs = [repmat({'20191105','n0'},20,1),repmat({1},20,1),num2cell(1:20).'];
raster_plot(IDs,[0.001,15])
savefig(gcf,'panelE_2.fig')
close all

%% figure 7 supp1: parameter and variance space analysis:
%   panelA: parameter space analysis (discrete peak at 60 pA)
%   To rerun simulations: SIMULATE_PARAMETER_SPACE (randomized steps can 
%   produce slightly different results).
MODEL_GLOBALTABLE_par
[synchScores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'});
parameter_space_plot([5,1,2],synchScores,Ids)
savefig(gcf,'supp1_panelA.fig'), close
%   panelB: parameter space analysis (exc. fixed to 60 pA, x axis: syn. weight)
parameter_space_plot([2,1,5],synchScores,Ids)
savefig(gcf,'supp1_panelB.fig'), close
%   panelC: parameter space analysis (exc. fixed to 60 pA, x axis: conn. rate)
parameter_space_plot([2,5,1],synchScores,Ids)
savefig(gcf,'supp1_panelC.fig'), close
%   panelD: variance space analysis
MODEL_GLOBALTABLE_var
[synchScores,Ids] = collect_properties(fullfile(RESULTDIR,'synch_scores'),'rec',{'synchScore'});
parameter_space_plot([2,5,3],synchScores,Ids)
savefig(gcf,'supp1_panelD.fig')
close all
end