function handles=InitializeMainAxes(handles,gridT,goalCells,robotInitPos,rows,cols,sizeCell,pauseTime)

axes(handles.axes1)
handles.axes1.XLim = [1 rows+1];
handles.axes1.YLim = [1 cols+1];
plotCurrentEvaluationAstar(gridT,goalCells,robotInitPos,1,0,0,0,0,sizeCell,rows,cols)
pause(pauseTime);