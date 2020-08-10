import javasci.* ; 


class  ExempleGetReal {

  public static void main(String[] args) {
    MatrixUtilities a = new MatrixUtilities("A",1,4,new double [] {1,2,3,4});
    a.scilabSend();
    Matrix.scilabExec("P=poly(A,''x'',''coeffs'');");
    System.out.println("Affichage scilab" );
    Matrix.scilabExec("Q=real(roots(P));disp(Q);");
    int m = 1;
    int n = 3;
    double val[] = new double[m*n];
    MatrixUtilities q = new MatrixUtilities("Q",m,n, val);
    q.scilabGet();

    int i, j, ij;

    // Affichage dans Java
    System.out.println();
    System.out.println("--------------------------------------" );
    System.out.println("Affichage apres recuperation dans java" );
    System.out.println();

    for(i=0;i<m;i++)
    {
      for(j=0;j<n;j++)
      {
         System.out.println(i + "," + j + " : " + val[ij=i+j*m]);
      }
    }
  }
}

