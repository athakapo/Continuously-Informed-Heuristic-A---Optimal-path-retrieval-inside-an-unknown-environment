function g=GoalTest(RobotsPos,goalCells)

nr=size(RobotsPos,1);
g=1;
for r=1:nr
    if RobotsPos(r,1)~=goalCells(r,1) || RobotsPos(r,2)~=goalCells(r,2)
       g=0;
       return;
    end
end


   