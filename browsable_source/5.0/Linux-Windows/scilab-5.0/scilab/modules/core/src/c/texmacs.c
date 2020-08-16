
#include <stdio.h> 
#include "machine.h" /* for C2F */
#include "stack-def.h" /* for paus */
#include "texmacs.h"
#include "prompt.h"
#include "readline.h"

#if 0 /* to debug TeXmacs interface */
#define DATA_BEGIN  ((char) 'B')
#define DATA_END    ((char) 'E')
#else
#define DATA_BEGIN  ((char) 2)
#define DATA_END    ((char) 5)
#endif
#define DATA_ESCAPE  ((char) 27)


#define Pause C2F(recu).paus
static int first=1;
static int texmacs_mode=0;

void settexmacs(void) {
  texmacs_mode=1;
}


int C2F(intexmacs)(void) {
  return texmacs_mode;
}

void next_input (void) {
  fprintf(stdout,"%cchannel:prompt%c",DATA_BEGIN,DATA_END);
  if (Pause==0)
    fprintf(stdout,SCIPROMPT);
  else
    fprintf(stdout,SCIPROMPT_INTERRUPT,Pause);
  
  fprintf(stdout,"%c",DATA_END);fflush (stdout);
}

void
C2F(texmacsin)(char buffer[],int *buf_size, int *len_line,int *eof,long int dummy1)
{

  int nr,info;
  if (first==1) {
    fprintf(stdout,"%cverbatim:",DATA_BEGIN);
  }
  next_input ();
  
  first=0;
  
  *eof=0;

  info=LineRead(stdin,buffer,*buf_size,len_line,&nr);
  fprintf(stdout,"%cverbatim:",DATA_BEGIN);
  *len_line=*len_line-1;
}

