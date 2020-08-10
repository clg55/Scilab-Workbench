// this script must be run from the drirectory 
// where the scipt is writen 

f=mopen('Names.incl','w');
mfprintf(f,'SCIDIR='+SCI+'\n')
mfprintf(f,'CURRENT_DIR='+getcwd()+'\n');
mclose(f);

// G_make('all','all')

