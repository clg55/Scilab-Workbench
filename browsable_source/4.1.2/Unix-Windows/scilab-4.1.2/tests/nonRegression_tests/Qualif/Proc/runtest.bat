@echo off

rem if not "%os%"=="Windows_NT" goto NextStep
REM --- Section sp�cifique � Windows NT ---
rem color 0F
rem :NextStep

if "%1"=="" goto aide

REM --- enregistrerle r�pertoire de d�part
set rep_depart=%cd%

REM --- se positionner dans le r�pertoire de qualif contenant le fichier scilab.ini utile pour la qualif.
REM --- d�finition des variables etc.
cd %envq_qualif%
date /t & time /t
echo -
echo -
echo -

REM --- LIST : param�tre constitu� de la liste de tests-suites demand�es
set LIST=

:continue
if "%1"=="" goto lancer_une

for /D %%j in (%envq_qualif%\work\%1) do set LIST=!LIST! %%~nj
shift
goto continue

REM --- lancer chaque tests-suite une par une
:lancer_une
echo liste des tests-suites :%LIST%
echo ------------------------
echo -

for %%i in (%LIST%) do echo %%i en cours ... & scilex -nw -e chdir(envq_work+"%%i");errcatch(-1,"stop");exec("%%i.sce");quit;  > %envq_qualif%\log\%envq_ver%\%%i.log

REM --- Analyse des log resultats 
for %%i in (%LIST%) do %envq_qualif%\proc\checklog %%i

:fin

echo -
echo -
echo -
date /t&time /t
rem restituer le r�pertoire de d�part
cd %rep_depart%



goto the_end

:aide
echo //
echo // RUNTEST
echo // Execute une ou plusieurs batteries de tests dans l'environnement de qualification Scilab (les meta-caracteres sont acceptes) :
echo // 
echo // runtest tests_suite [tests_suite]
echo // runtest *
echo // runtest n* sc?cos autre 
echo //
echo //

:the_end