import javasci.* ; 


class  ExempleGetString {

  public static void main(String[] args) {

    Matrix.scilabExec("StringMatrix=[''VV'',''CL'',''LG'';''Velizy'',''Charlebourg'',''La Garenne Colombe''];");

    // Display avec scilab
    System.out.println("Affichage scilab" );
    Matrix.scilabExec("disp(StringMatrix);");
    int m = 2;
    int n = 3;
    String sval[] = new String[m*n];

    // Creer une matrice (2,3) de type 2 = string (le 4 ieme paramètre)
    MatrixUtilities q = new MatrixUtilities("StringMatrix",m,n,sval);
    q.scilabGet();

    int i, j;


    // Affichage dans Java

    System.out.println();
    System.out.println("--------------------------------------" );
    System.out.println("Affichage apres recuperation dans java" );
    System.out.println();

    for(i=0;i<m;i++)
    {
      for(j=0;j<n;j++)
      {
         System.out.println(i+"," + j+ " : " + sval[i+j*m] );
      }
    }
  }
}

