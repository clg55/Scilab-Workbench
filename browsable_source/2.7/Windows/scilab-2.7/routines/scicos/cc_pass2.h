#define true  1
#define false 0
#define TEST (bllst2==NULL) && (bllst3==NULL) && (bllst4==NULL) && (bllst5==NULL) && (bllst10==NULL) && (bllst11==NULL) && (bllst12==NULL) && (bllst13==NULL)  

#ifdef FORDLL 
#define IMPORT  __declspec (dllimport)
#else 
#define IMPORT extern
#endif

extern int* GetCollVect(int* vect,int* vectid,int numcoll); 
extern int* FindDif(int*vect,int val);
extern int* GetPartVect(int* vect,int idebut,int taille);
extern double* GetPartVectd(double* vect,int idebut,int taille);
extern int OR(int* Vect);
extern int Max1(int* vect);
extern int Min1(int* vect);
extern int AND(int* Vect);
extern int* FindEg(int* vect,int val);
extern int* Duplicataa(int* v,int* w);
extern int power (int base, int n);
extern int* FindInfEg(int* vect,int val);
extern int* FindInf(int* vect,int val);
extern int* FindSupEgd(double* vect,int val);
extern int* FindSup(int* vect,int val);
extern int Sum (int *vect);
extern int Prod (int *vect);
extern void CumSum (int* vect);
extern int* Test(int* vect,int val);
extern int* VecEg1 (int* vect);
extern int* VecEg2 (int* vect);
extern void Setmem (int* vect,int val);
extern void Inv(int* vect);
extern void Incr2(int* vect,int j);
extern void Incr1(int* vect,int j);
extern double powerd (double base, int n);
extern void Invd(double* Vect);
 
typedef struct 
{
  int* col1;
  int* col2;
  int* col3;
  int* col4;
} Mat4C;

typedef struct 
{
  int* col1;
  int* col2;  
} Mat2C;

typedef struct 
{
  double* col1;
  double* col2;
  double* col3;  
} Mat3C;

int mini_extract_info(int* bllst2,int** bllst4,char **bllst10,int* bllst12,int* bllst2ptr,int* bllst3ptr,int** bllst4ptr,
		      int* connectmat,int* clkconnect,int **inplnk,int **outlnk,int** typ_l,int** typ_r,int** typ_m,
                      int** tblock,int** typ_cons,int* ok);

int pak_ersi(int** clkconnect,int* typ_r,int* typ_l,int* outoin,int* outoinptr,int* tblock,
	     int* typ_cons,int* bllst5ptr,int** exe_cons,int nblk);
int make_ptr(char** bllst10,int** bllst4ptr,int** bllst5ptr,int** typ_l,int** typ_m);
int cleanup(int** clkconnect);
int paksazi(char*** bllst111,int** bllst112,int** bllst2,int** bllst3,int**bllst9,char*** bllst10,int** bllst12,
	    int** bllst2ptr,int** bllst3ptr,int* bllst5ptr,int** bllst9ptr,int** connectmat,int** clkconnect,int* typ_l,
	    int* typ_m,int* done,int* ok,int* need_newblk,int** corinvec,int** corinvptr);
int extract_info(int* bllst3,int* bllst5,char **bllst10,double* bllst11,int* bllst12,char** bllst13,int* bllst2ptr,
		 int* bllst3ptr,int* bllst4ptr,int* bllst5ptr,int* bllst11ptr,int* connectmat,
                 int* clkconnect,int** lnkptr,int** inplnk,int** outlnk,int** typ_z,int** typ_s,int** typ_m,
		 double** initexe,int** bexe,int** boptr,int** blnk,int** blptr,int* ok,int* corinvec,int* corinvptr);
int conn_mat(int* inplnk,int* outlnk,int* bllst2ptr,int* bllst3ptr,int** outoin,int** outoinptr,int* nblk);
int synch_clkconnect(int* typ_s,int* clkconnect,int** evoutoin,int** evoutoinptr);
void *discard(int* bllst5ptr,int* clkconnect,int* exe_cons,int** ordptr1,int** execlk,int** clkconectj0,
	      int** clkconnectj_cons );
int scheduler(int* bllst12,int* bllst5ptr,int* execlk,int* execlk0,int* execlk_cons,int* ordptr1,
               int* outoin,int* outoinptr,int* evoutoin,int* evoutoinptr,int* typ_z,int* typ_x,int* typ_s,int* bexe,
               int* boptr,int* blnk,int* blptr,int** ordptr2,int** ordclk,int** cord,int** iord,int** oord,int** zord,
               int** critev,int* ok);
int init_agenda(double* initexe,int* bllst5ptr,double** tevts,int** evtspt,int* pointi);
int adjust_inout(int* bllst2,int* bllst3,int* bllst2ptr,int* bllst3ptr,int* connectmat,int* ok,int* corinvec,int* corinvptr,int nblk1);
int tree4(int* vec,int *nd,int nnd,int* outoin,int* outoinptr,int* typ_r,int** r);
int tree2(int* vect,int nb,int* wec,int* ind,int* deput,int* outoin,int* outoinptr,int** ord,int* ok);
int tree3(int*vec,int nb,int* deput,int* typl,int* bexe,int* boptr,int* blnk,int* blptr,int** ord,int* ok);






