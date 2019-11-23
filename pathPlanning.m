mymap=makemap(10)
%load map1
%testing
goal=[8,9]
start=[5,5]
ds=Dstar(mymap);
ds.plan(goal);
ds.plot();
ds.query(start, 'animate');

