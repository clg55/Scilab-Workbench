@echo off
REM Makesubdirs.bat all
cd algebre
echo Macros compilation algebre
nmake /C /f Makefile.mak %1 
cd ..
cd arma
echo Macros compilation arma
nmake /C /f Makefile.mak %1 
cd ..
cd auto	
echo Macros compilation auto	
nmake /C /f Makefile.mak %1 
cd ..
cd calpol
echo Macros compilation calpol
nmake /C /f Makefile.mak %1 
cd ..
cd comm
echo Macros compilation comm
nmake /C /f Makefile.mak %1
cd ..
cd elem
echo Macros compilation elem
nmake /C /f Makefile.mak %1
cd ..
cd fraclab
echo Macros compilation fraclab
nmake /C /f Makefile.mak %1
cd ..
cd metanet
echo Macros compilation metanet
nmake /C /f Makefile.mak %1
cd ..
cd optim
echo Macros compilation optim
nmake /C /f Makefile.mak %1
cd ..
cd percent
echo Macros compilation percent
nmake /C /f Makefile.mak %1
cd ..
cd robust
echo Macros compilation robust
nmake /C /f Makefile.mak %1
cd ..
cd sci2for
echo Macros compilation sci2for
nmake /C /f Makefile.mak %1
cd ..
cd scicos
echo Macros compilation scicos
nmake /C /f Makefile.mak %1
cd ..
cd scicos_blocks
echo Macros compilation scicos_blocks
nmake /C /f Makefile.mak %1
cd ..
cd signal
echo Macros compilation signal
nmake /C /f Makefile.mak %1
cd ..
cd sound
echo Macros compilation sound
nmake /C /f Makefile.mak %1
cd ..
cd tdcs
echo Macros compilation tdcs
nmake /C /f Makefile.mak %1
cd ..
cd util
echo Macros compilation util
nmake /C /f Makefile.mak %1
cd ..
cd xdess
echo Macros compilation xdess
nmake /C /f Makefile.mak %1
cd ..
cd m2sci
echo Macros compilation m2sci
nmake /C /f Makefile.mak %1
cd ..
cd mtlb
echo Macros compilation mtlb
nmake /C /f Makefile.mak %1 
cd ..
cd int
echo Macros compilation int
nmake /C /f Makefile.mak %1 
cd ..\..
