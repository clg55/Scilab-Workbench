mode(-1);

// [1] macros directory 
libname='stixboxlib'
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


// [3] generate Path.incl 

     F=mopen('Path.incl','w');
     mfprintf(F,'SCIDIR='+SCI+'\n');
     mfprintf(F,'SCIDIR1='+strsubst(SCI,'/','\\')+'\n');
     mclose(F);

// [4] man directory 

dir=getcwd();
chdir('man') 
formatman("stixbox","ascii");
chdir(dir);

clear fd err nams DIR libname MACROS genlib

