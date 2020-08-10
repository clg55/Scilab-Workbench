// Example ex12
//[1] call intersci with Makefile 
//
V=G_make('ex12fi.c','ex12fi.c');
//[2] run the builder generated by intersci.
//    Since files and libs were nor transmited 
//    to intersci we give them here 
files = ['ex12fi.o';'ex12c.o'];
libs  = [] ;
exec ex12fi_builder.sce 

//[3] run the loader to load the interface 
//    Note that the file loader.sce 
//    is changed each time you run a demo 
//    if several .desc are present in a directory
exec loader.sce 

//[4] test the loaded function 
b=ccalc12();
if norm(b-(0:9)) > %eps then pause,end




