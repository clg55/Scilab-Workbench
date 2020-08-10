function [txtdo]=lmidem(PROBNAME,XNAME,DNAME) 
// Copyright INRIA
[LHS,RHS]=argn(0);
txtdo=[]

if RHS ~=3 then
  PROBNAME1='foo';
  XNAME1='X1,X2,...';
  DNAME1='D1,D2,...';

  if RHS==1 then
    tt=read(PROBNAME,-1,1,'(a)');
    tt=stripblanks(tt);
    mat=str2vec(tt);

    [q1,p1]=find(mat'=='[');
    [q2,p2]=find(mat'==']');

    XNAME1=mat(p1(1),q1(1)+1:q2(1)-1);
    XNAME1=strcat(XNAME1);
    [q1,p1]=find(mat'=='(');
    [q2,p2]=find(mat'==')');
    DNAME1=mat(p1(1),q1(1)+1:q2(1)-1);
    DNAME1=strcat(DNAME1);
    [q2,p2]=find(mat'=='=');
    PROBNAME1=mat(p2(1),q2(1)+1:q1(1)-1);
    PROBNAME1=strcat(PROBNAME1);
  end

  labels=['LMI problem name: ';'Names of unknown matrices: ';...
          'Names of data matrices: '];
//  [ok,PROBNAME,XNAME,DNAME]=getvalue(['Problem definition';
//      'LMITOOL will generate for you a skeleton of the functions needed';
//        ' (see User''s Guide for details). For that, you need to specify:';
//        '1- Name of you problem which will be given to the solver function,';
//        '2- Names of unknown matrices or list of unknown matrices,';
//        '3- Names of data matrices or list of data matrices.'],labels,...
//        list('str',1,'str',1,'str',1),...
//        [PROBNAME1+'            ',XNAME1+'           ',DNAME1+'         ']);
  ok=%t
  PROBNAME=PROBNAME1;XNAME=XNAME1;DNAME=DNAME1;
    if ok==%f then 
        txtdo='Try again';return;
      end
    end      
//    PROBNAME=stripblanks(PROBNAME);
//    XNAME=stripblanks(XNAME);
//    DNAME=stripblanks(DNAME);


      pathname=getcwd();
      fname = pathname+'/'+PROBNAME+'.sci';
 
      txt0='function ['+XNAME+']='+PROBNAME+'('+DNAME+')'
      txt0=[txt0;'/'+'/ Generated by lmitool on ';'  '];

      txt0=[txt0;
          '  Mbound = 1e3;';
          '  abstol = 1e-10;';
          '  nu = 10;';
          '  maxiters = 100;';
          '  reltol = 1e-10;';
          '  options=[Mbound,abstol,nu,maxiters,reltol];'
          '   ']

      nv=length(XNAME);
      index_commas=[];
      for k=1:nv
        if part(XNAME,k)==',' then index_commas=[index_commas,k],end
      end
      vnum = length(index_commas)+1;
      index_commas = [0 index_commas length(XNAME)+1];

      txt1=[];txt2=[];
      for i = 1:vnum,
        vname = part(XNAME,index_commas(i)+1:index_commas(i+1)-1);
        if RHS<>1 then  
          txt1 = [txt1;
              vname+'_init=...']
        end
        txt2=[txt2,vname+'_init'];
      end



      txts1=['function [LME,LMI,OBJ]='+PROBNAME+'_eval(XLIST)';
          '['+XNAME+']=XLIST(:)']
      if RHS ~= 1 then
        txts2=['LME=...';'LMI=...';'OBJ=...']
      else
        [p,q]=size(mat);
        ind=[]
        for i=1:p
          if mat(i,2:7)==['/','/','/','/','/','/']  then
            ind=[ind i];
          end
        end
        if prod(size(ind))<>4 then 
          error('File not generated by lmitool or badly modified');
        end
        txt1=[];
        for i=ind(1)+1:ind(2)-1
          txt1=[txt1;strcat(mat(i,:))];
        end
        txts2=[];
        for i=ind(4)+1:p
          txts2=[txts2;strcat(mat(i,:))];
        end
      end

      sep11=['/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'...
              +'/'+'INITIAL GUESS']
      sep12=['/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'...
              +'/'+' ']
      sep13=['/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'...
              +'/'+'LME, LMI and OBJ']

      sep2=['/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'...
              +'/'+'EVALUATION FUNCTION'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/'+'/']

      txt2=[
          'XLIST0=list('+strcat(txt2,',')+')';
          'XLIST=lmisolver(XLIST0,'+PROBNAME+'_eval,options)';
          '['+XNAME+']=XLIST(:)'];

      txt4=[txt0;sep11;txt1;sep12;' ';txt2;' ';' ';' ';...
              sep2;' ';txts1;' ';sep13;txts2];

      if RHS==0|RHS==1 then
        select %demo_
        case 1 
          txtdem=['The problem is here:';
                  'Minimize gama  under the constraints:'
                  '    X''-X = 0';
                  '    and '
                  '[A X + X A'''+', B, X C'']';
                  '[ B'''+', -gama I, D'']';
                  '[C X, D, -gama I] < 0';
                '   '; 
                'This problem is solved by the function below (do not edit)'
                ]
          
          case 2 
            txtdem=['The problem is here:';
                  'Minimize trace(P+Q)  under the constraints:'
                  '    P''-P = 0';
                  '    Q''-Q = 0';
                  '    and '
                  '    NB'' (A Q + Q A'' + Q) NB < 0';
                  '    NC'' (A P + P A'' + P) NC < 0';
                  '    [P I; I Q] > 0'
                  ' where NB=kernel(B) and NC=kernel(C'')'
                '   '; 
                'This problem is solved by the function below (do not edit)'
                ]
          case 3
           txtdem=['The problem is here:';
               'Find X such that A*X+X*B-C (continuous time)'
               'or Find X such that A*X*B-C (discrete time)'
               ]
          end
        [txt4]=x_dialog(txtdem,[txt4]);
        end
      if txt4==[] then txtdo='Try again';return;end
        txt=[txt4];
        n=1;
function [vec]=str2vec(str)
w=length(str);
[p,q]=size(w);ma=max(w);
vec=[];
for i=1:ma
  vec=[vec part(str,i)]
end
