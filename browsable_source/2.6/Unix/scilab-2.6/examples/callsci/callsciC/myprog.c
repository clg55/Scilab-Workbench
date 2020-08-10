#include <math.h>
#include <stdio.h> 
#include "machine.h"
#include "stack-c.h"

/* 
 * Initialisation de Scilab 
 * avec execution de la startup 
 * pour ne pas avoir a ecrire un script 
 * de lancement je fixe SCI en dur qui est passe par le 
 * Makefile 
 */

#ifndef SCI 
#define SCI "../.."
#endif 

static void Initialize() 
{
  static char initstr[]="exec(\"SCI/scilab.star\",-1);quit;";
  static iflag=-1, stacksize = 1000000, ierr=0;
  /* je fixe des variables d'environement
   * ici pour pas avoir de callsci a ecrire 
   */ 
  setenv("SCI",SCI,1);
  /* Scilab Initialization */ 
  C2F(inisci)(&iflag,&stacksize,&ierr);
  if ( ierr > 0 ) 
    {
      fprintf(stderr,"Scilab initialization failed !\n");
      exit(1);
    }
  /* running the startup */ 
  C2F(settmpdir)();

  C2F(scirun)(initstr,strlen(initstr));
}

int send_scilab_job(char *job) 
{
  static char buf[1024],
    format[]="Err=execstr('%s','errcatch','n');quit;";
  int m,n,lp;
  sprintf(buf,format,job);
  C2F(scirun)(buf,strlen(buf));
  GetMatrixptr("Err", &m, &n, &lp);
  return (int) *stk(lp);
}

static int premier_exemple()
{
  static double A[]={1,2,3,4};  int mA=2,nA=2;
  static double b[]={4,5};  int mb=2,nb=1;
  int m,n,lp,i;
  WriteMatrix("A", &mA, &nA, A);
  WriteMatrix("b", &mb, &nb, b);

  if ( send_scilab_job("A,b,x=A\\b;") != 0) 
    {
      fprintf(stdout,"Error occured during scilab execution\n");
    }
  else 
    {
      GetMatrixptr("x", &m, &n, &lp);
      for ( i=0 ; i < m*n ; i++) 
	fprintf(stdout,"x[%d] = %5.2f\n",i,*stk(i+lp));
    }
  return 1;
} 

static int deuxieme_exemple() 
{
  int m,n,lx,ly,i;
  /* j'utilise scilab pour creer les abscisses 
   * et reserver de la place pour les ordonnees 
   */ 
  send_scilab_job("x=1:0.1:10;y=x;");
  GetMatrixptr("x", &m, &n, &lx);  
  GetMatrixptr("y", &m, &n, &ly);  
  for ( i=0; i < m*n ; i++) 
    { 
      double xi = *stk(lx+i);
      *stk(ly+i) = xi*sin(xi);
    }
  /* plot(x,y);  */
  send_scilab_job("plot(x,y);xclick();quit");
  return 1;
}


int troisieme_exemple() 
{
  double x[]={1,0,0} ; int mx=3,nx=1;
  double time[]={0.4,4}; int mt=1,nt=2;
  fprintf(stdout,"je linke \n");
  send_scilab_job("TMPDIR,link(''./mon_edo.o'',''mon_edo'',''c'');");
  fprintf(stdout,"fin du link  \n");
  send_scilab_job("link(''show'')");
  WriteMatrix("x", &mx, &nx, x);
  WriteMatrix("time", &mt, &nt,time);
  /* pour que scilab <<linke>> mon_edo */
  /* appel de ode */
  send_scilab_job("y=ode(x,0,time,''mon_ode''),");
}



/* I do not want to see the Scilab banier */ 

void C2F(banier)(int *x) 
{
  fprintf(stdout,"Ourf ....\n");
  C2F(storeversion)("scilab-2.5.1",12L);
}


int MAIN__(void) 
{
  Initialize();
  premier_exemple();
  deuxieme_exemple() ;
  troisieme_exemple() ;
  C2F(sciquit)();
}




