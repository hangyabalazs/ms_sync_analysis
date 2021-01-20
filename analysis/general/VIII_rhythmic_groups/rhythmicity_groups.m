function rhythmicity_groups(rhythmGroup,varargin)
%RHYTHMICITY_GROUPS(STR,ISSAVE) Assigns septal cell groups based on 
%theta-rhythmicity.
%   RHYTHMICITY_GROUPS(STR,ISSAVE) loads allCell matrix from DATA_LOADER() output
%   and creates cell groups according to their firing rhythmicity.
%   STR: 3 letter ID of cell group (string, e.g.: 'CTB' -> constitutive
%       bursting theta cells)
%   ISSAVE: save?
%
%   See also MSHCSP, DATA_LOADER, CELLTYPE, IMAGECCGS, CELL_FEATUES, 
%   LOAD_RADPOISSON, RANDPOISSON_PROCESS, .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR

% Overdefine in ..._variable.m files (not here)!!!
p = inputParser;
addOptional(p,'issave',false,@islogical);
addOptional(p,'isPlotCells',false,@islogical);
parse(p,varargin{:});

issave = p.Results.issave;
isPlotCells = p.Results.isPlotCells;

if nargin == 0
    variable_definitions; % rhythmGroup (issave,trgtFolder,isPlotCells) definitions
end

trgtFolder = fullfile('rhythmic_groups',rhythmGroup);
if issave | isPlotCells
    status = mkdir(fullfile(RESULTDIR,trgtFolder));
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Load rhythmicity table:
load(fullfile(RESULTDIR,'rhythmic_groups','rhGroups'),'rhGroups');
rhIndex = find(ismember(rhGroups(:,1),{rhythmGroup})); % find rhythmicity groups index

% Find indices (in allCell matrix) of cells belonging to STR group
inx = find(allCell(:,mO('rhGroup')) == rhIndex);
if isempty(inx)
    return
end

cell_groups(inx,issave,trgtFolder,isPlotCells);
end