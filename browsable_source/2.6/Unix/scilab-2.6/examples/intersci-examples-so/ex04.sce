// Example ex04
//[1] call intersci with Makefile 
//
V=G_make('ex04fi.c','ex04fi.c');
//[2] run the builder generated by intersci.
//    Since files and libs were nor transmited 
//    to intersci we give them here 
files = ['ex04fi.o';'ex04f.o'];
libs  = [] ;
exec ex04fi_builder.sce 

//[3] run the loader to load the interface 
//    Note that the file loader.sce 
//    is changed each time you run a demo 
//    if several .desc are present in a directory
exec loader.sce 



//[4] test the loaded function 

sys=ssrand(2,2,3,list('co',1));
n=contrb(sys,0.01);
if n <> 1 then pause,end




