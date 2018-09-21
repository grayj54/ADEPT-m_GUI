function [title kerr]=a_ltitle(p,fout)
global VERBOSE

if p.err == 2
    title=a_compress(p.title);
    kerr=0;
else
    title='';
    kerr=1;
    if VERBOSE; fprintf(fout,'      *---* Error on *ltitle diktat'); end
end