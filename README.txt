Execute main analysis on all datasets
- anesthetized rat (arat)
- anesthetized mouse (amouse)
- opto-tagging experiments
- freely moving mouse (fmouse)
- model
-> run EXECUTE_DATASETS() after write in VARIABLE_DEFINITIONS: funcCallDef = 'MAIN_ANALYSIS';

Attention:  
1. You need to adjust all global varriable tables first:
- ANA_RAT_GLOBALTABLE
- ANA_MOUSE_GLOBALTABLE
- OPTO_GLOBALTABLE
- FREE_MOUSE_GLOBALTABLE
- MODEL_GLOBALTABLE 
3. If you run optotagging project at first time you need to create a cellbase first!
4. If you want to simulate a model first: 
- specify network parameters in MODEL_PARAMETER_DEFINITIONS
- specify global variables in MODEL_GLOBALTABLE
- run GENERATE_AND_SIMULATE_MODEL
5. If you want to simulate the model parameter- or vaiancespace: 
- specify network parameter distributions in MODEL_PARAMETER_DEFINITIONS
- specify global variables in MODEL_GLOBALTABLE_PAR/MODEL_GLOBALTABLE_VAR
- run SIMULATE_PARAMETER_SPACE (for simulation)
- run EXPLORE_PARAMETER_SPACE (for processing results)
6. For model simulations make sure that you commented out the correct section in pacemaker_network_simulation.hoc (synaptic delays or decays are controlled)
7. In lot of codes ISSAVE argument of the functions is not logical, but flag variable (if specified -either true or false or whatever- it  will save the rsults)

For the creation of publication figures, call MSSYNC_FIGURES with the appropriate target directory as a string argument

Requirements:
- cellbase (optotagging) - https://github.com/hangyabalazs/CellBase
- npy-matlab codes are added to basic CODEFOLDER (readNPY, etc.)
- hangya-matlab-code package - https://github.com/hangyabalazs/Hangya-Matlab-code
- install Neuron simulator: ...\MS_sync_codes\modelnrn-7.4.i686-pc-mingw32-setup.exe (modeling)

- clustering: Kilosort/ Kilosort2 (run on GPU: Matlab parallel toolbox and Visual Studio, 
actual versions on analysis computer:
Matlab 2018a, Visual Studio 2013 (version12), Cuda 9.0):
Matlab- Visual Studio compatiblity:
https://www.mathworks.com/support/requirements/previous-releases.html
Matlab -Cuda:
https://www.mathworks.com/help/parallel-computing/gpu-support-by-release.html
Other compatible versions (with nvidia gtx 1080 GPU):
- Matlab 2016b+ Cuda7.5+visual studio 2013
or
- Matlab 2017b+ Cuda 8 + visual studio 2013
Download Kilosort:
https://github.com/cortex-lab/KiloSort
(Simply add to Matlab path the package)
Download manual clustering package (python based):
https://github.com/kwikteam/phy
- manual clustering Kilosort output: phy-GUI/ phy-GUI2