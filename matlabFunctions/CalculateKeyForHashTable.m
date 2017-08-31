function key = CalculateKeyForHashTable(SystemState,nr)

key= num2str(reshape(SystemState.RobotsCurrentPos(1,1:2),1,2*nr));