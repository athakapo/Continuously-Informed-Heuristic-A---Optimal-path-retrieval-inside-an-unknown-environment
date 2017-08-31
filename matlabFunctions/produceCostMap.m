function CostMap=produceCostMap(cost,n_actions)
    CostMap = zeros(n_actions,n_actions);
    for i=1:n_actions
        CostMap(i,mod(i-1,n_actions)+1)=cost(2);     % No turn
        CostMap(i,mod(i+1, n_actions)+1)=cost(2);  % No turn
        CostMap(i,mod(i, n_actions)+1)=cost(3);  % Turn Left
        CostMap(i,mod(i+2, n_actions)+1)=cost(1);  % Turn Right
     end