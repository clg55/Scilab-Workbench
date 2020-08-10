mode(-1);

//[1] loader for macros 

libname='scigraphlib'
mess=['Scilab graph toolbox loaded, demo menu updated.'] 
// generic 
DIR=get_absolute_file_path('loader.sce');
execstr(libname+'=lib(""'+DIR+'/macros/'+'"")')

//[2] loader for src 
exec(DIR+'/src/loader.sce');

// [3] loader for the help chapter
// write(%io(2),mess)
global %helps LANGUAGE
select LANGUAGE
case "eng"
  %helps = [%helps; DIR+'man/'+LANGUAGE+'/scigraph', "Graphs visualization"]
case "fr"
  %helps = [%helps; DIR+'man/'+LANGUAGE+'/scigraph', "Visualisation des graphes"]
end

// [4] loader for the demo menus 
global demolist
demolist=[demolist; 'Scigraph Demos', DIR+'/demos/scigraph.dem']

clear DIR libname libtitle mess get_file_path get_absolute_file_path
