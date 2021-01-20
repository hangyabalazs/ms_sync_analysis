function plot_phase_pref_circular(hangs,hmvls,arrowColors,edges,histColor)
%PLOT_PHASE_PREF_CIRCULAR Plots circular (hippo) phase preference of MS
%units.
%   PLOT_PHASE_PREF_CIRCULAR(HANGS,HMVLS,ARROWCOLORS,EDGES,HISTCOLOR) 
%   Creates quiver (arrow) plots and circular phase histogram.
%   Parameters:
%   HANGS: nCells x 1 vector, providing resultant phase angles of cells.
%   HMVLS: nCells x 1 vector, providing resultant phase vector lengths.
%   ARROWCOLORS: nCells x 1 vector, providing firing rate dependent gray
%   colors of cells (See COLOR_INTENSITIES).
%   EDGES: optional, vector, specifying phase histogram edges 
%   (e.g.: -pi:pi/3:pi).
%   HISTCOLOR: optional, color vector, histogram color.
%   
%   See also HIPPO_STATE_DETECTION, CELL_PHASE_PREFERENCE, CELL_GROUPS, 
%   COLOR_INTENSITIES.
 
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 03/08/2018

% Histogram of cell's phases
if exist('edges','var')
    sumHist = histcounts(hangs,edges,'Normalization','probability')*pi;
    x1 = sumHist.*cos(edges(1:end-1)); % right border
    x2 = sumHist.*cos(edges(2:end)); % left border
    y1 = sumHist.*sin(edges(1:end-1));
    y2 = sumHist.*sin(edges(2:end));
    line([x1;x2],[y1;y2],'Color',histColor,'LineWidth', 2);
    line([x1;zeros(size(x1))],[y1;zeros(size(y1))],'Color',histColor,'LineWidth',2); % border line
    line([x2;zeros(size(x2))],[y2;zeros(size(y2))],'Color',histColor,'LineWidth',2); % border line
end

% Cells' phase angle resultant vectors (arrows):
xendp = cos(hangs).*hmvls; % x coordinate of resultant vector endpoint
yendp = sin(hangs).*hmvls; % y coordinate of resultant vector endpoint
for it = 1:length(hangs)
    quiver(0,0,xendp(it),yendp(it),'Color',arrowColors(it,:),'LineWidth',2,'AutoScale','off');
end
plot_ellipse(0,0,1,1) % plot a unit circle
text(-1,0,'-180°'), text(0,-1,'-90°'), text(1,0,'0°'), text(0,1,'90°')
xlim([-1, 1]), ylim([-1, 1]), axis equal
set(gca,'Visible','off')
end