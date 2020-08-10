// Copyright INRIA
mode(-1)
//to Check all the demos
 funcprot(0)
clearfun('x_message')
clearfun('x_dialog')
clearfun('x_mdialog')
clearfun('x_choose')
clearfun('mode')
clearfun('xclick')
xgetm=funptr('xgetmouse')

deff('[]=mode(x)','x=x')
deff('[]=halt(  )',' ')
getf('SCI/macros/util/x_matrix.sci')
getf('SCI/macros/util/getvalue.sci')
getf('SCI/macros/util/getclick.sci')
getf('SCI/macros/auto/scicos.sci')
getf('SCI/demos/scicos/scicos_play.sci','n')
names=['choosefile';
'do_addnew';
'do_block';
'do_color';
'do_copy';
'do_copy_region';
'do_delete';
'do_delete_region';
'do_help';
'do_move';
'do_palettes';
'do_replace';
'do_run';
'do_tild';
'do_view';
'do_exit';
'getlink';
'move';
'prt_align']
for k=1:size(names,'r')
  getf('SCI/macros/scicos/'+names(k)+'.sci')
end
getf('SCI/macros/scicos_blocks/scifunc_block.sci')
lines(0)
clearfun('lines')
deff('x=lines(x)','x=0 ')
getf('SCI/tests/dialogs.sci')
execstr('message=x_message')
execstr('dialog=x_dialog')
I=file('open','SCI/tests/demos.dialogs','old')
//I=%io(1)
if MSDOS then
  O=file('open',TMPDIR+'\sciout','unknown')
else
  O=file('open','/dev/null','unknown')
end
%IO=[I,O]
lines(0)
exec('SCI/demos/alldems.dem')
file('close',I)
file('close',O)
