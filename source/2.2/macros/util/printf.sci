function printf(fmt,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,v16,..
    v17,v18,v19,v20,v21,v22,v23,v24,v25,v26,v27,v28,v29,v30)
// printf - Emulator of C language printf
//!
[lhs,rhs]=argn(0)
v='v'
args='fmt,'+strcat(v(ones(rhs-1,1))+string(1:rhs-1)',',')
execstr('write(%io(2),sprintf('+args+'))')
