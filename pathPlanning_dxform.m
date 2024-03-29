 %mymap=makemap(10);
% goal = [13,3]
% start = [9,11]


start = [3, 10];
goal = [12,3];
load mapvariable.mat;

dxform=DXform(mymap);
dxform.plan(goal);
dxform.plot();
b = dxform.query(start,goal)
dxform.plot(b);
%b = dxform.query(start, 'animate')
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



for i=1:1:m-1  %1 to 6
    if i==1
        mtraj_path_points_tpoly(i:10,1:2) = mtraj(@tpoly,[b(i,1) b(i,2)], [b(i+1,1) b(i+1,2)],10);
    else
        mtraj_path_points_tpoly((i*10)-9:10*i,1:2) = mtraj(@tpoly,[b(i,1) b(i,2)], [b(i+1,1) b(i+1,2)],10);
    end 
end



for i=1:1:m-1  %1 to 6
    if i==1
        mtraj_path_points_lspb(i:10,1:2) = mtraj(@lspb,[b(i,1) b(i,2)], [b(i+1,1) b(i+1,2)],10);
    else
        mtraj_path_points_lspb((i*10)-9:10*i,1:2) = mtraj(@lspb,[b(i,1) b(i,2)], [b(i+1,1) b(i+1,2)],10);
    end 
end
hold on;
current_position =  b(3,1:2)
%push button press
figure(2);
obstacle_at =b(5,1:2) 
mymap(obstacle_at(2),obstacle_at(1)) = 1;
hold on;
goal=[13,3]
dxform=DXform(mymap);
dxform.plan(goal);
dxform.plot();
hold on;
dxform.query(current_position,goal)
dxform.plot();
b2 = dxform.query(current_position, 'animate')
hold on;



% hold on;
% figure(1);
% plot(b(:,1),b(:,3),'-bs');
% hold on;
% plot(s1,s2,'pm');
% 
% hold on;
% plot(mtraj_path_points_lspb(:,1),mtraj_path_points_lspb(:,2),'*w');
