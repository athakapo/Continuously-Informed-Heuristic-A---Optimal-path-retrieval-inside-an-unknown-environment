function h=heuristicEvaluation(successor,goalCells)

h=sum(sum(abs(successor.RobotsCurrentPos(:,1:2)-goalCells)));



