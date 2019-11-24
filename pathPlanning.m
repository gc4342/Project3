<<<<<<< Updated upstream
mymap=makemap(10)
%load map1
%testing
goal=[8,9]
start=[5,5]
=======
%mymap= openfig('mapLayout.fig','visible')
%how do we just load a map and have drawMaze draw it
%load mymap


clear all;
close all;
clc;
mymap = makemap(10)
start=[15,10]
goal=[30,10]
>>>>>>> Stashed changes
ds=Dstar(mymap);
ds.plan(goal);
ds.plot();
ds.query(start, 'animate');
b = ds.query(start, 'animate')
[m,n]=size(b);
for i=1:1:m-1
    if i==1
        s1(1:10,1) = tpoly(b(1,1),b(1+1,1),10);
        s2(1:10,1) = tpoly(b(1,2),b(1+1,2),10);
    else
    s1(((i-1)*10)+1:((i-1)*10)+10,1) = tpoly(b(i,1),b(i+1,1),10);
     s2(((i-1)*10)+1:((i-1)*10)+10,1) = tpoly(b(i,2),b(i+1,2),10);
    end
end
hold on;
figure(1);
plot(b(:,1),b(:,2),'-bs');
hold on;
plot(s1,s2,'or');

