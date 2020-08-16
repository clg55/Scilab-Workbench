import javasci.*; 

class  TestMatrix3 {

  public static void main(String[] args) {
    if ( args.length > 0 ) 
      return ; 
    Matrix a = new Matrix("A",200,200);
    a.testFill();
  }
}

