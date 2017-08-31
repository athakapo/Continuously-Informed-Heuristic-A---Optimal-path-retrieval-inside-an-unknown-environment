function [msg,d,TrackPath,TrackHeading,J,GeneralIter]=MystarSolver_Final(parameters,radiusToSearch,hObject, handles)


v2struct(parameters)
RobotsCurrentPos = robotInitPos;

% Create initially empty heap
Fringe = cFibHeap;  %For O(logn) searches in the distances of states
% HashTable
AllNodes=HashTable(rows*cols); %For O(logn) searches in the states

ClosedSet=zeros(rows,cols);

%Keep the visited tiles to reproduce the solution
TrackPath=sub2ind([rows cols], RobotsCurrentPos(:,1), RobotsCurrentPos(:,2))';
TrackHeading = RobotsCurrentPos(:,3)';
indexOpenObstacle=zeros(rows,cols);
DisTable=ones(rows,cols).*inf;

Inv_Closed_Obstacles=ones(rows,cols);  
DiscoveredObstacles =[];  

%MaximumPossibleDist = (sum(sum(grid==0))*MaxCost);
%State Data Structure - Initial State
SystemState = struct('RobotsCurrentPos',RobotsCurrentPos,'TrackPath',TrackPath,...
    'TrackHeading',TrackHeading,'CostEvaluation',0,'augmentedMovementsCost',0);

g=size(TrackPath,1);
%h=MyheuristicEvaluationFinal(SystemState,goalCells,Inv_Closed_Obstacles,rows+cols);
h=MyheuristicEvaluationFinal(SystemState,goalCells,Inv_Closed_Obstacles,rows,cols,radiusToSearch);
SystemState.CostEvaluation = g+h;


%Update Priority Queue
Fringe.insert(SystemState.CostEvaluation,SystemState);

%Add the Initial State to the Fringe
AllNodes=AddToHashTable(AllNodes,SystemState,nr);
GeneralIter=0;
J=0;

gridAugmented=gridT;


%Main Searching Loop
while GeneralIter<=UpperBoundOfSearches && ~handles.stop_now
    if Fringe.n==0
        TrackPath=[];
        TrackHeading=[];
        d=inf;
        msg=1;
        J=inf;
        return;
    end
    GeneralIter=GeneralIter+1;
    
    %Choose from storage the one with the smaller heuristic value 
    [~,SystemState]=Fringe.extractMin;
    
    upHer = MyheuristicEvaluationFinal(SystemState,goalCells,Inv_Closed_Obstacles,rows,cols,radiusToSearch);
    
    firstCond = ClosedSet(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2));
    secondCond = round(SystemState.CostEvaluation-SystemState.augmentedMovementsCost)< round(upHer);
    
    while  firstCond || secondCond
        
        if firstCond
            if Fringe.n==0
                TrackPath=[];
                TrackHeading=[];
                d=inf;
                msg=1;
                J=inf;
                return;
             end

             [~,SystemState]=Fringe.extractMin;
             upHer = MyheuristicEvaluationFinal(SystemState,goalCells,Inv_Closed_Obstacles,rows,cols,radiusToSearch);
             secondCond = round(SystemState.CostEvaluation-SystemState.augmentedMovementsCost)< round(upHer);
        end 

        
        if secondCond
            SystemState.CostEvaluation = SystemState.augmentedMovementsCost+upHer;
            Fringe.insert(SystemState.CostEvaluation,SystemState);
            [~,SystemState]=Fringe.extractMin;
            upHer = MyheuristicEvaluationFinal(SystemState,goalCells,Inv_Closed_Obstacles,rows,cols,radiusToSearch);
            secondCond = round(SystemState.CostEvaluation-SystemState.augmentedMovementsCost)< round(upHer);
        end
        
        firstCond = ClosedSet(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2));
        
    end
    
    ClosedSet(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2))=1;
    Inv_Closed_Obstacles(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2))=0;
    DisTable(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2))=SystemState.CostEvaluation;
    indexOpenObstacle(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2))=0;
    
    %AllNodes=RemoveFromHashTable(AllNodes,SystemState,rows,cols,nr,goalType);
    %PlotProgress(SystemState.grid,SystemState.RobotsCurrentPos)
    %Check if the current state is a goal state
    if GoalTest(SystemState.RobotsCurrentPos,goalCells) 
        TrackPath=SystemState.TrackPath;
        TrackHeading=SystemState.TrackHeading;
        d = SystemState.augmentedMovementsCost;%size(SystemState.TrackPath,1);
        msg=0;
        if displayGraphWithNodes
            %plotForExplanation(gridT,goalCells,robotInitPos,0,0,0,0,1,TrackPath,sizeCell,rows,cols,0)
            plotCurrentEvaluationAstar(gridT,goalCells,robotInitPos,0,0,0,1,TrackPath,sizeCell,rows,cols)
        end
        return;
    end
    
   gridAugmented(SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2))=gridAugmented(SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2))+1;
   [Neighborhood,Inv_Closed_Obstacles,DiscoveredObstacles] = extractNeighbors4(SystemState,gridT,rows,cols,forward,Inv_Closed_Obstacles);
   
   if displayGraphWithNodes
        %plotForExplanation(DiscoveredObstacles,goalCells,robotInitPos,0,0,SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2),0,0,sizeCell,rows,cols,0)
        plotCurrentEvaluationAstar(DiscoveredObstacles,goalCells,robotInitPos,0,SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2),0,0,sizeCell,rows,cols)
        pause(pauseTime);
        %plotForExplanation(DiscoveredObstacles,goalCells,robotInitPos,0,0,SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2),0,0,sizeCell,rows,cols,1)
        plotCurrentEvaluationAstar2(DiscoveredObstacles,goalCells,robotInitPos,0,SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2),0,0,sizeCell,rows,cols)
    end
    

    if ~isempty(Neighborhood)
        
     
        F_NoComb=size(Neighborhood,1);
        %constraints
        
        for i=1:F_NoComb
            %init successor
            successor =  SystemState;
            
           %Successor's cell
            successor.RobotsCurrentPos(1,:) = Neighborhood(i,:);
            
            if ClosedSet(successor.RobotsCurrentPos(1),successor.RobotsCurrentPos(2))~=1
            
                
            %Calculate Successor's characteristics
            addAllCostTurns=CostMap(SystemState.RobotsCurrentPos(1,3),successor.RobotsCurrentPos(1,3));
            successor.TrackPath = [successor.TrackPath; sub2ind([rows cols], successor.RobotsCurrentPos(:,1), successor.RobotsCurrentPos(:,2))'];
            successor.TrackHeading =[successor.TrackHeading; successor.RobotsCurrentPos(:,3)'];
            successor.augmentedMovementsCost = successor.augmentedMovementsCost+addAllCostTurns;
            %successor.CostEvaluation = successor.augmentedMovementsCost+MyheuristicEvaluation(successor,goalCells,ClosedSet,DisTable,knownObstacles);
            successor.CostEvaluation = successor.augmentedMovementsCost+MyheuristicEvaluationFinal(successor,goalCells,Inv_Closed_Obstacles,rows,cols,radiusToSearch);


            
            %Chech if the new system's state are already in the
            %Hashable
            lkey= CalculateKeyForHashTable(successor,nr);
                
                if AllNodes.ContainsKey(lkey) %If it's true
                    PrevNode = AllNodes.Get(lkey);
                    %Keep the one with the smaller value(distance)
                    if  PrevNode.g >= successor.augmentedMovementsCost
                        AllNodes.Remove(lkey);
                        AllNodes=AddToHashTable(AllNodes,successor,nr);
                        Fringe.insert(successor.CostEvaluation,successor);
                    end
                else
                    %Make new entries in Data structures
                    Fringe.insert(successor.CostEvaluation,successor);
                    AllNodes=AddToHashTable(AllNodes,successor,nr);
                    
                    indexOpenObstacle(successor.RobotsCurrentPos(1),successor.RobotsCurrentPos(2))=1;
                    
                    %plotForExplanation(0,goalCells,robotInitPos,[successor.augmentedMovementsCost floor(successor.CostEvaluation - successor.augmentedMovementsCost)],0,successor.RobotsCurrentPos(1),successor.RobotsCurrentPos(2),-1,0,sizeCell,rows,cols,0)
                end


            end
        
        end
        
    end
 handles = guidata(hObject);  %Get the newest GUI data
end
TrackPath=[];
TrackHeading=[];
d=inf;
msg=2;
J=inf;
