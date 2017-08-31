function h=MyheuristicEvaluationFinal(successor,goalCells,knownObstacles,rows,cols,r)

difx = abs(successor.RobotsCurrentPos(1) - goalCells(1));
dify = abs(successor.RobotsCurrentPos(2) - goalCells(2));

if difx>dify
    if goalCells(1)<=successor.RobotsCurrentPos(1)
        if goalCells(2)<=successor.RobotsCurrentPos(2)
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,dify,goalCells(1),successor.RobotsCurrentPos(1),successor.RobotsCurrentPos(2),1,r,rows,cols);
        else
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,dify,goalCells(1),successor.RobotsCurrentPos(1),goalCells(2),2,r,rows,cols);
        end
    else
        if goalCells(2)<=successor.RobotsCurrentPos(2)
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,dify,successor.RobotsCurrentPos(1),goalCells(1),successor.RobotsCurrentPos(2),3,r,rows,cols);
        else
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,dify,successor.RobotsCurrentPos(1),goalCells(1),goalCells(2),4,r,rows,cols);
        end
    end
else
    if goalCells(1)<=successor.RobotsCurrentPos(1)
        if goalCells(2)<=successor.RobotsCurrentPos(2)
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,difx,goalCells(2),successor.RobotsCurrentPos(2),goalCells(1),5,r,rows,cols);
        else
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,difx,successor.RobotsCurrentPos(2),goalCells(2),goalCells(1),6,r,rows,cols);
        end
    else
        if goalCells(2)<=successor.RobotsCurrentPos(2)
             [extrah]=CalculateDistanceVectorFinal(knownObstacles,difx,goalCells(2),successor.RobotsCurrentPos(2),successor.RobotsCurrentPos(1),7,r,rows,cols);
        else
            [extrah]=CalculateDistanceVectorFinal(knownObstacles,difx,successor.RobotsCurrentPos(2),goalCells(2),successor.RobotsCurrentPos(1),8,r,rows,cols);
        end
    end
end

manhattanHeuristic = sum(abs(successor.RobotsCurrentPos(1,1:2)-goalCells));
h=manhattanHeuristic+tieBreaking(manhattanHeuristic,rows+cols)+extrah;