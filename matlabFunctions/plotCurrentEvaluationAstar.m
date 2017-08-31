function plotCurrentEvaluationAstar(DiscOB,goal,start,firstTime,x,y,lastTime,TrackPath,sizeCell,rows,cols)

if firstTime
    hold on
    for i=1:rows
        for j=1:cols
            if DiscOB(i,j)==-1
                rectangle('Position',[i,j,sizeCell,sizeCell],'FaceColor',[119 114 119] ./ 255,'EdgeColor','black')
            else
                rectangle('Position',[i,j,sizeCell,sizeCell],'FaceColor',[0 1 1],'EdgeColor','black')
            end
        end
    end
elseif lastTime==0
    for i=1:size(DiscOB,1)
        rectangle('Position',[DiscOB(i,1),DiscOB(i,2),sizeCell,sizeCell],'FaceColor',[0 0 0],'EdgeColor','black')
    end
    rectangle('Position',[x,y,sizeCell,sizeCell],'FaceColor',[1 0 1],'EdgeColor','black')
else
    for i=2:size(TrackPath,1)-1
        [curreRi, curreRj] = ind2sub([rows,cols],TrackPath(i,:));
        rectangle('Position',[curreRi,curreRj,sizeCell,sizeCell],'FaceColor',[1 0 0],'EdgeColor','black')
    end
end

rectangle('Position',[start(1),start(2),sizeCell,sizeCell],'FaceColor',[1 1 0],'EdgeColor','black')
rectangle('Position',[goal(1),goal(2),sizeCell,sizeCell],'FaceColor',[0 1 0],'EdgeColor','black')
