function [scs_m,edited]=do_SaveAs()
//
// Copyright INRIA
tit=['For saving in binary file use .cos extension,';
    'for saving in ascii file use .cosf extension']
fname=xgetfile('*.cos*',emptystr(),tit)
if fname==emptystr() then return,end

[path,name,ext]=splitfilepath(fname)
select ext
case 'cos' then
  ok=%t
  frmt='unformatted'
case 'cosf' then
  ok=%t
  frmt='formatted'
else
  message('Only *.cos binary or cosf ascii files allowed');
  return
end


// open the selected file
[u,err]=file('open',fname,'unknown',frmt)
if err<>0 then
  message('Directory write access denied')
  return
end

if ~super_block&~pal_mode then
//update cpr data structure to make it coherent with last changes
if needcompile==4 then
  cpr=list()
else
  [cpr,state0,needcompile,ok]=do_update(cpr,state0,needcompile)
  if ~ok then return,end
  cpr(1)=state0
end
else
  cpr=list()
end

drawtitle(scs_m(1))  //erase the old title
scs_m;
scs_m(1)(2)=[name,path] // Change the title

// save
if ext=='cos' then
  save(u,scicos_ver,scs_m,cpr)
else
  disablemenus()

  errcatch(-1,'continue')

  write(u,sci2exp(scicos_ver,'scicos_ver'),'(a)')
  errcatch(-1)
    if iserror(-1)==1 then
    errclear(-1)
    x_message('Directory write access denied')
    file('close',u)
    return
    end
  cos2cosf(u,do_purge(scs_m))
  enablemenus()
end
file('close',u)

drawtitle(scs_m(1))  // draw the new title

edited=%f
if pal_mode then 
  graph=path+'/'+name+'.pal'
  xsave(graph)
  update_scicos_pal(path,scs_m(1)(2)(1),fname),
end


    
