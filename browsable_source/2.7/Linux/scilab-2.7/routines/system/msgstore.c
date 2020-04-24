#include <string.h>
#include "../stack-c.h"
#include "msgstore.h"

#define MEM_LACK 3
#define MAX_LINES 2
#define MAX_MSG_LINES  20

static char* msg_buff[MAX_MSG_LINES];
static char funname[24];
static int where = 0;
static int err_n = 0;
static int msg_line_counter=0;

int C2F(errstore)(n)
     int *n;
{
  err_n = *n;
  return 0;
}
int C2F(linestore)(n)
     int *n;
{
  where = *n;
  return 0;
}
int C2F(funnamestore)(str,n)
     char *str;
     int *n;
{
  strncpy(funname, str, (size_t)*n);
  return 0;
}

int C2F(msgstore)(str,n)
     char *str;
     int *n;
{
  char *line, c;
  int i,count=0;
  if (msg_line_counter >= MAX_MSG_LINES)
    return(MAX_LINES);
  if ( (line = (char *) malloc((*n + 1)*sizeof(char))) == (char *)0) 
    return(MEM_LACK);
  /* do not store \r\n" */ 
  for ( i= 0 ; i < *n ; i++ ) 
    if ( (c=str[i]) != '\n' && c != '\r') line[count++]=c;
  line[count]='\0';
  msg_buff[msg_line_counter++]=line;
  return 0;
}

void C2F(freemsgtable)()
{
  int k;
  for (k=0 ; k< msg_line_counter ; k++)
    free(msg_buff[k]);
  msg_line_counter=0;
  err_n = 0;
}

int C2F(lasterror)(fname,fname_len)
     char *fname;
     unsigned long fname_len;
{
  int k, one=1, l1, zero=0, m1, n1, clear, four=4,lr;
  int sz[MAX_MSG_LINES];

  Rhs = Max(0, Rhs);
  CheckRhs(0,1);
  CheckLhs(1,4);
  if (msg_line_counter == 0) {
    CreateVar(1,"d",&zero,&zero,&l1);
    LhsVar(1)=1;
    if (Lhs == 2) {
      CreateVar(2,"d",&one,&one,&l1);
      *stk(l1) = (double)0.0;
      LhsVar(2)=2;
    }
  }
  else {
    clear = 1;
    if (Rhs==1) {
      GetRhsVar(1,"b",&m1,&n1,&l1);
      clear = *istk(l1);
    }
    for (k=0;k<msg_line_counter ; k++) 
      sz[k]=strlen(msg_buff[k])-1;
    C2F(createvarfromptr)(&one, "S", &msg_line_counter, &one,(void *) msg_buff, 1L);
    LhsVar(1) = 1;
    if (Lhs >= 2) {
      CreateVar(2,"d",&one,&one,&l1);
      *stk(l1) = (double)err_n;
      LhsVar(2)=2;
    }
    if (Lhs >= 3) {
      CreateVar(3,"d",&one,&one,&l1);
      *stk(l1) = (double)where;
      LhsVar(3)=3;
    }
    if (Lhs >= 4) {
      l1=strlen(funname);
      C2F(createvar)(&four,"c", &one,&l1 , &lr, 1L);
      strcpy(cstk(lr),funname);
      LhsVar(4)=4;
    }
    if (clear) {
      where=0;
      funname[0]='\0';
      C2F(freemsgtable)();
    }
  }
  C2F(putlhsvar)();
  return(0);
}
