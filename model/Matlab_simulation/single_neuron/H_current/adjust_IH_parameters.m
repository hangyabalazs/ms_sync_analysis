function adjust_IH_parameters()
%ADJUST_IH_PARAMETERS ADjust H current dynamics.
%   ADJUST_IH_PARAMETERS produces an interactive platform to adjust and 
%   tune a generic H current model parameters, by ploting time constant and
%   steady state curves whenever parameters are changed with the sliders.
%   Default values are adjusted according the followings: 
%   1. Migliore 2012 CA1 IH model (https://senselab.med.yale.edu/modeldb/showmodel.cshtml?model=144541&file=/Ih_current/fig-5a.hoc#tabs-2)
%   2. Xu, 2004, septohippocampal rat brain slices (Hippocampal theta
%   rhythm is reduced by suppression of the H-current in septohippocampal GABAergic neurons)
%
%   See also TAU_SS_CURVES.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 11/09/2020

xSize = 1000;
ySize = 500;
f1 = figure('Position', [50,50,xSize,ySize]);

% Default parameter values:
X_v0 = -98; % -0.09;
X_k0 = -6.73; % -0.01;
X_kt = 1.2353; % 5;
X_gamma = 0.81; % 0.8;
X_tau0 = 0.13; % 0;
v = -150:0.1:-50; % in mV
create_plot()

% Sliders:
sld1 = uicontrol('Style', 'slider',...
    'Min',-150,'Max',0,'Value',X_v0,...
    'Position', [10 + xSize*0.6, ySize-40, 200, 20]);
addlistener(sld1, 'Value', 'PreSet',@Xv0Slider);
statText1 = uicontrol('Style', 'text', 'String', 'X v0',...
    'Position', [220 + xSize*0.6 ySize-40 50 20]);

sld2 = uicontrol('Style', 'slider',...
    'Min',-25,'Max',10,'Value',X_k0,...
    'Position', [10 + xSize*0.6, ySize-80, 200, 20]);
addlistener(sld2, 'Value', 'PreSet',@Xk0Slider);
statText2 = uicontrol('Style', 'text', 'String', 'X k0',...
    'Position', [220 + xSize*0.6 ySize-80 50 20]);

sld3 = uicontrol('Style', 'slider',...
    'Min',0,'Max',3,'Value',X_kt,...
    'Position', [10 + xSize*0.6, ySize-120, 200, 20]);
addlistener(sld3, 'Value', 'PreSet',@XktSlider);
statText3 = uicontrol('Style', 'text', 'String', 'X kt',...
    'Position', [220 + xSize*0.6 ySize-120 50 20]);

sld4 = uicontrol('Style', 'slider',...
    'Min',0,'Max',1,'Value',X_gamma,...
    'Position', [10 + xSize*0.6, ySize-160, 200, 20]);
addlistener(sld4, 'Value', 'PreSet',@XgammaSlider);
statText4 = uicontrol('Style', 'text', 'String', 'X gamma',...
    'Position', [220 + xSize*0.6 ySize-160 50 20]);

sld5 = uicontrol('Style', 'slider',...
    'Min',0,'Max',0.5,'Value',X_tau0,...
    'Position', [10 + xSize*0.6, ySize-200, 200, 20]);
addlistener(sld5, 'Value', 'PreSet',@Xtau0Slider);
statText5 = uicontrol('Style', 'text', 'String', 'X tau0',...
    'Position', [220 + xSize*0.6 ySize-200 50 20]);

%Buttons:
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Quit',...
    'Position', [20 + xSize*0.6 ySize-240 50 20],...
    'Callback', @quitFunc);
    function quitFunc(src, event)
        close(f1);
        quit cancel;
    end

btn2 = uicontrol('Style', 'pushbutton', 'String', 'Save params',...
    'Position', [100 + xSize*0.6 ySize-240 100 20],...
    'Callback', @saveFunc);

    function saveFunc(src, event)
    actTime = clock;
    save([pwd '\IH_params\' num2str(actTime(1:5))], 'X_v0', 'X_k0', 'X_kt', 'X_gamma', 'X_tau0');
    end

% SLider listeners:
    function Xv0Slider(source,event)
        X_v0 = get(event.AffectedObject,'Value');
        create_plot();
    end
    function Xk0Slider(source,event)
        X_k0 = get(event.AffectedObject,'Value');
        create_plot();
    end
    function XktSlider(source,event)
        X_kt = get(event.AffectedObject,'Value');
        create_plot();
    end
    function XgammaSlider(source,event)
        X_gamma = get(event.AffectedObject,'Value');
        create_plot();
    end
    function Xtau0Slider(source,event)
        X_tau0 =get(event.AffectedObject,'Value');
        create_plot();
    end

    function create_plot()
        inf = ((X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) ./ ((X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) + (X_kt * (exp ((X_gamma - 1)  * (v - X_v0) / X_k0)))));
        inf(isnan(inf)) = 1;
        tau = 1 ./ ( (X_kt * (exp (X_gamma * (v - X_v0) / X_k0))) + (X_kt * (exp ((X_gamma - 1)  * (v - X_v0) / X_k0)))) + X_tau0;
        tau = tau*1000; %change to ms
        subplot(2, 10, [1:6]), plot(v, inf), legend('inf'); 
        subplot(2, 10, [11:16]), plot(v, tau); legend('tau'), ylim([0, 800]);
        title(['X v0: ' num2str(X_v0) ', X k0: ' num2str(X_k0) ...
            ', X kt: ' num2str(X_kt) ', X gamma: ' num2str(X_gamma)...
            ', X tau0: ' num2str(X_tau0)]);
    end

end