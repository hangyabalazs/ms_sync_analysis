function adjust_figure()
%ADJUST_FIGURE Adjust current figure parameters.
%   ADJUST_FIGURE applies different instructions to the current figure 
%   (limit axis, control layout, etc.).
%
%   See also CONVERT_ALL_FIGS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 31/10/2020

% limits=[0,10];xlim(limits),ylim(limits),set(gca, 'xtick', [limits(1),limits(2)/2,limits(2)]);set(gca, 'xticklabel', {limits(1),'',limits(2)}),set(gca, 'ytick', [limits(1),limits(2)/2,limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}), setmyplot_balazs, hold on, plot(limits,limits,'k')
% limits=[0,6e-4];ylim(limits),set(gca, 'ytick', [limits(1),mean(limits),limits(2)]);set(gca, 'yticklabel', {limits(1),'',limits(2)}),set(gca, 'xtick', [-2000,-1000,0,1000,2000]);set(gca, 'xticklabel', {-2,'',0,'',2}), setmyplot_balazs

xlabel(''), set(gca, 'xticklabel',{})
ylabel(''), set(gca, 'yticklabel',{})
title('')
% Set x axis:
% set(gca, 'xtick',[2000,2500,3000,3500,4000])
% set(gca, 'xticklabel',{'-1','','0','','1'})
% set(gca, 'xticklabel',{}), set(gca, 'yticklabel',{})
% set(gca,'xtick',[-pi,0,pi,2*pi,3*pi])
% xlabel('Lag (s)')
% xlabel('Time (s)')
% xlim([-2000,2000])
% xlim([2000,4000])

% Set y axis:
% yLims = ylim
% set(gca, 'ytick', [yLims(1)])
% set(gca, 'yticklabel', {yLims(2)-0.5})
% set(gca, 'ytick', [-100,-50,-0,50])
% set(gca, 'yticklabel', {-100,-50,-0,50})
% ylabel('Voltage (mV)')
% ylim([0,0.0004])
% ylim([0,10])

% set(gca,'clim',[0.000108566006644834,0.000216501153103967]);
% set(gcf,'Position',[680, 546, 1120, 200])

% title('')

% Set plot:
% allLines = findall(gca, 'Type', 'Line');
% allLines([7,14]) = [];
% delete(allLines);
% setmyplot_balazs
% set(gca,'FontSize',15,'LineWidth',0.75);
% set(gca,'TickDir','out','box','off');
% set(gcf, 'Position', [300,100,200,200]); % set figure POSITION and SIZE
% set(findall(gca, 'Type', 'Line'),'LineWidth',2); % set ALL LINE WIDTH to 2
% delete(findall(gca, 'Type', 'Text')); %
% delete(findall(gca, 'Type', 'Line')); %
% set(findall(gca, 'Type', 'stair'),'LineWidth',2); % set ALL LINE WIDTH to 2
% pbaspect([1 1 1]); axis square %ASPECT RATIO ([1 1 1] = square)
% legend('', '', '')

% Put line on:
% line([-300, 300], [-300, 300], 'Color','red','LineStyle','--')

% Change RENDERER (sugested)
% set(gcf,'renderer','Painters'), 

% REMOVE axes, frame box (keep only plotted data):
% set(gca,'Visible','off')
end