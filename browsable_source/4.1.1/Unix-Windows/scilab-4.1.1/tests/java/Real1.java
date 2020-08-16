import javasci.* ; 
/********************************************************************************************************/      
class Real1 
{
/********************************************************************************************************/  	
  public static void main(String[] args) 
    {
			SciReal A = new SciReal("A",4,1, new double [] {1.1,2.2,3.3,4.4} );
			A.Send();
      SciReal B = new SciReal("B",4,1, new double [] {4.4,3.3,2.2,1.1} );
      B.Send();
  		SciReal C = new SciReal("C",4,1, new double [] {1. ,1. ,1. ,1.} );
  		C.Send();
  		SciReal D = new SciReal("Dim",1,2);
  		D.Send();
  		SciReal E = new SciReal("E",C);
  		E.Send();
  		
  		
  		Scilab.Exec("disp(''A='');disp(A);");
  		Scilab.Exec("disp(''B='');disp(B);");
			Scilab.Exec("disp(''C='');disp(C);");
			Scilab.Exec("disp(''E='');disp(E);");
			
  		Scilab.Exec("C=A+B;");
  		D.Job("Dim=size(C)");
			
			Scilab.Exec("disp(''A='');disp(A);");
  		Scilab.Exec("disp(''B='');disp(B);");
			Scilab.Exec("disp(''C='');disp(C);");
			Scilab.Exec("disp(''Dim='');disp(Dim);");
			Scilab.Exec("disp(''E='');disp(E);");

    }
/********************************************************************************************************/      
}
/********************************************************************************************************/  
