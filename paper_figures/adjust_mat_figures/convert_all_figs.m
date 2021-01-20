function convert_all_figs(sourcefolderName,targetfolderName,saveFormat,isSubFolders)
%CONVERT_ALL_FIGS Converts all figures in a folder to a specific format,
%with optional figure modifications.
%   CONVERT_ALL_FIGS(SOURCEFOLDERNAME,TARGETFOLDERNAME,SAVEFORMAT,
%   ISSUBFOLDERS) saves all .fig files (in a folder) to png/eps/jpg/fig/svg
%   format, applying ADJUST_FIGURE instructions on each.
%
%   See also ADJUST_FIGURE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 31/10/2020

% Specify source and target folders:
if nargin == 0
    variable_definitions; %(sourcefolderName,targetfolderName,saveFormat) definitions
end

if exist('isSubFolders','var')
    [~,folderPaths] = recursive_folder(sourcefolderName,{});
else
    folderPaths{1} = sourcefolderName;
end

for it = 1:numel(folderPaths)
    % List all content of source folder:
    fileNames = dir(folderPaths{it});
    fileNames = fileNames(~[fileNames.isdir]); % delete directories from list
    % Create target folder if not exists
    if ~exist(fullfile(folderPaths{it},targetfolderName),'dir')
        status = mkdir(fullfile(folderPaths{it},targetfolderName));
        'Folder created for output'
    end
    for it1 = 1:length(fileNames)
        % convert only fig files:
        if  ~isempty(strfind(fileNames(it1).name, '.fig'))
            fileNames(it1).name
            openfig(fullfile(folderPaths{it}, fileNames(it1).name)); % open fig
%             adjust_figure(); % adjust axes limits, line thickness, labels, etc.
            switch saveFormat
                case 'png'
                    print(gcf,fullfile(folderPaths{it},targetfolderName,[fileNames(it1).name(1:end-4),'.png']),'-dpng','-r600');
                case 'eps'
                    print(gcf,fullfile(folderPaths{it},targetfolderName,[fileNames(it1).name(1:end-4),'.eps']),'-depsc')
                case 'jpg'
                    print(gcf,fullfile(folderPaths{it},targetfolderName,[fileNames(it1).name(1:end-4),'.jpg']),'-dpng','-r600');
                case 'fig' % overwrite
                    savefig(fullfile(folderPaths{it},targetfolderName,[fileNames(it1).name(1:end-4),'.fig']));
                case 'svg'
                    saveas(gcf,fullfile(folderPaths{it},targetfolderName,[fileNames(it1).name(1:end-4),'.svg']));
            end
            close;
        end
    end
end
end