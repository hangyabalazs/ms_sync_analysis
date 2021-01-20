function extract_points_from_plot()
% EXTRACT_POINTS_FROM_PLOT Extracts given objects from the current plot.

h = findobj(gca,'Type','scatter');
% h = findobj(gca,'Type','Line');
xPoints = get(h,'Xdata');
yPoints = get(h,'Ydata');
% comp = get(gca,'children');
% set(gca,'children',flipud(comp))
xLims = xlim; yLims = ylim;
thetaData = [xPoints{1},xPoints{3},xPoints{2}];
deltaData = [yPoints{1},yPoints{3},yPoints{2}];

sum(thetaData<xLims(1) | thetaData>xLims(2))

% nCells = cumsum([length(xPoints{1}),length(xPoints{3}),length(xPoints{2})]);
end