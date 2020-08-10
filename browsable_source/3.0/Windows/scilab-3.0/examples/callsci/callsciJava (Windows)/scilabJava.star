// Main Scilab initialisation file
// Copyright INRIA
// Modification Scilab.star pour Java
// CORNET Allan Novembre 2003

mode(-1);  // silent execution mode


// clean database when restarted
predef('clear'); //unprotect all variables 
clear  // erase all variables 
clear  scicos_pal // explicitly clear %helps scicos_pal variables
clearglobal();

// Special variables definition
ieee(2);%inf=1/0;ieee(0);%nan=%inf-%inf;

%s=poly(0,'s');%z=poly(0,'z');
$=poly(0,'$')

%T=%t;%F=%f;       // boolean variables
SCI=getenv('SCI')  // path of scilab main directory
if getenv('WIN32','NO')=='OK' then
  WSCI=getenv('WSCI')  // path of scilab main directory for Windows
end


load('SCI/macros/mtlb/lib')
load('SCI/macros/sci2for/lib')
load('SCI/macros/tdcs/lib')
load('SCI/macros/tksci/lib')
load('SCI/macros/arma/lib')
load('SCI/macros/metanet/lib')
load('SCI/macros/sound/lib')
load('SCI/macros/robust/lib')
load('SCI/macros/auto/lib')
load('SCI/macros/optim/lib')
load('SCI/macros/signal/lib')
load('SCI/macros/algebre/lib')
load('SCI/macros/statistics/lib')
load('SCI/macros/util/lib')
load('SCI/macros/elem/lib')
load('SCI/macros/int/lib')
load('SCI/macros/calpol/lib')
load('SCI/macros/percent/lib')
load('SCI/macros/xdess/lib')

// Create a temporary directory
TMPDIR=getenv('TMPDIR')

PWD = getcwd()
home= getenv('HOME','ndef');
if home=='ndef',home=unix_g('cd; pwd');end 

// in inisci.f COMPILER=getenv('COMPILER','NO');
// 
// use MSDOS syntax?
MSDOS = getenv('WIN32','NO')=='OK' & ..
	or(COMPILER==['VC++' 'ABSOFT' 'gcc'])


// LANGUAGE TO USE FOR ONLINE MAN
global LANGUAGE
LANGUAGE="eng" // default language

//Scilab Help Chapters, %helps is a two column matrix of strings
global %helps
%helps=initial_help_chapters(LANGUAGE)
clear initial_help_chapters
