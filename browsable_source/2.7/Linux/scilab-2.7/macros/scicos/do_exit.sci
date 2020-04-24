function do_exit()
// Copyright INRIA
r=0
if edited then
  if ~super_block then
    r=x_choose(['Save';'Save As'],..
	['Diagram has not been saved';
	'What to do before leaving?'],'Don''t save')
  end
end

if r==1 then
  ok=do_save()
  if ~ok then do_SaveAs(),end
elseif r==2 then
  do_SaveAs()
end

if ~super_block&~pal_mode  then
  if alreadyran then do_terminate(),end
end

ok=%t
if or(winsid()==curwin) then
  xset('window',curwin)
  //  erasemenubar(datam)
  //  if pixmap then xset('wshow'),end
  xbasc()
  xset('alufunction',3)
//  setmenu(curwin,'3D Rot.')
//  setmenu(curwin,'File',1) //clear
//  setmenu(curwin,'File',2) //select
//  setmenu(curwin,'File',4) //save
//  setmenu(curwin,'File',6) //load
//  setmenu(curwin,'File',7) //close


  if ~super_block then
    delmenu(curwin,'stop'),
    xset('window',curwin),xsetech([0 0 1 1])
    clearglobal %tableau;clear %tableau
  end
end

for win=windows(size(windows,1):-1:noldwin+1,2)'
  if or(win==winsid()) then
    xbasc(win),xdel(win);
  end
end
endfunction
