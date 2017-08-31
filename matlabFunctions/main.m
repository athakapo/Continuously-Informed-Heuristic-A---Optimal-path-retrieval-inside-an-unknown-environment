function handles = main(x,y,x_start,y_start,x_goal,y_goal,num_obstacles,full_map,handles)
%%%%%%%%---------- User defined Parameters ----------%%%%%%%
%World Grid size
rows = y; %22  %n*m = Number of Tiles   
cols = x; %22

robotInitPos=[y_start,x_start,1];

%The Robots have to reach the given gird cell following the minimum path 
%inside an unknown space
               
goalCells = [y_goal,x_goal];%[4,6];%[2,round(cols/2)];%[4,cols; 1,1];

loadDirectryTheMap = 0;

if (isempty(full_map))
    [obstacles,~]=generateRandomObstacles(num_obstacles,rows,cols);
else
    load(full_map)
end

cost = [1, 1, 1]; % [2, 1, 2] cost has 3 values, corresponding to making 
                   % a right turn, no turn, and a left turn   
                   
UpperBoundOfSearches = 8000;
pauseTime=0.09; %0.09

displayGraphWithNodes=1;
sizeCell = 1; %250;

%Build Grid
if loadDirectryTheMap
    gridT=CurrMap;
    obstacles=[];
else
    gridT=zeros(rows,cols);
    no=size(obstacles,1);
    deleteNode=0;
    for i=1:no
        if obstacles(i,1)==goalCells(1) && obstacles(i,2)==goalCells(2)
            deleteNode=i;
        else
            gridT(obstacles(i,1),obstacles(i,2))=-1;
        end
    end
    if deleteNode>0
        obstacles(deleteNode,:)=[];
        no = no-1;
    end
end


%%%%%%%%------------ Compute Array Helpers ------------%%%%%%%

nr=1;  %Number of robots
forward=[-1,  0;  0, -1; 1,  0; 0,  1]; 
thetasOrien = size(forward,1);
% action has 3 values: right turn, no turn, left turn
action = [-1, 0, 1];

%Produce the Cost function Map
CostMap=produceCostMap(cost,thetasOrien);
AverageCost=mean(cost);
MaxCost=max(cost);


penaltyForNonOptimality=1;
HeuristicParameters = [3 1];

SIMULparam = struct('rows',rows,'cols',cols,'nr',nr,'gridT',gridT,...
    'robotInitPos',robotInitPos,'obstacles',obstacles,'thetasOrien',thetasOrien,...
    'forward',forward,'CostMap',CostMap,'action',action,...
    'UpperBoundOfSearches',UpperBoundOfSearches,'goalCells',goalCells,...
    'AverageCost',AverageCost,'MaxCost',MaxCost,...
    'penaltyForNonOptimality',penaltyForNonOptimality,...
    'HeuristicParameters',HeuristicParameters,'sizeCell',sizeCell,...
    'displayGraphWithNodes',displayGraphWithNodes,'pauseTime',pauseTime);


handles.SIMULparam = SIMULparam;

if displayGraphWithNodes
    handles=InitializeMainAxes(handles,gridT,goalCells,robotInitPos,rows,...
        cols,sizeCell,pauseTime);
end

end