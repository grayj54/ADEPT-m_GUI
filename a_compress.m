function ss=a_compress(s)

s=strtrim(s);
l=length(s);

ss(1)=s(1);
k=2;
 for i=2:l-1
    if s(i) == ' '
        if s(i+1) ~= ' '
            ss(k)=s(i);
            k=k+1;
        end
    else
        ss(k)=s(i);
        k=k+1;
    end
end
ss(k)=s(l);
ss=strtrim(ss);
    
