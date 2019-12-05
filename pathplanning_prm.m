%%mymap=makemap(10);
mymap = load ('mymap')
start = [3, 10];
goal = [12,3];
mymap = mymap.mymap;
prm=PRM(mymap);
prm.plan(goal);
prm.plot();
b = prm.query(start,goal)
prm.plot(b);
% % b = prm.query(goal,'animate')
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
figure(1);
plot(b(:,1),b(:,2),'-bs');
hold on;
plot(s1,s2,'pm');

hold on;
plot(mtraj_path_points_lspb(:,1),mtraj_path_points_lspb(:,2),'*w');
