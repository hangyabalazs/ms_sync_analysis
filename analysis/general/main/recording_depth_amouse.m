function depth = recording_depth_amouse(animalId,recordingId)
%RECORDING_DEPTH_AMOUSE() defines the D-V location (depth) of the recording.
%   DEPTH=RECORDING_DEPTH_AMOUSE(ANIMALID,RECORDINGID) defines the
%   dorso-ventral (depth) coordinate (in mm) of the most dorsal recording
%   site in anaesthetized mouse recording identified by ANIMALID
%   and RECORDINGID. Electrode length 720 um (= 32 row*22.5 channel
%   separation) -> electrode tip: DEPTH + 720 um.
%   Parameters:
%   ANIMALID: string (e.g. '20170216').
%   RECORDINGID: string (e.g. '45').
%
%   See also CLUSTER_LOCATION_DEPTHS, ANA_MOURE_GLOBALTABLE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 25/03/2021

% Columns: animalID|recordingID|depth
recDepths = {'20170216', '45', 3.5; '20170216', '67', 4; ...%
    '20170607', '23', 3.5; ...%
    '20170608', '45', 3.5; '20170608', '6', 4;...%
    '20171207', '12', 3.5; '20171207', '3', 4; ...%
    '20171208', '12', 3.5; '20171208', '3', 4; ...%
    '201801082', '1', 3.5; '201801082', '3', 4.5; ...%
    '201801091', '12', 3.5; ...%
    '201801101', '12', 3.5; '201801101', '34', 4; '201801101', '56', 4.5; ...%
    '201801102', '12', 3.5; '201801102', '34', 4; '201801102', '56', 4.5; ...%
    '20180111', '12', 3.5; '20180111', '34', 4; '20180111', '56', 4.5; ...%
    '201801122', '12', 3.5; '201801122', '34', 4; '201801122', '5', 4.5};
rowInx = find(ismember(recDepths(:,1),animalId) & ismember(recDepths(:,2),recordingId));
depth = recDepths{rowInx,3};
end