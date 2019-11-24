clear all;
close all;
clc;

%mymap= openfig('mapLayout.fig','visible')
%how do we just load a map and have drawMaze draw it
%load mymap
mymap = makemap(10)
start=[5,5]
goal=[9,8]
ds=Dstar(mymap);
ds.plan(goal);
ds.plot();
ds.query(start, 'animate');
path_points = ds.query(start, 'animate')
[m,n]=size(path_points);
for i=1:1:m-1
    if i==1
        p1(1:10,1) = tpoly(path_points(1,1),path_points(1+1,1),10);
        p2(1:10,1) = tpoly(path_points(1,2),path_points(1+1,2),10);
    else
     p1(((i-1)*10)+1:((i-1)*10)+10,1) = tpoly(path_points(i,1),path_points(i+1,1),10);
     p2(((i-1)*10)+1:((i-1)*10)+10,1) = tpoly(path_points(i,2),path_points(i+1,2),10);
    end
end
hold on;
figure(1);
plot(path_points(:,1),path_points(:,2),'-bs');
hold on;
plot(p1,p2,'or');

