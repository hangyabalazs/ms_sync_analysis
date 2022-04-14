function create_txt_paramfile(resPath)
%CREATE_TXT_PARAMFILE Creates txt file from xlsx parameter definition
%files.
%   CREATE_TXT_PARAMFILE(RESPATH) converts .xlsx network parameter files 
%   to txt, readable by Neuron.
%
%   See also CREATE_NETWORK_PARAMETERS, CREATE_NETWORK_PARAMETERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/07/2018

if ~exist('resPath','var')
    % Path to Neuron software folder's network simulation directory:
    model_resPath_def;
end

% Number of cells, segment lengths:
headerFile = xlsread(fullfile(resPath,'actual_run','header.xlsx'));
nCells = headerFile(1:end-3); % number of cells
segmLenghts = headerFile(end-2:end);
allnCells = sum(nCells);
%Synapses:
synapsesFile = xlsread(fullfile(resPath,'actual_run','synapses.xlsx'));
thrshMatrix = synapsesFile(1:allnCells, 1:allnCells);
decayMatrix = synapsesFile(allnCells+1:allnCells*2, 1:allnCells);
delayMatrix = synapsesFile(allnCells*2+1:allnCells*3, 1:allnCells);
weightMatrix = synapsesFile(allnCells*3+1:allnCells*4, 1:allnCells);
%Stimulations:
stimMatrix = xlsread(fullfile(resPath,'actual_run','stimulation.xlsx'));
deltaStimMatrix = xlsread(fullfile(resPath,'actual_run','deltaStimulation.xlsx'));

% Create parameter file:
paramFile = fopen(fullfile(resPath,'actual_run','parameters.txt'),'w');
for it = 1:numel(nCells) 
    fprintf(paramFile,'%f ',nCells(it));
end
fprintf(paramFile,'\n');
fprintf(paramFile,'%f %f %f \n',segmLenghts);
for it = 1:size(thrshMatrix, 2)
    fprintf(paramFile,'%f %f %f ', thrshMatrix(it, :));
    fprintf(paramFile,'\n');
end
for it = 1:size(decayMatrix, 2)
    fprintf(paramFile,'%f %f %f ', decayMatrix(it, :));
    fprintf(paramFile,'\n');
end
for it = 1:size(delayMatrix, 2)
    fprintf(paramFile,'%f %f %f ', delayMatrix(it, :));
    fprintf(paramFile,'\n');
end
for it = 1:size(weightMatrix, 2)
    fprintf(paramFile,'%f %f %f ', weightMatrix(it, :));
    fprintf(paramFile,'\n');
end
fprintf(paramFile,'%f\n', size(stimMatrix, 1)); % write number of stimulations to file
for it = 1:size(stimMatrix, 1)
    fprintf(paramFile,'%f %f %f %f ', stimMatrix(it, :));
    fprintf(paramFile,'\n');
end
fprintf(paramFile,'%f', size(deltaStimMatrix, 1)); % write number of delta-stimulations to file
fprintf(paramFile,'\n');
for it = 1:size(deltaStimMatrix, 1)
    fprintf(paramFile,'%f %f %f %f %f ', deltaStimMatrix(it, :));
    fprintf(paramFile,'\n');
end
fclose(paramFile);

end