function MSsync_figure_S2()
%% FIGURE(1) S2 pyramidal layer phase change (amouse)
%   panelA: histolology Nissl, fluor, atlas (201801102_3HPC_13_J)
ANA_MOUSE_GLOBALTABLE
pyramidal_phase_change('201801102','12',[1204,1206]);
savefig(figure(1),'Figure_S2_panelC.fig')
savefig(figure(2),'Figure_S2_panelB.fig')
close all
end