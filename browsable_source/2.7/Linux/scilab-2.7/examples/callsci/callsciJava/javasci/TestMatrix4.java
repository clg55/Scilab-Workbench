import javasci.* ;

public class  TestMatrix4 {

  protected double [] x ;

  private int m,n;
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
   * les éléments de la matrice stockés colonne par colonne.
   */
  public double[] getData() { return x;}

  /**
   * Construit une matrice <tt>mxn</tt> de nom <tt>name</tt> 
   * (ce sera le nom Scilab de la matrice) dont les éléments sont 
   * initialisée avec la valeur zéro. 
   */
  public TestMatrix4(String name,int m,int n) 
  {
    x = new double[m*n];
    this.m = m ;
    this.n = n;
    this.name = name;
  }

  public void testFill() 
  {
    for ( int i = 0 ; i < m ; i++) 
      for ( int j = 0 ; j < n ; j++) 
	x[i+ m*j]=i+j;
  }

  public static void main(String[] args) {
  
    TestMatrix4 a = new TestMatrix4("A",200,200);
    a.testFill();
  }

  static 
  {
    System.loadLibrary("javasci");
  }

}
