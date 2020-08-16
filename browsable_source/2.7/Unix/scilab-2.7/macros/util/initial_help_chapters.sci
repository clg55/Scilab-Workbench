function %helps=initial_help_chapters(language)
[lhs,rhs]=argn(0)
if rhs==0 then
  language="eng"
else
  if rhs<>1 then error(39), end
end
dirs=["programming";"graphics";"elementary";"fileio";"functions";"strings";
      "gui";"utilities";"linear";"polynomials";"control";"robust";
      "nonlinear";"signal";"arma";"metanet";"scicos";"sound";"translation";
      "pvm";"tdcs";"tksci";"statistics";"dcd";"identification"];
sep="/";if MSDOS then sep="\",end
%helps=sep+"man"+sep+language+sep+dirs; 
select language
case "eng"
  %helps=[%helps,..
	  ["Programming";"Graphics Library";"Elementary Functions";
	   "Input/Output Functions";"Handling of functions and libraries";
	   "Character string manipulations";"Dialogs";"Utilities";
	   "Linear Algebra";"Polynomial calculations";
	   "General System and Control";"Robust control toolbox";
	   "Optimization and simulation";
	   "Signal Processing toolbox";
	   "Arma modelisation and simulation toolbox";
	   "Metanet: graph and network toolbox";
	   "Scicos: Bloc diagram editor and simulator";"Sound file handling";
	   "Language or data translations";"PVM parallel toolbox";"TdCs";
	   "TCL/Tk interface";
	   "Statistics";
	   "Cumulative Distribution Functions; Inverses, grand";
           "Identification"]];
  case "fr"
  %helps=[%helps,..
	  ["Programmation";"Librairie graphique";"Fonctions �l�mentaires";
	   "Entr�es-sorties";"Manipulation des fonctions et des librairies";
	   "Manipulations de cha�nes de caract�res";"Dialogues";"Utilitaires";
	   "Alg�bre lin�aire";"Calculs sur les polyn�mes";
	   "Contr�le et th�orie des syst�mes";"Contr�le robuste";
	   "Optimisation et simulation";
	   "Traitement du signal";"Mod�lisation et simulation ARMA";
	   "Metanet : graphes et r�seaux";
	   "Scicos : �diteur et simulateur de blocs diagrammes";
	   "Manipulation de fichiers sons";
	   "G�n�ration de code, traduction de donn�es";
	   "Calcul parall�le avec PVM";"TdCs";
	   "Interface TCL/Tk";
	   "Statistiques";
	   "Fonctions de distributions statistiques";
           "Identification"]];
end
%helps=[SCI+%helps(:,1),%helps(:,2)];
