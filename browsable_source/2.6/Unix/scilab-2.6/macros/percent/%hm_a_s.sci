function M1=%hm_a_s(M1,M2)
// Copyright INRIA
// hypermatrix + scalar

if and(size(M2)==[1 1]) then
  M1('entries')=M1('entries')+M2
else
  dims=M1('dims')(:)
  dims(find(dims==1))=[]
  if and(dims'==size(M2)) then
    M1('entries')=M1('entries')+M2(:)
  else
    error(8)
  end
end





