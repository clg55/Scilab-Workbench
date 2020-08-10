function scigraph_dem1()
// Copyright Enpc 
ta=[1,2,3,4,5,6];
he=[2,3,4,5,6,1];
g=make_graph('foo',1,6,ta,he);
g('node_x')=[239 156 55 57 149 231];
g('node_y')=[223 159 205 318 346 322];
g('edge_color')=1:6;
g('node_color')=1:6;
show_scigraph(g,'new',[400,400],[400,400]);
for j=1:10;
	for i=1:6, xpause(100000);show_scig_arcs(i);end ;
        for i=1:6, xpause(100000);show_scig_nodes(7-i);end 
end 


