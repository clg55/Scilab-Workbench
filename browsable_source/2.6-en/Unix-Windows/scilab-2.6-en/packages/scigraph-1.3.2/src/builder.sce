// This is the builder.sce 
// must be run from this directory 

ilib_name  = 'libscigraph' 		// interface library name 

// objects files 

files=['intMeta.o';'actions.o';'attributes.o';'bezier.o';'choose.o';'color.o';
	'dialog.o';'draw.o';'file.o';'find.o';'font.o';'graph.o';
	'graphics.o';'help.o';'init.o';
	'list.o';'load.o';'menu.o';'message.o';'metanet.o';'modify.o';
	'myhsearch.o';'name.o';'save.o';'show.o';'study.o';'graphlist.o'];

libs  = [] 				// other libs needed for linking

// table of (scilab_name,interface-name) 
// for fortran coded interface use 'C2F(name)'

table =['scigraph'  	'intscigraph';
	'm6show_scig' 	'intsshowscig';
	'show_scig_nodes' 'intsshowscigns';
	'show_nodes' 'intsshowscigns';
	'show_scig_arcs' 'intsshowscignp';
	'show_arcs' 'intsshowscignp';
	'show_scig_names','intsshowscignames';
	'show_names','intsshowscignames';
	'scigraph_set_node_menu','int_scignodenames';
	'set_node_menu','int_scignodenames';
	'scigraph_set_arc_menu','int_scigarcnames';
	'set_arc_menu','int_scigarcnames'];

// do not modify below 
// ----------------------------------------------
ilib_build(ilib_name,table,files,libs)









