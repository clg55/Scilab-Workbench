import javasci.* ;

class  TestMatrix1 {

  public static void main(String[] args) {
  
    MatrixUtilities a = new MatrixUtilities("A",2,2,new double [] {1,2,3,4});
    MatrixUtilities b = new MatrixUtilities("B",2,2,new double [] {5,6,7,8});
    MatrixUtilities x = new MatrixUtilities("X",1,2);
    a.scilabSend();
    b.scilabSend();
    Matrix.scilabExec("C=A*B;");
    // on suppose qu'on ne connait pas la  taille de C ? 
    // on la demande a Scilab 
    x.scilabJob("X=size(C);");
    double xv[]= x.getData();
    MatrixUtilities c = new MatrixUtilities("C",(int) xv[0],(int) xv[1]);
    c.scilabGet();
    double val[]= c.getData();
    for ( int i=0 ; i < val.length ; i++) 
      System.out.println("val " + i + "=" + val[i]); 
    c.disp(); 
  }
}

