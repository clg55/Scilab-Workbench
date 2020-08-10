function translatepaths(Paths,res_path)
// Copyright INRIA
if exists('m2scilib')==0 then load('SCI/macros/m2sci/lib'),end
logfile=%io(2)

res_path=stripblanks(res_path)
if part(res_path,length(res_path))<>'/' then
  res_path=res_path+'/'
end
Paths=stripblanks(Paths)

for k=1:size(Paths,'*')
  if part(Paths(k),length(Paths(k)))<>'/' then 
    Paths(k)=Paths(k)+'/',
  end
end
for k=1:size(Paths,'*')
  path=Paths(k)
  if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then 
    mfiles=unix_g('dir /b '+path+'*.m')
    sep='\'
  else
    mfiles=unix_g('ls '+path+'*.m')
    sep='/'
  end
  for k1=1:size(mfiles,1)
    if getenv('WIN32','NO')=='OK' & getenv('COMPILER','NO')=='VC++' then
      fnam=part(mfiles(k1),1:length(mfiles(k1))-2)
      mpath=path+mfiles(k1)
    else   
      kk=strindex(mfiles(k1),sep)
      fnam=part(mfiles(k1),kk($)+1:length(mfiles(k1))-2)
      mpath=mfiles(k1)    
    end
    scipath=res_path+fnam+'.sci'
    scepath=res_path+fnam+'.sce'
    if newest(mpath,scipath)==mpath then
      if newest(mpath,scepath)==mpath then
	mfile2sci(mpath,res_path,%f,%t)
      end
    end
  end
end
