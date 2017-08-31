function algorithm_call(algorithm,weight,hObject,handles)

SIMULparam = handles.SIMULparam;

%ALgorithm to run
%1: Ordinary A* with consistent heuristic
%8: Weighted A*
%9: CIA*
alg=algorithm; 

  
switch algorithm
    case 1
        tic
        [msg,d,TrackPath,TrackHeading,J,GeneralIter]=AstarSolver(SIMULparam,hObject, handles);
        texe = toc;
        fprintf('Algortihm: A* Solution:%d Expanded Nodes:%d Time:%f\n',d,GeneralIter,texe);
    case 8
        w=weight;
        tic
        [msg,d,TrackPath,TrackHeading,J,GeneralIter]=WeightedAstarSolver(SIMULparam,w,hObject, handles);
        texe = toc;
        fprintf('Algortihm: Weighted A* Solution:%d Expanded Nodes:%d Time:%f\n',d,GeneralIter,texe);
    case 9
        radiusToSearch = SIMULparam.rows; % >0
        tic
        [msg,d,TrackPath,TrackHeading,J,GeneralIter]=MystarSolver_Final(SIMULparam,radiusToSearch,hObject, handles);
        texe = toc;
        fprintf('Algortihm: CIA* Solution:%d Expanded Nodes:%d Time:%f\n',d,GeneralIter,texe);
end

