/* Copyright INRIA */
#include <string.h>
#include <malloc.h>

char *StripGraph(name)
char *name;
{
  char *s;
  int i;
  char *t;

  s = name;
  i = 0;
  t = (char *)malloc((unsigned)strlen(name)+1);
  while (t[i++] = *s++) {
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

char *my_basename (name)
char *name;
{
  char *base;

  base = strrchr (name, '/');
  return base ? base + 1 : name;
}

char* dirname (path)
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
  newpath = (char *)malloc ((unsigned)length + 1);
  if (newpath == 0)
    return 0;
  strncpy (newpath, path, length);
  newpath[length] = 0;
  return newpath;
}
