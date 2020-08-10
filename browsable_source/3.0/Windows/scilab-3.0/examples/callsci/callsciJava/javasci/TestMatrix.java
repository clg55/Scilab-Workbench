import javasci.* ; 

class  TestMatrix {

  public static void main(String[] args) {
    // creation d'une matrice 4x4 
    MatrixUtilities a = new MatrixUtilities("A",4,4);
    // on la remplit aléatoirement (loi uniforme sur (0,1)).
    a.rand();
    // display Scilab de la matrice. 
    a.disp();
    MatrixUtilities b = new MatrixUtilities("B",2,2, new double [] {1,2,3,4} );
    b.disp();
    // calcul de l'inverse 
    b.inv();
    b.disp();
    MatrixUtilities v = new MatrixUtilities("Void",0,0);
    v.disp();
    // Attention aux ' il faut les doubler
    // on fait executer une instruction Scilab 
    Matrix.scilabExec("write(%io(2),''coucou'')");
    MatrixUtilities h = new MatrixUtilities("H",2,2, new double [] {1,2,3,4} );
    // on envoit h a Scilab 
    h.scilabSend();
    // on fait executer une instruction Scilab 
    Matrix.scilabExec("disp(H)");
    // un peu de dessin 
    double  x[] = new double[10]; 
    double  y[] = new double[x.length]; 
    for ( int i= 0 ; i < x.length  ; i++ ) 
      {
	x[i]= (double) i; 
	y[i]= Math.sin((double) i);
      }
    Matrix mx = new Matrix("x",1,x.length,x); 
    Matrix my = new Matrix("y",1,y.length,y); 
    mx.scilabSend();
    my.scilabSend();
    Matrix.scilabExec("plot(x,y);halt();");
  }
}

  
