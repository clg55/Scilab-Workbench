// Test de non-regression du bug 557

//****************************************************
// Author : Pierre MARECHAL
// Date : 7 Fev 2005
//****************************************************
 
// G�n�ration du fichier de r�f�rence

l = [" ";"-->mprintf(''hello world\n'')";"hello world";" ";"-->diary(0)"]
l2 = ["hello world";" "]
mputl(l,TMPDIR+'/bug557.ref');

// G�n�ration du fichier rapport

diary(TMPDIR+'/bug557.dia');
mprintf('hello world\n')
diary(0)

// Comparaison

[u1,ierr]=mopen(TMPDIR+'/bug557.ref');
[u2,ierr]=mopen(TMPDIR+'/bug557.dia');

ref=mgetl(u1);mclose(u1);
dia=mgetl(u2);mclose(u2);

// Affichage du r�sultat

if or(ref<>dia) then 
	affich_result(%F,557);
else
	 affich_result(%T,557);
end