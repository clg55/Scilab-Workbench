@echo off
REM Makesubdirs.bat all
if "%1" == "all" goto all
if "%1" == "clean" goto all
if "%1" == "distclean" goto all

echo Unknown target %1 
goto end

:all
cd scigraph-1.3.2
echo Making %1 in directory  scigraph-1.3.2
 nmake /C /f Makefile.mak %1
cd ..
cd stixbox-1.2.3
echo Making %1 in directory stixbox-1.2.3
 nmake /C /f Makefile.mak %1
cd ..
echo on
goto end

:end 


