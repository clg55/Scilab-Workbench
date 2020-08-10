import javasci.* ; 

class  Exemple3 {

  public static void main(String[] args) {
        
  MatrixUtilities a = new MatrixUtilities("A",4,1, new double [] {1,2,3,4} );
  MatrixUtilities b = new MatrixUtilities("B",4,1, new double [] {3,1,2,4} );
  MatrixUtilities c = new MatrixUtilities("C",4,1, new double [] {0,0,0,0} );
  
  a.scilabSend();
  b.scilabSend();
  c.scilabSend();
  
  Matrix.scilabExec("disp(A);");
  Matrix.scilabExec("disp(B);");
  Matrix.scilabExec("disp(C);");
  
  a.disp();
  b.disp();
  c.disp();
    
  Matrix.scilabExec("C=A+B;");
  a.scilabGet();
  b.scilabGet();
  c.scilabGet();
  
  a.disp();
  b.disp();
  c.disp();
  
	}
}
  
