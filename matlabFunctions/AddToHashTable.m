function Fringe = AddToHashTable(Fringe,SystemState,nr)


key= CalculateKeyForHashTable(SystemState,nr);

value = struct('g',SystemState.augmentedMovementsCost,'TrackPath',SystemState.TrackPath,'TrackHeading',SystemState.TrackHeading);
if isempty(value.TrackPath)
    value.TrackPath = zeros(1,nr);
end
Fringe.Add(key,value);