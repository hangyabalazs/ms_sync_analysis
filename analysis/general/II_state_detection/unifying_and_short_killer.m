function [logicVector,s1,s2] = unifying_and_short_killer(logicVector,windowS1,windowS2)
%UNIFYING_AND_SHORT_KILLER Cuts short isolated sections from vector.
%   [LOGICVECTOR,S1,S2] = UNIFYING_AND_SHORT_KILLER() finds and erase too 
%   short segments (both theta and delta) in a logical vector.
%   Parameters:
%   LOGICVECTOR is a logical vector representing two states (0 or 1).
%   WINDOWS1: window size (neglect 0 (delta) segments shorter than this
%   value, e.g. 1*NSR).
%   (e.g. 5). 
%   WINDOWS2: window size (neglect 1 (theta) segments shorter than this
%   value, e.g. 1*NSR).
%   S1: vector, time points of 0 to 1 transitions.
%   S2: vector, time points of 1 to 0 transitions.
%
%   See also THETA_DETECTION, SAVE_STIMULATION_OPTO,
%   FREE_MOUSE_STIMULATIONS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 03/08/2018

if nargin==1
    variable_definitions; %windowS1, windowS2 definitions
end

% Unifier (kills short 0s segments):
dtheta = diff(logicVector);
s1 = find(dtheta==1);  % change from non-theta to theta.
s2 = find(dtheta==-1);  % change from theta to non-theta

for it = 1:length(s1)-1
    if s1(it+1) - s2(it) < windowS1
        logicVector(s2(it):s1(it+1)) = 1;
    end
end

% Short_killer (kills short 1s segments):
logicVector = [0 logicVector 0];
dtheta = diff(logicVector);
s1 = find(dtheta==1);  % change from non-theta to theta.
s2 = find(dtheta==-1);  % change from theta to non-theta

for it = 1:length(s1)-1
    if s2(it) - s1(it) < windowS2
        logicVector(s1(it):s2(it)) = 0;
    end
end

logicVector = logicVector(3:end-2);
dtheta = diff(logicVector);
s1 = find(dtheta==1);
s2 = find(dtheta==-1);
end