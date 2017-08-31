function add_n=tieBreaking(x,maxDis)

uppAdd = 0.8;
lowAdd = 0.1;

add_n = x*(uppAdd-lowAdd)/(maxDis) +lowAdd;
%add_n=0;