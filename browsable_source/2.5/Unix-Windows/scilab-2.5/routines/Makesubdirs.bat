@echo off
REM Makesubdirs.bat all
if "%1" == "all" goto all
if "%1" == "clean" goto all
if "%1" == "distclean" goto all
if "%1" == "tksci" goto tksci 
if "%1" == "pvm" goto pvm 

echo Unknown target %1 
goto end

:all
cd f2c\src 
echo Making %1 in directory  f2c\src 
 nmake /C /f Makefile.mak %1
cd ..\..
cd f2c\libf2c
echo Making %1 in directory  f2c\libf2c
 nmake /C /f Makefile.mak %1
cd ..\..
cd xdr
echo Making %1 in directory  xdr
 nmake /C /f Makefile.mak %1
cd ..
cd fraclab
echo Making %1 in directory  fraclab
 nmake /C /f Makefile.mak %1
cd ..
cd graphics
echo Making %1 in directory  graphics
 nmake /C /f Makefile.mak %1
cd ..
cd calelm
echo Making %1 in directory  calelm
 nmake /C /f Makefile.mak %1
cd ..
cd blas
echo Making %1 in directory  blas
 nmake /C /f Makefile.mak %1
cd ..
cd comm
echo Making %1 in directory  comm
 nmake /C /f Makefile.mak %1
cd ..
cd control
echo Making %1 in directory  control
 nmake /C /f Makefile.mak %1
cd ..
cd default
echo Making %1 in directory  default
 nmake /C /f Makefile.mak %1
cd ..
cd integ
echo Making %1 in directory  integ
 nmake /C /f Makefile.mak %1
cd ..
cd interf
echo Making %1 in directory  interf
 nmake /C /f Makefile.mak %1
cd ..
cd intersci
echo Making %1 in directory  intersci
 nmake /C /f Makefile.mak %1
cd ..
cd lapack
echo Making %1 in directory  lapack
 nmake /C /f Makefile.mak %1
cd ..
cd libcomm
echo Making %1 in directory  libcomm
 nmake /C /f Makefile.mak %1
cd ..
cd metanet
echo Making %1 in directory  metanet
 nmake /C /f Makefile.mak %1
cd ..
cd optim
echo Making %1 in directory  optim
 nmake /C /f Makefile.mak %1
cd ..
cd poly
echo Making %1 in directory  poly
 nmake /C /f Makefile.mak %1
cd ..
cd signal
echo Making %1 in directory  signal
 nmake /C /f Makefile.mak %1
cd ..
cd sparse
echo Making %1 in directory  sparse
 nmake /C /f Makefile.mak %1
cd ..
cd sun
echo Making %1 in directory  sun
 nmake /C /f Makefile.mak %1
cd ..
cd system
echo Making %1 in directory  system
 nmake /C /f Makefile.mak %1
cd ..
cd system2
echo Making %1 in directory  system2
 nmake /C /f Makefile.mak %1
cd ..
cd menusX
echo Making %1 in directory  menusX
 nmake /C /f Makefile.mak %1
cd ..
cd scicos
echo Making %1 in directory  scicos
 nmake /C /f Makefile.mak %1
cd ..
cd sound
echo Making %1 in directory  sound
 nmake /C /f Makefile.mak %1
cd ..
cd dcd 
echo Making %1 in directory  dcd 
 nmake /C /f Makefile.mak %1
cd ..
cd randlib
echo Making %1 in directory  randlib
 nmake /C /f Makefile.mak %1
cd ..
cd wsci
echo Making %1 in directory  wsci
 nmake /C /f Makefile.mak %1
cd ..
cd gd
echo Making %1 in directory  gd
 nmake /C /f Makefile.mak %1
cd ..
cd int
echo Making %1 in directory  int
 nmake /C /f Makefile.mak %1
cd ..
echo on
goto end

:tksci 
cd tksci 
echo Making %1 in directory  tksci 
 nmake /C /f Makefile.mak all
cd ..
goto end 

:pvm 
cd pvm 
echo Making %1 in directory  pvm 
 nmake /C /f Makefile.mak all
cd ..
goto end

:end 


