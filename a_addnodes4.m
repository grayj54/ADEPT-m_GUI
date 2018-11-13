function [newx,nset]=a_addnodes4(x,V,minh,nkt)
nset=0;
n=length(x);

for ii=2:n
    h=x(ii)-x(ii-1);
    dv=abs(V(ii)-V(ii-1));
    if h >= 2*minh && dv > nkt
        nset=nset+1;
        x(n+nset)=0.5*(x(ii)+x(ii-1));
    end
end

newx=sort(x);
idup=dupl_x(newx);
if isempty(idup) == 0
    for kk=1:length(idup) % remove duplicate nodes
       newx(idup(kk))=inf;
       nset=nset-1;
    end
    newx=sort(newx);
    newx=newx(1:length(newx)-length(idup));
end
