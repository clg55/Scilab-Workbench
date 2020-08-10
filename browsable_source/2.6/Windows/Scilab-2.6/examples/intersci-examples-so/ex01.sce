// Example ex01 

//[1] call intersci through a Makefile 
V=G_make('ex01fi.c','ex01fi.c');
//[2] run the builder generated by intersci.
//    Since files and libs were nor transmited 
//    to intersci we give them here 
files = ['ex01fi.o' , 'ex01c.o'];
libs  = [] ;
exec('ex01fi_builder.sce');

//[3] run the loader to load the interface 
//    Note that the file loader.sce 
//    is changed each time you run a demo 
//    if several .desc are present in a directory
exec loader.sce 

//[4] test the loaded function 
	
a=[1,2,3];b=[4,5,6];
c=ext1c(a,b);
if norm(c-(a+b)) > %eps then pause,end



