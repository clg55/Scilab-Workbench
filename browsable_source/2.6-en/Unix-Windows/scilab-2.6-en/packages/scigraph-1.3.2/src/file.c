#include <string.h>
#include "graphics/Math.h" 

int check_graph_sufix(name)
     char *name;
{
  char *base = strstr(name,".graph");
  return (base != NULL) ? 1:0;
}


char *MStripGraph(name)
     char *name;
{
  char *s = name;
  int i =0 ;
  char *t;
  if ((t = (char *)MALLOC((unsigned)strlen(name)+1)) == NULL) return name;
  while ((t[i++] = *s++)) {
    if (*s == '.') {
      if (strcmp(++s,"graph") == 0) {
	t[i] = '\0'; 
	return t;
      }
      t[i++] = '.';
    }
  }
  return name;
}

char *mybasename (name)
     char *name;
{
  char *base;
  base = strrchr (name, '/');
  return base ? base + 1 : name;
}

char* metanedirname (path)
     char *path;
{
  char *newpath;
  char *slash;
  int length;    /* Length of result, not including NUL. */

  slash = strrchr (path, '/');
  if (slash == 0)
    {
      /* File is in the current directory.  */
      path = ".";
      length = 1;
    }
  else
    {
      /* Remove any trailing slashes from result. */
      while (slash > path && *slash == '/')
	--slash;
      length = slash - path + 1;
    }
  newpath = (char *)MALLOC ((unsigned)length + 1);
  if (newpath == 0)
    return 0;
  strncpy (newpath, path, length);
  newpath[length] = 0;
  return newpath;
}


