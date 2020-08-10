mode(-1);
// specific part
libname='stixboxlib'
mess=['STIXBOX loaded';
      'enter ""stixdemo()"" or ""stixtest()"" for a demo'];

//disp('STIXBOX')
//disp('       Anders Holtsberg, 25-11-94')
//disp('       Copyright (c) Anders Holtsberg')
//disp('       and J. Coursol, Universite de Paris Sud')
//disp('       Scilab version Scilab Group')

// generic part  
// get the absolute path 

DIR=get_absolute_file_path('loader.sce');

if ~MSDOS then
  MACROS=DIR+'/macros/'
else 
  MACROS=DIR+'\macros\'
end
   
// load the library
execstr(libname+'=lib(""'+MACROS+'"")')
// add the help chapter
//write(%io(2),mess)
global LANGUAGE %helps
select LANGUAGE
case "eng"
  %helps = [%helps; DIR+'man/'+LANGUAGE+'/stixbox', "Statistical toolbox STIXBOX"]
case "fr"
  %helps = [%helps; DIR+'man/'+LANGUAGE+'/stixbox', "Boîte à outils statistiques STIXBOX";]
end

clear fd err nams DIR libname libtitle mess MACROS get_absolute_file_path
