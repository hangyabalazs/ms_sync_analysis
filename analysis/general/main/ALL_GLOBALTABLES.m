%ALL_GLOBALTABLE
%All project, global varriables and path definitions.
%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 26/09/2019

% clear all

analysisID = 'final_analysis';
rootPath = 'D:';

global ALLDATA_RESULTDIR
ALLDATA_RESULTDIR = fullfile(rootPath,'ALLDATASETS','analysis',analysisID);
global ANA_RAT_RESULTDIR
ANA_RAT_RESULTDIR = fullfile(rootPath,'ANA_RAT','analysis',analysisID);
global ANA_MOUSE_RESULTDIR
ANA_MOUSE_RESULTDIR = fullfile(rootPath,'ANA_MOUSE','analysis',analysisID);
global FREE_MOUSE_RESULTDIR
FREE_MOUSE_RESULTDIR = fullfile(rootPath,'FREE_MOUSE','analysis',analysisID);
global MODEL_RESULTDIR
MODEL_RESULTDIR= fullfile(rootPath,'MODEL','analysis',analysisID);
global OPTO_RESULTDIR
OPTO_RESULTDIR = fullfile(rootPath,'OPTOTAGGING','analysis',analysisID);