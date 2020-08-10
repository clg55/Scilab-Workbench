function scitest(tstfile)

diafile=strsubst(tstfile,'.tst','.dia')
if newest(tstfile,diafile)==2 then return,end

mydisp('------------------- File '+tstfile+'--------------------')
//Reset standard globals
rand('seed',0);rand('uniform');
if MSDOS then
  SCI=strsubst(SCI,'/','\')
  tmpfiles=strsubst(TMPDIR,'/','\')+'\tmp.'
else
  tmpfiles=TMPDIR+'/tmp.'
end


// Do some modification in  tst file 
// ---------------------------------
txt=mgetl(tstfile)
txt=strsubst(txt,'pause,end','bugmes();quit;end')
txt=strsubst(txt,'-->','@#>') //to avoid suppression of input --> with prompts
txt=strsubst(txt,'halt()','');

head='mode(3);clear;lines(0);'..
	+'deff(''[]=bugmes()'',''write(%io(2),''''error on test'''')'');'..
	+'predef(''all'');'..
	+'diary('''+tmpfiles+'dia'+''');'..
	+'driver(''Pos'');xinit('''+tmpfiles+'gr'+''');';
tail="diary(0);xend();exit;"

txt=[head;
    txt;
    tail];
// and save it in a temporary file 
mputl(txt,tmpfiles+'tst')

myexec()

//  Do some modification in  dia file 
// ----------------------------------
dia=mgetl(tmpfiles+'dia')
dia(grep(dia,'exec('))=[];
dia(grep(dia,'diary(0)'))=[];

//suppress the prompts
dia=strsubst(strsubst(dia,'-->',''),'@#>','-->')
dia=strsubst(dia,'-1->','')

//standardise  number display   
dia=strsubst(strsubst(strsubst(strsubst(dia,' .','0.'),..
    'E+','D+'),'E-','D-'),'-.','-0.')

dia=strsubst(dia,'bugmes();return','bugmes();quit'); //not to change the ref files
// write down the resulting dia file
mputl(dia,diafile)
//Check for execution errors
// -------------------------
if grep(dia,'error on test')<>[] then
  mydisp("Test failed ERROR DETECTED  while executing "+tstfile)
  return
end
//Check for diff with the .ref file
// --------------------------------
[u,ierr]=mopen(diafile+'.ref','r')
if ierr== 0 then //ref file exists
  ref=mgetl(u);mclose(u)
  // suppress blank (diff -nw)
  dia=strsubst(dia,' ','')
  ref=strsubst(ref,' ','')
  
  if or(ref<>dia) then 
    if MSDOS then
      mydisp('Test Failed SEE : fc /L /N  '+diafile+' '+diafile+'.ref ')
    else
      mydisp('Test Failed SEE : diff -w  '+diafile+' '+diafile+'.ref ')
    end
  else
    mydisp('Test passed')
  end
end
mydisp('----------------------------------------------------------')

function mydisp(str)
//write(result,str,'(a)')
write(%io(2),str,'(a)')

function myexec()
if MSDOS then
  unix_s('del '+tmpfiles+'dia')
  unix_s(SCI+'\bin\scilex.exe -nwni -f '+tmpfiles+'tst')
else
  unix_s('rm -f '+tmpfiles+'dia')
  unix_s('( '+SCI+'/bin/scilab -nw <'+tmpfiles+'tst > '+tmpfiles+'res ) 2> '+tmpfiles+'err')
end
