// Example ex10
//[1] call intersci with Makefile 
//
V=G_make('ex10fi.c','ex10fi.c');
//[2] run the builder generated by intersci.
//    Since files and libs were nor transmited 
//    to intersci we give them here 
files = ['ex10fi.o';'ex10f.o'];
libs  = [] ;
exec ex10fi_builder.sce 

//[3] run the loader to load the interface 
//    Note that the file loader.sce 
//    is changed each time you run a demo 
//    if several .desc are present in a directory
exec loader.sce; 

//[4] test the loaded function 
// calc1: 3 matrix input variables and at most 3 output variables of
// types double, real, int
l=calc10(list(1,[2,3],[1,2;3,4]));
if norm(l(1)-2) > %eps then pause,end
if norm(l(2)-([2,3]+[1,2])) > %eps then pause,end
if norm(l(3)-([1,2;3,4]+[1,3;2,4])) > %eps then pause,end





