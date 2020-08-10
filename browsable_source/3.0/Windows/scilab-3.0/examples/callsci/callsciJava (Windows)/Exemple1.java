import javasci.* ; 


class  Exemple1 {

  public static void main(String[] args) {
    MatrixUtilities a = new MatrixUtilities("A",1,4,new double [] {1,2,3,4});
    a.scilabSend();
    Matrix.scilabExec("P=poly(A,''x'',''coeffs'');");
    Matrix.scilabExec("Q=real(roots(P));");
    MatrixUtilities q = new MatrixUtilities("Q",1,3);
    q.scilabGet();
    q.disp();
  }
}

