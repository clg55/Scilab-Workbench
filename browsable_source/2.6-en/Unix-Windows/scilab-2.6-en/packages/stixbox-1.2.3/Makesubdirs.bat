@echo off
REM Makesubdirs.bat all
if "%1" == "clean" goto clean 
if "%1" == "distclean" goto distclean 

echo Unknown target %1 
goto end

:distclean 
cd src 
 nmake /C /f Makefile.mak distclean 
cd ..
cd macros 
 nmake /C /f Makefile.mak distclean 
cd ..
goto end 

:clean 
cd src 
 nmake /C /f Makefile.mak clean 
cd ..
cd macros 
 nmake /C /f Makefile.mak clean 
cd ..
goto end 

:end 
