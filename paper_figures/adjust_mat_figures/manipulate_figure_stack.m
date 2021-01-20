function manipulate_figure_stack()

comp = get(gca,'children');
set(gca,'children',[comp(2:end);comp(1)]) %send the uppermost object behind everybody

end