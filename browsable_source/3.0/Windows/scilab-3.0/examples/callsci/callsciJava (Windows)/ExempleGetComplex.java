import javasci.* ; 


class  ExempleGetComplex {

  public static void main(String[] args) {
    MatrixUtilities a = new MatrixUtilities("A",1,3,new double [] {1,1,1});
    a.scilabSend();
    Matrix.scilabExec("P=poly(A,''x'',''coeffs'');");
    System.out.println("Affichage scilab" );
    Matrix.scilabExec("Q=roots(P);disp(Q);");
    // Creer une matrice (2,3) de type 1 = complex (le 4 ieme paramètre)
    int m = 1;
    int n = 2;
    double val[] = new double[2*m*n];
    MatrixUtilities q = new MatrixUtilities("Q",m,n,val);

    q.scilabGet();
    int i, j, ij;

    System.out.println();
    System.out.println("--------------------------------------" );
    System.out.println("Affichage apres recuperation dans java" );
    System.out.println();

    for(i=0;i<m;i++)
    {
      for(j=0;j<n;j++)
      {
         ij=i+j*m;

         if ( val[ij+m*n] >= 0 )
         {
           System.out.println(i+"," +j+ " : " + val[ij] + "+" + val[ij+m*n] + "i");
         }
         else
         {
           System.out.println(i+"," +j+ " : " + val[ij] +  val[ij+m*n] + "i");
         }
      }
    }
  }
}

