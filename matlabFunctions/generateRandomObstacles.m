function [obstacles,ob]=generateRandomObstacles(ob,rows,cols)


singleINDX = randperm(rows*cols, ob);

[I,J] = ind2sub([rows,cols],singleINDX);

obstacles=[I',J'];

ob = size(obstacles,1);