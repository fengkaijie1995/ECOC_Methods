%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function focus on drawing matrix color map
% x is matrix values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = [];
x_names = {'F1','F2','F3','N2','N3','C1'};
y_names={'C1','N3','N2','F3','F2','F1'};  
matrixplot(x,'FigSize','Full','XVarNames',x_names,'YVarNames',x_names,'ColorBar','on');
% matrixplot(x,'XVarNames',XVarNames,'YVarNames',XVarNames,'DisplayOpt','off','FigSize','Full','ColorBar','on');

h = HeatMap(x);
h.addTitle('ECOC PD Values');
h.addXLabel('DC');
h.addYLabel('DC');