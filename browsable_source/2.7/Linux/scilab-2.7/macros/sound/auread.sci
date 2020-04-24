function [y,Fs,bits]=auread(aufile,ext)
[nargout,nargin] = argn(0)
//Utility fct: reads .au sound file.
//auread(aufile) loads a sound file specified by the string aufile,
//returning the sampled data in y. The .au extension is appended
//if no extension is given.  Amplitude values are in the range [-1,+1].
//Supports multi-channel data in the following formats:
//8-bit mu-law, 8-, 16-, and 32-bit linear, and floating point.
 
//   [y,Fs,bits]=auread(aufile) returns the sample rate (Fs) in Hertz
//   and the number of bits per sample used to encode the
//   data in the file.
 
//  auread(aufile,n) returns the first n samples from each
//       channel in the file.
//  auread(aufile,[n1,n2]) returns samples n1 through n2 from
//       each channel in the file.
//  siz=auread(aufile,'size') returns the size of the audio data contained
//  in the file in place of the actual audio data, returning the
//  vector siz=[samples channels].
 
if nargin>2 then
  error('Too many input arguments.');
end
// Append .au extension if it's missing:
if strindex(aufile,'.')==[] then
  aufile = aufile+'.au';
end
[fid,junk] = mopen(aufile,'rb',0)
if junk<0 then
  error('Can''t open .au sound file for input.');
end

snd = read_sndhdr(fid);
 
Fs = snd('rate');
bits = snd('bits');
 
// Determine if caller wants data:
if nargin<2 then
  ext = [];
end
// Default - read all samples
exts = prod(size(ext));

if convstr(ext)=='size' then
  // Caller doesn't want data - just data size:
  mclose(fid);
  y = [snd('samples'),snd('chans')];
  return
   
elseif exts>2 then
  error('Index range must be specified as a scalar or 2-element vector.');
elseif exts==1 then
  ext = [1,ext];
end

// Read data:

snd = read_sndata(fid,snd,ext);
y = snd('data');
mclose(fid);

endfunction
function [new_snd]=read_sndata(fid,snd,ext)
new_snd=[];
SamplesPerChannel = snd('samples');
BytesPerSample = snd('bits')/8;
// format:
if snd('format')==1 then
  dtype = 'ucb';  // 8-bit mu-law
elseif snd('format')==2 then
  dtype = 'cb';  // 8-bit linear
elseif snd('format')==3 then
  dtype = 'sb';  // 16-bit linear
elseif snd('format')==5 then
  dtype = 'ib'; // 32-bit linear
elseif snd('format')==6 then
  dtype = 'fb';  // Single precision
elseif snd('format')==7 then
  dtype = 'db';  // Double-precision
else
  error('Unrecognized data format.')
end
 

// sample range to read:
if ext==[] then
  ext = [1,SamplesPerChannel];
// all samples
else
  if prod(size(ext))~=2 then
    error('Sample limit vector must have 2 elements.')
  end
  if ext(1)<1|ext(2)>SamplesPerChannel then
    error('Sample limits out of range.')
  end
  if ext(1)>ext(2) then
    error('Sample limits must be given in ascending order.')
  end
end
// Skip over leading samples:
if ext(1)>1 then
  // Skip over leading samples, if specified:
  status = mseek(BytesPerSample*(ext(1)-1)*snd('chans'),fid,'cur');
  if status==(-1) then
    error('Error in file format.')
  end
end

// Read desired data:
nSPCext = ext(2)-ext(1)+1;
// # samples per channel in extraction range
extSamples = snd('chans')*nSPCext;
data=mget(snd('chans')*nSPCext,dtype,fid);
// Rearrange data into a matrix with one channel per column:
data = data';
 
 
// Convert and normalize data range:
if snd('format')==1 then
  // 8-bit mu-law
  data = mu2lin(data);
elseif snd('format')==2 then
  // 8-bit linear
  data = data*(2^(-7));
elseif snd('format')==3 then
  // 16-bit linear
  data = data*(2^(-15));
elseif snd('format')==5 then
  // 32-bit linear
  data = data*(2^(-31));
elseif snd('format')==6|snd('format')==7 then
  // Float/Double
  a = min(min(data));
  b = max(max(data));
  data = (data-a)/(b-a)*2-1;
end
 
new_snd = snd;
new_snd('data')=data
return

endfunction
function [snd]=read_sndhdr(fid)
// Read file header:
snd=tlist(['snd','offset','databytes','format','rate','chans','data','info','bits','samples','magic'])

snd.magic = ascii(mget(4,'c',fid))
if snd.magic~='.snd',
  error('Not a .au sound file.')
end

snd('offset')=mget(1,'uib',fid)
snd('databytes')=mget(1,'uib',fid)
snd('format')=mget(1,'uib',fid)
snd('rate')=mget(1,'uib',fid)
snd('chans')=mget(1,'uib',fid)

 
// Directly determine how long info string is:
info_len = snd('offset')-24;
 [info,cnt] = mtlb_fread(fid,info_len,'char');
snd('info')=stripblanks(ascii(info'))
if cnt~=info_len then
  error('Error while reading sound file.')
end
 
// Determine file length
mseek(0,fid,'end');
// Go to end of file
file_len = mtell(fid);
// Get position in bytes
mseek(snd('offset'),fid,'set');
// Reposition file pointer
snd('databytes')=file_len-snd('offset')
 
// Interpret format:
if snd('format')==1 then
  snd('bits')=8
  // 8-bit mu-law
elseif snd('format')==2 then
  snd('bits')=8
  // 8-bit linear
elseif snd('format')==3 then
  snd('bits')=16
  // 16-bit linear
elseif snd('format')==5 then
  snd('bits')=32
  // 32-bit linear
elseif snd('format')==6 then
  snd('bits')=32
  // Single precision
elseif snd('format')==7 then
  snd('bits')=64
  // Double-precision
else
  error('Unrecognized data format.')
end
// Determine # of samples per channel:
snd('samples')=snd('databytes')*8/snd('bits')/snd('chans')
if snd('samples')~=fix(snd('samples')) then
  error('Truncated data file.')
end
endfunction
