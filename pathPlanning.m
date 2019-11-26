clear all;
close all;
clc;

goal = [13,3]
start = [9,11]

ds=Dstar(mymap);
ds.plan(goal);
ds.plot();
ds.query(start, 'animate');
path_points = ds.query(start, 'animate')
[m,n]=size(path_points);

for i=1:1:m-1
    if i==1

        s1(1:10,1) = tpoly(path_points(1,1),path_points(1+1,1),10);
        s2(1:10,1) = tpoly(path_points(1,2),path_points(1+1,2),10);
       
    else
     s1(((i-1)*10)+1:((i-1)*10)+10,1) = tpoly(path_points(i,1),path_points(i+1,1),10);
     s2(((i-1)*10)+1:((i-1)*10)+10,1) = tpoly(path_points(i,2),path_points(i+1,2),10);
    end
end

for i=1:1:m-1  %1 to 6
    if i==1
        mtraj_path_points_tpoly(i:10,1:2) = mtraj(@tpoly,[path_points(i,1) path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);
    else
        mtraj_path_points_tpoly((i*10)-9:10*i,1:2) = mtraj(@tpoly,[path_points(i,1) path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);
    end 
end



for i=1:1:m-1  %1 to 6
    if i==1
        mtraj_path_points_lspb(i:10,1:2) = mtraj(@lspb,[path_points(i,1) path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);
    else
        mtraj_path_points_lspb((i*10)-9:10*i,1:2) = mtraj(@lspb,[path_points(i,1) path_points(i,2)], [path_points(i+1,1) path_points(i+1,2)],10);
    end 
end


hold on;
figure(1);
plot(path_points(:,1),path_points(:,2),'-bs');
hold on;
plot(s1,s2,'pm');

hold on;
plot(mtraj_path_points_lspb(:,1),mtraj_path_points_lspb(:,2),'*w');


