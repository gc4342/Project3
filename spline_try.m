clear all;
close all;
clc;
load mapvariable.mat;
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

 x1 = path_points(1:m,1);
 y1 = path_points(1:m,2);
 figure(2)
 plot(x1,y1,'-bs')
 hold on; 
 plot(s1,s2,'*g');
 hold on;
 
 
 x11= [9.75 10];
 y11 = [10.21 9.603];
 pp11 = spline(x11,y11);
 xx11 = linspace(9.75,10,10);
 yy11 = ppval(pp11, linspace(9.75,10,10));
 
 
 figure(3)
 plot(x1,y1,'-bs');
 hold on;
 plot(xx11,yy11,'-bs')
 hold on;
 
 
 x12= [9 10 11 12 13 14];
 y12 = [11 10 8 7 6 5 ];
 pp12 = spline(x12,y12);
 xx12 = linspace(9,14,50);
 yy12 = ppval(pp12, linspace(9,14,50));
 figure(4)
 plot(x1,y1,'-bs');
 hold on;
 plot(xx12,yy12,'*g')
 hold on;
 
 
 figure(1)
 plot(xx12,yy12,'b--o')
 hold on;
% axis equal 
 
 
 
 
 
% PP = SPLINE(X,Y) provides the piecewise polynomial form of the 
% %   cubic spline interpolant to the data values Y at the data sites X,
% %   for use with the evaluator PPVAL and the spline utility UNMKPP.
% %   X must be a vector.

