function plot_ellipse(centreX,centreY,radius1,radius2)
%PLOT_ELLIPSE Plots an ellipse.
%   PLOT_ELLIPSE(CENTREX,CENTREY,RADIUS1,RADIUS2) plots an ellipse with
%   given center (CENTREX,CENTREY) points and radiuses (RADIUS1,RADIUS2).

angles = 0:pi/50:2*pi;
xunit = centreX + radius1 * cos(angles);
yunit = centreY + radius2 * sin(angles);
plot(xunit, yunit, 'k');
end