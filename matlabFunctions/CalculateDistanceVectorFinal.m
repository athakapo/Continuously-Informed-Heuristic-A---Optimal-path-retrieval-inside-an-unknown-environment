function y=CalculateDistanceVectorFinal(knownObstacles,dif,q,w,e,mode,radi,rows,cols)

if mode <=4
    r=0;
    while r<=radi
        applyOrdHeuristic=1;
        if q-r>=1 && w+r<=rows && e-dif-r>=1 && e+r<=cols
        
            BW = knownObstacles(q-r:w+r,e-dif-r:e+r);
            [L, ~] = bwlabeln(BW, 4);
            if ~isempty(L)
                switch mode
                    case 1
                        applyOrdHeuristic = (L(1+r,1+r) == L(end-r,end-r));
                    case 2
                        applyOrdHeuristic = (L(1+r,end-r) == L(end-r,1+r));
                    case 3
                        applyOrdHeuristic = (L(end-r,1+r) == L(1+r,end-r));
                    case 4
                        applyOrdHeuristic = (L(end-r,end-r) == L(1+r,1+r));
                end
            else
                applyOrdHeuristic=1;
            end
        
        
        end
        
        if applyOrdHeuristic; break; end
        
        r=r+1;
    end
else
    r=0;
    while r<=radi
        applyOrdHeuristic=1;
        if e-r>=1 && e+dif+r<=rows && q-r>=1 && w+r<=cols
    
            BW = knownObstacles(e-r:e+dif+r,q-r:w+r);
            [L, ~] = bwlabeln(BW, 4);
            if ~isempty(L)
                switch mode
                    case 5
                        applyOrdHeuristic = (L(1+r,1+r) == L(end-r,end-r));
                    case 6
                        applyOrdHeuristic = (L(1+r,end-r) == L(end-r,1+r));
                    case 7
                        applyOrdHeuristic = (L(end-r,1+r) == L(1+r,end-r));
                    case 8
                        applyOrdHeuristic = (L(end-r,end-r) == L(1+r,1+r));
                end
            else
                applyOrdHeuristic=1;
            end
            
        end
        
        if applyOrdHeuristic; break; end
       
        r=r+1;
    end
end

if r==0 && applyOrdHeuristic
    y=0;
elseif r==0 && applyOrdHeuristic==0
    y=2; 
elseif r>=1
    y=2*r;
end

