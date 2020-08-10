echo off
rem Allan CORNET
rem INRIA Septembre 2003
echo ------------------------------------------------------------------------
echo Pour que cet exemple fonctionne,
echo Les divers chemins des compilateurs (Java et Visual Studio 6) doivent
echo etre definis correctement.
echo Ainsi que les variables environnement Scilab ( SCI , TMPDIR )
echo Dans le cas contraire 
echo Editer ce fichier et modifier les chemins en consequence
echo ------------------------------------------------------------------------
pause
echo on
rem A modifier selon votre répertoire d'installation de Java(TM) 2 SDK, Standard Edition Version 1.4.2
PATH=%PATH%;C:\j2sdk1.4.2_01\bin;

rem modifier selon votre répertoire d'installation de Visual Studio
rem "C:\Program Files\Microsoft Visual Studio\VC98\Bin\VCVARS32.bat"

rem A modifier selon votre répertoire d'installation de scilab
SET SCI=c:\scilabCVS
SET TMPDIR=c:\scilabCVS

rem copie des dll dans le sous repertoire javasci\classes\
md javasci\classes
copy ..\..\..\bin\libScilab.dll javasci\classes\libScilab.dll
copy ..\..\..\bin\TCL84.dll javasci\classes\TCL84.dll
copy ..\..\..\bin\TK84.dll javasci\classes\TK84.dll
copy scilabJava.star ..\..\..\scilabJava.star

rem Compilation de l'interface C --> Java
cl javasci_Matrix.c ..\..\..\routines\f2c\libf2c\main.obj ..\..\..\bin\LibScilab.lib
rem on efface le fichier javasci_Matrix.exe car il nous est inutile
del javasci_Matrix.exe
link ..\..\..\bin\libscilab.lib -nologo -debug -dll -out:javasci\classes\javasci.dll javasci_Matrix.obj

rem Compilation des classes Java d'interfaces
cd javasci
javac -d classes *.java

rem Compilation des exemples
cd ..
javac -d javasci\classes -classpath javasci\classes *.java

rem execution des exemples
cd javasci\classes
echo off
echo ------------------------------------------------------------------------
echo Exemple 1
echo ------------------------------------------------------------------------
java Exemple1
pause
echo ------------------------------------------------------------------------
echo Exemple 2
echo ------------------------------------------------------------------------
java Exemple2
pause
echo ------------------------------------------------------------------------
echo Exemple 3
echo ------------------------------------------------------------------------
java Exemple3
pause
echo ------------------------------------------------------------------------
echo ExempleGet
echo ------------------------------------------------------------------------
java ExempleGet
pause
cd ..
cd ..
echo on

