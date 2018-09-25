function dupx=dupl_x(x)

dupx=[];
n=length(x);
k=0;
for i=1:n-1
    if x(i) == x(i+1)
        k=k+1;
        dupx(k)=i;
    end
end
        