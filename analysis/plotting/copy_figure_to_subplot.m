function copy_figure_to_subplot(F1,F2,S)
%COPY_FIGURE_TO_SUBPLOT Copies opened figure content to another figure's
%subplot.
%   COPY_FIGURE_TO_SUBPLOT(F1,F2,S)
%   Parameters:
%   F1: figure to copy.
%   F2: target figure.
%   S: subplot axes handle on F2.

figure(F1)
oldColorMap = colormap();
old_ax = gca;

figure(F2)
new_ax = gca; hold on
copyobj(get(old_ax, 'children'),new_ax);

new_ax.XLim = old_ax.XLim;
new_ax.YLim = old_ax.YLim;
% new_ax.Colormap = old_ax.Colormap;
% new_ax.ColorScale = old_ax.ColorScale;
new_ax.CLim = old_ax.CLim;
new_ax.XTick = old_ax.XTick;
new_ax.XTickLabel = old_ax.XTickLabel;
% new_ax.PlotBoxAspectRatio = old_ax.PlotBoxAspectRatio;
new_ax.Visible = old_ax.Visible;
% oldProperties = get(old_ax);
% figureFieldNames = fieldnames(oldProperties);
drawnow
end