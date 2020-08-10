mode(-1);

// [1] macros directory 

libname='scigraphlib'
DIR=get_file_path('builder.sce');
//compile sci files if necessary and build lib file
if MSDOS then
genlib(libname,DIR+'\macros\')
else
genlib(libname,DIR+'/macros/')
end

// prepare macro directory in case one wants to run make 
dir=getcwd();
chdir('macros') 
exec builder.sce 
chdir(dir);

// [2] src directory 

if c_link('libscigraph') 
  write(%io(2),'please do not rebuild a shared library while it is linked')
  write(%io(2),'in scilab. use ulink to unlink first');
else 
  dir=getcwd();
  chdir('src') 
  exec builder.sce 
  chdir(dir);
end 

// [3] man directory 
//dir=getcwd();
//chdir("man/"+LANGUAGE) 
//formatman("scigraph","ascii");
//chdir(dir);

// [3] generate Path.incl 

     F=mopen('Path.incl','w');
     mfprintf(F,'SCIDIR='+SCI+'\n');
     mfprintf(F,'SCIDIR1='+strsubst(SCI,'/','\\')+'\n');
     mclose(F);

clear DIR libname genlib get_file_path F dir test ilib





