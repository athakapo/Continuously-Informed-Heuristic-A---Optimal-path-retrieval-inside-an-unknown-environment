function [Neighborhood,Inv_Closed_Obstacles,DiscoveredObstacles] = extractNeighbors(SystemState,gridT,rows,cols,forward,Inv_Closed_Obstacles)
%Find the possible next movement for each robot

x = SystemState.RobotsCurrentPos(1,1);
y = SystemState.RobotsCurrentPos(1,2);
theta = SystemState.RobotsCurrentPos(1,3);
Neighborhood=[];
DiscoveredObstacles=[];
cand=0;
for act=1:4
    %theta_cand = mod(theta+action(act)-1,thetasOrien)+1;
    x_cand = x + forward(act,1);
    y_cand = y + forward(act,2);
    if x_cand > 0 && x_cand <= rows && y_cand >0 && y_cand <= cols
        if gridT(x_cand,y_cand)~=-1
            cand=cand+1;
            Neighborhood=[Neighborhood; x_cand,y_cand,theta];
        else
            DiscoveredObstacles=[DiscoveredObstacles; x_cand,y_cand];
            Inv_Closed_Obstacles(x_cand,y_cand)=0;
            %DisTable(x_cand,y_cand)=inf;
        end
    end
end
