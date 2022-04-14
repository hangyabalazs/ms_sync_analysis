function save_figure_3formats(fName)

savefig([fName,'.fig'])
saveas(gcf,[fName,'.svg']);
saveas(gcf,[fName,'.png']);
end