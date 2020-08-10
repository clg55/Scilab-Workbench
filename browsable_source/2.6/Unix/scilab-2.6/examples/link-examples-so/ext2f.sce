// Demo file for ext2f example 

// builder code for ext2f.c 
link_name = 'ext2f';    // functions to be added to the call table 
flag  = "f";		// ext2f is a C function 
files = ['ext2f.o' ];   // objects files for ext2f 
libs  = [];		// other libs needed for linking 

// the next call generates files (Makelib,loader.sce) used
// for compiling and loading ext2f and performs the compilation

ilib_for_link(link_name,files,libs,flag);

// load new function code in the scope of call 
// using the previously generated loader 
exec loader.sce 

// test new function through the call function 

a=[1,2,3];b=[4,5,6];n=3;
c=call('ext2f',n,1,'i',a,2,'d',b,3,'d','out',[1,3],4,'d');
if norm(c-(sin(a)+cos(b))) > %eps then pause,end
