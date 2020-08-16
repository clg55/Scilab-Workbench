package javasci ;


/**
 * Cette classe permet de cr�er des matrices et de faire effectuer des 
 * calculs sur ces matrices par Scilab 
 */

public class  Matrix {
  /**
   * contient les �l�ments de la matrice stock�s colonne par 
   * colonne. 
   */

  protected double [] x ;
  protected String s[] ;

  private int m, n, t;
  private String name; 

  /**
   * renvoit le nombre de lignes de la matrice. 
   */
  public int getRow() { return m;}
  /**
   * renvoit le nombre de colonnes de la matrice. 
   */
  public int getCol() { return n;}
  /**
   * renvoit le nom Scilab de la matrice.
   */
  public String getName() {return name;}

  /**
   * renvoit un tableau unidimensionnel de <tt>double</tt> contenant
   * les �l�ments de la matrice stock�s colonne par colonne.
   */
  public double[] getData() { return x;}
  public String[] getSData() { return s;}

  /**
   * Construit une matrice <tt>mxn</tt> de nom <tt>name</tt> 
   * (ce sera le nom Scilab de la matrice) dont les �l�ments sont 
   * initialis�e avec la valeur z�ro. 
   */
  public Matrix(String name,int m,int n) 
  {
 
    x = new double[m*n];
    this.m = m ;
    this.n = n;
    this.name = name;
    this.t = 0 ;   // real matrix
  }

  public Matrix(String name,int m,int n, int typemat) 
  {
    if ( typemat == 0 )
    {
      /** Complex matrix */
      x = new double[m*n];
    }
    else if ( typemat == 1 )
    {
      /** Complex matrix */
      x = new double[2*m*n];
    }
    else if ( typemat == 2 )
    {
      /** String matrix */
      s = new String[m*n];
    }
    this.t = typemat;
    this.m = m ;
    this.n = n;
    this.name = name;
  }


  /**
   * Construit une matrice <tt>mxn</tt> de nom <tt>name</tt> 
   * (ce sera le nom Scilab de la matrice) dont les �l�ments sont 
   * initialis�e avec le vecteur de double <tt>x</tt>. <tt>x</tt>
   * contient les valeurs des �l�ments de la matrice stock�s 
   * colonne par colonne. l'�l�ment <tt>(i,j)</tt> est donc en 
   * <tt>x[i+ m*j]</tt> pour <tt>i</tt> dans <tt>[0,m]</tt> et <tt>j</tt>
   * dans <tt>[0,n]</tt>. 
   */
  public Matrix(String name,int m,int n,double []x ) 
  {
    if ( m*n != x.length && 2*m*n != x.length ) 
      throw new BadDataArgumentException("Bad Matrix call, size of third argument is wrong");
    this.x = x ;  this.m = m ;  this.n = n;
    this.name = name;
    if ( m*n == x.length )
    {
      this.t = 0 ;
    }
    else
    {
      this.t = 1 ;
    }  
  }

  public Matrix(String name,int m,int n, String[]s ) 
  {
    if ( m*n != s.length ) 
      throw new BadDataArgumentException("Bad Matrix call, size of third argument is wrong");
    this.m = m ;  this.n = n;
    this.name = name;
    this.t = 2 ;  // String matrix
    this.s = s ;
  }

  /**
   * Envoit la matrice r�f�renc�e par l'objet <tt>Matrix</tt> � scilab. 
   * Fait executer le calcul Scilab d�crit par la cha�ne 
   * <tt>job</tt> et renvoit dans l'objet <tt>Matrix</tt> 
   * l'�tat de la matrice apr�s le calul. C'est le champ 
   * <tt>name</tt> qui d�signe le nom Scilab de la Matrice. 
   *
   * @param job Cha�ne de carat�re (Attention le caract�re <tt>'</tt>
   * pour �tre utilis� dans la cha�ne <tt>job</tt> doit �tre 
   * dupliqu�. 
   */

  public void scilabGet()
  {
        // Appel de scilabGet native
 	if ( t != 2 )
        {
	   scilabGetN();
        }
        else
        {
           int ix, j;
           for(ix=0;ix<m;ix++)
           {
              for(j=0;j<n;j++)
              {
	         s[ix+j*m] = scilabGetSN(ix, j);
              }
           }
        }
  }

    public native void scilabJob(String job);
  /**
   * Envoit la matrice r�f�renc�e par l'objet <tt>Matrix</tt> � scilab. 
   */
  public native void scilabSend();
  
  public static native void scilabEvents();
  
  public static native int scilabHaveAGraph();
  
  
  /**
   * Recopie dans l'objet <tt>Matrix</tt> la valeur de l'objet Scilab 
   * de type Matrice correspondant.
   */
  public native void scilabGetN();
  public native String scilabGetSN(int ix, int j);
  /**
   * Fait executer le calcul Scilab d�crit par la cha�ne 
   * <tt>job</tt>. 
   */
  public static native void scilabExec(String job);


  public native void testFill();

  static 
  {
    System.loadLibrary("javasci");
  }

}

