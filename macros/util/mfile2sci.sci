function mfile2sci(fil,res_path,Imode,Recmode)
// Copyright INRIA
if exists('m2scilib')==0 then load('SCI/macros/m2sci/lib'),end

[l,mac]=where()
Reclevel=size(find(mac=='mfile2sci'),'*')
if Reclevel==1 then
  nametbl=[]
end


logfile=%io(2) // logical unit of the logfile

[lhs,rhs]=argn(0)
write(logfile,'------------ translation of '+fil+' -----------')


if rhs<4 then Recmode=%f,end
if rhs<3 then Imode=%f,end
if rhs<2 then res_path='./',end

if part(res_path,length(res_path))<>'/' then res_path=res_path+'/',end


res=[]
quote=''''
dquote=""""
ctm='.'+'.'+'.'
old=who('get')
first_ncl=1
//timer()
info=%f
//
k=strindex(fil,'.')
if k<>[]
  ke=k($)-1
  basename=part(fil,1:ke)
else
  ke=length(fil)
  basename=fil
end
k=strindex(fil,'/')
if k==[] then
  file_path='./'
else
  file_path=part(fil,1:k($))
end
fnam=part(basename,k($)+1:ke) // name of the file witout extension

//
if info then write(logfile,'Reading file and comment substitution'),end
//txt=read(fil,-1,1,'(a)')
txt=readmfile(fil)
if txt==[] then 
  write(logfile,'Empty file! nothing done'),
  return,
end
// continuation lines
k=0
n=size(txt,'r')
to_kill=[]
while k<size(txt,'r')
  k=k+1
  kc=strindex(txt(k),ctm)
  isacontline=%f
  for kck=kc,isacontline=isacontline|~isinstring(txt(k),kck),end
  if isacontline then
    kc1=isacomment(txt(k))
    if kc1<>0 then // line has a comment
      if kc1<kc(1) then // ... in a comment
      else // comment follow continuation mark
        com=part(txt(k),kc1(1):length(txt(k)))
        txt(k)=part(txt(k),1:kc(1)-1)+txt(k+1)+com
        txt(k+1)=[]
        k=k-1
      end
    else
      txt(k)=part(txt(k),1:kc(1)-1)+txt(k+1)
      txt(k+1)=[]
      k=k-1
    end
  end
end


// change comments
n=size(txt,'r')
first=%t
helppart=[],endofhelp=%f
for k=1:n
  tk=txt(k)
  // insert blank when a digit is followed by a dotted operator
  kdot=strindex(tk,['.*','./','.\','.^','.'''])
  if kdot<>[] then
    kdgt=kdot(find(abs(str2code(part(tk,kdot-1)))<9))
    for kk=size(kdgt,'*'):-1:1
      tk=part(tk,1:kdgt(kk)-1)+' '+part(tk,kdgt(kk):length(tk));
    end
  end
  // looking at comments 
  kc=isacomment(tk)
  if kc<>0 then
    // a comment, replace it by a function call
    com=part(tk,kc+1:length(tk))
    if ~endofhelp then helppart=[helppart;com];end
    if length(com)==0 then com=' ',end
    com=strsubst(com,quote,quote+quote)
    com=strsubst(com,dquote,dquote+dquote)
    com=';comment('+quote+com+quote+')'
    txt(k)=part(tk,1:kc-1)+com
  else
    if first then 
      if tk<>part(' ',1:length(tk)) then
        first_ncl=k,first=%f,
      else
        endofhelp=%t
      end
    end
  end
end

// replace ' by '' 
txt=strsubst(txt,dquote,dquote+dquote)

// replace switch by select
txt=strsubst(txt,'switch ','select ')
// replace otherwise by else
txt=strsubst(txt,'otherwise','else')
// 1i ,...


// replace {..} by (..) or [..]
//txt=replace_brackets(txt)

txt=i_notation(txt)

// place function definition line at first line
kc=strindex(txt(first_ncl),'function')
if kc==[] then
  //batch file
  txt=['function []=script()';txt]
  batch=%t
else
  kc=kc(1)
  batch=%f
  if first_ncl<>1 then
    while strindex(txt(first_ncl($)+1),ctm)<>[] then
      first_ncl=[first_ncl,first_ncl($)+1]
    end
    txt=[txt(first_ncl);txt(1:first_ncl(1)-1);txt(first_ncl($)+1:$)]
  end
end


kc=strindex(txt(1),'function');kc=kc(1);
killed=[]//killfuns()

deff(part(txt(1),kc+8:length(txt(1))),txt(2:$),'n')

w=who('get');
mname=w(1)
nametbl=[nametbl;mname]

execstr('comp('+mname+',1)')
//restorefuns(killed)
if info then disp('                                     '+string(timer())),end
if info then write(logfile,'Analysing '+mname+' m_file code'),end
//disp(timer())
code=macr2lst(evstr(mname))
if info then disp('                                     '+string(timer())),end
if info then write(logfile,'Generation of '+mname+' scilab code'),end
[res,trad]=m2sci(code,w(1),Imode,Recmode)
if info then disp('                                     '+string(timer())),end
if batch then res(1)=[],end // suppress function definition line if batch
//striping last return and blank lines
n=size(res,1)
while res(n)==part(' ',1:length(res(n))) then n=n-1,end
res=res(1:n-1)

//output file name
if batch then 
  res(1)==[],ext='.sce',
else
  ext='.sci'
end

//res=splitlines(res,100)
scifil=res_path+fnam+ext
if info then write(logfile,'Writing to '+scifil+' file'),end
u=file('open',scifil,'unknown')
write(u,res,'(a)')
file('close',u)

// writing .cat file
if helppart<>[] then
  catfil=res_path+fnam+'.cat'
  if info then write(logfile,'Writing to '+catfil+' file'),end
  u=file('open',catfil,'unknown')
  write(u,helppart,'(a)')
  file('close',u)
end

// writing translation file
if trad<>[] then
  if batch then
    mname=fnam
  end
  sci_fil=res_path+'sci_'+mname+'.sci'
  if info then write(logfile,'Writing to '+sci_fil+' file'),end
  u=file('open',sci_fil,'unknown')
  write(u,trad,'(a)')
  file('close',u)
end
nametbl($)=[]
nametbl=resume(nametbl)

function txt=i_notation(txt)
// Change 1i ,... by 1*i,...
n=size(txt,1)
I='i';J='j'
matches=[string(0:9)+I(ones(1,10)),'.i',string(0:9)+J(ones(1,10)),'.j']
symbs=['+','-','*','/','\','(','[',' ','^',' ',',',';','=']
s1=['+','-','*','/','\',',',';',' ','^','.','&','|','''']
s2=[string(0:9),'d','e','D','E','.']
for k=1:n
  tk=txt(k)+' '
  kc=strindex(tk,matches)
  for kk=size(kc,'*'):-1:1
    km=kc(kk)+2
    if find(part(tk,km)==s1)==[] then kc(kk)=[],end
  end

  //  if kc<>[] then txt='!'+txt,end
  kc=[0 kc]

  for kk=size(kc,'*'):-1:2
    km=kc(kk)
    num=%t
    while or(part(tk,km)==s2)
      km=km-1
      if km<=kc(kk-1)+1 then km=kc(kk-1);num=%f;break,end
    end
    tokill=%f
    num=part(tk,km+1:kc(kk)-1)
    ke=strindex(convstr(num),['e','d'])
    kd=strindex(convstr(num),'.')
    if size(ke,2)>1|size(kd,2)>1 then
      tokill=%t
    elseif size(ke,2)==1&size(kd,2)==1 then
      if ke<kd then tokill=%t,end
    end
    if ~tokill then 
      if km<>kc(kk-1) then
	if and(part(tk,km)<>symbs) then tokill=%t,end
      end
    end
    if ~tokill then 
      km=kc(kk)
      if ~isinstring(tk,km ) then
	tk=part(tk,1:km)+'*%'+part(tk,km+1:length(tk))
      end
    end  
  end
  //if size(kc,2)>1 then txt='!'+txt,end
  txt(k)=tk
end

function i_n_test()
Txt=[
'x=1+k2i1'
'x=1.i'
'[1,2i,3;4.001i 0i 0.i]'
'1.i'
'x=2+1.d0i'
'x=33.4+a0i1+1.d+01i'
'c=x0i'
'x=2+d.0i'
'x=33.4+a0i1+1.d+01i'''
'x=''33.4+a0i1+1.d+01i'''
]
for k=1:size(Txt,1)
  txt=Txt(k)
  disp(txt+' --> '+i_notation(txt))
end
