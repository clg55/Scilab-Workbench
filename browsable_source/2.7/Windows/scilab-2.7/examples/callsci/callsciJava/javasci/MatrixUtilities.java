package javasci ;

/**
 * Extension de la classe <tt>Matrix</tt> 
 * qui d�finit a titre d'exemple quelques 
 * op�rateurs sur les matrices. 
 */

public class MatrixUtilities extends Matrix { 

  public MatrixUtilities(String name,int m,int n) 
  {
    super(name,m,n);
  }

  public MatrixUtilities(String name,int m,int n,double []x )
  {
    super(name,m,n,x);
  }

  /**
   * Calcul l'inverse d'une matrice 
   */
  public void inv() { scilabJob( getName() + "=inv(" + getName() +");");}
  /**
   * Display Scilab de la matrice 
   */
  public void disp() {
    System.out.println("Matrix "+ getName() +"=");
    scilabJob( "disp(" + getName() +");");
  }
  /**
   * Remplit les �l�ments de la matrice avec des nombres 
   * al�atoires de loi uniforme sur [0,1).
   */
  public void rand() { 
    scilabJob(  getName() + "=rand(" + getRow() +"," + getCol() +");");
  }

}







