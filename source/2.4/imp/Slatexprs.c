/* Copyright INRIA */
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#ifndef __STDC__
#include <malloc.h>
#endif 
#include <stdio.h>

void readOneLine();

#ifdef WIN32 
extern void SciEnv(void);
#endif 

/*---------------------------------------------------------
  Blatexprs fileres file1 .... filen  
  fait une mise en page de n dessins scilab ou neoclo 
  genere le fichier postscript fileres.ps 
  associe ainsi  qu'un fichier TeX fileres.tex
-------------------------------------------------------------*/

char * UsageStr[]={
#ifndef DOC
  "Usage  : Blatexprs fileres file1 .... filen  \n",
#else 
  "Usage  : Blatdocs fileres file1 .... filen  \n",
#endif
  "\tfile1, ... filen : are n Postscript files produced by Scilab\n",
  "\tfileres : a file name for the result \n",
  "\tThis command will create fileres.ps and fileres.tex \n",
  "fin"};

char entete[160];

void WriteTeX(filename,wide,height)
     double wide,height;
     char filename[];
{
  char filename1[255];
  FILE *fdo;
  sprintf(filename1,"%s.tex",filename);
  fdo=fopen(filename1,"w");
  if (fdo == 0 ) 
    {
      fprintf (stderr," Can't Create Output file <%s> \n",filename1);
      exit(0);
    }
#ifndef DOC 
  fprintf(fdo,"\\long\\def\\Checksifdef#1#2#3{\n");
  fprintf(fdo,"\\expandafter\\ifx\\csname #1\\endcsname\\relax#2\\else#3\\fi}\n");
  fprintf(fdo,"\\Checksifdef{Figdir}{\\gdef\\Figdir{}}{}\n");
  fprintf(fdo,"\\def\\dessin#1#2{\n");
#endif
  fprintf(fdo,"\\begin{figure}\n\\begin{center}\n");
  fprintf(fdo,"\\setlength{\\unitlength}{1cm}\n");
  fprintf(fdo,"\\fbox{\\begin{picture}(%.2f,%.2f)\n",wide,height);
#ifdef EPSFIG
  fprintf(fdo,"\\epsfig{file=\\Figdir %s.ps}\n",filename);
#else
  fprintf(fdo,"%% if you want to use epsfig uncomment the following line \n");
  fprintf(fdo,"%% and comment the special line \n");
  fprintf(fdo,"%%\\epsfig{file=\\Figdir %s.ps}\n",filename);
#endif
  fprintf(fdo,"\\special{psfile=\\Figdir %s.ps}\n", filename);
  fprintf(fdo,"\\end{picture}}\n");
  fprintf(fdo,"\\end{center}\n");
#ifndef DOC 
  fprintf(fdo,"\\caption{\\label{#2}#1}\n\\end{figure}}");
#endif
  fclose(fdo);
}

/*---------------------------------------------------
 remplace strin<i> par strout<i> en lisant le contenu de 
 file et en ecrivant sur fdo
-------------------------------------------------------*/

void Sed(file,strin1,strout1,strin2,strout2,strin3,strout3,fdo)
     FILE *fdo;
     char file[],strin1[],strout1[],strout3[];
     char strin2[],strout2[],strin3[];
{
  FILE *fd;
  fd=fopen(file,"r");
  if (fd != 0)
    { int stop=0;
      while ( stop != 1)
	{  char buff[512];
	   readOneLine (buff,&stop,fd); 
	   if (strncmp(buff,strin1,strlen(strin1))==0)
	     fprintf(fdo,"%s\n",strout1);
	   else
	     {
	       if (strncmp(buff,strin2,strlen(strin2))==0)
		 fprintf(fdo,"%s\n",strout2);
	       else 
		 {
		   if (strncmp(buff,strin3,strlen(strin3))==0)
		     fprintf(fdo,"%s\n",strout3);
		   else
		     fprintf(fdo,"%s",buff);
		 }
	     }
	 }
      fclose(fd);
    }
  else 
    {
      fprintf(stderr,"file %s not found ",file);
      return;
    }
}

/*-----------------------------------------------
  lit une ligne dans fd et la stocke dans buff
---------------------------------------------------*/

void readOneLine(buff,stop,fd)
     char buff[];
     int *stop;
     FILE *fd;
{ int i ,c ;
  for ( i = 0 ;  (c =getc(fd)) !=  '\n' && c != EOF ; i++) buff[i]= c ;
  buff[i]='\n';buff[i+1]='\0';
  if ( c == EOF) {*stop = 1;}
}

/*-----------------------------------------------
  calcule la taille pour un dessin suivant le nombre de dessin a 
  placer dans la feuille 
  num est le nombre de dessins et i le numero du dessin 
  renvoit le point gauche dans (*x,*y) la largeur et le hauteur 
  dans (*w,*h)
  (*wt et *ht sont la hauteur totale et la argeur totale)
-----------------------------------------------------*/

void ComputeSize(num,i,x,y,w,h,wt,ht)
     int num,i;
     double *x,*y,*w,*h,*wt,*ht;
{
  switch (num)
    {
    case 1 :
      /** une figure dans upleft(0,20,h=20,w=15) **/
      *wt=15.0;*ht=20.0;
      *x=0.0;*y=20.0;*h=20.0;*w=15.0;
      break;
    case 2 :
      *wt=15.0;*ht=20.0;
      /** 2 figures dans upleft(0,20,h=20,w=15) **/
      *x=0.0;*y=(20-(i-1)*10);*h=10.0;*w=15.0;
      break;
    case 3 :
      *wt=15.0;*ht=21.0;
      /** 3 figures dans upleft(0,21,h=21,w=15) **/
      *x=0.0;*y=(21-(i-1)*7);*h=7.0;*w=15.0;
      break;
    case 4 :

      /** 4 figures dans upleft **/
      *wt=16.0;*ht=16.0;
      if (i <= 2) *y=16.0;else *y=8.0;
      if ( (i % 2 ) == 0 ) 
	{ *x= 8.0;*h=8.0;*w=8.0;}
      else 
	{*x= 0.0;*h=8.0;*w=8.0;}
      break ;
    case 5 :
    case 6 :
      *wt=16.0;*ht=21.0;
      if (i <= 2) *y=21.0;else { if ( i <= 4) *y=14.0; else *y=7.0;}
      if ( (i % 2 ) == 0 ) 
	{ *x= 8.0;*h=7.0;*w=8.0;}
      else 
	{*x= 0 ;*h=7.0;*w=8.0;}
      break ;
    case 7 :
    case 8 :
    case 9 :
      *wt=16.0;*ht=18.0;
      if (i <= 3) *y=18.0;else { if ( i <= 6) *y=12.0; else *y=6.0;}
      if ( (i % 3 ) == 0 ) 
	{ *x= 2*5.3;*h=6.0;*w=5.3;}
      else 
	{
	  if ( (i % 3 ) == 1 ) 
	    { *x= 0.0;*h=6.0;*w=5.3;}
	  else 
	    {*x= 5.3 ;*h=6.0;*w=5.3;}
	}
      break ;
    case 10 :
    case 11 :
    case 12 :
    default :
      *wt=16.0;*ht=20.0;
      if (i <= 3) *y=20.0;
      else { 
	if ( i <= 6) *y=15.0;
	else {
	  if (i <= 9 ) *y=10.0; else *y=5.0;}
      }
      if ( (i % 3 ) == 0 ) 
	{ *x= 2*5.3;*h=5.0;*w=5.3;}
      else 
	{
	  if ( (i % 3 ) == 1 ) 
	    { *x=0.0;*h=5.0;*w=5.3;}
	  else 
	    {*x= 5.3 ;*h=5.0;*w=5.3;}
	}
      break ;
    }
}



int main(argc, argv)
     int argc;
     char *argv[];

{
  char *env;
  char filename1[255];
  double x,y,w,h,wt,ht;
  char buf[256];
  int i ;
  FILE *fd;
  FILE *fdo;
#ifdef WIN32 
  SciEnv();
#endif 

  if (argc <= 2) { int i=0;
		   while (strcmp(UsageStr[i],"fin")!=0)
		     { 
		       fprintf(stderr,"%s",UsageStr[i]),i++;
		     }
		   exit(0);
		 }
  sprintf(filename1,"%s.ps",argv[1]);
  fdo=fopen(filename1,"w");
  if (fdo == 0 ) 
    {
      fprintf (stderr," Can't Create Output file <%s> \n",filename1);
      exit(0);
    }
  env = getenv("SCI");
  if (env == NULL) {
    fprintf(stderr,"Environment variable SCI must be defined\n");
    exit(0);
  }
  sprintf(entete,"%s/imp/NperiPos.ps",env);
  fd=fopen(entete,"r");
  if (fd != 0)
    { int c;
      while ( (c=getc(fd)) != EOF)
	{
	  putc((char) c,fdo);
	}
      fclose(fd);
    }
  else 
    {
      fprintf(stderr,"file %s not found ",entete);
      return(1);
    }
  for ( i = 2 ; i < argc-1 ; i++)
    { 
      ComputeSize(argc-2,i-1,&x,&y,&w,&h,&wt,&ht)      ;
      sprintf(buf,"gsave [1 0 0 -1 0 0] concat %5.2f %5.2f %5.2f %5.2f DesPosi"
	      ,x,y,w,h);
      Sed(argv[i],"[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div] concat",
	  buf," showpage","grestore",
	  " end saved restore","% end saved restore",fdo);
    }
  ComputeSize(argc-2,argc-2,&x,&y,&w,&h,&wt,&ht)      ;   
  sprintf(buf,"gsave [1 0 0 -1 0 0] concat %5.2f %5.2f %5.2f %5.2f DesPosi"
	  ,x,y,w,h);
  Sed(argv[argc-1],"[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div] concat",
      buf, " showpage"," grestore ",
      " end saved restore"," end saved restore",fdo);
  fprintf(fdo,"%%%%BoundingBox: 0 0 %d %d\n",(int)wt ,(int)ht);
  fclose(fdo);
  /** ecriture du fichier TeX associe **/
  WriteTeX(argv[1],wt,ht);
  return(0);
}
