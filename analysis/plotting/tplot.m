function tplot(varargin)
%TPLOT Plots input signal rescaled to the same x axis of gca.

hold on
xLims = xlim;
psep = (xLims(2)-xLims(1))/(length(varargin{1})-1); % point separation
timeVec = xLims(1):psep:xLims(2);
plot(timeVec,varargin{:})
hold off
end