function [shankId,cellId] = cbId2shankcellId(cellIdFname)
%CBID2HANKCELLID Extracts shank and cellId from cellbase name.
%   [SHANKID,CELLID] = CBID2HANKCELLID(CELLIDFNAME).
%   Parameters:
%   CELLIDFNAME: string (e.g. 'PVR02_180821a_1.32').
%
%   See also MYNAME2CBNAME.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

indices = regexp(cellIdFname,'(\d)*(\d)','match');
shankId = str2num(indices{1});
cellId = str2num(indices{2});
end