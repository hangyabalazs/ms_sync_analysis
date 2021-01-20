function activeRecIds = collect_active_recordings()
%COLLECT_ACTIVE_RECORDINGS Collects active recordings.
%   ACTIVERECIDS = COLLECT_ACTIVE_RECORDINGS() collects all recordings from
%   the DATADIR folder that doesn't have a 'n' in their foldername 
%   (animnals) or filename (recordings).
%   ACTIVERECIDS is #active recordings x 2 (animalId,recordingId) cell 
%   array.
%
%   See also ANA_RAT_GLOBALTABLE, ANA_MOUSE_GLOBALTABLE, 
%   FREE_MOUSE_GLOBALTABLE, OPTO_GLOBALTABLE, MODEL_GLOBALTABLE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global DATADIR

animalFolders = dir(DATADIR);
animalFolders = return_used_folders(animalFolders,true,{'.','n'});

activeRecIds = {};
for it1 = 1:length(animalFolders) % iterate trough all animals
    animalId = animalFolders(it1).name;
    recordingFolders = dir(fullfile(DATADIR, animalId));
    recordingFolders = return_used_folders(recordingFolders,true,{'.','n'});
    for it2 = 1:length(recordingFolders) % iterate trough all recordings
        recordingId = recordingFolders(it2).name;
        activeRecIds(end+1,:) = {animalId,recordingId};
    end
end
end