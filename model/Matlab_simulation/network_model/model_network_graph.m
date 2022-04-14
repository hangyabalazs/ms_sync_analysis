function model_network_graph(resPath)
%MODEL_NETWORK_GRAPH Plots network organization.
%   MODEL_NETWORK_GRAPH(RESPATH) plots a network grap, where edges 
%   reflects synaptical weights.
%
%   See also GENERATE_AND_SIMULATE_MODEL, SIMULATE_PARAMETER_SPACE, 
%   EXPLORE_PARAMETER_SPACE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 25/09/2020

if nargin == 0
    variable_definitions; %resPath definition
end
headerFile = xlsread(fullfile(resPath,'header.xlsx'));
allnCells = sum(headerFile(1:end-3));

synapsesFile = xlsread(fullfile(resPath,'synapses.xlsx'));
% thrshMatrix = synapsesFile(1:allnCells, 1:allnCells);
% decayMatrix = synapsesFile(allnCells+1:allnCells*2, 1:allnCells);
% delayMatrix = synapsesFile(allnCells*2+1:allnCells*3, 1:allnCells);
weightMatrix = synapsesFile(allnCells*3+1:allnCells*4, 1:allnCells);
% Synaptical strength graph
G = digraph(weightMatrix); % create directed graph
weights = normalize(G.Edges.Weight,'range')*4+0.01; % scale weights
figure, h = plot(G,'k','LineWidth',weights); % 'EdgeLabel',weights
% Matrix representation of synaptical weights:
figure, imagesc(weightMatrix), colormap jet
end