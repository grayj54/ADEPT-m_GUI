function [newx,maxDrat,nset]=a_addnodes3(x,D,minh,maxrD,Dth)
nset=0;
n=length(x);
Dll=D(1:n-2);
Drr=D(2:n-1);
hll=x(2:n-1)-x(1:n-2);
hrr=x(3:n)-x(2:n-1);
maxrD=sqrt(2);
r1=max(abs(Drr./Dll));
r2=max(abs(Dll./Drr));
maxDrat=max(r1,r2);

for ii=2:n-1
    Dl=Dll(ii-1);
    Dr=Drr(ii-1);
    hl=hll(ii-1);
    hr=hrr(ii-1);
    % nodes ii-1, ii, ii+1
    if abs(Dl) <= Dth && abs(Dl) <= Dth % D field too small to consider
        continue;
    elseif Dl*Dr < 0 % D changes sign, add 2 nodes
        if hl > 2*minh
            nset=nset+1;
            x(n+nset)=0.5*(x(ii)+x(ii-1));
        end
        if hr > 2*minh
            nset=nset+1;
            x(n+nset)=0.5*(x(ii+1)+x(ii));
        end
    else % Ds are same sign
        if abs(Dl) > maxrD*abs(Dr) && hl > 2*minh
            nset=nset+1;
            x(n+nset)=0.5*(x(ii)+x(ii-1));
        elseif abs(Dr) > maxrD*abs(Dl) && hr > 2*minh
            nset=nset+1;
            x(n+nset)=0.5*(x(ii+1)+x(ii));
        end
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
