// Example ex14
//[1] call intersci with Makefile 
//
V=G_make('ex14fi.c','ex14fi.c');
//[2] run the builder generated by intersci.
//    Since files and libs were nor transmited 
//    to intersci we give them here 
files = ['ex14fi.o';'ex14c.o'];
libs  = [] ;
exec ex14fi_builder.sce 

//[3] run the loader to load the interface 
//    Note that the file loader.sce 
//    is changed each time you run a demo 
//    if several .desc are present in a directory
exec loader.sce; 

//[4] test the loaded function 

a=[0,0,1.23;0,2.32,0;3.45,0,0];
ai=[0,0,9;0,6,0;7,0,0];
spa=sparse(a);
spai=sparse(a+%i*ai);
// simple sparse argument 

b=spt1(spa);
if norm(full(b- spa)) > %eps then pause,end

b=spt1(spai);
if norm(full(b- spai)) > %eps then pause,end

// sparse and return a sparse in a list 

b=spt3(spa);
if norm(full(b(1)- spa)) > %eps then pause,end

b=spt3(spai);
if norm(full(b(1)- spai)) > %eps then pause,end

// new sparse in intersci 

b=spt4(spa);
if norm(full(b- 2*spa)) > %eps then pause,end

b=spt4(spai);
if norm(full(b- 2*spai)) > %eps then pause,end


// new sparse returned in a list 

b=spt6(spa);
if norm(full(b(1)- 2*spa)) > %eps then pause,end

b=spt6(spai);
if norm(full(b(1)- 2*spai)) > %eps then pause,end

// list argument with a sparse 

b=spt7(list(spa));
if norm(full(b- spa)) > %eps then pause,end

b=spt7(list(spai));
if norm(full(b- spai)) > %eps then pause,end

// list argument + list output 

b=spt9(list(spa));
if norm(full(b(1)- spa)) > %eps then pause,end

b=spt9(list(spai));
if norm(full(b(1)- spai)) > %eps then pause,end

b=spt10(spa);
if norm(full(b- 2*spa)) > %eps then pause,end

