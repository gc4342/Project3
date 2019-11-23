mymap=makemap(10);
goal=[8,9]
start=[5,5]
prm=PRM(mymap);
prm.plan(goal);
prm.plot();
prm.query(start,goal)
prm.plot();