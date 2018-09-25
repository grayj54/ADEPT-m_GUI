function S=A_load(fname)

dum=load('-mat',fname);
d=fieldnames(dum);
if length(d) == 1
    S=getfield(dum,d{1});
else
    error('A_load: Error loading %s',fname)
end
    