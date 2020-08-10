import javasci.* ; 


class  ExempleGet {

  public static void main(String[] args) {
    
    /***************************************************/
    /** Recuperation de double [] **/
      MatrixUtilities a = new MatrixUtilities("A",1,4,new double [] {1,2,3,4});
    a.scilabSend();
    System.out.println("Affichage temoins de la matrice a");
    a.disp();
    Matrix.scilabExec("P=poly(A,''x'',''coeffs'');");
    Matrix.scilabExec("Q=real(roots(P));");
    // Display sous scilab
    System.out.println("Affichage de Q avec disp de scilab");
    Matrix.scilabExec("disp(Q);");
    MatrixUtilities q = new MatrixUtilities("Q",3,1);
    q.scilabGet();
    // Display avec scilabGet
    System.out.println("Affichage de q recuperee par scilabGet");
    q.disp();
    
    
    /***************************************************/
    /** Recuperation de Int [] **/
    int [] B=new int[4];
        
    Matrix C = new Matrix("C",1,4);
    Matrix.scilabExec("C=[1 2 3 4];");
    Matrix.scilabExec("C=C+[1 1 1 1];");
    
    C.scilabGetInt();
    
    B=C.getDataInt();
    System.out.println("Recupere en Java depuis Scilab :");
    for (int i=0;i< ( C.getRow()* C.getCol() );i++)
    {
    	System.out.print(B[i]+" ");
    }
    System.out.println();
    
    /***************************************************/
    /** Recuperation de String **/
    String ChaineBis=new String("vide");
    
    Matrix Chaine = new Matrix("Chaine",1,20);
    Matrix.scilabExec("Chaine=''Scilab'';");
    Matrix.scilabExec("Chaine=Chaine+'' 2.7.2'';");
    
    ChaineBis=Chaine.getDataCharArray() ;
    
    System.out.println("Recupere en Java depuis Scilab :"+ChaineBis);
    
  }
}

