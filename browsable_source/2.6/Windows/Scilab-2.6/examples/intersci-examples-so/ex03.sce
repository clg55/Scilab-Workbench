// Example ex03
//[1] call intersci with Makefile 
//
V=G_make('ex03fi.c','ex03fi.c');
//[2] run the builder generated by intersci.
//    Since files and libs were nor transmited 
//    to intersci we give them here 
files = ['ex03fi.o' ];
libs  = [] ;
exec ex03fi_builder.sce 

//[3] run the loader to load the interface 
//    Note that the file loader.sce 
//    is changed each time you run a demo 
//    if several .desc are present in a directory
exec loader.sce 

//[4] test the loaded function 
n=3;a=13;incx=2;incy=3;x=1:10;y=2*x;
ynew=scilabdaxpy(n,a,x,incx,y,incy);
y(1:incy:n*incy)=y(1:incy:n*incy)+a*x(1:incx:n*incx);
if norm(ynew-y) > %eps then pause,end



