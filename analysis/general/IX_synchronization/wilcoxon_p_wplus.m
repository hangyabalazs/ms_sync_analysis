function [p,Wplus] = wilcoxon_p_wplus(data1,data2)
% WILCOXON_P_WPLUS calculates Wilcoxon signed rank paired test statistics
% (W+) and p values.
%
%   See also FIRING_RATE_STATISTICS, PLOT_SYNCHRONIZATION_THEORIES,
%   GROUP_SYNCHRONIZATION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 15/02/2022

if isempty(data1)
    p = NaN;
    Wplus = NaN;
else
    % Wilcoxon signed-rank test
    p = signrank(data1,data2); % statistics: paired signrank
    d = data1 - data2;
    d(d == 0) = [];
    R = tiedrank(abs(d));
    Wplus = sum(R(d>0)); % W+ test statistics
end
end