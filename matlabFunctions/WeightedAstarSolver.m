function [msg,d,TrackPath,TrackHeading,J,GeneralIter]=WeightedAstarSolver(parameters,w,hObject, handles)


v2struct(parameters)
RobotsCurrentPos = robotInitPos;

% Create initially empty heap
Fringe = cFibHeap;  %For O(logn) searches in the distances of states
% HashTable
AllNodes=HashTable(rows*cols); %For O(logn) searches in the states

ClosedSet=zeros(rows,cols);
DiscoveredObstacles =[]; 

%Keep the visited tiles to reproduce the solution
TrackPath=sub2ind([rows cols], RobotsCurrentPos(:,1), RobotsCurrentPos(:,2))';
TrackHeading = RobotsCurrentPos(:,3)';

%MaximumPossibleDist = (sum(sum(grid==0))*MaxCost);
%State Data Structure - Initial State
SystemState = struct('RobotsCurrentPos',RobotsCurrentPos,'TrackPath',TrackPath,...
    'TrackHeading',TrackHeading,'CostEvaluation',0,'augmentedMovementsCost',0);

g=size(TrackPath,1);
manhattanHeuristic=heuristicEvaluation(SystemState,goalCells);
%h=heuristicEvaluation(SystemState,goalCells);
SystemState.CostEvaluation = g+w*manhattanHeuristic;%tieBreaking(manhattanHeuristic,rows+cols);


%Update Priority Queue
Fringe.insert(SystemState.CostEvaluation,SystemState);

%Add the Initial State to the Fringe
AllNodes=AddToHashTable(AllNodes,SystemState,nr);
NoActions=size(action,2);
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
    
    while ClosedSet(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2))
        if Fringe.n==0
            TrackPath=[];
            TrackHeading=[];
            d=inf;
            msg=1;
            J=inf;
            return;
        end
        
        [~,SystemState]=Fringe.extractMin;
    end
    
    ClosedSet(SystemState.RobotsCurrentPos(1),SystemState.RobotsCurrentPos(2))=1;
    
    %Check if the current state is a goal state
    if GoalTest(SystemState.RobotsCurrentPos,goalCells) 
        TrackPath=SystemState.TrackPath;
        TrackHeading=SystemState.TrackHeading;
        %d = SystemState.CostEvaluation;%size(SystemState.TrackPath,1);
        d = SystemState.augmentedMovementsCost;
        msg=0;
        if displayGraphWithNodes
            %plotCurrentEvaluationAstar(gridT,goalCells,robotInitPos,0,0,0,1,TrackPath,sizeCell)
            plotCurrentEvaluationAstar(DiscoveredObstacles,goalCells,robotInitPos,0,0,0,1,TrackPath,sizeCell,rows,cols)
        end
        return;
    end
    
   gridAugmented(SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2))=gridAugmented(SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2))+1;
   if displayGraphWithNodes
        plotCurrentEvaluationAstar(DiscoveredObstacles,goalCells,robotInitPos,0,SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2),0,0,sizeCell,rows,cols)
        pause(pauseTime);
        plotCurrentEvaluationAstar2(DiscoveredObstacles,goalCells,robotInitPos,0,SystemState.RobotsCurrentPos(1,1),SystemState.RobotsCurrentPos(1,2),0,0,sizeCell,rows,cols)
   end
    
    %For each Robot find the next valid movement    
    [Neighborhood,~,DiscoveredObstacles] = extractNeighbors(SystemState,gridT,rows,cols,forward,[]);

   
    
    if ~isempty(Neighborhood)
        
     
   F_NoComb=size(Neighborhood,1);
        %constraints
        
        for i=1:F_NoComb
            %init successor
            successor =  SystemState;
            addAllCostTurns=0;
            successor.RobotsCurrentPos(1,:) = Neighborhood(i,:);
                
            if ClosedSet(successor.RobotsCurrentPos(1),successor.RobotsCurrentPos(2))~=1
            
            
                %Calculate Successor's characteristics
                addAllCostTurns=addAllCostTurns+CostMap(SystemState.RobotsCurrentPos(1,3),successor.RobotsCurrentPos(1,3));
                successor.TrackPath = [successor.TrackPath; sub2ind([rows cols], successor.RobotsCurrentPos(:,1), successor.RobotsCurrentPos(:,2))'];
                successor.TrackHeading =[successor.TrackHeading; successor.RobotsCurrentPos(:,3)'];
                successor.augmentedMovementsCost = successor.augmentedMovementsCost+addAllCostTurns;
                manhattanHeuristic=heuristicEvaluation(successor,goalCells);
                successor.CostEvaluation = successor.augmentedMovementsCost+w*manhattanHeuristic;%+tieBreaking(manhattanHeuristic,rows+cols);
                %successor.CostEvaluation = successor.augmentedMovementsCost+heuristicEvaluation(successor,goalCells);


                %Chech if the new system's state are already in the
                %Hashable
                lkey= CalculateKeyForHashTable(successor,nr);

                if AllNodes.ContainsKey(lkey) %If it's true
                    PrevNode = AllNodes.Get(lkey);
                    %Keep the one with the smaller value(distance)
                    if  PrevNode.g > successor.augmentedMovementsCost
                        AllNodes.Remove(lkey);
                        AllNodes=AddToHashTable(AllNodes,successor,nr);
                        Fringe.insert(successor.CostEvaluation,successor);
                    end
                else
                    %Make new entries in Data structures
                    Fringe.insert(successor.CostEvaluation,successor);
                    AllNodes=AddToHashTable(AllNodes,successor,nr);
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
