// Demo file for ext10c example 

// builder code for ext10c.c 
link_name = 'ext10c';    // functions to be added to the call table 
flag  = "c";		 // ext10c is a C function 
files = ['ext10c.o' ];   // objects files for ext10c 
libs  = [];		 // other libs needed for linking 

// the next call generates files (Makelib,loader.sce) used
// for compiling and loading ext10c and performs the compilation

ilib_for_link(link_name,files,libs,flag);

// load new function code in the scope of call 
// using the previously generated loader 
exec loader.sce 

// test new function through the ode function 
//passing a parameter to ext10c routine by a list:

param=[0.04,10000,3d+7];    
y=ode([1;0;0],0,[0.4,4],list('ext10c',param));

