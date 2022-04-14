function plot_ccg_network(varargin)
%PLOT_CCG_NETWORK Plots all possible intra- and intergroup ccgs.
%   PLOT_CCG_NETWORK(ISSHIFT?MAXLAG) plots the MS network (ccgs of 
%   corecorded cells) of the
%   5 rhythmicity groups (CTB, CTT, CD, DT, NT). Intragroup ccgs: diagonal.
%   Parameters:
%   ISSHIFT: optional, logical, controlls if ccgs will be aligned at their
%   peaks (default: true).
%   MAXLAG: maximum shift in sampling rate (default: CGWINDOW*NSR).
%
%   See also CREATE_CCGMATRIX, CREATE_CCGMATRIXIDS, ALIGN_CCG_PEAKS, 
%   CCG_SCORE_TEST.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/05/2019

global RESULTDIR
global NSR
global CGWINDOW

% Overdefine in variable_definitions.m files (not here)!!!
p = inputParser;
addOptional(p,'isShift',true,@islogical);
addOptional(p,'maxlag',CGWINDOW*NSR,@islogical);
addOptional(p,'plotScores',true,@islogical);
parse(p,varargin{:});

isShift = p.Results.isShift;
maxlag = p.Results.maxlag;
plotScores = p.Results.plotScores;

if nargin == 0
    variable_definitions; %maxlag,(isShift) definitions
end

if isShift
    findMaxIn = -maxlag/2:maxlag/2; % lags
    findMaxIn = findMaxIn + maxlag; % indices of lags
    slideWindow = maxlag / 2;
    %     hmean = tight_subplot(5,6,[0.05,0.02],0.05,0.05);
else
    slideWindow = maxlag;
end
% xticks = [1,slideWindow+1,slideWindow*2+1];
% xlabels = {-slideWindow,0,slideWindow};
figure('Position',[1,41,1097,505]); %figure('Position',get(0,'Screensize')),
himage = tight_subplot(5,6,[0.05,0.02],0.05,0.05);

if ~exist(fullfile(RESULTDIR,'network','ccgMatrixIds.mat'))
    create_ccgMatrix();
    'ccgMatrix created'
end

% Load data table
load(fullfile(RESULTDIR,'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'),'mO');

% Load ccg matrices
load(fullfile(RESULTDIR,'network','ccgMatrixIds.mat'),'ccgMatrixIds');
load(fullfile(RESULTDIR,'network',num2str(maxlag),'ccgMatrixTh.mat'),'ccgMatrixTh'); %during theta
load(fullfile(RESULTDIR,'network',num2str(maxlag),'ccgMatrixDe.mat'),'ccgMatrixDe'); %during delta
nGroups = size(ccgMatrixIds,1);
% Calculate color range for imagesc-s
allPoints = [ccgMatrixTh{:},ccgMatrixDe{:}];
allPoints = sort(allPoints(:));
CI = [allPoints(round(length(allPoints)/10)), allPoints(end-round(length(allPoints)/10))];

rhGroups = {'pacemaker','tonic','theta-skipping','follower','theta-follower'};
for it1 = 1:size(ccgMatrixTh,1) % go trough rows of ccg arrays
    for it2 = 1:size(ccgMatrixTh,2) % go trough columns of ccg arrays
        IDpairs = ccgMatrixIds{it1,it2};
        if ~isempty(IDpairs) 
            % Group recordings:
            recIds = [allCell(IDpairs(:,1),mO('animalId')),allCell(IDpairs(:,1),mO('recordingId'))];
            recIds = cellfun(@(x) str2double(sprintf('%d',x(1),x(2))),num2cell(recIds,2),'UniformOutput',false);
            changeRec = find(diff(cell2mat(recIds))~=0) + 0.5; % change recording
            
            if isShift % align ccgs at their peaks?
                ccgsDe = align_ccg_peaks(ccgMatrixDe{it1,it2},findMaxIn,slideWindow); % shift ccgs
                ccgsTh = align_ccg_peaks(ccgMatrixTh{it1,it2},findMaxIn,slideWindow); % shift ccgs
            else
                ccgsDe = ccgMatrixDe{it1,it2};
                ccgsTh = ccgMatrixTh{it1,it2};
            end
            
            %% During delta
            axes(himage((it2-1)*(nGroups+1)+it1))
            [~,inxDe] = sort(range(ccgsDe)); % sort ccg matrix (amplitude)
            imageccgs(ccgsDe(:,inxDe).'); hold on
            % Differentiate between recordings:
%             arrayfun(@(x) line([1,slideWindow*2+1],[x,x],'Color',[1,1,1],'LineWidth',1),changeRec);
            % Create mean ccg:
            meanCcgDe = mean(ccgsDe.');
            plot(size(ccgsDe,2)-meanCcgDe*size(ccgsDe,2)/0.0005,'Color',[1,0,0],'LineWidth',2)
%             set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
            set(gca,'CLim',CI)
            yLims = ylim; set(gca,'ytick',yLims(1)), set(gca,'yticklabel',yLims(2)-0.5), set(gca,'TickDir','out');
            set(gca,'xtick',[0.5,maxlag/2,maxlag+0.5]), set(gca,'xticklabel',{'','',''}), xlabel(''), setmyplot_balazs
% % % %             % ccg score distribution:
% % % %             yyaxis right
% % % %             ccgDeScores = sum((ccgsDe-mean(ccgsDe)).^2);
% % % %             h = boxplot(ccgDeScores,'positions',1500,'Width',maxlag/2,'Colors','k','symbol','');
% % % % %             set(h,{'linew'},{2})
% % % %             ylim([0,2.6]*1e-5)
% % % % %             title(sum((meanCcgDe - mean(meanCcgDe)).^2))
            title({[rhGroups{it1}, ' - ', rhGroups{it2}, ' (delta)'];...
                median(sum((ccgsDe-mean(ccgsDe)).^2))})
            
            %% During theta:
            axes(himage((it1-1)*(nGroups+1)+it2+1))
            [~,inxTh] = sort(range(ccgsTh)); %sorte ccg matrix (amplitude)
            imageccgs(ccgsTh(:,inxTh).'); hold on
            % Differentiate between recordings:
%             arrayfun(@(x) line([1,slideWindow*2+1],[x,x],'Color',[1,1,1],'LineWidth',1),changeRec);
            % Create mean ccg:
            meanCcgTh = mean(ccgsTh.');
            plot(size(ccgsTh,2)-meanCcgTh*size(ccgsTh,2)/0.0005,'Color',[0,0,1],'LineWidth',2)
%             set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
            set(gca,'CLim',CI)
            yLims = ylim; set(gca,'ytick',yLims(1)), set(gca,'yticklabel',yLims(2)-0.5), set(gca,'TickDir','out');
            set(gca,'xtick',[0.5,maxlag/2,maxlag+0.5]), set(gca,'xticklabel',{'','',''}), xlabel(''), setmyplot_balazs
% % % %             % ccg score distribution:
% % % %             yyaxis right
% % % %             ccgThScores = sum((ccgsTh-mean(ccgsTh)).^2);
% % % %             h = boxplot(ccgThScores,'positions',1500,'Width',maxlag/2,'Colors','k','symbol','');
% % % % %             set(h,{'linew'},{2})
% % % %             ylim([0,2.6]*1e-5)
% % % % %             title(sum((meanCcgTh - mean(meanCcgTh)).^2))
            title({[rhGroups{it1}, ' - ', rhGroups{it2}, ' (theta)'];...
                median(sum((ccgsTh-mean(ccgsTh)).^2))})
        end
    end
end
end