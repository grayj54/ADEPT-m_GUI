function S=A_load(fname)
% S=A_load(fname)
% S - data object
% fname - mat-file name
%
% Example:
%    to load adeptfile.EQ into dev0, type
%    dev0=A_load('adeptfile.EQ')

dum=load('-mat',fname);
d=fieldnames(dum);
if length(d) == 1
    S=getfield(dum,d{1});
else
    error('A_load: Error loading %s',fname)
end
    