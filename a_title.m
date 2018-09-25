function [title kerr]=a_title(p,fout)

if p.err == 2
    title=a_compress(p.title);
    kerr=0;
else
    title='';
    kerr=1;
    fprintf(fout,'      *---* Error on *title diktat');
end