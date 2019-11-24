%mymap= openfig('mapLayout.fig','visible')
%how do we just load a map and have drawMaze draw it
%load mymap
mymap = makemap(10)
start=[15,10]
goal=[30,10]
ds=Dstar(mymap);
ds.plan(goal);
ds.plot();
ds.query(start, 'animate');

